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



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ws_url, $ws_proxy
# Structure of res : @ret = [ %val1, %val2, ... %valN ]
print "\n** Test $current_test test_query_golm with default parameters **\n" ; $current_test++;
is_deeply( test_query_golmTest("http://gmd.mpimp-golm.mpg.de", "http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx"),
1,
"Method \'test_query_golm\' Test Golm webservice with default spectrum");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ws_url, $ws_proxy
## 		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print "\n** Test $current_test connectWSlibrarySearchGolm with real uri and proxy **\n" ; $current_test++;
isa_ok( connectWSlibrarySearchGolmTest("http://gmd.mpimp-golm.mpg.de", "http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx"), 'SOAP::Lite' );



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ri, $riWindow, $gcColumn, $spectrum, $maxHits, $JaccardDistanceThreshold,
#		$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,$HammingDistanceThreshold,
#		$EuclideanDistanceThreshold,$ws_url, $ws_proxy,$default_ri, $default_ri_window, $default_gc_column
# Structure of res : @limited_hits = [ %val1, %val2, ... %valN ], @json_res = [ ojson1, ojson2,... ]
print "\n** Test $current_test LibrarySearch with a list of mzs, intensities and real search parameters **\n" ; $current_test++;
is_deeply(LibrarySearchTest(1898, 5, "VAR5", "70 3 71 3 72 16 73 999 74 87 75 78 76 4 77 5 81 1 82 6 83 13 84 4 85 3 86 4 87 5 88 4 89 52 90 4 91 2 97 2 98 1 99 4 100 12 101 16 102 9 103 116 104 11 105 26 106 2 107 1 111 1 112 1 113 4 114 11 115 7 116 5 117 93 118 9 119 8 126 1 127 3 128 3 129 101 130 19 131 25 132 4 133 60 134 8 135 4 140 1 141 1 142 4 143 13 144 2 145 6 146 1 147 276 148 44 149 27 150 3 151 1 156 1 157 70 158 12 159 5 160 148 161 26 162 7 163 8 164 1 168 1 169 2 170 1 172 3 173 4 174 1 175 4 177 4 186 2 187 1 189 28 190 7 191 13 192 2 193 1 201 5 202 1 203 3 204 23 205 162 206 31 207 16 208 2 210 2 214 1 215 2 216 8 217 88 218 18 219 8 220 1 221 6 222 1 229 23 230 6 231 11 232 3 233 4 234 3 235 1 243 1 244 2 245 1 246 2 247 1 256 1 262 3 263 1 269 2 270 1 274 4 275 1 277 4 278 1 291 7 292 2 293 1 300 1 305 4 306 1 307 4 308 1 318 1 319 122 320 37 321 17 322 3 323 1 343 1 364 2 365 1",
							2, 0.9, 0.9, 0.5, 500, 0.5,"http://gmd.mpimp-golm.mpg.de", "http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx",1500, 3000, "VAR5"),
		
        [
          {
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'EuclideanDistance' => '0.00648652157',
            'HammingDistance' => 51,
            'ri' => '1899.05493',
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            's12GowerLegendreDistance' => '0.404159725',
            'riDiscrepancy' => '1.054953',
            'DotproductDistance' => '0.00376573764',
            'JaccardDistance' => '0.2849162'
          },
          {
            'DotproductDistance' => '0.0041610254',
            'JaccardDistance' => '0.238709673',
            'ri' => '1897.25439',
            'spectrumID' => 'd00de57d-6fab-49d0-9aee-25e259da9180',
            's12GowerLegendreDistance' => '0.367506444',
            'riDiscrepancy' => '0.745605469',
            'analyteName' => 'Idose (1MEOX) (5TMS) BP',
            'spectrumName' => 'Idose (1MEOX) (5TMS) BP [A191005-ambient-na-1]',
            'EuclideanDistance' => '0.007327365',
            'HammingDistance' => 37,
            'analyteID' => '6f4e926f-d7ef-47b6-a52c-91ff88ca567a',
            'metaboliteID' => 'ab025068-f464-4bc6-9c92-994c29387db2'
          }
        ]
        ,
    "Method \'LibrarySearch\' returns a list of hits for a spectrum and parameters given in argument");


print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;

##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ri, $riWindow, $gcColumn, $spectrum, $maxHits, $JaccardDistanceThreshold,
#		$s12GowerLegendreDistanceThreshold,$DotproductDistanceThreshold,$HammingDistanceThreshold,
#		$EuclideanDistanceThreshold,$ws_url, $ws_proxy,$default_ri, $default_ri_window, $default_gc_column
# Structure of res : @ret = [ %val1, %val2, ... %valN ]
print "\n** Test $current_test BUG LibrarySearch with a list of mzs, intensities and empty spectrum **\n" ; $current_test++;
is_deeply(LibrarySearchTest(1898, 5, "VAR5", "", 2, 0.9, 0.9, 0.5, 500, 0.5,"http://gmd.mpimp-golm.mpg.de", "http://gmd.mpimp-golm.mpg.de/webservices/wsLibrarySearch.asmx",1500, 3000, "VAR5"),
[],
"Method \'LibrarySearch\' returns a list of hits for a spectrum and parameters given in argument");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
#		$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold
# Structure of res : @ret = [ %val1, %val2, ... %valN ]

my $results = [
          {
            's12GowerLegendreDistance' => '0.404159725',
            'JaccardDistance' => '0.2849162',
            'ri' => '1899.05493',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'EuclideanDistance' => '0.00648652157',
            'HammingDistance' => '51',
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            'DotproductDistance' => '0.00376573671',
            'riDiscrepancy' => '1.054953',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP'
          },
          {
            'analyteName' => 'Idose (1MEOX) (5TMS) BP',
            'spectrumName' => 'Idose (1MEOX) (5TMS) BP [A191005-ambient-na-3]',
            'riDiscrepancy' => '0.745605469',
            'ri' => '1897.25439',
            'metaboliteID' => 'ab025068-f464-4bc6-9c92-994c29387db2',
            'JaccardDistance' => '0.835855663',
            's12GowerLegendreDistance' => '0.771266937',
            'DotproductDistance' => '0.0228821356',
            'HammingDistance' => '718',
            'EuclideanDistance' => '0.007299051',
            'analyteID' => '6f4e926f-d7ef-47b6-a52c-91ff88ca567a',
            'spectrumID' => '274f5578-3087-4c10-8a6c-6ffa6eb4bd6c'
          }
  		] ;
print "\n** Test $current_test filter_scores_golm_results with results and thresholds **\n" ; $current_test++;
is_deeply(filter_scores_golm_resultsTest($results, 0.9, 0.9, 0.5, 500, 0.5),
		[
          {
            's12GowerLegendreDistance' => '0.404159725',
            'DotproductDistance' => '0.00376573671',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'riDiscrepancy' => '1.054953',
            'ri' => '1899.05493',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP',
            'HammingDistance' => 51,
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            'JaccardDistance' => '0.2849162',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'EuclideanDistance' => '0.00648652157'
          }
        ],
"Method \'filter_scores_golm_results\' returns results wich have distance scores under thresholds");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $results,$JaccardDistanceThreshold,$s12GowerLegendreDistanceThreshold,
#		$DotproductDistanceThreshold,$HammingDistanceThreshold,$EuclideanDistanceThreshold
# Structure of res : @ret = [ %val1, %val2, ... %valN ]

$results = [
          {
            's12GowerLegendreDistance' => '0.404159725',
            'JaccardDistance' => '0.9849162',
            'ri' => '1899.05493',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'EuclideanDistance' => '0.00648652157',
            'HammingDistance' => '51',
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            'DotproductDistance' => '0.00376573671',
            'riDiscrepancy' => '1.054953',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP'
          },
          {
            'analyteName' => 'Idose (1MEOX) (5TMS) BP',
            'spectrumName' => 'Idose (1MEOX) (5TMS) BP [A191005-ambient-na-3]',
            'riDiscrepancy' => '0.745605469',
            'ri' => '1897.25439',
            'metaboliteID' => 'ab025068-f464-4bc6-9c92-994c29387db2',
            'JaccardDistance' => '0.835855663',
            's12GowerLegendreDistance' => '0.771266937',
            'DotproductDistance' => '0.0228821356',
            'HammingDistance' => '718',
            'EuclideanDistance' => '0.007299051',
            'analyteID' => '6f4e926f-d7ef-47b6-a52c-91ff88ca567a',
            'spectrumID' => '274f5578-3087-4c10-8a6c-6ffa6eb4bd6c'
          }
  		] ;
  		
print "\n** Test $current_test filter_scores_golm_results with results having too high distance scores **\n" ; $current_test++;
is_deeply(filter_scores_golm_resultsTest($results, 0.9, 0.9, 0.5, 500, 0.5),
		[],
"Method \'filter_scores_golm_results\' returns results wich have distance scores under thresholds");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $results
# Structure of res : @ret = [ %val1, %val2, ... %valN ]

$results = [
          {
            's12GowerLegendreDistance' => '0.404159725',
            'JaccardDistance' => '0.9849162',
            'ri' => '1899.05493',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'EuclideanDistance' => '0.00648652157',
            'HammingDistance' => '51',
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            'DotproductDistance' => '0.00376573671',
            'riDiscrepancy' => '1.054953',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP'
          },
          {
            's12GowerLegendreDistance' => '0.404159725',
            'JaccardDistance' => '0.9849162',
            'ri' => '1899.05493',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'EuclideanDistance' => '0.00648652157',
            'HammingDistance' => '51',
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            'DotproductDistance' => '0.07376573671',
            'riDiscrepancy' => '1.054953',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP'
          }
  		] ;
  		
print "\n** Test $current_test filter_replica_results with real parameters **\n" ; $current_test++;
is_deeply(filter_replica_resultsTest($results),
		[
          {
            's12GowerLegendreDistance' => '0.404159725',
            'JaccardDistance' => '0.9849162',
            'ri' => '1899.05493',
            'metaboliteID' => '68513255-fc44-4041-bc4b-4fd2fae7541d',
            'EuclideanDistance' => '0.00648652157',
            'HammingDistance' => '51',
            'analyteID' => '0a2b3536-2245-4c0e-bdbc-495766eeec67',
            'spectrumID' => 'dd5bb721-ce4f-4cec-99ff-de2cb818304d',
            'DotproductDistance' => '0.00376573671',
            'riDiscrepancy' => '1.054953',
            'spectrumName' => 'Glucose (1MEOX) (5TMS) BP [A191001-ambient-na-23]',
            'analyteName' => 'Glucose (1MEOX) (5TMS) BP'
          }
        ],
"Method \'filter_replica_results\' returns results with unique spectra with lowest dotproduct");

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
# ARGS : $msp_file, $mzRes
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file normal parameters **\n" ; $current_test++;
is_deeply( get_mzsTest('./data/inputSpectra_unit_test.msp',0),
		[
          [
            73,
            74,
            75,
            100,
            103,
            116,
            117,
            118,
            128,
            131,
            133,
            147,
            48,
            149,
            190,
            191,
            192,
            207,
            218
          ]
        ], 
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file");




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file, $mzRes
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file: specific mzRes **\n" ; $current_test++;
is_deeply( get_mzsTest('./data/inputSpectra_unit_test.msp',2),
		[
          [
            '73.05',
            '74.05',
            '75.03',
            '100.06',
            '103.02',
            '116.09',
            '117.09',
            '118.09',
            '128.05',
            '131.04',
            '133.04',
            '147.07',
            '48.07',
            '149.06',
            '190.11',
            '191.11',
            '192.10',
            '207.03',
            '218.10'
          ]
        ], 
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file ");




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file, $mzRes
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file: too big mzRes **\n" ; $current_test++;
is_deeply( get_mzsTest('./data/inputSpectra_unit_test.msp',10),
		[
          [
            '73.0465000000',
            '74.0481000000',
            '75.0319000000',
            '100.0573000000',
            '103.0227000000',
            '116.0884000000',
            '117.0905000000',
            '118.0869000000',
            '128.0526000000',
            '131.0359000000',
            '133.0438000000',
            '147.0666000000',
            '48.0660000000',
            '149.0551000000',
            '190.1069000000',
            '191.1063000000',
            '192.1023000000',
            '207.0333000000',
            '218.1028000000'
          ]
        ],
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file ");





##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_intensities from a .msp file **\n" ; $current_test++;
is_deeply(get_intensitiesTest('./data/inputSpectra_unit_test.msp'),
		[
          [
            '826983.38',
            '70018.08',
            '69475.73',
            '37477.24',
            '43054.28',
            '1433179.62',
            '151975.23',
            '53105.64',
            '26404.77',
            '22647.44',
            '22141.56',
            '255488.28',
            '49965.66',
            '37762.38',
            '72568.23',
            '18017.34',
            '6460.8',
            '35435.81',
            '30528.82'
          ]
        ],
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file");





##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $inputSpectra,$mzRes
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_masses_from_stringTest from string of mzs and intensities **\n" ; $current_test++;
is_deeply(get_masses_from_stringTest('70 3 71 3 72 16 73 999 74 87 75 78 76 4 77 5 81 1 82 6 83 13 84 4 85 3 86 4 87 5 88 4 89 52 90 4 91 2 97 2 98 1 99 4 100
 12 101 16 102 9 103 116 104 11 105 26 106 2 107 1 111 1 112 1 113 4 114 11 115 7 116 5 117 93 118 9 119 8 126 1 127 3 128 3 129 101 130 19 131 25 132 4 133 60 134 8 135 4 140
  1 141 1 142 4 143 13 144 2 145 6 146 1 147 276 148 44 149 27 150 3 151 1 156 1 157 70 158 12 159 5 160 148 161 26 162 7 163 8 164 1 168 1 169 2 170 1 172 3 173 4 174 1 175 4
   177 4 186 2 187 1 189 28 190 7 191 13 192 2 193 1 201 5 202 1 203 3 204 23 205 162 206 31 207 16 208 2 210 2 214 1 215 2 216 8 217 88 218 18 219 8 220 1 221 6 222 1 229 23
    230 6 231 11 232 3 233 4 234 3 235 1 243 1 244 2 245 1 246 2 247 1 256 1 262 3 263 1 269 2 270 1 274 4 275 1 277 4 278 1 291 7 292 2 293 1 300 1 305 4 306 1 307 4 308 1 318
     1 319 122 320 37 321 17 322 3 323 1 343 1 364 2 365 1', 0),
		[
          '70', '71', '72', '73', '74', '75', '76', '77', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '111', '112', '113', '114', '115', '116', '117', '118', '119', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '156', '157', '158', '159', '160', '161', '162', '163', '164', '168', '169', '170', '172', '173', '174', '175', '177', '186', '187', '189', '190', '191', '192', '193', '201', '202', '203', '204', '205', '206', '207', '208', '210', '214', '215', '216', '217', '218', '219', '220', '221', '222', '229', '230', '231', '232', '233', '234', '235', '243', '244', '245', '246', '247', '256', '262', '263', '269', '270', '274', '275', '277', '278', '291', '292', '293', '300', '305', '306', '307', '308', '318', '319', '320', '321', '322', '323', '343', '364', '365'
		],
"Method \'get_masses_from_stringTest\' return an array containing all masses from a string");




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $inputSpectra
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_intensities_from_stringTest from string of mzs and intensities **\n" ; $current_test++;
is_deeply(get_intensities_from_stringTest("70 3 71 3 72 16 73 999 74 87 75 78 76 4 77 5 81 1 82 6 83 13 84 4 85 3 86 4 87 5 88 4 89 52 90 4 91 2 97 2 98 1 99 4 100
 12 101 16 102 9 103 116 104 11 105 26 106 2 107 1 111 1 112 1 113 4 114 11 115 7 116 5 117 93 118 9 119 8 126 1 127 3 128 3 129 101 130 19 131 25 132 4 133 60 134 8 135 4 140
  1 141 1 142 4 143 13 144 2 145 6 146 1 147 276 148 44 149 27 150 3 151 1 156 1 157 70 158 12 159 5 160 148 161 26 162 7 163 8 164 1 168 1 169 2 170 1 172 3 173 4 174 1 175 4
   177 4 186 2 187 1 189 28 190 7 191 13 192 2 193 1 201 5 202 1 203 3 204 23 205 162 206 31 207 16 208 2 210 2 214 1 215 2 216 8 217 88 218 18 219 8 220 1 221 6 222 1 229 23
    230 6 231 11 232 3 233 4 234 3 235 1 243 1 244 2 245 1 246 2 247 1 256 1 262 3 263 1 269 2 270 1 274 4 275 1 277 4 278 1 291 7 292 2 293 1 300 1 305 4 306 1 307 4 308 1 318
     1 319 122 320 37 321 17 322 3 323 1 343 1 364 2 365 1"),
		[
          '3', '3', '16', '999', '87', '78', '4', '5', '1', '6', '13', '4', '3', '4', '5', '4', '52', '4', '2', '2', '1', '4', '12', '16', '9', '116', '11', '26', '2', '1', '1', '1', '4', '11', '7', '5', '93', '9', '8', '1', '3', '3', '101', '19', '25', '4', '60', '8', '4', '1', '1', '4', '13', '2', '6', '1', '276', '44', '27', '3', '1', '1', '70', '12', '5', '148', '26', '7', '8', '1', '1', '2', '1', '3', '4', '1', '4', '4', '2', '1', '28', '7', '13', '2', '1', '5', '1', '3', '23', '162', '31', '16', '2', '2', '1', '2', '8', '88', '18', '8', '1', '6', '1', '23', '6', '11', '3', '4', '3', '1', '1', '2', '1', '2', '1', '1', '3', '1', '2', '1', '4', '1', '4', '1', '7', '2', '1', '1', '4', '1', '4', '1', '1', '122', '37', '17', '3', '1', '1', '2', '1'
        ],
"Method \'get_intensities_from_stringTest\' return an array containing all intensities from a string");





##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $mzs,$intensities
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
	'73 5764652 147 5244020 157 3561241 160 3454586 205 4437872 217 3601276 272 30900.41 319 5352581 320 3587208 ',
	'73 5551756 129 3361335 147 5231997 157 3641748 160 3947240 205 4374348 217 3683153 319 5377373 320 3621938 ',
],
"Method \'encode_spectrum_for_query\' return an array containing WS formatted spectrum strings");




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $mzs,$intensities
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test encode_spectrum_for_query from empty mzs and intensities arrays **\n" ; $current_test++;

$mzs = [] ;

$intensities = [];

is_deeply(encode_spectrum_for_queryTest($mzs,$intensities),
[],
"Method \'encode_spectrum_for_query\' return an array containing WS formatted spectrum strings");



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $mzs,$intensities
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test encode_spectrum_for_query from undef mzs and intensities arrays **\n" ; $current_test++;
is_deeply(encode_spectrum_for_queryTest(undef,undef),
[],
"Method \'encode_spectrum_for_query\' return an array containing WS formatted spectrum strings");




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $mzs_res_sorted, $maxIons
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test keep_only_max_masses from mzs arrays according to a max ions given in argument **\n" ; $current_test++;
is_deeply(keep_only_max_massesTest(
		[
          '73', '147', '205', '160', '319', '103', '129', '117', '217', '74', '75', '157', '133', '89', '148', '320', '206', '189', '149', '105', '161', '131', '204', '229', '130', '218', '321', '72', '101', '207', '83', '143', '191', '100', '158', '104', '114', '231', '102', '118', '119', '134', '163', '216', '219', '115', '162', '190', '291', '82', '145', '221', '230', '77', '87', '116', '159', '201', '76', '84', '86', '88', '90', '99', '113', '132', '135', '142', '173', '175', '177', '233', '274', '277', '305', '307', '70', '71', '85', '127', '128', '150', '172', '203', '232', '234', '262', '322', '91', '97', '106', '144', '169', '186', '192', '208', '210', '215', '244', '246', '269', '292', '364', '81', '98', '107', '111', '112', '126', '140', '141', '146', '151', '156', '164', '168', '170', '174', '187', '193', '202', '214', '220', '222', '235', '243', '245', '247', '256', '263', '270', '275', '278', '293', '300', '306', '308', '318', '323', '343', '365'
        ], 2),
		[
          '73',
          '147'
        ],
"Method \'keep_only_max_masses\' return an array containing the number of masses to send to Golm");



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $mzs_res_sorted, $maxIons
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test keep_only_max_intensities from intensity arrays according to a max ions given in argument **\n" ; $current_test++;
is_deeply(keep_only_max_intensitiesTest(
		[
          999,276,162,148,122,116,101,93,88,87,78,70,60,52,44,37,31,28,27,26,26,25,23,23,19,18,17,16,16,16,13,13,13,12,12,11,11,11,9,9,8,8,8,8,8,7,7,7,7,6,6,6,6,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ], 2),
		[
          999,
          276
        ],
"Method \'keep_only_max_intensities\' return an array containing the number of intensities to send to Golm");



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ref_mzs_res, $ref_ints_res
# Structure of res: [ mz1,mz2,... ] , [ int1,int2,... ]
print "\n** Test $current_test sorting_descending_intensities sort mzs and intensities arrays by descending intensity values **\n" ; $current_test++;
is_deeply(sorting_descending_intensities1Test(
		[
          '70','71','72','73','74','75','76','77','81','82','83','84','85','86','87','88','89','90','91','97','98','99','100','101','102','103','104','105','106','107','111','112','113','114','115','116','117','118','119','126','127','128','129','130','131','132','133','134','135','140','141','142','143','144','145','146','147','148','149','150','151','156','157','158','159','160','161','162','163','164','168','169','170','172','173','174','175','177','186','187','189','190','191','192','193','201','202','203','204','205','206','207','208','210','214','215','216','217','218','219','220','221','222','229','230','231','232','233','234','235','243','244','245','246','247','256','262','263','269','270','274','275','277','278','291','292','293','300','305','306','307','308','318','319','320','321','322','323','343','364','365'
        ], 
        [
          '3','3','16','999','87','78','4','5','1','6','13','4','3','4','5','4','52','4','2','2','1','4','12','16','9','116','11','26','2','1','1','1','4','11','7','5','93','9','8','1','3','3','101','19','25','4','60','8','4','1','1','4','13','2','6','1','276','44','27','3','1','1','70','12','5','148','26','7','8','1','1','2','1','3','4','1','4','4','2','1','28','7','13','2','1','5','1','3','23','162','31','16','2','2','1','2','8','88','18','8','1','6','1','23','6','11','3','4','3','1','1','2','1','2','1','1','3','1','2','1','4','1','4','1','7','2','1','1','4','1','4','1','1','122','37','17','3','1','1','2','1'
        ]),
		[
          '73','147','205','160','319','103','129','117','217','74','75','157','133','89','148','320','206','189','149','105','161','131','204','229','130','218','321','72','101','207','83','143','191','100','158','104','114','231','102','118','119','134','163','216','219','115','162','190','291','82','145','221','230','77','87','116','159','201','76','84','86','88','90','99','113','132','135','142','173','175','177','233','274','277','305','307','70','71','85','127','128','150','172','203','232','234','262','322','91','97','106','144','169','186','192','208','210','215','244','246','269','292','364','81','98','107','111','112','126','140','141','146','151','156','164','168','170','174','187','193','202','214','220','222','235','243','245','247','256','263','270','275','278','293','300','306','308','318','323','343','365'
        ],
"Method \'sorting_descending_intensities\' return the arrays of mz sorted accordingly to the rearrangment of the ints array");




##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ref_mzs_res, $ref_ints_res
# Structure of res: [ mz1,mz2,... ] , [ int1,int2,... ]
print "\n** Test $current_test sorting_descending_intensities sort mzs and intensities arrays by descending intensity values **\n" ; $current_test++;
is_deeply(sorting_descending_intensities2Test(
		[
          '70','71','72','73','74','75','76','77','81','82','83','84','85','86','87','88','89','90','91','97','98','99','100','101','102','103','104','105','106','107','111','112','113','114','115','116','117','118','119','126','127','128','129','130','131','132','133','134','135','140','141','142','143','144','145','146','147','148','149','150','151','156','157','158','159','160','161','162','163','164','168','169','170','172','173','174','175','177','186','187','189','190','191','192','193','201','202','203','204','205','206','207','208','210','214','215','216','217','218','219','220','221','222','229','230','231','232','233','234','235','243','244','245','246','247','256','262','263','269','270','274','275','277','278','291','292','293','300','305','306','307','308','318','319','320','321','322','323','343','364','365'
        ], 
        [
          '3','3','16','999','87','78','4','5','1','6','13','4','3','4','5','4','52','4','2','2','1','4','12','16','9','116','11','26','2','1','1','1','4','11','7','5','93','9','8','1','3','3','101','19','25','4','60','8','4','1','1','4','13','2','6','1','276','44','27','3','1','1','70','12','5','148','26','7','8','1','1','2','1','3','4','1','4','4','2','1','28','7','13','2','1','5','1','3','23','162','31','16','2','2','1','2','8','88','18','8','1','6','1','23','6','11','3','4','3','1','1','2','1','2','1','1','3','1','2','1','4','1','4','1','7','2','1','1','4','1','4','1','1','122','37','17','3','1','1','2','1'
        ]),
		[
          999,276,162,148,122,116,101,93,88,87,78,70,60,52,44,37,31,28,27,26,26,25,23,23,19,18,17,16,16,16,13,13,13,12,12,11,11,11,9,9,8,8,8,8,8,7,7,7,7,6,6,6,6,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ],
"Method \'sorting_descending_intensities\' return the arrays of ints sorted by descending intensity values");



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ref_mzs_res, $ref_ints_res
# Structure of res: [ mz1,mz2,... ] , [ int1,int2,... ]
print "\n** Test $current_test sorting_descending_intensities remove redundant masses **\n" ; $current_test++;
is_deeply(remove_redundants1Test(
		[
          '70','71','71','73'
		], 
        [
          '147','259','276','45'
        ]),
		[
          '70','71','73'
        ],
"Method \'sorting_descending_intensities\' return the arrays of masses of non redundant ions");



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ref_mzs_res, $ref_ints_res
# Structure of res: [ mz1,mz2,... ] , [ int1,int2,... ]
print "\n** Test $current_test sorting_descending_intensities remove redundant masses **\n" ; $current_test++;
is_deeply(remove_redundants2Test(
		[
          '70','71','71','73'
		], 
        [
          '147','259','276','45'
        ]),
		[
          '147','276','45'
        ],
"Method \'sorting_descending_intensities\' return the arrays of ints of non redundant ions");



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $uniq_total_intensities
# Structure of res: [ [int1,int2,...] , ... ]
print "\n** Test $current_test apply_relative_intensity make intensities to relative **\n" ; $current_test++;
is_deeply(apply_relative_intensityTest(
		[
          [
            '1433179.62','826983.38','255488.28','151975.23','72568.23','70018.08','69475.73','53105.64','49965.66','43054.28','37762.38','37477.24','35435.81','30528.82','26404.77','22647.44','22141.56','18017.34','6460.8'
          ]
        ], 
        ),
		[
          [
            '100','57.7027030289476','17.8266754867753','10.6040602224025','5.063442780466','4.88550625636164','4.84766382597598','3.7054420296599','3.48635016174735','3.00410914299772','2.63486721922546','2.61497159720985','2.47253097277507','2.13014611525107','1.84239083723504','1.58022341958784','1.54492568070428','1.25715854095106','0.450801833199386'
          ]
        ],
"Method \'apply_relative_intensity\' return the arrays of relativ intensities");



}
else {
	croak "Can\'t launch any test : no sequence clearly defined !!!!\n" ;
}

