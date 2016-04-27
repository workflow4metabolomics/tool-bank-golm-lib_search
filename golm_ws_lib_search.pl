#!perl

## script  : XXX.pl
#=============================================================================
#                              Included modules and versions
#=============================================================================
## Perl modules
use strict ;
use warnings ;
use Carp qw (cluck croak carp) ;

use Data::Dumper ;
use Getopt::Long ;
use FindBin ; ## Allows you to locate the directory of original perl script

## Specific Perl Modules (PFEM)
use lib $FindBin::Bin ;

## Dedicate Perl Modules PFEM
#use lib '/home/gabriel/lab/tool-bank-golm-lib_search/lib' ;
use lib '/media/gcretin/donnees2/lab_local/tool-bank-golm-lib_search/lib' ;
use golm_ws_api qw( :ALL ) ;
use msp qw( :ALL ) ;

## Initialized values
my ($OptHelp,$ri,$riWindow,$gcColumn,$msp_file,$maxHits,$mzRes,$maxIons,$threshold,$spectrum_string) = (undef,undef, undef, undef, undef,undef, undef, undef, undef,undef) ;
my @hits = () ;
my $encoded_spectra ;

#=============================================================================
#                                Manage EXCEPTIONS
#=============================================================================
&GetOptions ( 	
				"help|h"     => \$OptHelp,       # HELP
				"spectraFile:s"		=> \$msp_file,
				"spectrumString:s"		=> \$spectrum_string,
				"ri:f"		=> \$ri,
				"riWindow:f"		=> \$riWindow,
				"gcColumn:s"		=> \$gcColumn,
				"maxHits:i"		=> \$maxHits,
				"mzRes:i"		=> \$mzRes,
				"maxIons:i"		=> \$maxIons,
				"threshold:f"		=> \$threshold, # Optionnal
            ) ;
         
## if you put the option -help or -h or even no arguments, function help is started
if ( defined($OptHelp) ){ &help ; }

#=============================================================================
#                                MAIN SCRIPT
#=============================================================================



############# -------------- Parse the .msp file -------------- ############# :

my $omsp = msp->new() ;

## case when only one spectra is queried
if (defined $spectrum_string) { 
	my $omsp = msp->new() ;
	my $mzs_res = $omsp->get_intensities_and_mzs_from_string($spectrum_string) ;
	my @mzs = @$mzs_res[0] ;
	my @intensities = @$mzs_res[1] ;
	
	$encoded_spectra = $omsp->encode_spectrum_for_query(\@mzs,\@intensities) ;
	#print Dumper $encoded_spectra ;
}
## Taking care of the msp file
else { 
	my $ref_mzs_res = $omsp->get_mzs($msp_file,$mzRes) ;
	my $ref_ints_res = $omsp->get_intensities($msp_file) ;
	
	## Sorting intensities
	my ($mzs_res, $ints_res) = $omsp->sorting_descending_intensities($ref_mzs_res, $ref_ints_res) ;
		
	## Encode spectra
	$encoded_spectra = $omsp->encode_spectrum_for_query($mzs_res, $ints_res) ;
	
}



############# -------------- Send queries to Golm -------------- ############# :

my $oapi = golm_ws_api->new() ;

	foreach my $spectrum (@$encoded_spectra){
		my $results = $oapi->LibrarySearch ($ri, $riWindow, $gcColumn, $spectrum, $maxHits) ;
		push (@hits , $results) ;
}

print Dumper \@hits ;






#====================================================================================
# Help subroutine called with -h option
# number of arguments : 0
# Argument(s)        :
# Return           : 1
#====================================================================================
sub help {
	print STDERR "
golm_ws_lib_search.pl

# golm_ws_lib_search.pl is a script to use SOAP Golm webservice and send specific queries about spectra searches. 
# Input : a list of mzs and intensities.
# Authors : Yann Guitton / Gabriel Cretin / Franck Giacomoni
# Emails : franck.giacomoni\@clermont.inra.fr
#		   gabriel.cretin\@clermont.inra.fr
#		   yann.guitton\@oniris-nantes.fr
# Version : 1.0
# Created : xx/xx/2016
USAGE :		 
		golm_ws_lib_search.pl -help OR
		
		golm_ws_lib_search.pl 
			-spectraFile [.msp file]	
			-spectrumString [masses + intensities of an ion: 'mz1 int1 mz2 int2 mzx intx...']
			-ri [Rentention Index: float or integer ]
			-riWindow [Retention Index Window: 1500 or the value of your choice]
			-gcColumn [AlkaneRetentionIndexGcColumnComposition: 'VAR5' or 'MDN35' or 'None' ]
			-maxHits [Maximum hits per queried spectra: integer]
			-mzRes [Number of digits after the decimal point for m/z values: integer (0 -> 4)]
			-maxIons [Number of m/z per spectra you want to keep for the queries, default 0 for all detected ions]
			-threshold [ignore ions which masses are smaller than the threshold value: float]	
				
";
	exit(1);
}

## END of script

__END__

=head1 NAME

 XXX.pl -- script for

=head1 USAGE

 XXX.pl -precursors -arg1 [-arg2] 
 or XXX.pl -help

=head1 SYNOPSIS

This script manage ... 

=head1 DESCRIPTION

This main program is a ...

=over 4

=item B<function01>

=item B<function02>

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>
Marion Landi E<lt>marion.landi@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : xx / xx / 201x

version 2 : ??

=cut