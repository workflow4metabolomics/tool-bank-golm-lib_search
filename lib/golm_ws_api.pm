package golm_ws_api ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;
#use SOAP::Lite ;
use SOAP::Lite +trace => [qw (debug)];


use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( connectWSlibrarySearchGolm LibrarySearch );
our %EXPORT_TAGS = ( ALL => [qw( connectWSlibrarySearchGolm LibrarySearch )] );

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
	## Input : $osoap, $ri, $riWindow, $gcColumn, $spectrum
	## Ouput : $spectra
	## Usage : ($spectra) = LibrarySearch($osoap, $ri, $riWindow, $gcColumn, $spectrum) ;

=cut

sub LibrarySearch() {
	## Retrieve Values
    my $self = shift ;
	my ($osoap, $ri, $riWindow, $gcColumn, $spectrum) = @_;
	
	# init in case :
	$ri = 1500 if ( !defined $ri ) ;
	$riWindow = 3000 if ( !defined $riWindow ) ;
	$gcColumn = 'VAR5' if ( !defined $gcColumn ) ;
	
	my %val = () ;
	my $res_status ;
	my @res ; # @ret = [ %val1, %val2,... ]
	
	if ( defined $spectrum ){
		    	
    	if ( $spectrum ne '' ) {
    		
    		my $ri = SOAP::Data -> name('ri' => $ri) ;
    		my $riWindow = SOAP::Data -> name('riWindow' => $riWindow) ;
    		my $gcColumn = SOAP::Data -> name('AlkaneRetentionIndexGcColumnComposition' => $gcColumn) ;
    		my $spectrum = SOAP::Data -> name('spectrum' => $spectrum) ;
    								
			my $som = $osoap -> LibrarySearch($ri, $riWindow, $gcColumn, $spectrum);
			
			## DETECTING A SOAP FAULT OR NOT
		    if ( $som ) {
		    	
		    	if ($som->fault) {
					push (@res, $som->faultstring) ;
				}
				
				else {
	
					$res_status = $som->valueof('//ResultOfAnnotatedMatch/Status') ;
					
					
					my $spectrumID;
					my $analyteID;
					my $ri;
					my $riDiscrepancy;
					my $DotproductDistance;
					my $EuclideanDistance;
					my $HammingDistance;
					my $JaccardDistance;
					my $s12GowerLegendreDistance;
					my $spectrumName;
					my $metaboliteID;
					
					#check if query successed and get results from xml via XPATH
					if ($res_status eq 'success') {
						for my $res ($som->valueof('//ResultOfAnnotatedMatch/Status')) {
						      
						      %val = ('analyteName', $res->{analyteName}, 'ri', $res->{ri}, 'spectrumID', $res->{spectrumID}, 'analyteID', $res->{analyteID}, 'riDiscrepancy', $res->{riDiscrepancy},
					      			'DotproductDistance', $res->{DotproductDistance}, 'EuclideanDistance', $res->{EuclideanDistance}, 'HammingDistance', $res->{HammingDistance},
					      			'JaccardDistance', $res->{JaccardDistance}, 's12GowerLegendreDistance', $res->{s12GowerLegendreDistance}, 'spectrumName', $res->{spectrumName},
					      			'metaboliteID', $res->{metaboliteID}) ;
					      	  push ( @res , { %val } ) ;
						}
					    
					    
					}
					## if query didn't go as planned
					else {
						%val = ('spectrumID', undef, 'analyteID', undef, 'ri', undef, 'riDiscrepancy', undef,
					      		'DotproductDistance', undef, 'EuclideanDistance', undef, 'HammingDistance', undef,
					      		'JaccardDistance', undef, 's12GowerLegendreDistance', undef, 'spectrumName', undef,
					      		'metaboliteID', undef) ;
						push ( @res , { %val } ) ;
					}
	    		}
		    }
		    else { carp "The som return (from the LibrarySearch method) isn't defined\n" ; }
    	}
    	else { carp "The spectrum for query is empty, Golm soap will stop\n" ; }
    }
    else { carp "The spectrum for query is undef, Golm soap will stop\n" ; }
    
    return(\@res) ;
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