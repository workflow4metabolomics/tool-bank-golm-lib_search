package lib::msp ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( get_mzs get_intensities get_intensities_and_mzs_from_string encode_spectrum_for_query sorting_descending_intensities);
our %EXPORT_TAGS = ( ALL => [qw( get_mzs get_intensities get_intensities_and_mzs_from_string encode_spectrum_for_query sorting_descending_intensities)] );

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
	## Input : $msp_file, $mzRes, $maxIon
	## Output : \@total_spectra_mzs 
	## Usage : my ( $mzs ) = get_mzs( $msp_file , $mzRes, $maxIon) ;
	## Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
=cut
## START of SUB
sub get_mzs {
	## Retrieve Values
    my $self = shift ;
    my ( $msp_file, $mzRes, $maxIons ) = @_ ;
  
  	my @ions = () ;
  	my @mzs = ();
  	my @total_spectra_mzs = ();
  	my $mz ;
  	my $i = 0 ;
  	  	
    open (MSP , "<" , $msp_file) or die $! ;
    
	{
		local $/ = 'Name' ;
	    my @infos = () ;
	    # Extract spectrum
	    while(my $line = <MSP>) {
	    	chomp $line;
	    	@infos = split (/\n/ , $line) ;
	    	#Detect spectrum
	    	for (my $i=0 ; $i<@infos ; $i++) {
		    	if ($infos[$i] =~ /(\d+\.?\d*)\s+(\d+\.?\d*)\s*;\s*?/) {
		    		@ions = split ( /;/ , $infos[$i] ) ;
		    		# Retrieve mzs according to maxIons value
		    		foreach my $ion (@ions) {
		    			if ($ion =~ /^\s*(\d+\.?\d*)\s+(\d+\.?\d*)$/) {
		    				$mz = $1 ;
		    				## Truncate mzs depending on $mzRes wanted
		    				if ($mzRes == 0 && @mzs < $maxIons) {
		    					$mz = int($mz) ;
		    					push (@mzs , $mz) ;
		    				}
		    				elsif (@mzs < $maxIons) { 
		    					$mz = substr ($mz , 0 , -$mzRes) ;
		    					push (@mzs , $mz) ;    					
		    				}
		    			}
		    		}
		    	}
	    	}
	    	if($line ne '') {
		    	@{ $total_spectra_mzs[$i] } = @mzs ;
			    $i++ ;
			    @mzs = () ;	  
	    	}  	
	    }
    }
    #print Dumper \@total_spectra_mzs ;
    close (MSP) ;
    return(\@total_spectra_mzs) ;
}
## END of SUB




=head2 METHOD get_intensities

	## Description : parse msp file and get intensities
	## Input : $msp_file, $maxIons
	## Output : \@total_spectra_intensities 
	## Usage : my ( $intensities ) = get_mzs( $msp_file, $maxIons ) ;
	## Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
=cut
## START of SUB
sub get_intensities {
	## Retrieve Values
    my $self = shift ;
    my ( $msp_file, $maxIons ) = @_ ;
  
  	my @ions = () ;
  	my @intensities = () ;
  	my @total_spectra_intensities = (); 
  	my $i = 0 ;
  	
    open (MSP , "<" , $msp_file) or die $! ;
    
    {
		local $/ = 'Name' ;
	    my @infos = () ;
	    # Extract spectrum
	    while(my $line = <MSP>) {
	    	chomp $line;
	    	@infos = split (/\n/ , $line) ;
	    	#Detect spectrum
	    	for (my $i=0 ; $i<@infos ; $i++) {
		    	if ($infos[$i] =~ /(\d+\.?\d*)\s+(\d+\.?\d*)\s*;\s*?/) {
		    		@ions = split ( /;/ , $infos[$i] ) ;
		    		# Retrieve intensities
		    		foreach my $ion (@ions) {
		    			if ($ion =~ /^\s*(\d+)\s+(\d+\.?\d*)$/ && @intensities < $maxIons) {
    						push ( @intensities , $2 ) ;
		    			}
		    		}
		    	}
	    	}
	    	if($line ne '') {
		    	@{ $total_spectra_intensities[$i] } = @intensities ;
			    $i++ ;
			    @intensities = () ;	  
	    	}  	
	    }
    }
    close (MSP) ;
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
    		
    		if ($spectrum_string =~ /\s*(\d+\.?\d*)\s+(\d+\.?\d*)\s*/ ) {
    		
	    		my @val = split (/\s+/ , $spectrum_string) ;
	    		for (my $i=0 ; $i<@val ; $i++) {
	    			if ($i%2 == 0)  { push @mzs,$val[$i] ; }
	    			else 			{ push @intensities,$val[$i] ; }
	    		}
	    		my @spectrum_intensities_mzs = (\@mzs , \@intensities) ;
	    		#print Dumper \@spectrum_intensities_mzs ;
	    		return \@spectrum_intensities_mzs ;
    		}
    		else { croak "Wrong format of the spectrum. See help\n" }
    	}
    	else { croak "Spectrum is empty, the service will stop\n" } ;
    }
    else { croak "Spectrum is not defined, service will stop\n" } ;
}
## END of SUB




=head2 METHOD sorting_descending_intensities

	## Description : parse a spectrum string and get mzs and intensities
	## Input : $spectrum_string
	## Output : \@spectrum_intensities_mzs 
	## Usage : my ( $spectrum_intensities_mzs ) = sorting_descending_intensities( $spectrum_string ) ;
=cut
## START of SUB
sub sorting_descending_intensities {
	## Retrieve Values
    my $self = shift ;
    my ( $ref_mzs_res, $ref_ints_res ) = @_ ;
    
    my @mzs_res = @$ref_mzs_res ;
	my @ints_res = @$ref_ints_res ;
	
	## Sorting ions by decreasing intensity values
	for (my $i=0 ; $i<@ints_res ; $i++) {
		my @sorted_indices = sort { @{$ints_res[$i]}[$b] <=> @{$ints_res[$i]}[$a] } 0..$#{$ints_res[$i]};
		@$_ = @{$_}[@sorted_indices] for \(@{$ints_res[$i]},@{$mzs_res[$i]});
	
	return (\@mzs_res, \@ints_res) ;
	}
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
    
    #print Dumper $mzs ;
    
    for (my $i=0 ; $i< @$mzs ; $i++) {
    	
    	for ( my $j=0 ; $j< @{ @$mzs[$i] } ; $j++ ) {
    		
    		$spectrum = $spectrum . $$mzs[$i][$j] . "%20" . $$intensities[$i][$j] . "%20";
    	}
    	#remove the "%20" at the end
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