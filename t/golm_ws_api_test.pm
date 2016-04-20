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

#use lib '/media/gcretin/donnees1/lab_local/tool-bank-golm-lib_search/lib/golm_ws_api' ;
use lib::golm_ws_api qw( :ALL ) ;

sub connectWSlibrarySearchGolmTest {
    my $oBih = lib::golm_ws_api->new() ;
    my ($soap) = $oBih->connectWSlibrarySearchGolm() ;
    return ($soap) ;
}


sub LibrarySearchTest {
	my ($ri, $riWindow, $gcColumn, $spectrum) = @_ ;
	my $oBih = lib::golm_ws_api->new() ;
    my ($osoap) = $oBih->connectWSlibrarySearchGolm() ;
    my ($res) = $oBih->LibrarySearch($osoap, $ri, $riWindow, $gcColumn, $spectrum) ;
    print Dumper $res ;
    return($res) ;
}


1 ;