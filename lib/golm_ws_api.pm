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
our @EXPORT = qw( connectWSlibrarySearchGolm LibrarySearch test_query_golm _filter_scores_golm_results);
our %EXPORT_TAGS = ( ALL => [qw( connectWSlibrarySearchGolm LibrarySearch test_query_golm _filter_scores_golm_results)] );

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
     
     
     
     
     
=head2 METHOD test_query_golm

	## Description : send a test request (default given on ws website) to golm database.
	## Input : $self
	## Ouput : $soap ;
	## Usage : my $soap = connectWSlibrarySearchGolm() ;

=cut

sub test_query_golm() {
	## Retrieve Values
    my $self = shift ;
	my $soap = SOAP::Lite
              -> uri('http://gmd.mpimp-golm.mpg.de')
              -> on_action( sub { join '/', 'http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx', $_[1] } )
              -> proxy('http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx', timeout => 500);
               
           # Setting Content-Type myself
           my $http_request = $soap
              ->{'_transport'}
              ->{'_proxy'}
              ->{'_http_request'};
           $http_request->content_type("text/xml; charset=utf-8");
           
            my $method = SOAP::Data->name('LibrarySearch')
                ->attr({xmlns => 'http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx/'});
           
            my @params = (
                           SOAP::Data->name('ri' => 1898),
                           SOAP::Data->name('riWindow' => 5),
                           SOAP::Data->name('AlkaneRetentionIndexGcColumnComposition' => 'VAR5'),
                           SOAP::Data->name('spectrum' => "70 3 71 3 72 16 73 999 74 87 75 78 76 4 77 5 81 1 82 6 83 13 84 4 85 3 86 4 87 5 88 4 89 52 90 4 91 2 97 2 98 1 99 4 100 12 101 16 102 9 103 116 104 11 105 26 106 2 107 1 111 1 112 1 113 4 114 11 115 7 116 5 117 93 118 9 119 8 126 1 127 3 128 3 129 101 130 19 131 25 132 4 133 60 134 8 135 4 140 1 141 1 142 4 143 13 144 2 145 6 146 1 147 276 148 44 149 27 150 3 151 1 156 1 157 70 158 12 159 5 160 148 161 26 162 7 163 8 164 1 168 1 169 2 170 1 172 3 173 4 174 1 175 4 177 4 186 2 187 1 189 28 190 7 191 13 192 2 193 1 201 5 202 1 203 3 204 23 205 162 206 31 207 16 208 2 210 2 214 1 215 2 216 8 217 88 218 18 219 8 220 1 221 6 222 1 229 23 230 6 231 11 232 3 233 4 234 3 235 1 243 1 244 2 245 1 246 2 247 1 256 1 262 3 263 1 269 2 270 1 274 4 275 1 277 4 278 1 291 7 292 2 293 1 300 1 305 4 306 1 307 4 308 1 318 1 319 122 320 37 321 17 322 3 323 1 343 1 364 2 365 1" ) );
			
			my $som = $soap->call($method => @params);
			die $som->faultstring if ($som->fault);
			
			## Get the hits + status of the query
			my $results = $som->result->{Results} ;
			my $status = $som->result->{Status} ;
			
			if ($status eq 'success' && $results ne '') {
				print "\n\n\nThe test request succeeded.\n\n\n" ;
			}
			else { croak "\n\n\nSomething went wrong with the test request. Status delivered by Golm = ".$status."\n\n" ; }
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
	my ($ri, $riWindow, $gcColumn, $spectrum, $maxHits,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,
		$HammingDistanceThreshold,$EuclideanDistanceThreshold) = @_ ;

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
                   
            #print Dumper $results ;
            my $res_json = encode_json ($results) ;
			my @results = @$results ;
			my $oapi = lib::golm_ws_api->new() ;
            
            ## Limitate number of hits returned according to user's $maxHit
            ## and filter hits on specific values ($filter) with a threshold
            my @limited_hits = ();
            
            ### Return all hits
            if ($maxHits == 0 && $status eq 'success') {
            	my $filtered_res = $oapi->filter_scores_golm_results(\@results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
																		$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold) ;
            	return $filtered_res ;
            }
            elsif ($maxHits > 0 && $status eq 'success'){
            	for (my $i=0 ; $i<$maxHits ; $i++) {
	            	push (@limited_hits , @$results[$i]) ;
	            	push (@json_res , $res_json) ;
            	}
            	my $filtered_res = $oapi->_filter_scores_golm_results(\@limited_hits,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
																		$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold) ;
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
	## Description : filter golm's hits by distance scores 
	## Input : $results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
	##		   $DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold
	## Ouput : \@filtered_res ;
	## Usage : my ($filtered_res) = filter_scores_golm_results($results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
	##															$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold) ;

=cut

sub _filter_scores_golm_results() {
	## Retrieve Values
    my $self = shift ;
	my ($results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
		$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold) = @_ ;
		
	my @results = @$results ;
	my @filtered_res = () ;
	
	foreach my $res (@results){
		
			if ($res->{'JaccardDistance'} <= $JaccardDistanceThreshold && $s12GowerLegendreDistanceThreshold <= $DotproductDistanceThreshold
				&& $res->{'DotproductDistance' } <= $DotproductDistanceThreshold && $res->{'HammingDistance'} <= $HammingDistanceThreshold && 
				$res->{'EuclideanDistance' } <= $EuclideanDistanceThreshold) {
					
				push (@filtered_res , $res) ;
			}
	}
	return \@filtered_res ;
}

	
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