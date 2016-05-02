package lib::golm_ws_api ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;
use SOAP::Lite +trace => [qw (debug)];
use JSON ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( connectWSlibrarySearchGolm LibrarySearch parseResult filter_scores_golm_results);
our %EXPORT_TAGS = ( ALL => [qw( connectWSlibrarySearchGolm LibrarySearch parseResult filter_scores_golm_results)] );

=head1 NAME

My::Module - An example module

=head1 SYNOPSIS

    use My::Module;
    my $object = My::Module->new();
    print $object->as_string;

=head1 DESCRIPTION

This module does not really exist, it
was made for the sole purpose of
demonstrating how POD works.

=head1 METHODS

Methods are :

=head2 METHOD new

	## Description : new
	## Input : $self
	## Ouput : bless $self ;
	## Usage : new() ;

=cut

sub new {
    ## Variables
    my $self={};
    bless($self) ;
    return $self ;
}
### END of SUB
     
=head2 METHOD connectWSlibrarySearchGolm

	## Description : create a soap object throught the webservice LibrarySearch of Golm.
	## Input : $self
	## Ouput : $soap ;
	## Usage : my $soap = connectWSlibrarySearchGolm() ;

=cut

sub connectWSlibrarySearchGolm() {
	## Retrieve Values
    my $self = shift ;
	my $osoap = SOAP::Lite
		-> soapversion('1.2')
		-> envprefix('soap12')
		-> readable(1)
		-> uri('gmd.mpimp-golm.mpg.de')
		-> proxy('http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx/' )
		-> on_fault(sub { my($soap, $res) = @_; 
         eval { die ref $res ? $res->faultstring : $soap->transport->status, "\n"};
         return ref $res ? $res : new SOAP::SOM ;
         });
	
	return ($osoap);
}
### END of SUB
     

=head2 METHOD LibrarySearch

	## Description : Matches a single user submitted GC-EI mass spectrum against the Golm Metabolome Database (GMD). 
	## 				 A limited amount of hits can be kept according to the maxHits value and after them being filtered by $filter value
	## Input : $osoap, $ri, $riWindow, $gcColumn, $spectrum, $maxHits
	## Ouput : \@limited_hits, \@json_res
	## Usage : ($limited_hits,$json_res) = LibrarySearch($osoap, $ri, $riWindow, $gcColumn, $spectrum, $maxHits) ;

=cut

sub LibrarySearch() {
	## Retrieve Values
	my $self = shift ;
	my ($ri, $riWindow, $gcColumn, $spectrum, $maxHits, $filter, $thresholdHits) = @_ ;

	#init in case :
	$ri = 1500 if ( !defined $ri ) ;
	$riWindow = 3000 if ( !defined $riWindow ) ;
	$gcColumn = 'VAR5' if ( !defined $gcColumn ) ;
	
	my $result ;
	my @limited_hits ;
	my @json_res ;
	
	if ( defined $spectrum ){
		    	
    	if ( $spectrum ne '' ) {
    		
		   my $soap = SOAP::Lite
              -> uri('http://gmd.mpimp-golm.mpg.de')
              -> on_action( sub { join '/', 'http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx', $_[1] } )
              -> proxy('http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx');
               
           # Setting Content-Type myself
           my $http_request = $soap
              ->{'_transport'}
              ->{'_proxy'}
              ->{'_http_request'};
           $http_request->content_type("text/xml; charset=utf-8");
           
            my $method = SOAP::Data->name('LibrarySearch')
                ->attr({xmlns => 'http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx/'});
           
            my @params = (
                           SOAP::Data->name('ri' => $ri),
                           SOAP::Data->name('riWindow' => $riWindow),
                           SOAP::Data->name('AlkaneRetentionIndexGcColumnComposition' => $gcColumn),
                           SOAP::Data->name('spectrum' => $spectrum) ) ;
			
			my $som = $soap->call($method => @params);
			die $som->faultstring if ($som->fault);
			
			## Get the hits + status of the query
			my $results = $som->result->{Results} ;
			my $status = $som->result->{Status} ;
                   
            
            my $res_json = encode_json ($results) ;
			my @results = @$results ;
			my $oapi = lib::golm_ws_api->new() ;
            
            ## Limitate number of hits returned according to user's $maxHit
            ## and filter hits on specific values ($filter) with a threshold
            my @limited_hits = ();
            
            ### Return all hits
            if ($maxHits == 0 && $status eq 'success') {
            	my $filtered_res = $oapi->filter_scores_golm_results(\@results,$filter,$thresholdHits) ;
            	return $filtered_res ;
            }
            elsif ($maxHits > 0 && $status eq 'success'){
            	for (my $i=0 ; $i<$maxHits ; $i++) {
	            	push (@limited_hits , @$results[$i]) ;
	            	push (@json_res , $res_json) ;
            	}
            	my $filtered_res = $oapi->filter_scores_golm_results(\@limited_hits,$filter,$thresholdHits) ;
            	open(JSON, '>:utf8', "resJSON.txt") or die "Can't create the file resJSON.txt\n" ;
			    print JSON $json_res[0] ;
			    close(JSON) ;
            	return $filtered_res ;
            }
            else { carp "No match returned from Golm for the query.\n" }
        }
    	else { carp "The spectrum for query is empty, Golm soap will stop.\n" ; }
    }
    else { carp "The spectrum for query is undef, Golm soap will stop.\n" ; }
	
	return \@limited_hits ;
}
### END of SUB




=head2 METHOD filter_scores_golm_results
	## Description : filter golm's hits by a certain score with a specific threshold 
	## Input : $results,$filter,$threshold
	## Ouput : \@filtered_res ;
	## Usage : my ($filtered_res) = filter_scores_golm_results($results,$filter,$threshold) ;

=cut

sub filter_scores_golm_results() {
	## Retrieve Values
    my $self = shift ;
	my ($results,$filter,$threshold) = @_ ;
		
	my @filtered_res ;
	my @results = @$results ;

	foreach my $res (@results) {
		if ($res->{$filter} > $threshold) {
			push (@filtered_res, $res) ;
		}
	}
	return \@filtered_res ;
	
}
### END of SUB





1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc golm_ws_api.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>
Gabriel Cretin E<lt>gabriel.cretin@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : xx / xx / xx

version 2 : ??

=cut