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
use JSON ;

## Dedicate Perl Modules PFEM
use lib::golm_ws_api qw( :ALL ) ;
use lib::msp qw( :ALL ) ;
use lib::output qw( :ALL ) ;
use lib::conf qw( :ALL ) ;

## Initialized values
my ($OptHelp,$ri,$riWindow,$gcColumn,$inputFile,$inputMasses,$maxHits,$mzRes,$maxIons,$threshold,$relative) = (undef,undef,undef,undef,undef,undef,undef,undef,undef,undef,undef) ;
my ( $JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold ) = (undef,undef,undef,undef,undef) ;
my ($excel_file,$html_file,$html_template,$json_file,$csv_file) = (undef,undef,undef,undef,undef) ;
my (@hits, @ojson) = ( () , () ) ;
my $encoded_spectra ;

## if you put no arguments, function help is started
if (!@ARGV){ &help ; } 

#=============================================================================
#                                Manage EXCEPTIONS
#=============================================================================
&GetOptions ( 	
				"help|h"     => \$OptHelp,       # HELP
				"inputFile:s"		=> \$inputFile,
				"inputMasses:s"		=> \$inputMasses,
				"ri:i"		=> \$ri,
				"riWindow:i"		=> \$riWindow,
				"gcColumn:s"		=> \$gcColumn,
				"maxHits:i"		=> \$maxHits,
				"mzRes:i"		=> \$mzRes,
				"maxIons:i"		=> \$maxIons,
				"JaccardDistanceThreshold:f"		=> \$JaccardDistanceThreshold,
				"s12GowerLegendreDistanceThreshold:f"		=> \$s12GowerLegendreDistanceThreshold,
				"DotproductDistanceThreshold:f"		=> \$DotproductDistanceThreshold,
				"HammingDistanceThreshold:f"		=> \$HammingDistanceThreshold,
				"EuclideanDistanceThreshold:f"		=> \$EuclideanDistanceThreshold,
				"relative:s"			=> \$relative,
				"excelFile:s"			=> \$excel_file,
				"htmlFile:s"		=> \$html_file,
				"jsonFile:s"		=> \$json_file,
				"csvFile:s"		=> \$csv_file,
            ) ;
            
            die "maxHits must be >= 0\n" unless ($maxHits >= 0) ;
            die "mzRes must be >= 0 \n" unless ($mzRes >= 0) ;
            die "maxIons must be >= 0\n" unless ($maxIons >= 0) ;
            
         
## if you put the option -help or -h function help is started         
if(defined($OptHelp)){ &help ; }

#=============================================================================
#                                MAIN SCRIPT
#=============================================================================

## Create module objects ###

my $oapi = lib::golm_ws_api->new() ;
my $omsp = lib::msp->new() ;
my $o_output = lib::output->new() ;
my $oConf = lib::conf->new() ;


## -------------- Conf file ------------------------ :
my ( $CONF ) = ( undef ) ;
foreach my $conf ( <$binPath/*.cfg> ) {
	$CONF = $oConf->as_conf($conf) ;
}

## -------------- HTML template file ------------------------ :
$html_template = <$binPath/golm_out.tmpl> ;
$CONF->{'HTML_TEMPLATE'} = $html_template ;


## -------------- Retrieve values from conf file ------------------------ :
my $ws_url = $CONF->{'WS_URL'} ;
my $ws_proxy = $CONF->{'WS_PROXY'} ;
my $default_ri = $CONF->{'RI'} ;
my $default_ri_window = $CONF->{'RI_WINDOW'} ;
my $default_gc_column = $CONF->{'GC_COLUMN'} ;
my $default_entries = $CONF->{'DEFAULT_ENTRIES'} ;
my $analyte_ref = $CONF->{'ANALYTE_REF'} ;
my $metabolite_ref = $CONF->{'METABOLITE_REF'} ;
my $spectrum_ref = $CONF->{'SPECTRUM_REF'} ;

############# -------------- Test the Golm web service -------------- ############# :

$oapi->test_query_golm($ws_url, $ws_proxy) ;

############# -------------- Parse the .msp file -------------- ############# :


my $ref_mzs_res ;
my $ref_ints_res ;

## Case when masses are entered manually
if (defined $inputMasses && !defined $inputFile) { 
	
	## Retrieve masses from msp file
	$ref_mzs_res = $omsp->get_masses_from_string($inputMasses, $mzRes) ;
	
	## Retrieve intensities from msp file
	$ref_ints_res = $omsp->get_intensities_from_string($inputMasses) ;
	
	## Sorting intensities
	my ($mzs_res_sorted, $ints_res_sorted) = $omsp->sorting_descending_intensities($ref_mzs_res, $ref_ints_res) ;
	
	## Keep a limited number of ions according to $maxIons
	if($maxIons > 0){
		
		$ref_mzs_res = $omsp->keep_only_max_masses( $mzs_res_sorted, $maxIons ) ;
		$ref_ints_res = $omsp->keep_only_max_intensities( $ints_res_sorted, $maxIons ) ;
	}
	
	## Remove redundant masses
	my ($uniq_masses , $uniq_intensities) = $omsp->remove_redundants($ref_mzs_res, $ref_ints_res) ;
	
	## Relative intensity
	my $relative_ints_res = undef ;
	if ($relative eq "true") {
		my @relative_ints = map { ($_ * 100)/@$ints_res_sorted[0] } @$ints_res_sorted ;
		$relative_ints_res = \@relative_ints ;
	}
	
	## Encode spectra
	if (defined $relative_ints_res) {
		$encoded_spectra = $omsp->encode_spectrum_for_query($mzs_res_sorted, $relative_ints_res) ;
	}
	else { $encoded_spectra = $omsp->encode_spectrum_for_query($mzs_res_sorted, $ints_res_sorted) ; }
	
}
## Case with the msp file
elsif (defined $inputFile and -e $inputFile and !defined $inputMasses and defined $mzRes and defined $maxIons and defined $maxHits) {

	unless (-f $inputFile)  { croak "$inputFile is not a file" ; }
	unless (-s $inputFile)  { croak "$inputFile is empty" ; }
	
	## Get masses and their intensities
	$ref_mzs_res = $omsp->get_mzs($inputFile, $mzRes) ;
	$ref_ints_res = $omsp->get_intensities($inputFile, $maxIons) ;
	
	## Sorting intensities
	my ($mzs_res_sorted, $ints_res_sorted) = $omsp->sorting_descending_intensities($ref_mzs_res, $ref_ints_res) ;
	
	## Keep only $maxIons ions
	if($maxIons > 0){
		( $mzs_res_sorted ) = $omsp->keep_only_max_masses( $mzs_res_sorted, $maxIons ) ;
		( $ints_res_sorted ) = $omsp->keep_only_max_intensities( $ints_res_sorted, $maxIons ) ;
	}
	
	## Remove redundant masses
	my ($uniq_masses , $uniq_intensities) = (undef,undef) ;
	my @uniq_total_masses = () ;
	my @uniq_total_intensities = () ;
	
	for (my $i=0 ; $i<@$mzs_res_sorted && $i<@$ints_res_sorted ; $i++) {
	
		($uniq_masses , $uniq_intensities) = $omsp->remove_redundants(@$mzs_res_sorted[$i], @$ints_res_sorted[$i]) ;
		push (@uniq_total_masses , $uniq_masses) ;
		push (@uniq_total_intensities, $uniq_intensities) ;
	}
	
	## Relative intensity
	my $relative_ints_res = undef ;
	if ($relative eq "true") {
		$relative_ints_res = $omsp->apply_relative_intensity(\@uniq_total_intensities) ;
	}
	
	## Encode spectra
	if (defined $relative_ints_res) {
		$encoded_spectra = $omsp->encode_spectrum_for_query(\@uniq_total_masses, $relative_ints_res) ;
	}
	else { $encoded_spectra = $omsp->encode_spectrum_for_query(\@uniq_total_masses, \@uniq_total_intensities) ; }

}
elsif (!defined $maxHits or !defined $maxIons or !defined $mzRes) { croak "Parameters mzRes or maxIons or maxHits are undefined\n"; } 
elsif (!-f $inputFile) 										  	  { croak "$inputFile does not exist" ; }

############# -------------- Send queries to Golm -------------- ############# :

my $limited_hits ;
foreach my $spectrum (@$encoded_spectra){
	($limited_hits) = $oapi->LibrarySearch ($ri, $riWindow, $gcColumn, $spectrum, $maxHits, $JaccardDistanceThreshold,
																										  $s12GowerLegendreDistanceThreshold,
																										  $DotproductDistanceThreshold,
																										  $HammingDistanceThreshold,
																										  $EuclideanDistanceThreshold,
																										  $ws_url, $ws_proxy,
																										  $default_ri, $default_ri_window, $default_gc_column) ;
	push (@hits , $limited_hits) ;
}
			

############# -------------- Build outputs -------------- ############# :
	
my $jsons_obj = $o_output->build_json_res_object(\@hits) ;
#$o_output->write_json_skel(\$json_file, $jsons_obj) ;

# Build the ajax data source for html view
#my $ajax = $o_output->write_ajax_data_source($jsons_obj) ;


my $tbody_entries = $o_output->add_entries_to_tbody_object($jsons_obj,$analyte_ref,$metabolite_ref,$spectrum_ref) ;
$o_output->write_html_body($jsons_obj, $tbody_entries, $html_file, $html_template, $default_entries, $jsons_obj) ;
$o_output->excel_like_output($excel_file, $jsons_obj) ;
$o_output->write_csv($csv_file , $jsons_obj) ;


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
# Input : a list of masses (m/z) and their intensities.
# Authors : Gabriel Cretin / Franck Giacomoni / Yann Guitton 
# Emails : franck.giacomoni\@clermont.inra.fr
#		   gabriel.cretin\@clermont.inra.fr
#		   yann.guitton\@oniris-nantes.fr
# Version : 1.0
# Created : 07/06/2016
USAGE :		 
		golm_ws_lib_search.pl -help OR
		
		golm_ws_lib_search.pl 
			-spectraFile [.msp file]	
			-spectraMasses [masses + intensities of an ion: 'mz1 int1 mz2 int2 mzx intx...']
			-ri [Rentention Index: float or integer]
			-riWindow [Retention Index Window: 1500 or the value of your choice]
			-gcColumn [AlkaneRetentionIndexGcColumnComposition: 'VAR5' or 'MDN35' or 'None']
			-maxHits [Maximum hits per queried spectra: integer >= 1 (100 for all of them)]
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
			-csv_file [name of the csv file in output: string]
				
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