package lib::golm_ws_api_test ;

use diagnostics; # this gives you more debugging information
use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Exporter ;
use Carp ;

use Data::Dumper ;

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( connectWSlibrarySearchGolmTest LibrarySearchTest encode_spectrum_for_queryTest get_mzsTest get_intensitiesTest get_intensities_and_mzs_from_stringTest sorting_descending_intensitiesTest);
our %EXPORT_TAGS = ( ALL => [qw( connectWSlibrarySearchGolmTest LibrarySearchTest encode_spectrum_for_queryTest get_mzsTest get_intensitiesTest get_intensities_and_mzs_from_stringTest sorting_descending_intensitiesTest)] );


use lib::golm_ws_api qw( :ALL ) ;
use lib::msp qw( :ALL ) ;

### Test API module ###

sub connectWSlibrarySearchGolmTest {
    my $oBih = lib::golm_ws_api->new() ;
    my ($soap) = $oBih->connectWSlibrarySearchGolm() ;
    #print Dumper $soap ;
    return ($soap) ;
}


sub LibrarySearchTest {
	my ($ri, $riWindow, $gcColumn, $spectrum, $maxHits) = @_ ;
	my $oBih = lib::golm_ws_api->new() ;
    my ($limited_hits) =$oBih->LibrarySearch($ri, $riWindow, $gcColumn, $spectrum, $maxHits) ;
    #print Dumper @$limited_hits ;
    return ($limited_hits);#, $json_res) ;
}


### Test MSP module ###

sub get_mzsTest {
	my ($msp_file, $mzRes, $maxIons) = @_;
	my $omsp = lib::msp->new();
	my $mzs = $omsp->get_mzs ($msp_file, $mzRes, $maxIons) ;
	print Dumper \$mzs ;
    return($mzs) ;
}


sub get_intensitiesTest {
	my ($msp_file) = @_;
	my $omsp = lib::msp->new();
	my $intensities = $omsp->get_intensities($msp_file) ;
	print Dumper \$intensities ;
    return($intensities) ;
}


sub get_intensities_and_mzs_from_stringTest {
	my ($spectrum_string) = @_;
	my $omsp = lib::msp->new();
	my $spectrum_intensities_mzs = $omsp->get_intensities_and_mzs_from_string($spectrum_string) ;
	print Dumper \$spectrum_intensities_mzs ;
    return($spectrum_intensities_mzs) ;
}


sub sorting_descending_intensitiesTest {
	my ($spectrum_string) = @_;
	my $omsp = lib::msp->new();
	my $spectrum_intensities_mzs = $omsp->sorting_descending_intensities($spectrum_string) ;
	print Dumper \$spectrum_intensities_mzs ;
    return($spectrum_intensities_mzs) ;
}


sub encode_spectrum_for_queryTest {
	my ($mzs, $intensities) = @_;
	my $omsp = lib::msp->new();
	my $encoded_spectra = $omsp->encode_spectrum_for_query($mzs, $intensities) ;
	print Dumper $encoded_spectra ;
	return ($encoded_spectra) ;
}

1 ;