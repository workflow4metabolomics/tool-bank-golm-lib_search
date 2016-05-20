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
my $binPath = $FindBin::Bin ;

## Dedicate Perl Modules PFEM
use lib::golm_ws_api qw( :ALL ) ;
use lib::msp qw( :ALL ) ;
use lib::output qw( :ALL ) ;
use lib::conf qw( :ALL ) ;

## Initialized values
my ($OptHelp,$ri,$riWindow,$gcColumn,$msp_file,$maxHits,$mzRes,$maxIons,$threshold,$spectrum_string,$relative) = (undef,undef,undef,undef,undef,undef,undef,undef,undef,undef,undef) ;
my ( $JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold ) = (undef,undef,undef,undef,undef) ;
my ($excel_file,$html_file,$html_template,$json_file) = (undef,undef,undef,undef) ;
my (@hits, @ojson) = ( () , () ) ;
my $encoded_spectra ;

## if you put no arguments, function help is started
if (!@ARGV){ &help ; } 

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
				"JaccardDistanceThreshold:f"		=> \$JaccardDistanceThreshold,
				"s12GowerLegendreDistanceThreshold:f"		=> \$s12GowerLegendreDistanceThreshold,
				"DotproductDistanceThreshold:f"		=> \$DotproductDistanceThreshold,
				"HammingDistanceThreshold:f"		=> \$HammingDistanceThreshold,
				"EuclideanDistanceThreshold:f"		=> \$EuclideanDistanceThreshold,
				"relative"			=> \$relative,
				"excelFile:s"			=> \$excel_file,
				"htmlFile:s"		=> \$html_file,
				"json_file:s"		=> \$json_file
            ) ;
            
            die "maxHits must be >= 0\n" unless ($maxHits >= 0) ;
            die "mzRes must be >= 0 \n" unless ($mzRes >= 0) ;
            die "maxIons must be >= 0\n" unless ($maxIons >= 0) ;
            
         
## if you put the option -help or -h function help is started         
if(defined($OptHelp)){ &help ; }

#=============================================================================
#                                MAIN SCRIPT
#=============================================================================


## -------------- Conf file ------------------------ :
my ( $CONF ) = ( undef ) ;
foreach my $conf ( <$binPath/*.cfg> ) {
	my $oConf = lib::conf->new() ;
	$CONF = $oConf->as_conf($conf) ;
}

## -------------- HTML template file ------------------------ :
$html_template = <$binPath/golm_out.tmpl> ;
$CONF->{'HTML_TEMPLATE'} = $html_template ;



## Create new module objects ###

my $oapi = lib::golm_ws_api->new() ;
my $omsp = lib::msp->new() ;
my $o_output = lib::output->new() ;


############# -------------- Test the Golm web service -------------- ############# :

$oapi->test_query_golm() ;

############# -------------- Parse the .msp file -------------- ############# :


my $ref_mzs_res ;
my $ref_ints_res ;

## Case when only one spectra is queried
if (defined $spectrum_string) { 
	
	my $mzs_res = $omsp->get_intensities_and_mzs_from_string($spectrum_string) ;
	my @mzs = @$mzs_res[0] ;
	my @intensities = @$mzs_res[1] ;
	
	$encoded_spectra = $omsp->encode_spectrum_for_query(\@mzs,\@intensities) ;
	#print Dumper $encoded_spectra ;
}
## Taking care of the msp file
elsif (defined $msp_file and defined $mzRes and defined $maxIons and defined $maxHits) {
	
	unless (-e $msp_file)  { croak "$msp_file does not exist" ; }
	unless (-f $msp_file)  { croak "$msp_file is not a file" ; }
	unless (-s $msp_file)  { croak "$msp_file is empty" ; }
	
	
	$ref_mzs_res = $omsp->get_mzs($msp_file,$mzRes,$maxIons) ;
	$ref_ints_res = $omsp->get_intensities($msp_file, $maxIons) ;
	
	## Sorting intensities
	my ($mzs_res, $ints_res) = $omsp->sorting_descending_intensities($ref_mzs_res, $ref_ints_res) ;
	
	## Relative intensity
	my $relative_ints_res = undef ;
	if ($relative eq "true") {
		$relative_ints_res = $omsp->apply_relative_intensity($ints_res) ;
	}
	
	## Encode spectra
	if (defined $relative_ints_res) {
		$encoded_spectra = $omsp->encode_spectrum_for_query($mzs_res, $relative_ints_res) ;
	}
	else { $encoded_spectra = $omsp->encode_spectrum_for_query($mzs_res, $ints_res) ; }
}
elsif (!defined $maxHits or !defined $maxIons or !defined $mzRes) { croak "Parameters mzRes or maxIons or maxHits are undefined\n"; } 


############# -------------- Send queries to Golm -------------- ############# :

foreach my $spectrum (@$encoded_spectra){
	my ($limited_hits, $res_json) = $oapi->LibrarySearch ($ri, $riWindow, $gcColumn, $spectrum, $maxHits, $JaccardDistanceThreshold,
																										  $s12GowerLegendreDistanceThreshold,
																										  $DotproductDistanceThreshold,
																										  $HammingDistanceThreshold,
																										  $EuclideanDistanceThreshold) ;
	push (@hits , $limited_hits) ;
	push (@ojson , $res_json) ;
}

############# -------------- Build outputs -------------- ############# :

my $jsons_obj = $o_output->build_json_res_object(\@hits) ;
$o_output->write_json_skel(\$json_file, $jsons_obj) ;

my $tbody_entries = $o_output->add_entries_to_tbody_object($jsons_obj) ;
$o_output->write_html_body($jsons_obj, $tbody_entries, $html_file, $html_template) ;
$o_output->excel_output($excel_file, $jsons_obj) ;


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
			-ri [Rentention Index: float or integer]
			-riWindow [Retention Index Window: 1500 or the value of your choice]
			-gcColumn [AlkaneRetentionIndexGcColumnComposition: 'VAR5' or 'MDN35' or 'None']
			-maxHits [Maximum hits per queried spectra: integer (0 for all)]
			-mzRes [Number of digits after the decimal point for m/z values: integer (0 if none)]
			-maxIons [Number of m/z per spectra you want to keep for the queries, default 0 for all detected ions]
			-JaccardDistanceThreshold...............[
			-s12GowerLegendreDistanceThreshold......[  Threshold for each score. Hits with greater scores are ignored: 0 (perfect match) < threshlold <= 1 (mismatch) ]
			-DotproductDistanceThreshold............[
			-EuclideanDistanceThreshold.............[
			-HammingDistanceThreshold[Threshold for hamming score. Hits with greater scores are ignored: 0 - perfect match to higher values indicating a mismatch]
			-relative [Transforms absolute intensities in the msp file into relative intensities: (intensity * 100)/ max(intensitiess), otherwise, leave them absolute: true or false]
			-excelFile [name of the xls file in output: string]
			-htmlFile [name of the html file in output: string]
			-json_file [name of the json file in output: string]
				
";
	exit(1);
}

## END of script

__END__

=head1 NAME

 golm_ws_lib_search.pl -- script to send GC-MS spectra queries to Golm Metabolome Database (GMD)

=head1 USAGE

 XXX.pl -precursors -arg1 [-arg2] 
 or XXX.pl -help

=head1 SYNOPSIS

This script sends GC-MS EI spectra from an msp file given in argument to Golm Database, and presents results on a web interface.

=head1 DESCRIPTION

This main program is a ...

=over 4

=item B<function01>

=item B<function02>

=back

=head1 AUTHOR

Gabriel Cretin	E<lt>gabriel.cretin@clermont.inra.frE<gt>
Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : xx / xx / 2016

version 2 : ??

=cut