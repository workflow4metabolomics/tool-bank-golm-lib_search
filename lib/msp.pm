package msp ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( get_mzs get_intensities encode_spectrum_for_query);
our %EXPORT_TAGS = ( ALL => [qw( get_mzs get_intensities encode_spectrum_for_query)] );

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



=head2 METHOD get_mzs

	## Description : parse msp file and get mzs
	## Input : $msp_file
	## Output : \@total_spectra_mzs 
	## Usage : my ( $mzs ) = get_mzs( $msp_file ) ;
	## Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
=cut
## START of SUB
sub get_mzs {
	## Retrieve Values
    my $self = shift ;
    my ( $msp_file ) = @_ ;
  
  	my @ions ;
  	my @mzs ;
  	my @total_spectra_mzs ; 
  	my $i = 0 ;
  	
    open (MSP , "<" , $msp_file) or die $! ;
    
     # Extract spectrum
    while(<MSP>) {
    	chomp ;
    	#Detect spectrum
    	if (/^\s(.+);/) {
    		@ions = split /;/ , $1 ;
    		# retrieve mz of a spectrum
    		foreach my $ion (@ions) {
    			if ($ion =~ /^\s*(\d+)\s+(\d+\.?\d*)$/) {
    					push @mzs , int($1) ;
    			}
    		}
    	}
    	if(/^$/) {
    		@{ $total_spectra_mzs[$i] } = @mzs ;
    		@mzs = () ;
    		$i++ ;
    	}
    }
    return(\@total_spectra_mzs) ;
}
## END of SUB




=head2 METHOD get_intensities

	## Description : parse msp file and get intensities
	## Input : $msp_file
	## Output : \@total_spectra_intensities 
	## Usage : my ( $intensities ) = get_mzs( $msp_file ) ;
	## Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
=cut
## START of SUB
sub get_intensities {
	## Retrieve Values
    my $self = shift ;
    my ( $msp_file ) = @_ ;
  
  	my @ions ;
  	my @intensities ;
  	my @total_spectra_intensities ; 
  	my $i = 0 ;
  	
    open (MSP , "<" , $msp_file) or die $! ;
    
     # Extract spectrum
    while(<MSP>) {
    	chomp ;
    	#Detect spectrum
    	if (/^\s(.+);/) {
    		@ions = split /;/ , $1 ;
    		# retrieve intensity of a spectrum
    		foreach my $ion (@ions) {
    			if ($ion =~ /^\s*(\d+)\s+(\d+\.?\d*)$/) {
    				push @intensities , $2 ;
    			}
    		}
    	}
    	if(/^$/) {
    		@{ $total_spectra_intensities[$i] } = @intensities ;
    		@intensities = () ;
    		$i++ ;
    	}
    }
    return(\@total_spectra_intensities) ;
}
## END of SUB


=head2 METHOD get_intensities_and_mzs_from_string

	## Description : parse a spectrum string and get mzs and intensities
	## Input : $spectrum_string
	## Output : \@spectrum_intensities_mzs 
	## Usage : my ( $spectrum_intensities_mzs ) = get_intensities_and_mzs_from_string( $spectrum_string ) ;
=cut
## START of SUB
sub get_intensities_and_mzs_from_string {
	## Retrieve Values
    my $self = shift ;
    my ( $spectrum_string ) = @_ ;
    
    my @intensities = () ;
    my @mzs = () ;
        
    if (defined $spectrum_string) {
    	
    	if ($spectrum_string ne '') {
    		
    		my @val = split (/ / , $spectrum_string) ;
    		for (my $i=0 ; $i<@val ; $i++) {
    			if ($i%2 == 0) { push @mzs,$val[$i] ; }
    			else { push @intensities,$val[$i] ; }
    		}
    		my @spectrum_intensities_mzs = (\@mzs , \@intensities) ;
    		return \@spectrum_intensities_mzs ;
    	}
    	else { croak "Spectrum is empty, the service will stop\n" } ;
    }
    else { croak "Spectrum is not defined, service will stop\n" } ;
}
## END of SUB




=head2 METHOD encode_spectrum_for_query

	## Description : get mzs and intensities values and generate the spectra strings formatted for the WS query (html) 
	## Input : $mzs, $intensities
	## Output : \@encoded_spectra
	## Usage : my ( $encoded_spectra ) = get_spectra( $mzs, $intensities ) ;
	
=cut
## START of SUB
sub encode_spectrum_for_query {
	## Retrieve Values
    my $self = shift ;
    my ( $mzs, $intensities ) = @_ ;
    
    my @encoded_spectra ;
    my $spectrum = "" ;
    my $k = 0 ;
    
    #print "Coucou". @{@$mzs[0]} ;
    
    for (my $i=0 ; $i< @$mzs ; $i++) {
    	
    	for ( my $j=0 ; $j<scalar @{@$mzs[$i]} ; $j++ ) {
    		
    		$spectrum = $spectrum . $$mzs[$i][$j] . "%20" . $$intensities[$i][$j] . "%20";
    	}
    	$spectrum = substr($spectrum,0,-3);
    	$encoded_spectra[$k] = $spectrum ;
    	$k++ ;
    	$spectrum = '' ;
    }
    
    return \@encoded_spectra ;
}
## END of SUB



1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc csv.pm

=head1 Exports

=over 4

=item :ALL is get_spectra

=back

=head1 AUTHOR

Gabriel Cretin E<lt>gabriel.cretin@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : ??

=cut