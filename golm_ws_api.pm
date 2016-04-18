package lib::golm_ws_api ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;
use SOAP::Lite ;
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
		-> uri('gmd.mpimp-golm.mpg.de')
		-> proxy('http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx/', timeout => 100 )
		-> on_fault(sub { my($soap, $res) = @_; 
         eval { die ref $res ? $res->faultstring : $soap->transport->status, "\n"};
         return ref $res ? $res : new SOAP::SOM ;
         });
	
	return ($osoap);
}
### END of SUB
     

=head2 METHOD LibrarySearch

	## Description : Matches a single user submitted GC-EI mass spectrum against the Golm Metabolome Database (GMD).
	## Input : $osoap, $ri, $riWindow, $gcColumn, $mzs, $intensities
	## Ouput : $spectra
	## Usage : ($spectra) = LibrarySearch($osoap, $ri, $riWindow, $gcColumn, $mzs, $intensities) ;

=cut

sub LibrarySearch() {
	## Retrieve Values
    my $self = shift ;
	my ($osoap, $ri, $riWindow, $gcColumn, $mzs, $intensities) = @_;
	
	# init in case :
	$ri = 1500 if ( !defined $ri ) ;
	$riWindow = 3000 if ( !defined $riWindow ) ;
	$gcColumn = 'VAR5' if ( !defined $gcColumn ) ;
	
	my %res = () ;
	
	if ( defined $mzs ){
		my $nb_mzs = scalar (@{$mzs}) ;
    	
    	if ( $nb_mzs > 0 ) {
    		
    		my @data1 = () ;
    		my @data2 = () ;    		
    		my @mzs = @{$mzs} ;
    		my @intensities = @{$intensities} ;
    		my $i = 0;
    		
    		foreach my $mz (@mzs) {
				push(@data1, SOAP::Data -> name('mzs' => $mz) );
				push(@data2, SOAP::Data -> name('intensities' => $intensities[$i]) );
				$i++ ;
			}
    		
    		push(@data2, SOAP::Data -> name('ri' => $ri) ) ;
			push(@data2, SOAP::Data -> name('riWindow' => $riWindow) ) ;
			push(@data2, SOAP::Data -> name('gcColumn' => $gcColumn) ) ;
			
			
    		my $data = SOAP::Data -> value(@data1, @data2);
			my $som = $osoap -> searchSpectrum($data);
			
			## DETECTING A SOAP FAULT OR NOT
		    if ( $som ) {
		    	if ($som->fault) {
					$res{'fault'} = $som->faultstring ;
				}
				else {
					my $res_status = $som->valueof('//LibrarySearchResponse/LibrarySearchResult/Results/Status') ;
					
					#get results from xml via XPATH
					
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
					
					if ($res_status eq 'success') {
						for my $res ($som->valueof('//LibrarySearchResponse/LibrarySearchResult/Results')) {
						      $spectrumID = $res->{spectrumID} ;
						      $analyteID = $res->{analyteID} ;
						      $ri = $res->{ri} ;
						      $riDiscrepancy = $res->{riDiscrepancy} ;
						      $DotproductDistance = $res->{DotproductDistance} ;
						      $EuclideanDistance = $res->{EuclideanDistance} ;
						      $HammingDistance = $res->{HammingDistance} ;
						      $JaccardDistance = $res->{JaccardDistance} ;
						      $s12GowerLegendreDistance = $res->{s12GowerLegendreDistance} ;
						      $spectrumName = $res->{spectrumName} ;
						      $metaboliteID = $res->{metaboliteID} ;
						}
						
					    %res = ('spectrumID', $spectrumID, 'analyteID', $analyteID, 'ri', $ri, 'riDiscrepancy', $riDiscrepancy,
					      			'DotproductDistance', $DotproductDistance, 'EuclideanDistance', $EuclideanDistance, 'HammingDistance', $HammingDistance,
					      			'JaccardDistance', $JaccardDistance, 's12GowerLegendreDistance', $s12GowerLegendreDistance, 'spectrumName', $spectrumName,
					      			'metaboliteID', $metaboliteID) ;
					    
					}
					## if query didn't go as planned
					else {
						%res = ('spectrumID', undef, 'analyteID', undef, 'ri', undef, 'riDiscrepancy', undef,
					      			'DotproductDistance', undef, 'EuclideanDistance', undef, 'HammingDistance', undef,
					      			'JaccardDistance', undef, 's12GowerLegendreDistance', undef, 'spectrumName', undef,
					      			'metaboliteID', undef) ;
						
					}
	    		}
		    }
		    else {
		    	carp "The som return (from the LibrarySearch method) isn't defined\n" ; }
    	}
    	else { carp "Query MZs list is empty, Golm soap will stop\n" ; }
    }
    else { carp "Query MZs list is undef, Golm soap will stop\n" ; }
#	print Dumper @ret ;
    return(\%res) ;
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

version 1 : xx / xx / 201x

version 2 : ??

=cut