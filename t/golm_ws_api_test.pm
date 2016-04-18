package lib::golm_ws_api_test ;

use diagnostics; # this gives you more debugging information
use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Exporter ;
use Carp ;

use Data::Dumper ;

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( connectWSlibrarySearchGolmTest LibrarySearchTest );
our %EXPORT_TAGS = ( ALL => [qw( connectWSlibrarySearchGolmTest LibrarySearchTest )] );

use lib::golm_ws_api qw( :ALL ) ;


sub connectWSlibrarySearchGolmTest {
    my $oBih = lib::golm_ws_api->new() ;
    my ($osoap) = $oBih->connectWSlibrarySearchGolm() ;
    return ($osoap) ;
}


sub LibrarySearchTest {
	my ($osoap, $ri, $riWindow, $gcColumn, $mzs, $intensities) = @_ ;
	my $oBih = lib::golm_ws_api->new() ;
    my ($osoap) = $oBih->connectWSlibrarySearchGolm() ;
    my ($res) = $oBih->LibrarySearch($osoap, $ri, $riWindow, $gcColumn, $mzs, $intensities) ;
    print Dumper $res ;
    return($res) ;
}


1 ;