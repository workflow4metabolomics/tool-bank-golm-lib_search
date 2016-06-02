package lib::golm_ws_api_test ;

use diagnostics; # this gives you more debugging information
use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Exporter ;
use Carp ;

use Data::Dumper ;

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( keep_only_max_massesTest keep_only_max_intensitiesTest test_query_golmTest connectWSlibrarySearchGolmTest LibrarySearchTest encode_spectrum_for_queryTest get_mzsTest get_intensitiesTest get_masses_from_stringTest get_intensities_from_stringTest sorting_descending_intensities1Test sorting_descending_intensities2Test remove_redundants1Test remove_redundants2Test filter_scores_golm_resultsTest filter_replica_resultsTest apply_relative_intensityTest);
our %EXPORT_TAGS = ( ALL => [qw( keep_only_max_massesTest keep_only_max_intensitiesTest test_query_golmTest connectWSlibrarySearchGolmTest LibrarySearchTest encode_spectrum_for_queryTest get_mzsTest get_intensitiesTest get_masses_from_stringTest get_intensities_from_stringTest sorting_descending_intensities1Test sorting_descending_intensities2Test remove_redundants1Test remove_redundants2Test filter_scores_golm_resultsTest filter_replica_resultsTest apply_relative_intensityTest)] );


use lib::golm_ws_api qw( :ALL ) ;
use lib::msp qw( :ALL ) ;
use lib::output qw( :ALL ) ;

### Test API module ###

sub test_query_golmTest {
	my ($ws_url, $ws_proxy) = @_;
    my $oBih = lib::golm_ws_api->new() ;
    my ($status) = $oBih->test_query_golm($ws_url, $ws_proxy) ;
    return ($status) ;
}


sub connectWSlibrarySearchGolmTest {
	my ($ws_url, $ws_proxy) = @_ ;
    my $oBih = lib::golm_ws_api->new() ;
    my ($soap) = $oBih->connectWSlibrarySearchGolm($ws_url, $ws_proxy) ;
    return ($soap) ;
}


sub LibrarySearchTest {
	my ($ri, $riWindow, $gcColumn, $spectrum, $maxHits, $JaccardDistanceThreshold,
		$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,$HammingDistanceThreshold,
		$EuclideanDistanceThreshold,$ws_url, $ws_proxy,$default_ri, $default_ri_window, $default_gc_column) = @_ ;
	my $oBih = lib::golm_ws_api->new() ;
    my ($limited_hits) =$oBih->LibrarySearch($ri, $riWindow, $gcColumn, $spectrum, $maxHits, $JaccardDistanceThreshold,
											$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,$HammingDistanceThreshold,
											$EuclideanDistanceThreshold,$ws_url, $ws_proxy,$default_ri, $default_ri_window, $default_gc_column) ;
    return ($limited_hits) ;
}


sub filter_scores_golm_resultsTest {
	my ($results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
		$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold) = @_ ;
    my $oBih = lib::golm_ws_api->new() ;
    my ($filtered_res_before_hits_limited) = $oBih->filter_scores_golm_results($results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
													$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold) ;
    return ($filtered_res_before_hits_limited) ;
}


sub filter_replica_resultsTest {
	my ($results) = @_ ;
    my $oBih = lib::golm_ws_api->new() ;
    my ($sortAnalytes) = $oBih->filter_replica_results($results) ;
    return ($sortAnalytes) ;
}




### Test MSP module ###

sub get_mzsTest {
	my ($inputSpectra, $mzRes) = @_;
	my $omsp = lib::msp->new();
	my $mzs = $omsp->get_mzs ($inputSpectra, $mzRes) ;
    return($mzs) ;
}


sub get_intensitiesTest {
	my ($inputSpectra) = @_;
	my $omsp = lib::msp->new();
	my $intensities = $omsp->get_intensities($inputSpectra) ;
    return($intensities) ;
}


sub get_masses_from_stringTest {
	my ($inputSpectra, $mzRes) = @_;
	my $omsp = lib::msp->new();
	my ($ref_mzs_res) = $omsp->get_masses_from_string($inputSpectra, $mzRes) ;
    return($ref_mzs_res) ;
}


sub get_intensities_from_stringTest {
	my ($inputSpectra) = @_;
	my $omsp = lib::msp->new();
	my ($ref_ints_res) = $omsp->get_intensities_from_string($inputSpectra) ;
    return($ref_ints_res) ;
}


sub keep_only_max_massesTest {
	my ($ref_mzs_res, $maxIons) = @_;
	my $omsp = lib::msp->new();
	my ($mzs_res_sorted) = $omsp->keep_only_max_masses($ref_mzs_res, $maxIons) ;
    return($mzs_res_sorted) ;
}


sub keep_only_max_intensitiesTest {
	my ($ref_ints_res, $maxIons) = @_;
	my $omsp = lib::msp->new();
	my ($ints_res_sorted) = $omsp->keep_only_max_intensities($ref_ints_res, $maxIons) ;
    return($ints_res_sorted) ;
}


sub sorting_descending_intensities1Test {
	my ($uniq_total_masses, $uniq_total_intensities) = @_;
	my $omsp = lib::msp->new();
	my ($mzs_res_sorted, $ints_res_sorted) = $omsp->sorting_descending_intensities($uniq_total_masses, $uniq_total_intensities) ;
    return($mzs_res_sorted) ;
}


sub sorting_descending_intensities2Test {
	my ($uniq_total_masses, $uniq_total_intensities) = @_;
	my $omsp = lib::msp->new();
	my ($mzs_res_sorted, $ints_res_sorted) = $omsp->sorting_descending_intensities($uniq_total_masses, $uniq_total_intensities) ;
    return($ints_res_sorted) ;
}


sub encode_spectrum_for_queryTest {
	my ($mzs_res_sorted, $relative_ints_res) = @_;
	my $omsp = lib::msp->new();
	my $encoded_spectra = $omsp->encode_spectrum_for_query($mzs_res_sorted, $relative_ints_res) ;
	return ($encoded_spectra) ;
}


sub remove_redundants1Test {
	my ($ref_mzs_res, $ref_ints_res) = @_;
	my $omsp = lib::msp->new();
	my ($uniq_masses , $uniq_intensities) = $omsp->remove_redundants($ref_mzs_res, $ref_ints_res, $ref_mzs_res, $ref_ints_res) ;
	return ($uniq_masses ) ;
}


sub remove_redundants2Test {
	my ($ref_mzs_res, $ref_ints_res) = @_;
	my $omsp = lib::msp->new();
	my ($uniq_masses , $uniq_intensities) = $omsp->remove_redundants($ref_mzs_res, $ref_ints_res, $ref_mzs_res, $ref_ints_res) ;
	return ($uniq_intensities) ;
}


sub apply_relative_intensityTest {
	my ($uniq_total_intensities) = @_;
	my $omsp = lib::msp->new();
	my ($relative_ints_res) = $omsp->apply_relative_intensity($uniq_total_intensities) ;
	return ($relative_ints_res) ;
}





1 ;