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

#use lib '/media/gcretin/donnees1/lab_local/tool-bank-golm-lib_search/t' ;
use golm_ws_api_test qw( :ALL ) ;

## To launch the right sequence : API, MSP...
my $sequence = 'MSP' ; 
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
# ARGS : $ri, $riWindow, $gcColumn, $spectrum
# Structure of res : @ret = [ %val1, %val2, ... %valN ]
print "\n** Test $current_test LibrarySearch with a list of mzs, intensities and real search parameters **\n" ; $current_test++;
is_deeply( LibrarySearchTest(
		1500,
		3000,
		'VAR5',
		'73%2082.6%20147%2084.6%20273%20100%20274%2063.1%20347%2064.7%20375%2061.5'
	),
	[
		{
			'analyteName' => 'Citric acid (4TMS)',
			'ri', '1803.92065', 
			'spectrumID', '721a7c7a-16df-45c9-b004-bed31f078a4f', 
			'analyteID', '5cb91881-3359-4fbb-a8e4-dd2f007f01ba', 
			'riDiscrepancy', '303.92',
			'DotproductDistance', '0.1', 
			'EuclideanDistance', '0.03', 
			'HammingDistance', '44',
			'JaccardDistance', '0.88', 
			's12GowerLegendreDistance', '0.81', 
			'spectrumName', 'Citric acid (4TMS) [A182004-ambient-na-21]',
			'metaboliteID', '8f5d336a-442d-434a-9fb0-e400ff74e343'
		}
	], 
"Method \'LibrarySearch\' return a list of entries from given mzs list with relative intensities");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;

}


#### #### ##### ###### ################################################ ###### ##### ##### ###### ######

								## START of MSP SEQUENCE ## 
							
#### #### ##### ###### ################################################ ###### ##### ##### ###### ######


if ($sequence eq "MSP") {
	
	## testing msp module of golm wrapper.
	## 		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	print "\n\t\t\t  * * * * * * \n" ;
	print "\t  * * * - - - Test MSP parsing module - - - * * * \n\n" ;

	##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file
# Structure of res : [ $spectrum1 , $spectrum2 ... $spectrumN ]
print "\n** Test $current_test get_spectra from a .msp file **\n" ; $current_test++;
is_deeply( get_spectraTest(
		'/home/gcretin/Téléchargements/tool-ext-dbsearch_golm/peakspectra.msp'
	),
	[
		"73%204908673%20147%205025522%20273%205942964%20274%203752779%20347%203843372%20375%203656316",
		"73%205764652%20147%205244020%20157%203561241%20160%203454586%20205%204437872%20217%203601276%20272%2030900.41%20319%205352581%20320%203587208",
		"73%205551756%20129%203361335%20147%205231997%20157%203641748%20160%203947240%20205%204374348%20217%203683153%20319%205377373%20320%203621938"
	], 
"Method \'get_spectra\' return a list of query formatted spectra from a msp file");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;




}
else {
	croak "Can\'t launch any test : no sequence clearly defined !!!!\n" ;
}
















