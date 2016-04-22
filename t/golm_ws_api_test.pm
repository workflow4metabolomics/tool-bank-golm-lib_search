package golm_ws_api_test ;

use diagnostics; # this gives you more debugging information
use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Exporter ;
use Carp ;

use Data::Dumper ;

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( connectWSlibrarySearchGolmTest LibrarySearchTest get_spectraTest get_mzsTest);
our %EXPORT_TAGS = ( ALL => [qw( connectWSlibrarySearchGolmTest LibrarySearchTest get_spectraTest get_mzsTest)] );

use lib '/media/gcretin/donnees1/lab_local/tool-bank-golm-lib_search/lib' ;
use golm_ws_api qw( :ALL ) ;
use msp qw( :ALL ) ;


sub connectWSlibrarySearchGolmTest {
    my $oBih = golm_ws_api->new() ;
    my ($soap) = $oBih->connectWSlibrarySearchGolm() ;
    return ($soap) ;
}


sub get_mzsTest {
	my ($msp_file) = @_;
	my $omsp = msp->new();
	my $mzs = $omsp->get_mzs ($msp_file) ;
	print Dumper \$mzs ;
    return($mzs) ;
}


sub get_spectraTest {
	my ($msp_file) = @_;
	my $omsp = msp->new();
	my $spectra = $omsp->get_spectra ($msp_file) ;
	print Dumper \$spectra ;
    return($spectra) ;
}





sub LibrarySearchTest {
	my ($ri, $riWindow, $gcColumn, $spectrum) = @_ ;
	my $oBih = golm_ws_api->new() ;
    my ($osoap) = $oBih->connectWSlibrarySearchGolm() ;
    my ($res) = $oBih->LibrarySearch($osoap, $ri, $riWindow, $gcColumn, $spectrum) ;
    print Dumper $res ;
    return($res) ;
}


1 ;