#! perl
use diagnostics;
use warnings;
no warnings qw/void/;
use strict;
no strict "refs" ;
use Test::More qw( no_plan );
use FindBin ;
use Carp ;

## Specific Modules
use lib $FindBin::Bin ;
my $binPath = $FindBin::Bin ;


use lib::golm_ws_api_test qw( :ALL ) ;

## To launch the right sequence : API, MSP...
my $sequence = 'API' ; 
my $current_test = 1 ;


#### #### ##### ###### ################################################ ###### ##### ##### ###### ######

								## START of API SEQUENCE ## 
							
#### #### ##### ###### ################################################ ###### ##### ##### ###### ######


if ($sequence eq "API") {
	
	## testing api module of golm wrapper.
	## 		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	print "\n\t\t\t  * * * * * * \n" ;
	print "\t  * * * - - - Test Golm API module - - - * * * \n\n" ;

	##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


## 		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print "\n** Test $current_test connectWSlibrarySearchGolm with real uri and proxy **\n" ; $current_test++;
isa_ok( connectWSlibrarySearchGolmTest(), 'SOAP::Lite' );



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ri, $riWindow, $gcColumn, $spectrum, $maxHits
# Structure of res : @limited_hits = [ %val1, %val2, ... %valN ], @json_res = [ ojson1, ojson2,... ]
print "\n** Test $current_test LibrarySearch with a list of mzs, intensities and real search parameters **\n" ; $current_test++;
is_deeply(LibrarySearchTest(1500,3000,'VAR5','73%205551756%20129%203361335%20147%205231997%20157%203641748%20160%203947240',2),
		
          [
          {
            'riDiscrepancy' => '1367.10339',
            'EuclideanDistance' => '0.04856206',
            'analyteID' => '1eef4f2a-6c16-4509-87ba-d4a7edd52804',
            'JaccardDistance' => '0.997881353',
            'spectrumName' => 'Piceatannol (4TMS) MP [A286012-ambient-na-1]',
            'ri' => '2867.10327',
            's12GowerLegendreDistance' => '0.9896098',
            'spectrumID' => 'd5533e09-5538-4943-9137-48cb807de2bb',
            'HammingDistance' => '471',
            'metaboliteID' => 'f13be9bb-b7d7-4d40-b31a-c15b953e033d',
            'analyteName' => 'Piceatannol (4TMS) MP',
            'DotproductDistance' => '0.556552649'
          },
          {
            'metaboliteID' => 'f13be9bb-b7d7-4d40-b31a-c15b953e033d',
            'HammingDistance' => '498',
            'analyteName' => 'Piceatannol (4TMS) BP',
            'DotproductDistance' => '0.5581766',
            'spectrumName' => 'Piceatannol (4TMS) BP [A253010-ambient-na-2]',
            'ri' => '2532.646',
            's12GowerLegendreDistance' => '0.9898986',
            'spectrumID' => 'cc8df104-db77-4b38-83fb-5dbdc2e70ddf',
            'JaccardDistance' => '0.997996',
            'EuclideanDistance' => '0.0472988449',
            'riDiscrepancy' => '1032.646',
            'analyteID' => '162d9496-96eb-4e16-a51a-cf847d93bf87'
          }
        ]
        ,
    "Method \'LibrarySearch\' returns a list of hits for a spectrum and parameters given in argument");


print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;

##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ri, $riWindow, $gcColumn, $spectrum, $maxHits
# Structure of res : @ret = [ %val1, %val2, ... %valN ]
print "\n** Test $current_test BUG LibrarySearch with a list of mzs, intensities and empty spectrum **\n" ; $current_test++;
is_deeply( LibrarySearchTest(1500,3000,'VAR5','',2),
[],
"Method \'LibrarySearch\' returns a list of hits for a spectrum and parameters given in argument");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;




}


#### #### ##### ###### ################################################ ###### ##### ##### ###### ######

								## START of MSP SEQUENCE ## 
							
#### #### ##### ###### ################################################ ###### ##### ##### ###### ######


elsif ($sequence eq "MSP") {
	
	## testing msp module of golm wrapper.
	## 		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	print "\n\t\t\t  * * * * * * \n" ;
	print "\t  * * * - - - Test MSP parsing module - - - * * * \n\n" ;

	##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file, $mzRes, $maxIons
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file normal parameters **\n" ; $current_test++;
is_deeply( get_mzsTest('./data/peakspectra_test.msp',0,5),
	[
		[73,147,157,160,205],
		[73,129,147,157,160]
	], 
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file, $mzRes, $maxIons
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file: specific mzRes **\n" ; $current_test++;
is_deeply( get_mzsTest('./data/peakspectra_test.msp',2,5),
	[
		[73.65,147.65,157.65,160.65,205.65],
		[73.65,129.65,147.65,157.65,160.65]
	], 
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file ");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file, $mzRes, $maxIons
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file: too big mzRes **\n" ; $current_test++;
is_deeply( get_mzsTest('./data/peakspectra_test.msp',10,5),
	[
		[73.65435,147.65435,157.65435,160.65435,205.65435],
		[73.65435,129.65435,147.65435,157.65435,160.65435]
	], 
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file ");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;


###		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## ARGS : $msp_file, $mzRes, $maxIons
## Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
#print "\n** Test $current_test get_mzs from a .msp file: negative mzRes **\n" ; $current_test++;
#is_deeply( get_mzsTest('./data/peakspectra_test.msp',-1,5),
#	, 
#"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file ");
#
#print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



###		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## ARGS : $msp_file, $mzRes, $maxIons
## Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
#print "\n** Test $current_test get_mzs from a .msp file: negative maxIons **\n" ; $current_test++;
#is_deeply( get_mzsTest('./data/peakspectra_test.msp',0,-1),
#	, 
#"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file ");
#
#print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;






##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_intensities from a .msp file **\n" ; $current_test++;
is_deeply(get_intensitiesTest('./data/peakspectra_test.msp'),
	[
			[
              '5764652.563',
              '5244020.563',
              '3561241.563',
              '3454586.563',
              '4437872.563',
              '3601276.563',
              '30900.41',
              '5352581.563',
              '3587208.563'
            ],
            [
              '5551756.563',
              '3361335.563',
              '5231997.563',
              '3641748.563',
              '3947240.563',
              '4374348.563',
              '3683153.563',
              '5377373.563',
              '3621938.563'
            ]
	],
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file");







##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test encode_spectrum_for_query from mzs and intensities arrays **\n" ; $current_test++;

my $mzs = [
		[73,147,157,160,205,217,272,319,320],
		[73,129,147,157,160,205,217,319,320]
		] ;

my $intensities = [
				[5764652,5244020,3561241,3454586,4437872,3601276,30900.41,5352581,3587208],
	            [5551756,3361335,5231997,3641748,3947240,4374348,3683153,5377373,3621938]
				];

is_deeply(encode_spectrum_for_queryTest($mzs,$intensities),
[
	'73%205764652%20147%205244020%20157%203561241%20160%203454586%20205%204437872%20217%203601276%20272%2030900.41%20319%205352581%20320%203587208',
	'73%205551756%20129%203361335%20147%205231997%20157%203641748%20160%203947240%20205%204374348%20217%203683153%20319%205377373%20320%203621938',
],
"Method \'encode_spectrum_for_query\' return an array containing WS formatted spectrum strings");



}
else {
	croak "Can\'t launch any test : no sequence clearly defined !!!!\n" ;
}














