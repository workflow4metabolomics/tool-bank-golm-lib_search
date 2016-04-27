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


use golm_ws_api_test qw( :ALL ) ;

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
# ARGS : $ri, $riWindow, $gcColumn, $spectrum
# Structure of res : @ret = [ %val1, %val2, ... %valN ]
print "\n** Test $current_test LibrarySearch with a list of mzs, intensities and real search parameters **\n" ; $current_test++;
is_deeply(LibrarySearchTest(1500,3000,'VAR5','73%2082.6%20147%2084.6%20273%20100%20274%2063.1%20347%2064.7%20375%2061.5'),

			[
                       {
                         'HammingDistance' => '472',
                         'analyteID' => '1eef4f2a-6c16-4509-87ba-d4a7edd52804',
                         'ri' => '2867.10327',
                         'DotproductDistance' => '0.9005022',
                         'spectrumID' => 'd5533e09-5538-4943-9137-48cb807de2bb',
                         'EuclideanDistance' => '0.0617059171',
                         'spectrumName' => 'Piceatannol (4TMS) MP [A286012-ambient-na-1]',
                         'riDiscrepancy' => '1367.10339',
                         'JaccardDistance' => '0.9978858',
                         'metaboliteID' => 'f13be9bb-b7d7-4d40-b31a-c15b953e033d',
                         's12GowerLegendreDistance' => '0.9905194',
                         'analyteName' => 'Piceatannol (4TMS) MP'
                       },
                       {
                         'analyteName' => 'Piceatannol (4TMS) BP',
                         's12GowerLegendreDistance' => '0.9907828',
                         'metaboliteID' => 'f13be9bb-b7d7-4d40-b31a-c15b953e033d',
                         'riDiscrepancy' => '1032.646',
                         'JaccardDistance' => '0.998',
                         'spectrumName' => 'Piceatannol (4TMS) BP [A253010-ambient-na-2]',
                         'EuclideanDistance' => '0.0600288771',
                         'spectrumID' => 'cc8df104-db77-4b38-83fb-5dbdc2e70ddf',
                         'ri' => '2532.646',
                         'DotproductDistance' => '0.900866568',
                         'analyteID' => '162d9496-96eb-4e16-a51a-cf847d93bf87',
                         'HammingDistance' => '499'
                       },
                       {
                         'analyteName' => 'Uric acid (4TMS)',
                         'metaboliteID' => '565ff3af-8afa-4ee9-9fc4-6b119784a5bb',
                         's12GowerLegendreDistance' => '0.969768465',
                         'JaccardDistance' => '0.9807692',
                         'riDiscrepancy' => '594.620239',
                         'spectrumName' => 'Uric acid (4TMS) [A211006-ambient-na-2]',
                         'spectrumID' => '1193c784-8be9-48b2-9005-3e64b0d95ba3',
                         'EuclideanDistance' => '0.186151221',
                         'ri' => '2094.62036',
                         'DotproductDistance' => '0.9009593',
                         'HammingDistance' => '51',
                         'analyteID' => '18c9bf1b-a685-4b88-bab4-8661b23bf501'
                       },
                       {
                         'analyteName' => 'Decylplastoquinone (2TMS)',
                         's12GowerLegendreDistance' => '0.974932134',
                         'metaboliteID' => '00324682-b841-44ff-ad40-8b4b3aaa0b96',
                         'riDiscrepancy' => '863.2302',
                         'JaccardDistance' => '0.986301363',
                         'spectrumName' => 'Decylplastoquinone (2TMS) [A236008-ambient-na-1]',
                         'EuclideanDistance' => '0.157113135',
                         'spectrumID' => '8fc5b695-d879-4161-b156-6c834e137fda',
                         'ri' => '2363.23022',
                         'DotproductDistance' => '0.900985658',
                         'analyteID' => '959ed72d-8ab8-41ad-8dd4-70e52aac8eab',
                         'HammingDistance' => '72'
                       },
                       {
                         'spectrumName' => 'Taxifolin (5TMS) [A296005-ambient-(2R-trans)--3]',
                         'JaccardDistance' => '0.9921875',
                         'riDiscrepancy' => '1453.53076',
                         's12GowerLegendreDistance' => '0.9814222',
                         'metaboliteID' => 'eac9738a-244f-48d9-a49e-53b9ff37ee19',
                         'analyteName' => 'Taxifolin (5TMS)',
                         'HammingDistance' => '127',
                         'analyteID' => 'a80f7441-314e-4832-b45c-b1163a989b8b',
                         'DotproductDistance' => '0.901014268',
                         'ri' => '2953.53076',
                         'EuclideanDistance' => '0.11865221',
                         'spectrumID' => 'ef4b37c2-251b-46d4-b2da-9ec92686044f'
                       },
                       {
                         'spectrumName' => 'Glucose-6-phosphate (1MEOX) (6TMS) MP [A233002-ambient-na-8]',
                         'riDiscrepancy' => '807.337158',
                         'JaccardDistance' => '0.994709',
                         's12GowerLegendreDistance' => '0.9848368',
                         'metaboliteID' => '962672d2-8750-46fd-9a76-e598aa2319da',
                         'analyteName' => 'Glucose-6-phosphate (1MEOX) (6TMS) MP',
                         'analyteID' => '249ea5fd-66e6-4293-838b-586365a336f4',
                         'HammingDistance' => '188',
                         'DotproductDistance' => '0.9010376',
                         'ri' => '2307.33716',
                         'EuclideanDistance' => '0.0976462439',
                         'spectrumID' => '24d8e102-5177-495b-aebb-4c801776cc13'
                       },
                       {
                         'analyteName' => 'Aspartic acid, N-(3-indolylacetyl)- (4TMS)',
                         's12GowerLegendreDistance' => '0.983077943',
                         'metaboliteID' => 'da0b15b0-caf0-499a-a99b-35f39f500f52',
                         'JaccardDistance' => '0.993464053',
                         'riDiscrepancy' => '1191.4812',
                         'spectrumName' => 'Aspartic acid, N-(3-indolylacetyl)- (4TMS) [A270006-ambient-na-1]',
                         'EuclideanDistance' => '0.108529769',
                         'spectrumID' => '7a59af44-f760-4138-b4ae-008e4ca0af88',
                         'DotproductDistance' => '0.90107137',
                         'ri' => '2691.4812',
                         'analyteID' => '0b9243a6-ea69-4ddb-bb45-0d7a8cb5a690',
                         'HammingDistance' => '152'
                       },
                       {
                         'DotproductDistance' => '0.901119232',
                         'ri' => '2034.63708',
                         'HammingDistance' => '69',
                         'analyteID' => '4e1e692f-be7f-4eb6-be43-77041dfe8435',
                         'EuclideanDistance' => '0.160456419',
                         'spectrumID' => '163b5a0f-ecf4-4ae4-9fa2-b7397d2d0e78',
                         'riDiscrepancy' => '534.6371',
                         'JaccardDistance' => '0.985714257',
                         'spectrumName' => 'NA [A204004-ambient-na-2]',
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.9743526',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000'
                       },
                       {
                         'spectrumID' => '9f774a04-4f31-4eb9-a616-1580338e1ffd',
                         'EuclideanDistance' => '0.0741289',
                         'ri' => '2569.67773',
                         'DotproductDistance' => '0.901195467',
                         'HammingDistance' => '327',
                         'analyteID' => '390c944d-aa0b-4688-a390-7c82ba072fb9',
                         'analyteName' => 'Neopterin, 7,8-dihydro- (6TMS)',
                         'metaboliteID' => '69e16c56-6129-445c-b652-c8ac2695c2c7',
                         's12GowerLegendreDistance' => '0.988577',
                         'JaccardDistance' => '0.9969512',
                         'riDiscrepancy' => '1069.67773',
                         'spectrumName' => 'Neopterin, 7,8-dihydro- (6TMS) [A256007-ambient-na-1]'
                       },
                       {
                         'HammingDistance' => '268',
                         'analyteID' => '65bff36a-79ba-43fc-bf2d-8c3331d09301',
                         'DotproductDistance' => '0.9012106',
                         'ri' => '1308.97351',
                         'spectrumID' => '82f66d39-0b56-4760-979a-de7e5364f1d7',
                         'EuclideanDistance' => '0.08185628',
                         'spectrumName' => 'Catechol_2TMS [A131018-ambient-na-4]',
                         'riDiscrepancy' => '191.026428',
                         'JaccardDistance' => '0.9962825',
                         'metaboliteID' => '5cc5f251-7344-445c-a519-06efb3063f2a',
                         's12GowerLegendreDistance' => '0.9873571',
                         'analyteName' => 'Catechol_2TMS'
                       },
                       {
                         'spectrumName' => 'Allantoin (5TMS) [A188009-ambient-na-6]',
                         'JaccardDistance' => '0.9929078',
                         'riDiscrepancy' => '396.9983',
                         'metaboliteID' => 'a999f0d6-0285-41d9-a6ba-b705987b663c',
                         's12GowerLegendreDistance' => '0.9823406',
                         'analyteName' => 'Allantoin (5TMS)',
                         'analyteID' => '65bb54d2-6bf7-4a53-aa22-8abf71240005',
                         'HammingDistance' => '140',
                         'DotproductDistance' => '0.901243865',
                         'ri' => '1896.99829',
                         'spectrumID' => '063fa226-ed62-4d9f-9d5c-ee52c0974e55',
                         'EuclideanDistance' => '0.113064587'
                       },
                       {
                         'EuclideanDistance' => '0.0446536355',
                         'spectrumID' => 'd40c1b84-6a2b-4a12-a5ca-4fca1ae68c07',
                         'ri' => '2814.1228',
                         'DotproductDistance' => '0.9012642',
                         'analyteID' => '586bf3e7-bad0-4d9d-88d1-26277da7b3e0',
                         'HammingDistance' => '903',
                         'analyteName' => 'Taxifolin (1MEOX) (5TMS) MP',
                         's12GowerLegendreDistance' => '0.9931688',
                         'metaboliteID' => 'eac9738a-244f-48d9-a49e-53b9ff37ee19',
                         'riDiscrepancy' => '1314.1228',
                         'JaccardDistance' => '0.9988938',
                         'spectrumName' => 'Taxifolin (1MEOX) (5TMS) MP [A279012-ambient-(2R-trans)--1]'
                       },
                       {
                         'EuclideanDistance' => '0.1168576',
                         'spectrumID' => '3c6d7a7b-3a77-4297-b715-2a76bb1801ff',
                         'DotproductDistance' => '0.9012762',
                         'ri' => '1164.86169',
                         'HammingDistance' => '131',
                         'analyteID' => '5edc1cff-df4b-47bd-b6cf-63c25c7d4562',
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.981719851',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'riDiscrepancy' => '335.1383',
                         'JaccardDistance' => '0.99242425',
                         'spectrumName' => 'NA [A116011-ambient--1]'
                       },
                       {
                         's12GowerLegendreDistance' => '0.986872852',
                         'metaboliteID' => 'ac17fd8d-94bc-4c87-b5e6-d2b60f03b45d',
                         'analyteName' => 'Indole-3-pyruvic acid (1MEOX) (2TMS) MP',
                         'spectrumName' => 'Indole-3-pyruvic acid (1MEOX) (2TMS) MP [A219009-ambient-na-1]',
                         'JaccardDistance' => '0.996',
                         'riDiscrepancy' => '697.0774',
                         'EuclideanDistance' => '0.08491389',
                         'spectrumID' => '18d869ee-d9af-413c-b129-50af0a5deede',
                         'analyteID' => 'ff5019ea-3794-49fc-a42f-e9e45576fc03',
                         'HammingDistance' => '249',
                         'DotproductDistance' => '0.9012961',
                         'ri' => '2197.07739'
                       },
                       {
                         'spectrumName' => 'NA [A180002-13C-na-4]',
                         'JaccardDistance' => '0.98888886',
                         'riDiscrepancy' => '290.237671',
                         's12GowerLegendreDistance' => '0.9776089',
                         'metaboliteID' => '8ef9b098-51c3-4f17-9bfc-904b401aeff7',
                         'analyteName' => 'NA',
                         'analyteID' => '4945549f-e9c0-4902-8975-5f26f1106c6a',
                         'HammingDistance' => '89',
                         'DotproductDistance' => '0.901334941',
                         'ri' => '1790.23767',
                         'EuclideanDistance' => '0.141526192',
                         'spectrumID' => '9c84508c-5623-42c1-abc5-70a544c9c11e'
                       },
                       {
                         'spectrumName' => 'Ampelopsin (6TMS) [A298004-ambient-na-2]',
                         'JaccardDistance' => '0.9971831',
                         'riDiscrepancy' => '1485.07971',
                         's12GowerLegendreDistance' => '0.989028931',
                         'metaboliteID' => '2b89fbac-4dd1-44c9-be2a-9d0c173bdfd8',
                         'analyteName' => 'Ampelopsin (6TMS)',
                         'HammingDistance' => '354',
                         'analyteID' => '94f3b660-9d50-4577-afcf-bd3a29e60760',
                         'ri' => '2985.07983',
                         'DotproductDistance' => '0.9014147',
                         'EuclideanDistance' => '0.0712628439',
                         'spectrumID' => 'aa464780-f734-45bf-82b2-d6be8eeb93ef'
                       },
                       {
                         'riDiscrepancy' => '1424.095',
                         'JaccardDistance' => '0.9885057',
                         'spectrumName' => 'NA294001 (classified unknown) [A294001-ambient-na-1]',
                         'analyteName' => 'NA294001 (classified unknown)',
                         's12GowerLegendreDistance' => '0.9771983',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'ri' => '2924.095',
                         'DotproductDistance' => '0.901455641',
                         'HammingDistance' => '86',
                         'analyteID' => 'a25781e9-1fe9-499f-b2ca-fb56d423e94f',
                         'EuclideanDistance' => '0.143955261',
                         'spectrumID' => '7b035651-daef-4677-a494-48370d68ff69'
                       },
                       {
                         'DotproductDistance' => '0.901482463',
                         'ri' => '2814.1228',
                         'analyteID' => '586bf3e7-bad0-4d9d-88d1-26277da7b3e0',
                         'HammingDistance' => '594',
                         'EuclideanDistance' => '0.055047188',
                         'spectrumID' => 'f06f1881-47ae-42d7-a57b-5c642090cfc7',
                         'JaccardDistance' => '0.9983193',
                         'riDiscrepancy' => '1314.1228',
                         'spectrumName' => 'Taxifolin (1MEOX) (5TMS) MP [A279012-ambient-(2R-trans)--2]',
                         'analyteName' => 'Taxifolin (1MEOX) (5TMS) MP',
                         's12GowerLegendreDistance' => '0.991560757',
                         'metaboliteID' => 'eac9738a-244f-48d9-a49e-53b9ff37ee19'
                       },
                       {
                         'analyteName' => 'Siloxane',
                         'metaboliteID' => 'f4443374-bfd1-4fe5-9b7e-27b5ed4e590d',
                         's12GowerLegendreDistance' => '0.9806096',
                         'riDiscrepancy' => '271.636719',
                         'JaccardDistance' => '0.9915254',
                         'spectrumName' => 'Siloxane [A177007-ambient-na-1]',
                         'spectrumID' => '0d499823-3a91-45dd-9dc0-7b15263d4c78',
                         'EuclideanDistance' => '0.123611294',
                         'ri' => '1771.63672',
                         'DotproductDistance' => '0.9015054',
                         'HammingDistance' => '117',
                         'analyteID' => 'a8c21c48-8a1a-4eb6-9b31-18bc0f8966d2'
                       },
                       {
                         'HammingDistance' => '159',
                         'analyteID' => '5bb480fd-2d3a-4b4b-ad0f-7f689f761079',
                         'DotproductDistance' => '0.901522',
                         'ri' => '2981.68042',
                         'EuclideanDistance' => '0.106155664',
                         'spectrumID' => '7a168431-15b9-44d2-bddc-3b82fa091e63',
                         'spectrumName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS) [A299001-ambient-Z--4]',
                         'JaccardDistance' => '0.99375',
                         'riDiscrepancy' => '1481.68042',
                         's12GowerLegendreDistance' => '0.9834677',
                         'metaboliteID' => 'a88bcff0-2903-4b78-bbf5-5133683ec2c5',
                         'analyteName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS)'
                       },
                       {
                         'spectrumID' => '116b48d3-8d36-45f5-b5a3-bcfdab51ec2c',
                         'EuclideanDistance' => '0.0437742062',
                         'DotproductDistance' => '0.9015632',
                         'ri' => '2956.7644',
                         'analyteID' => 'c6009617-8113-419d-a3f5-127fefb203c4',
                         'HammingDistance' => '940',
                         'analyteName' => 'Eriodictyol (5TMS)',
                         'metaboliteID' => 'b50dd53a-d1b0-4fb5-ac5f-c0f43001b7d8',
                         's12GowerLegendreDistance' => '0.993305564',
                         'JaccardDistance' => '0.9989373',
                         'riDiscrepancy' => '1456.7644',
                         'spectrumName' => 'Eriodictyol (5TMS) [A295014-ambient-na-1]'
                       },
                       {
                         'ri' => '1949.14136',
                         'DotproductDistance' => '0.9015655',
                         'analyteID' => '4d937d88-a569-4a52-a84b-84f3884787d1',
                         'HammingDistance' => '115',
                         'spectrumID' => '724e801d-a205-4687-a866-6341226df8ff',
                         'EuclideanDistance' => '0.124676511',
                         'JaccardDistance' => '0.9913793',
                         'riDiscrepancy' => '449.141357',
                         'spectrumName' => 'Galacturonic acid (1MEOX) (5TMS) BP [A196003-ambient-na-3]',
                         'analyteName' => 'Galacturonic acid (1MEOX) (5TMS) BP',
                         'metaboliteID' => '0707e18b-36ec-46d2-98f6-256c00604b21',
                         's12GowerLegendreDistance' => '0.980434'
                       },
                       {
                         'JaccardDistance' => '0.998727739',
                         'riDiscrepancy' => '1414.98572',
                         'spectrumName' => 'Epigallocatechin (6TMS) [A291010-ambient-(-)--2]',
                         'analyteName' => 'Epigallocatechin (6TMS)',
                         'metaboliteID' => 'ccd3ac6f-06c0-43d8-94c8-58130d45dfa9',
                         's12GowerLegendreDistance' => '0.992669',
                         'DotproductDistance' => '0.901610136',
                         'ri' => '2914.98584',
                         'HammingDistance' => '785',
                         'analyteID' => '3a16a830-124c-4e69-b719-f79f9872ec9d',
                         'spectrumID' => '593587a6-9904-41d7-ab3f-9d034ab3db1c',
                         'EuclideanDistance' => '0.04789753'
                       },
                       {
                         's12GowerLegendreDistance' => '0.990697443',
                         'metaboliteID' => 'd71df4bf-1a4b-492c-b185-9e8a20e9da10',
                         'analyteName' => 'Nivalenol (4TMS)',
                         'spectrumName' => 'Nivalenol (4TMS) [A244006-ambient-na-1]',
                         'JaccardDistance' => '0.997963369',
                         'riDiscrepancy' => '946.549255',
                         'EuclideanDistance' => '0.0606017336',
                         'spectrumID' => 'd17f8566-2dc1-4629-9aa6-4700315867b5',
                         'HammingDistance' => '490',
                         'analyteID' => '72ef0309-cda2-49d5-ba34-4e7ac4808f8f',
                         'ri' => '2446.54932',
                         'DotproductDistance' => '0.901616'
                       },
                       {
                         'riDiscrepancy' => '604.560547',
                         'JaccardDistance' => '0.992126',
                         'spectrumName' => 'NA [A211005-ambient-na-2]',
                         'analyteName' => 'NA',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.9813455',
                         'ri' => '2104.56055',
                         'DotproductDistance' => '0.9016464',
                         'analyteID' => '9c987f49-db3b-4c3d-8456-198ca9066bcb',
                         'HammingDistance' => '126',
                         'spectrumID' => '0d23c0bf-609e-48bc-a5a2-6341bfeda943',
                         'EuclideanDistance' => '0.119160213'
                       },
                       {
                         'spectrumName' => 'Ampelopsin (6TMS) [A298004-ambient-na-1]',
                         'riDiscrepancy' => '1485.07971',
                         'JaccardDistance' => '0.998661339',
                         'metaboliteID' => '2b89fbac-4dd1-44c9-be2a-9d0c173bdfd8',
                         's12GowerLegendreDistance' => '0.9924781',
                         'analyteName' => 'Ampelopsin (6TMS)',
                         'analyteID' => '94f3b660-9d50-4577-afcf-bd3a29e60760',
                         'HammingDistance' => '746',
                         'ri' => '2985.07983',
                         'DotproductDistance' => '0.9016776',
                         'spectrumID' => '3c3ab1a4-1f13-4fb8-8ca7-1cc26972f4f6',
                         'EuclideanDistance' => '0.0491337962'
                       },
                       {
                         'spectrumID' => 'f9045a87-9d6f-449f-a90b-9538cd33191f',
                         'EuclideanDistance' => '0.159375161',
                         'ri' => '1776.3092',
                         'DotproductDistance' => '0.901715636',
                         'analyteID' => '58fd387c-81a4-43a3-807d-e631aa2db468',
                         'HammingDistance' => '70',
                         'analyteName' => 'NA180004',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.9745502',
                         'riDiscrepancy' => '276.3092',
                         'JaccardDistance' => '0.9859155',
                         'spectrumName' => 'NA180004 [A180004-ambient-na-1]'
                       },
                       {
                         'JaccardDistance' => '0.996551752',
                         'riDiscrepancy' => '2090.643',
                         'spectrumName' => 'Phyllohydroquinone (2TMS) [A358003-ambient-na-1]',
                         'analyteName' => 'Phyllohydroquinone (2TMS)',
                         's12GowerLegendreDistance' => '0.987834752',
                         'metaboliteID' => '84c51b31-3ce2-476b-be66-a84bdd46a513',
                         'ri' => '3590.643',
                         'DotproductDistance' => '0.90171665',
                         'HammingDistance' => '289',
                         'analyteID' => 'b986a209-14a6-4620-8e34-eeb4a63ece81',
                         'EuclideanDistance' => '0.07885896',
                         'spectrumID' => 'd572e4e4-4d37-4f17-b434-72b8c3ce4e84'
                       },
                       {
                         'EuclideanDistance' => '0.05993781',
                         'spectrumID' => '3b516a44-96ae-4e16-9f63-0d9022eb7127',
                         'DotproductDistance' => '0.9017278',
                         'ri' => '2454.06055',
                         'HammingDistance' => '501',
                         'analyteID' => 'da0360a8-1700-400d-b8dd-546521afa3aa',
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.990801454',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'JaccardDistance' => '0.998007953',
                         'riDiscrepancy' => '954.060547',
                         'spectrumName' => 'NA [A245011-ambient--1]'
                       },
                       {
                         'metaboliteID' => '49643640-fd4c-4b93-bd28-0d7c2021cc52',
                         's12GowerLegendreDistance' => '0.9793749',
                         'analyteName' => 'Quercetin (5TMS)',
                         'spectrumName' => 'Quercetin (5TMS) [A319004-ambient-na-4]',
                         'riDiscrepancy' => '1672.15112',
                         'JaccardDistance' => '0.9904762',
                         'spectrumID' => 'fd8de9c6-bc93-46ac-a923-8c13ff26eb50',
                         'EuclideanDistance' => '0.131057277',
                         'HammingDistance' => '104',
                         'analyteID' => '996782d2-2ff2-4a57-aa83-ec294d8c1a81',
                         'DotproductDistance' => '0.9017407',
                         'ri' => '3172.15112'
                       },
                       {
                         'analyteName' => 'NA',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.9506708',
                         'JaccardDistance' => '0.956521749',
                         'riDiscrepancy' => '660.9204',
                         'spectrumName' => 'NA [A217002-13C-na-3]',
                         'spectrumID' => 'b6b3da45-1426-472d-a543-cf83f7bea63b',
                         'EuclideanDistance' => '0.2800353',
                         'DotproductDistance' => '0.9018273',
                         'ri' => '2160.92041',
                         'analyteID' => '5aba9b24-f85c-46da-83d6-3b5a128baf43',
                         'HammingDistance' => '22'
                       },
                       {
                         'spectrumID' => 'd5ae2991-04f5-4c28-8680-1c3f303b0b04',
                         'EuclideanDistance' => '0.128050223',
                         'analyteID' => '65bff36a-79ba-43fc-bf2d-8c3331d09301',
                         'HammingDistance' => '109',
                         'ri' => '1308.97351',
                         'DotproductDistance' => '0.9018273',
                         'metaboliteID' => '5cc5f251-7344-445c-a519-06efb3063f2a',
                         's12GowerLegendreDistance' => '0.979877055',
                         'analyteName' => 'Catechol_2TMS',
                         'spectrumName' => 'Catechol_2TMS [A131018-ambient-na-1]',
                         'JaccardDistance' => '0.9909091',
                         'riDiscrepancy' => '191.026428'
                       },
                       {
                         'EuclideanDistance' => '0.102404147',
                         'spectrumID' => 'a0d95abd-848a-4f6d-95d2-216a22bafc63',
                         'ri' => '3099.586',
                         'DotproductDistance' => '0.9018485',
                         'HammingDistance' => '171',
                         'analyteID' => 'a7805fdf-1028-4275-a8f1-3620610199f6',
                         'analyteName' => 'Quinic acid, 3-caffeoyl-, trans- (6TMS)',
                         's12GowerLegendreDistance' => '0.984077632',
                         'metaboliteID' => '32cf6d13-8f08-485f-b79e-f8a6ac318e07',
                         'JaccardDistance' => '0.994186044',
                         'riDiscrepancy' => '1599.58594',
                         'spectrumName' => 'Quinic acid, 3-caffeoyl-, trans- (6TMS) [A311001-ambient-E--3]'
                       },
                       {
                         'spectrumID' => 'b48eda03-7e6f-4c90-baee-f795b02a195d',
                         'EuclideanDistance' => '0.174847916',
                         'HammingDistance' => '58',
                         'analyteID' => '72786f67-ed87-443a-a85d-c506fe32d66b',
                         'ri' => '2106.36987',
                         'DotproductDistance' => '0.901867867',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.9718253',
                         'analyteName' => 'NA',
                         'spectrumName' => 'NA [A212001-ambient-na-2]',
                         'riDiscrepancy' => '606.3699',
                         'JaccardDistance' => '0.9830508'
                       },
                       {
                         'spectrumID' => 'c535d1e2-0a2d-4381-9c1a-c709acc57e5e',
                         'EuclideanDistance' => '0.0433237627',
                         'DotproductDistance' => '0.9018737',
                         'ri' => '2956.7644',
                         'analyteID' => 'c6009617-8113-419d-a3f5-127fefb203c4',
                         'HammingDistance' => '960',
                         'analyteName' => 'Eriodictyol (5TMS)',
                         'metaboliteID' => 'b50dd53a-d1b0-4fb5-ac5f-c0f43001b7d8',
                         's12GowerLegendreDistance' => '0.9933762',
                         'riDiscrepancy' => '1456.7644',
                         'JaccardDistance' => '0.9989594',
                         'spectrumName' => 'Eriodictyol (5TMS) [A295014-ambient-na-2]'
                       },
                       {
                         'EuclideanDistance' => '0.0643199',
                         'spectrumID' => '0e41f4bf-c341-4b4a-9053-f9b93b0dabb6',
                         'HammingDistance' => '435',
                         'analyteID' => '8e2a0474-67db-4839-a6d4-09dc035e3d7f',
                         'DotproductDistance' => '0.901876867',
                         'ri' => '1695.86609',
                         's12GowerLegendreDistance' => '0.990118861',
                         'metaboliteID' => '2b316672-1b4e-4ba1-9347-b0d706846d8e',
                         'analyteName' => 'Malic acid, 3-oxalo- (TMS)',
                         'spectrumName' => 'Malic acid, 3-oxalo- (TMS) [A169007-ambient-na-2]',
                         'riDiscrepancy' => '195.866135',
                         'JaccardDistance' => '0.9977064'
                       },
                       {
                         's12GowerLegendreDistance' => '0.9844933',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'analyteName' => 'NA',
                         'spectrumName' => 'NA [A165002-ambient-na-1]',
                         'JaccardDistance' => '0.9944751',
                         'riDiscrepancy' => '143.67334',
                         'EuclideanDistance' => '0.09982781',
                         'spectrumID' => '99b2d23b-7a87-4008-8a6e-899e1dd7ba4d',
                         'HammingDistance' => '180',
                         'analyteID' => '439bb8c9-d79c-440f-819b-1873ae7cbc2f',
                         'DotproductDistance' => '0.901886046',
                         'ri' => '1643.67334'
                       },
                       {
                         'spectrumID' => 'b1d5b1dd-c993-4a7b-8832-f41eb0a6647f',
                         'EuclideanDistance' => '0.07832848',
                         'analyteID' => 'ca89472e-4d12-4a88-ae52-d47fd6582798',
                         'HammingDistance' => '293',
                         'ri' => '1560.80664',
                         'DotproductDistance' => '0.9018967',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.987919748',
                         'analyteName' => 'NA156013 (classified unknown)',
                         'spectrumName' => 'NA156013 (classified unknown) [A156013-ambient--1]',
                         'JaccardDistance' => '0.996598661',
                         'riDiscrepancy' => '60.8066673'
                       },
                       {
                         'EuclideanDistance' => '0.08914346',
                         'spectrumID' => '054691ed-30ab-4fa9-8586-abbf1014ae49',
                         'analyteID' => '6bc575ee-1453-47eb-854a-95862fc6d68c',
                         'HammingDistance' => '226',
                         'DotproductDistance' => '0.901934266',
                         'ri' => '3487.3313',
                         's12GowerLegendreDistance' => '0.9862049',
                         'metaboliteID' => '84c51b31-3ce2-476b-be66-a84bdd46a513',
                         'analyteName' => 'Phyllodihydroquinone (2TMS)',
                         'spectrumName' => 'Phyllodihydroquinone (2TMS) [A348004-ambient-na-1]',
                         'riDiscrepancy' => '1987.3313',
                         'JaccardDistance' => '0.99559474'
                       },
                       {
                         's12GowerLegendreDistance' => '0.9853494',
                         'metaboliteID' => '294b1373-e8c3-442d-8240-d7ea2650b160',
                         'analyteName' => 'Guanosine (5TMS)',
                         'spectrumName' => 'Guanosine (5TMS) [A278001-ambient-na-7]',
                         'riDiscrepancy' => '1261.9718',
                         'JaccardDistance' => '0.9950495',
                         'EuclideanDistance' => '0.09449956',
                         'spectrumID' => 'c47fb514-76a5-496a-884a-9f21e1829117',
                         'HammingDistance' => '201',
                         'analyteID' => '58207476-3182-4e36-874a-5e45eb653206',
                         'DotproductDistance' => '0.9019469',
                         'ri' => '2761.97168'
                       },
                       {
                         'analyteName' => 'Neopterin, 7,8-dihydro- (6TMS)',
                         'metaboliteID' => '69e16c56-6129-445c-b652-c8ac2695c2c7',
                         's12GowerLegendreDistance' => '0.9874288',
                         'JaccardDistance' => '0.9963235',
                         'riDiscrepancy' => '1069.67773',
                         'spectrumName' => 'Neopterin, 7,8-dihydro- (6TMS) [A256007-ambient-na-2]',
                         'spectrumID' => '57decb40-be80-4c22-a21f-30dffcd895de',
                         'EuclideanDistance' => '0.08143776',
                         'ri' => '2569.67773',
                         'DotproductDistance' => '0.90196687',
                         'analyteID' => '390c944d-aa0b-4688-a390-7c82ba072fb9',
                         'HammingDistance' => '271'
                       },
                       {
                         'analyteID' => 'cebca4ab-4550-438f-943a-1df63a10b96f',
                         'HammingDistance' => '35',
                         'DotproductDistance' => '0.901970148',
                         'ri' => '3140.20679',
                         'spectrumID' => '9d799f36-fed5-40e3-bc76-5f8b4b50f37d',
                         'EuclideanDistance' => '0.2238514',
                         'spectrumName' => 'NA [A315001-ambient-na-1]',
                         'JaccardDistance' => '0.9722222',
                         'riDiscrepancy' => '1640.20679',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.962640345',
                         'analyteName' => 'NA'
                       },
                       {
                         'spectrumID' => '817f2a03-9df5-46e3-973c-b2a9675109cf',
                         'EuclideanDistance' => '0.126351029',
                         'HammingDistance' => '112',
                         'analyteID' => '65bb54d2-6bf7-4a53-aa22-8abf71240005',
                         'ri' => '1896.99829',
                         'DotproductDistance' => '0.901998937',
                         'metaboliteID' => 'a999f0d6-0285-41d9-a6ba-b705987b663c',
                         's12GowerLegendreDistance' => '0.980161369',
                         'analyteName' => 'Allantoin (5TMS)',
                         'spectrumName' => 'Allantoin (5TMS) [A188009-ambient-na-5]',
                         'JaccardDistance' => '0.991150439',
                         'riDiscrepancy' => '396.9983'
                       },
                       {
                         'DotproductDistance' => '0.9020054',
                         'ri' => '1862.67151',
                         'HammingDistance' => '385',
                         'analyteID' => '6f980846-f868-4b1f-a869-38930e18a00b',
                         'EuclideanDistance' => '0.0683637559',
                         'spectrumID' => 'd0ce4f39-8cbf-40a0-9e2c-099fed8283c1',
                         'JaccardDistance' => '0.997409344',
                         'riDiscrepancy' => '362.671478',
                         'spectrumName' => 'Phenylglycol, 3,4-dihydroxy- (4TMS) [A186017-ambient-DL--1]',
                         'analyteName' => 'Phenylglycol, 3,4-dihydroxy- (4TMS)',
                         's12GowerLegendreDistance' => '0.9894872',
                         'metaboliteID' => '4740838a-79c1-450b-827d-a3b2f61834f4'
                       },
                       {
                         'JaccardDistance' => '0.996350348',
                         'riDiscrepancy' => '690.4812',
                         'spectrumName' => 'Malic acid, 3-oxalo- (1MEOX) (4TMS) MP [A219010-ambient-na-1]',
                         'analyteName' => 'Malic acid, 3-oxalo- (1MEOX) (4TMS) MP',
                         's12GowerLegendreDistance' => '0.987475932',
                         'metaboliteID' => '2b316672-1b4e-4ba1-9347-b0d706846d8e',
                         'DotproductDistance' => '0.902026832',
                         'ri' => '2190.4812',
                         'HammingDistance' => '273',
                         'analyteID' => 'fda144dd-1d94-40ea-88d6-ec4a0784ecc9',
                         'EuclideanDistance' => '0.0811426938',
                         'spectrumID' => '6160cea4-d7fe-41e1-8484-01b5fd9875fd'
                       },
                       {
                         'analyteID' => '249ea5fd-66e6-4293-838b-586365a336f4',
                         'HammingDistance' => '204',
                         'DotproductDistance' => '0.90206784',
                         'ri' => '2307.33716',
                         'spectrumID' => '938c85c2-587a-463a-8b63-7ea04a0c3040',
                         'EuclideanDistance' => '0.09381184',
                         'spectrumName' => 'Glucose-6-phosphate (1MEOX) (6TMS) MP [A233002-ambient-na-11]',
                         'riDiscrepancy' => '807.337158',
                         'JaccardDistance' => '0.995121956',
                         'metaboliteID' => '962672d2-8750-46fd-9a76-e598aa2319da',
                         's12GowerLegendreDistance' => '0.9854605',
                         'analyteName' => 'Glucose-6-phosphate (1MEOX) (6TMS) MP'
                       },
                       {
                         'ri' => '2265.17578',
                         'DotproductDistance' => '0.902073',
                         'analyteID' => '52456612-1df9-4cf8-b114-6e9b1ef19f2c',
                         'HammingDistance' => '59',
                         'EuclideanDistance' => '0.17340444',
                         'spectrumID' => 'fd28e9bb-92bd-484c-b9af-f8e0521adc97',
                         'riDiscrepancy' => '765.1758',
                         'JaccardDistance' => '0.983333349',
                         'spectrumName' => 'NA [A228001-ambient-na-5]',
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.9720863',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000'
                       },
                       {
                         'riDiscrepancy' => '794.9476',
                         'JaccardDistance' => '0.995',
                         'spectrumName' => 'Mannose-6-phosphate (1MEOX) (6TMS) MP [A231001-ambient-D--4]',
                         'analyteName' => 'Mannose-6-phosphate (1MEOX) (6TMS) MP',
                         'metaboliteID' => 'a074f4fa-f19b-4afa-af19-0e6f967a7e91',
                         's12GowerLegendreDistance' => '0.985273957',
                         'ri' => '2294.94751',
                         'DotproductDistance' => '0.902132154',
                         'HammingDistance' => '199',
                         'analyteID' => 'd0b63bc5-a04a-410d-8a42-56ece95dadd8',
                         'spectrumID' => '39b7cad7-548e-4f0b-8053-50af8adb224d',
                         'EuclideanDistance' => '0.09498064'
                       },
                       {
                         'spectrumName' => 'Eriodictyol (1MEOX) (4TMS) [A304006-ambient-na-2]',
                         'riDiscrepancy' => '1540.15955',
                         'JaccardDistance' => '0.9985185',
                         'metaboliteID' => 'b50dd53a-d1b0-4fb5-ac5f-c0f43001b7d8',
                         's12GowerLegendreDistance' => '0.992082655',
                         'analyteName' => 'Eriodictyol (1MEOX) (4TMS)',
                         'HammingDistance' => '674',
                         'analyteID' => 'f28cd3a1-6135-4d42-a8a5-017a75d65403',
                         'ri' => '3040.15942',
                         'DotproductDistance' => '0.9021389',
                         'spectrumID' => 'd19bd46f-e7a1-4613-804c-53d6312484c1',
                         'EuclideanDistance' => '0.0517011024'
                       },
                       {
                         'EuclideanDistance' => '0.0729544759',
                         'spectrumID' => '5058aef0-8058-4f43-bd46-cf0c4b909fc7',
                         'ri' => '2458.75659',
                         'DotproductDistance' => '0.9021393',
                         'HammingDistance' => '338',
                         'analyteID' => '422a47a3-2988-492b-895f-b41b7444a03c',
                         'analyteName' => 'D245834',
                         's12GowerLegendreDistance' => '0.988767743',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'JaccardDistance' => '0.997050166',
                         'riDiscrepancy' => '958.756653',
                         'spectrumName' => 'D245834 [A245012-ambient-na-3]'
                       },
                       {
                         'ri' => '2532.646',
                         'DotproductDistance' => '0.902156651',
                         'analyteID' => '162d9496-96eb-4e16-a51a-cf847d93bf87',
                         'HammingDistance' => '694',
                         'EuclideanDistance' => '0.0509522744',
                         'spectrumID' => '6910ccad-fedb-4030-8914-463fe4ae3f8d',
                         'riDiscrepancy' => '1032.646',
                         'JaccardDistance' => '0.998561144',
                         'spectrumName' => 'Piceatannol (4TMS) BP [A253010-ambient-na-1]',
                         'analyteName' => 'Piceatannol (4TMS) BP',
                         's12GowerLegendreDistance' => '0.9921987',
                         'metaboliteID' => 'f13be9bb-b7d7-4d40-b31a-c15b953e033d'
                       },
                       {
                         'spectrumName' => 'Neopterin, 7,8-dihydro- (5TMS) [A265008-ambient-na-2]',
                         'riDiscrepancy' => '1157.69165',
                         'JaccardDistance' => '0.998130858',
                         'metaboliteID' => '69e16c56-6129-445c-b652-c8ac2695c2c7',
                         's12GowerLegendreDistance' => '0.991093755',
                         'analyteName' => 'Neopterin, 7,8-dihydro- (5TMS)',
                         'HammingDistance' => '534',
                         'analyteID' => '6dad2d4a-80f5-456e-a87f-ee9828041438',
                         'ri' => '2657.69165',
                         'DotproductDistance' => '0.902169',
                         'spectrumID' => '509bcc19-91ec-4890-b134-60e87c07c020',
                         'EuclideanDistance' => '0.0580740422'
                       },
                       {
                         'spectrumID' => 'd509f9c1-51b2-4b78-a593-ba4735d3f253',
                         'EuclideanDistance' => '0.155106187',
                         'DotproductDistance' => '0.902172446',
                         'ri' => '2037.57874',
                         'HammingDistance' => '74',
                         'analyteID' => 'fd066513-c41d-488d-b07a-55987e6d3192',
                         'analyteName' => 'Galactaric acid (6TMS)',
                         'metaboliteID' => 'db1a77de-0cb9-4ef3-a902-3cb04c998644',
                         's12GowerLegendreDistance' => '0.9752974',
                         'riDiscrepancy' => '537.578735',
                         'JaccardDistance' => '0.9866667',
                         'spectrumName' => 'Galactaric acid (6TMS) [A204001-13C-na-3]'
                       },
                       {
                         'JaccardDistance' => '0.9985251',
                         'riDiscrepancy' => '1709.62158',
                         'spectrumName' => 'Myricetin (6TMS) [A320003-ambient-na-1]',
                         'analyteName' => 'Myricetin (6TMS)',
                         's12GowerLegendreDistance' => '0.9921004',
                         'metaboliteID' => 'c07e0ed2-abf6-4bd3-a2b2-a98caef20fd1',
                         'ri' => '3209.62158',
                         'DotproductDistance' => '0.9021803',
                         'analyteID' => '775c0401-bf65-4162-b86b-1b7d5e710116',
                         'HammingDistance' => '677',
                         'EuclideanDistance' => '0.05158778',
                         'spectrumID' => 'a09b068b-89ff-41cf-b1ab-0d60341bf719'
                       },
                       {
                         'analyteName' => 'Saccharic acid (6TMS)',
                         'metaboliteID' => '52b6ca34-55ed-41a0-be2a-45aabdc4dc81',
                         's12GowerLegendreDistance' => '0.980695665',
                         'riDiscrepancy' => '500.791779',
                         'JaccardDistance' => '0.991596639',
                         'spectrumName' => 'Saccharic acid (6TMS) [A201001-ambient-D--13]',
                         'spectrumID' => '1930ed86-9749-47f4-8d83-a696f741d10b',
                         'EuclideanDistance' => '0.123136975',
                         'ri' => '2000.79175',
                         'DotproductDistance' => '0.9021815',
                         'analyteID' => 'c98be9bb-ceb5-4886-aa9d-1f8f274a2cef',
                         'HammingDistance' => '118'
                       },
                       {
                         'analyteID' => '0b9243a6-ea69-4ddb-bb45-0d7a8cb5a690',
                         'HammingDistance' => '552',
                         'ri' => '2691.4812',
                         'DotproductDistance' => '0.9022171',
                         'EuclideanDistance' => '0.0571225956',
                         'spectrumID' => 'f33f90c1-8888-4a98-9ff3-bbba89b5dc16',
                         'spectrumName' => 'Aspartic acid, N-(3-indolylacetyl)- (4TMS) [A270006-ambient-na-3]',
                         'riDiscrepancy' => '1191.4812',
                         'JaccardDistance' => '0.998191655',
                         's12GowerLegendreDistance' => '0.9912419',
                         'metaboliteID' => 'da0b15b0-caf0-499a-a99b-35f39f500f52',
                         'analyteName' => 'Aspartic acid, N-(3-indolylacetyl)- (4TMS)'
                       },
                       {
                         'EuclideanDistance' => '0.08781454',
                         'spectrumID' => 'ed994cba-5569-4e02-b4f7-601afedfe7e9',
                         'ri' => '3375.60034',
                         'DotproductDistance' => '0.902233',
                         'analyteID' => 'beceaad3-704e-460e-9623-1bd20ba445b7',
                         'HammingDistance' => '233',
                         'analyteName' => 'Fluorescein, 5(6)-carboxy- (4TMS)',
                         's12GowerLegendreDistance' => '0.9864189',
                         'metaboliteID' => '08e30fe8-a2f7-407b-919b-831ab7137432',
                         'JaccardDistance' => '0.995726466',
                         'riDiscrepancy' => '1875.60034',
                         'spectrumName' => 'Fluorescein, 5(6)-carboxy- (4TMS) [A337006-ambient-na-1]'
                       },
                       {
                         's12GowerLegendreDistance' => '0.9847107',
                         'metaboliteID' => '32cf6d13-8f08-485f-b79e-f8a6ac318e07',
                         'analyteName' => 'Quinic acid, 3-caffeoyl-, trans- (6TMS)',
                         'spectrumName' => 'Quinic acid, 3-caffeoyl-, trans- (6TMS) [A311001-ambient-E--8]',
                         'JaccardDistance' => '0.994623661',
                         'riDiscrepancy' => '1599.58594',
                         'EuclideanDistance' => '0.09849641',
                         'spectrumID' => '255bfcf0-7c80-4919-b211-603e1314af0b',
                         'analyteID' => 'a7805fdf-1028-4275-a8f1-3620610199f6',
                         'HammingDistance' => '185',
                         'ri' => '3099.586',
                         'DotproductDistance' => '0.902243435'
                       },
                       {
                         'EuclideanDistance' => '0.167914942',
                         'spectrumID' => '10d01576-d56b-4cdf-9b07-eec5d21f803e',
                         'DotproductDistance' => '0.9022538',
                         'ri' => '2913.481',
                         'analyteID' => '22f00ac2-4636-4b10-9506-7abe52f6426f',
                         'HammingDistance' => '63',
                         'analyteName' => 'D291398',
                         's12GowerLegendreDistance' => '0.973062456',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'JaccardDistance' => '0.984375',
                         'riDiscrepancy' => '1413.48108',
                         'spectrumName' => 'D291398 [A291011-ambient-na-2]'
                       },
                       {
                         'DotproductDistance' => '0.9022672',
                         'ri' => '3448.103',
                         'analyteID' => 'ce6166c8-42b5-4ce9-be5c-87d2b22abefc',
                         'HammingDistance' => '286',
                         'EuclideanDistance' => '0.0792942345',
                         'spectrumID' => 'c842a1ef-9233-4f1b-9959-cf971b5668ed',
                         'riDiscrepancy' => '1948.103',
                         'JaccardDistance' => '0.9965157',
                         'spectrumName' => 'Phyllodihydroquinone (2TMS) [A344004-ambient-na-2]',
                         'analyteName' => 'Phyllodihydroquinone (2TMS)',
                         's12GowerLegendreDistance' => '0.9877698',
                         'metaboliteID' => '84c51b31-3ce2-476b-be66-a84bdd46a513'
                       },
                       {
                         'spectrumName' => 'Calystegine B3 (1MEOX) (4TMS) BP [A183008-ambient-na-3]',
                         'JaccardDistance' => '0.998116732',
                         'riDiscrepancy' => '297.716431',
                         'metaboliteID' => '4c2844a4-cf88-44bf-9f5a-02c7b6024efc',
                         's12GowerLegendreDistance' => '0.9910598',
                         'analyteName' => 'Calystegine B3 (1MEOX) (4TMS) BP',
                         'HammingDistance' => '530',
                         'analyteID' => '8913cf47-652c-4978-b71d-12b286d69754',
                         'ri' => '1797.71643',
                         'DotproductDistance' => '0.9022751',
                         'spectrumID' => '91750549-1e91-4394-88b8-3b1183f6b1b8',
                         'EuclideanDistance' => '0.0582957938'
                       },
                       {
                         'HammingDistance' => '413',
                         'analyteID' => 'cd699884-f7c2-41df-b092-e04a0c04719b',
                         'ri' => '1798.42908',
                         'DotproductDistance' => '0.9022896',
                         'spectrumID' => '6082e670-d4d1-4ff8-8f17-25fb0c0822d1',
                         'EuclideanDistance' => '0.06602187',
                         'spectrumName' => 'Calystegine B2 (1MEOX) (4TMS) MP [A181006-ambient-na-6]',
                         'riDiscrepancy' => '298.429077',
                         'JaccardDistance' => '0.9975845',
                         'metaboliteID' => '127e4c51-f774-4783-bf04-584e35802638',
                         's12GowerLegendreDistance' => '0.98985523',
                         'analyteName' => 'Calystegine B2 (1MEOX) (4TMS) MP'
                       },
                       {
                         'EuclideanDistance' => '0.09405319',
                         'spectrumID' => 'bbba4323-d9a7-4deb-af96-acbb30cfa89d',
                         'DotproductDistance' => '0.902292252',
                         'ri' => '2912.67017',
                         'analyteID' => 'cbbc9fab-9701-4ecc-9ea2-bf4677251e02',
                         'HammingDistance' => '203',
                         'analyteName' => 'NA292001 (classified unknown)',
                         's12GowerLegendreDistance' => '0.9854238',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'riDiscrepancy' => '1412.67017',
                         'JaccardDistance' => '0.995098054',
                         'spectrumName' => 'NA292001 (classified unknown) [A292001-ambient-na-1]'
                       },
                       {
                         'HammingDistance' => '163',
                         'analyteID' => '4d6bca6a-d703-49b2-b04b-9393782f5f81',
                         'DotproductDistance' => '0.902303',
                         'ri' => '2075.73364',
                         'EuclideanDistance' => '0.1048985',
                         'spectrumID' => '778809e1-77c2-4373-97c6-f8d3324853fa',
                         'spectrumName' => 'Prephenic acid (1MEOX) (3TMS) [A209003-ambient-na-4]',
                         'JaccardDistance' => '0.993902445',
                         'riDiscrepancy' => '575.7335',
                         's12GowerLegendreDistance' => '0.9836787',
                         'metaboliteID' => 'd0caeb4e-fd01-4ad2-9dc4-aabebf5aed8a',
                         'analyteName' => 'Prephenic acid (1MEOX) (3TMS)'
                       },
                       {
                         's12GowerLegendreDistance' => '0.981719851',
                         'metaboliteID' => '0707e18b-36ec-46d2-98f6-256c00604b21',
                         'analyteName' => 'Galacturonic acid (1MEOX) (5TMS) MP',
                         'spectrumName' => 'Galacturonic acid (1MEOX) (5TMS) MP [A194003-ambient-na-10]',
                         'JaccardDistance' => '0.99242425',
                         'riDiscrepancy' => '428.058136',
                         'EuclideanDistance' => '0.116925314',
                         'spectrumID' => '52dc1316-2538-465b-8ac4-c1a6cdb6bf29',
                         'HammingDistance' => '131',
                         'analyteID' => 'c280058f-2d3c-4951-8563-3c9a544d4580',
                         'DotproductDistance' => '0.902321',
                         'ri' => '1928.05811'
                       },
                       {
                         'spectrumID' => '6a8a48fc-7e57-4499-ab36-2600a8157329',
                         'EuclideanDistance' => '0.0502049327',
                         'HammingDistance' => '715',
                         'analyteID' => '3a16a830-124c-4e69-b719-f79f9872ec9d',
                         'ri' => '2914.98584',
                         'DotproductDistance' => '0.9023517',
                         'metaboliteID' => 'ccd3ac6f-06c0-43d8-94c8-58130d45dfa9',
                         's12GowerLegendreDistance' => '0.992315233',
                         'analyteName' => 'Epigallocatechin (6TMS)',
                         'spectrumName' => 'Epigallocatechin (6TMS) [A291010-ambient-(-)--1]',
                         'JaccardDistance' => '0.998603344',
                         'riDiscrepancy' => '1414.98572'
                       },
                       {
                         'HammingDistance' => '279',
                         'analyteID' => '5bb480fd-2d3a-4b4b-ad0f-7f689f761079',
                         'ri' => '2981.68042',
                         'DotproductDistance' => '0.9023571',
                         'EuclideanDistance' => '0.08028329',
                         'spectrumID' => '32caefa3-7cfb-4879-a833-f865bd5882ba',
                         'spectrumName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS) [A299001-ambient-Z--9]',
                         'riDiscrepancy' => '1481.68042',
                         'JaccardDistance' => '0.996428549',
                         's12GowerLegendreDistance' => '0.987614155',
                         'metaboliteID' => 'a88bcff0-2903-4b78-bbf5-5133683ec2c5',
                         'analyteName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS)'
                       },
                       {
                         'DotproductDistance' => '0.90237534',
                         'ri' => '1998.2605',
                         'HammingDistance' => '516',
                         'analyteID' => 'b63314e0-f6a5-40bf-9501-0810f7a9b820',
                         'EuclideanDistance' => '0.0590831079',
                         'spectrumID' => 'c249a24a-7f2c-46c8-a728-97329c87f0dc',
                         'riDiscrepancy' => '498.2605',
                         'JaccardDistance' => '0.99806577',
                         'spectrumName' => 'Homonojirimycin (6TMS) [A199016-ambient-na-1]',
                         'analyteName' => 'Homonojirimycin (6TMS)',
                         's12GowerLegendreDistance' => '0.9909378',
                         'metaboliteID' => '5f014ec3-e03f-4855-8605-373d1af7d2ca'
                       },
                       {
                         's12GowerLegendreDistance' => '0.987898648',
                         'metaboliteID' => '2714e487-d765-4621-bccc-df13f924d4d7',
                         'analyteName' => 'Gibberellin A1 (3TMS)',
                         'spectrumName' => 'Gibberellin A1 (3TMS) [A290012-ambient-na-2]',
                         'JaccardDistance' => '0.996587038',
                         'riDiscrepancy' => '1249.94043',
                         'EuclideanDistance' => '0.07848309',
                         'spectrumID' => 'c0b0e1ac-ad6b-439b-8e8c-8e0c59bbd176',
                         'HammingDistance' => '292',
                         'analyteID' => 'd0f2f458-c8db-40a1-8c47-cf5d91c93104',
                         'DotproductDistance' => '0.9023808',
                         'ri' => '2749.94043'
                       },
                       {
                         'EuclideanDistance' => '0.112343825',
                         'spectrumID' => '161cceef-b413-449c-bee8-abf658deef06',
                         'HammingDistance' => '142',
                         'analyteID' => '4d6bca6a-d703-49b2-b04b-9393782f5f81',
                         'ri' => '2075.73364',
                         'DotproductDistance' => '0.902411163',
                         's12GowerLegendreDistance' => '0.982470155',
                         'metaboliteID' => 'd0caeb4e-fd01-4ad2-9dc4-aabebf5aed8a',
                         'analyteName' => 'Prephenic acid (1MEOX) (3TMS)',
                         'spectrumName' => 'Prephenic acid (1MEOX) (3TMS) [A209003-ambient-na-2]',
                         'JaccardDistance' => '0.993007',
                         'riDiscrepancy' => '575.7335'
                       },
                       {
                         'analyteID' => '2e26fb76-98d9-4f71-82e1-81c3527481f7',
                         'HammingDistance' => '915',
                         'ri' => '2654.66968',
                         'DotproductDistance' => '0.9024192',
                         'EuclideanDistance' => '0.044388596',
                         'spectrumID' => '0c568574-ee98-4c6f-ae79-0b120e4a8ed2',
                         'spectrumName' => 'Neuraminic acid, N-acetyl- (1MEOX) (7TMS) MP [A266006-ambient-na-1]',
                         'JaccardDistance' => '0.9989083',
                         'riDiscrepancy' => '1154.66968',
                         's12GowerLegendreDistance' => '0.993214',
                         'metaboliteID' => '028d6d24-32a0-45ed-857e-4138653435fb',
                         'analyteName' => 'Neuraminic acid, N-acetyl- (1MEOX) (7TMS) MP'
                       },
                       {
                         'ri' => '1790.49573',
                         'DotproductDistance' => '0.9024209',
                         'HammingDistance' => '129',
                         'analyteID' => '78ceccbd-f504-485e-80bc-31710fda1cba',
                         'spectrumID' => '9051744c-61f3-49ce-bfce-6319c19c3a21',
                         'EuclideanDistance' => '0.117827825',
                         'JaccardDistance' => '0.992307663',
                         'riDiscrepancy' => '290.495728',
                         'spectrumName' => 'NA [A181004-13C-na-3]',
                         'analyteName' => 'NA',
                         'metaboliteID' => '8ef9b098-51c3-4f17-9bfc-904b401aeff7',
                         's12GowerLegendreDistance' => '0.9815728'
                       },
                       {
                         'spectrumID' => '2100fae2-7a20-4e20-9804-679b0002f428',
                         'EuclideanDistance' => '0.1939103',
                         'ri' => '2818.72046',
                         'DotproductDistance' => '0.902428865',
                         'HammingDistance' => '47',
                         'analyteID' => '80e6bcab-4e32-4c99-90d3-302fc476ac5c',
                         'analyteName' => 'NA',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.968371153',
                         'JaccardDistance' => '0.9791667',
                         'riDiscrepancy' => '1318.72046',
                         'spectrumName' => 'NA [A283003-ambient-na-1]'
                       },
                       {
                         'JaccardDistance' => '0.9982935',
                         'riDiscrepancy' => '916.462158',
                         'spectrumName' => 'Galactose-6-phosphate (1MEOX) (6TMS) BP [A235001-ambient-D--3]',
                         'analyteName' => 'Galactose-6-phosphate (1MEOX) (6TMS) BP',
                         'metaboliteID' => '9fbea297-cf39-432f-9160-9837faba7c9e',
                         's12GowerLegendreDistance' => '0.9914953',
                         'DotproductDistance' => '0.9024332',
                         'ri' => '2416.46216',
                         'HammingDistance' => '585',
                         'analyteID' => '2818ee61-174c-4579-bb4f-4f0c9f00ad3b',
                         'spectrumID' => '84406ec0-9f61-42c0-858c-37079019ec05',
                         'EuclideanDistance' => '0.05549754'
                       },
                       {
                         'HammingDistance' => '642',
                         'analyteID' => '2af502a1-c5bb-493b-bdda-9b1d727dd30a',
                         'ri' => '2865.56445',
                         'DotproductDistance' => '0.9024358',
                         'spectrumID' => 'a95a8606-b7e6-48ee-8ff0-532a46d842d9',
                         'EuclideanDistance' => '0.0529806949',
                         'spectrumName' => 'Catechin (5TMS) [A289005-ambient-(+/-)--2]',
                         'riDiscrepancy' => '1365.56445',
                         'JaccardDistance' => '0.9984448',
                         'metaboliteID' => 'ee68d890-72e6-4ba1-9ad2-038c19d48620',
                         's12GowerLegendreDistance' => '0.9918857',
                         'analyteName' => 'Catechin (5TMS)'
                       },
                       {
                         'riDiscrepancy' => '192.47168',
                         'JaccardDistance' => '0.9895833',
                         'spectrumName' => 'NA [A171003-ambient-na-3]',
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.978368',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'DotproductDistance' => '0.9024433',
                         'ri' => '1692.47168',
                         'analyteID' => '9cdfb801-5fc2-4816-8b0a-e2ee7a8435ec',
                         'HammingDistance' => '95',
                         'EuclideanDistance' => '0.137116373',
                         'spectrumID' => 'cad62ac4-0060-4fb3-820f-73a254b34076'
                       },
                       {
                         'HammingDistance' => '264',
                         'analyteID' => '3855a1a6-e410-4d58-b5d5-b8c456c02bb5',
                         'DotproductDistance' => '0.902457237',
                         'ri' => '2055.69629',
                         'EuclideanDistance' => '0.08252877',
                         'spectrumID' => '025e3b4d-7409-4cf1-8b79-5d61c9767bde',
                         'spectrumName' => 'Indole-3-acetamide (3TMS) [A205009-ambient-na-2]',
                         'riDiscrepancy' => '555.6962',
                         'JaccardDistance' => '0.99622643',
                         's12GowerLegendreDistance' => '0.9872596',
                         'metaboliteID' => '99fea035-a073-4863-9f14-923310e3bc45',
                         'analyteName' => 'Indole-3-acetamide (3TMS)'
                       },
                       {
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.9774745',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'riDiscrepancy' => '836.4348',
                         'JaccardDistance' => '0.988764048',
                         'spectrumName' => 'NA [A234002-ambient-na-2]',
                         'EuclideanDistance' => '0.142407656',
                         'spectrumID' => '3ffe8941-e355-4f09-a740-ec684f396a2f',
                         'DotproductDistance' => '0.9024575',
                         'ri' => '2336.43481',
                         'HammingDistance' => '88',
                         'analyteID' => '8d206d14-c06b-45e4-a472-f452736a1d77'
                       },
                       {
                         'spectrumID' => '5f5fa4f0-60e0-46a8-b8be-b15590b609c5',
                         'EuclideanDistance' => '0.104589663',
                         'ri' => '2030.46814',
                         'DotproductDistance' => '0.9024673',
                         'HammingDistance' => '164',
                         'analyteID' => '593e644b-68a3-4e67-bab1-bdd99219e072',
                         'analyteName' => 'Galactaric acid (6TMS)',
                         'metaboliteID' => '9316e06e-79a6-4c12-94bc-9ee2f7f89a38',
                         's12GowerLegendreDistance' => '0.9837302',
                         'JaccardDistance' => '0.9939394',
                         'riDiscrepancy' => '530.4682',
                         'spectrumName' => 'Galactaric acid (6TMS) [A204001-ambient-D--9]'
                       },
                       {
                         'metaboliteID' => '7d5f143e-52e8-4fbb-87f1-0d4f96b4ca60',
                         's12GowerLegendreDistance' => '0.9843584',
                         'analyteName' => 'Phenylpyruvic acid (1MEOX) (1TMS) MP',
                         'spectrumName' => 'Phenylpyruvic acid (1MEOX) (1TMS) MP [A160002-ambient-na-11]',
                         'JaccardDistance' => '0.994382',
                         'riDiscrepancy' => '91.2988052',
                         'spectrumID' => 'a6ddba56-447a-44f4-8977-ac02058d1777',
                         'EuclideanDistance' => '0.100697979',
                         'HammingDistance' => '177',
                         'analyteID' => 'b5dcd527-edf1-4354-8c27-17d838d80f07',
                         'DotproductDistance' => '0.90246737',
                         'ri' => '1591.29883'
                       },
                       {
                         'analyteName' => 'Fluorescein, 5(6)-carboxy- (4TMS)',
                         's12GowerLegendreDistance' => '0.991281748',
                         'metaboliteID' => '08e30fe8-a2f7-407b-919b-831ab7137432',
                         'riDiscrepancy' => '1875.60034',
                         'JaccardDistance' => '0.998207867',
                         'spectrumName' => 'Fluorescein, 5(6)-carboxy- (4TMS) [A337006-ambient-na-2]',
                         'EuclideanDistance' => '0.0568746552',
                         'spectrumID' => 'e3a3d410-b76a-420d-bdb5-7acba2478301',
                         'ri' => '3375.60034',
                         'DotproductDistance' => '0.902488768',
                         'HammingDistance' => '557',
                         'analyteID' => 'beceaad3-704e-460e-9623-1bd20ba445b7'
                       },
                       {
                         'analyteName' => 'Eriodictyol (1MEOX) (4TMS)',
                         'metaboliteID' => 'b50dd53a-d1b0-4fb5-ac5f-c0f43001b7d8',
                         's12GowerLegendreDistance' => '0.991847157',
                         'JaccardDistance' => '0.998430133',
                         'riDiscrepancy' => '1540.15955',
                         'spectrumName' => 'Eriodictyol (1MEOX) (4TMS) [A304006-ambient-na-1]',
                         'spectrumID' => 'a82ace65-8ceb-416d-9fb4-4ac70a62a6c5',
                         'EuclideanDistance' => '0.0532312766',
                         'ri' => '3040.15942',
                         'DotproductDistance' => '0.9024917',
                         'HammingDistance' => '636',
                         'analyteID' => 'f28cd3a1-6135-4d42-a8a5-017a75d65403'
                       },
                       {
                         'metaboliteID' => '294b1373-e8c3-442d-8240-d7ea2650b160',
                         's12GowerLegendreDistance' => '0.9872842',
                         'analyteName' => 'Guanosine (5TMS)',
                         'spectrumName' => 'Guanosine (5TMS) [A278001-ambient-na-3]',
                         'JaccardDistance' => '0.9962406',
                         'riDiscrepancy' => '1261.9718',
                         'spectrumID' => 'c64d062b-58a4-48ab-9e8b-392d4a409585',
                         'EuclideanDistance' => '0.0823757052',
                         'HammingDistance' => '265',
                         'analyteID' => '58207476-3182-4e36-874a-5e45eb653206',
                         'DotproductDistance' => '0.9025057',
                         'ri' => '2761.97168'
                       },
                       {
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.9747433',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'riDiscrepancy' => '938.797852',
                         'JaccardDistance' => '0.9861111',
                         'spectrumName' => 'NA [A245002-ambient-na-1]',
                         'EuclideanDistance' => '0.158333942',
                         'spectrumID' => '4177094f-ee4c-4482-b19b-28795e1eff70',
                         'ri' => '2438.79785',
                         'DotproductDistance' => '0.902506948',
                         'analyteID' => '2652d0e5-146e-45a5-8dcc-7605dbba40c0',
                         'HammingDistance' => '71'
                       },
                       {
                         'DotproductDistance' => '0.9025465',
                         'ri' => '2922.823',
                         'HammingDistance' => '652',
                         'analyteID' => 'bea6f212-55bf-48fd-adfc-05d9c72930eb',
                         'spectrumID' => '1ef84214-f23c-4a50-bb8d-fe9a28cdf615',
                         'EuclideanDistance' => '0.0525766835',
                         'riDiscrepancy' => '1422.823',
                         'JaccardDistance' => '0.9984686',
                         'spectrumName' => 'Morin (5TMS) [A292008-ambient-na-2]',
                         'analyteName' => 'Morin (5TMS)',
                         'metaboliteID' => '91a9d69e-fab0-45cd-90e5-deefbade86c1',
                         's12GowerLegendreDistance' => '0.991948843'
                       },
                       {
                         'spectrumName' => 'NA [A322001-ambient-na-1]',
                         'riDiscrepancy' => '1704.71606',
                         'JaccardDistance' => '0.991304338',
                         's12GowerLegendreDistance' => '0.980344355',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'analyteName' => 'NA',
                         'HammingDistance' => '114',
                         'analyteID' => 'aa3d8e0c-a528-4267-9d08-82731d7f12cd',
                         'ri' => '3204.716',
                         'DotproductDistance' => '0.9025511',
                         'EuclideanDistance' => '0.125285834',
                         'spectrumID' => '70ee3c53-9e3e-4cf9-b5a9-801900eee407'
                       },
                       {
                         'analyteName' => 'Epicatechin (5TMS)',
                         's12GowerLegendreDistance' => '0.9929363',
                         'metaboliteID' => '714e3a52-14f7-4c41-bf5d-1daa0c81fcc5',
                         'riDiscrepancy' => '1363.55359',
                         'JaccardDistance' => '0.998818',
                         'spectrumName' => 'Epicatechin (5TMS) [A286011-ambient-(-)--2]',
                         'EuclideanDistance' => '0.04619192',
                         'spectrumID' => '0985c504-81fe-4255-b477-e7ad7f658b68',
                         'DotproductDistance' => '0.902552366',
                         'ri' => '2863.55347',
                         'analyteID' => 'c3605fb5-b63f-4d6f-8906-d1f1d5418c8f',
                         'HammingDistance' => '845'
                       },
                       {
                         'spectrumName' => 'Glucose-6-phosphate (1MEOX) (6TMS) MP [A233002-ambient-na-6]',
                         'JaccardDistance' => '0.997435868',
                         'riDiscrepancy' => '807.337158',
                         'metaboliteID' => '962672d2-8750-46fd-9a76-e598aa2319da',
                         's12GowerLegendreDistance' => '0.9895422',
                         'analyteName' => 'Glucose-6-phosphate (1MEOX) (6TMS) MP',
                         'analyteID' => '249ea5fd-66e6-4293-838b-586365a336f4',
                         'HammingDistance' => '389',
                         'DotproductDistance' => '0.9025632',
                         'ri' => '2307.33716',
                         'spectrumID' => '8d5f864f-8549-42b4-879d-3101cda87250',
                         'EuclideanDistance' => '0.06803329'
                       },
                       {
                         'HammingDistance' => '155',
                         'analyteID' => '58207476-3182-4e36-874a-5e45eb653206',
                         'DotproductDistance' => '0.9025734',
                         'ri' => '2761.97168',
                         'spectrumID' => '732aec07-1bd8-4632-80c1-1e104bc9015d',
                         'EuclideanDistance' => '0.107570693',
                         'spectrumName' => 'Guanosine (5TMS) [A278001-ambient-na-2]',
                         'riDiscrepancy' => '1261.9718',
                         'JaccardDistance' => '0.993589759',
                         'metaboliteID' => '294b1373-e8c3-442d-8240-d7ea2650b160',
                         's12GowerLegendreDistance' => '0.9832483',
                         'analyteName' => 'Guanosine (5TMS)'
                       },
                       {
                         'JaccardDistance' => '0.9989035',
                         'riDiscrepancy' => '700',
                         'spectrumName' => 'Malic acid, 3-oxalo- (1MEOX) (4TMS) BP [A214019-ambient-na-1]',
                         'analyteName' => 'Malic acid, 3-oxalo- (1MEOX) (4TMS) BP',
                         'metaboliteID' => '2b316672-1b4e-4ba1-9347-b0d706846d8e',
                         's12GowerLegendreDistance' => '0.99319905',
                         'DotproductDistance' => '0.9025781',
                         'ri' => '2200',
                         'HammingDistance' => '911',
                         'analyteID' => 'a555842a-1d27-42e9-8930-1c9e3c8d79e6',
                         'spectrumID' => 'de07050f-84e9-4bce-b30d-d199abad8b01',
                         'EuclideanDistance' => '0.0444897525'
                       },
                       {
                         'metaboliteID' => '4c2844a4-cf88-44bf-9f5a-02c7b6024efc',
                         's12GowerLegendreDistance' => '0.990049',
                         'analyteName' => 'Calystegine B3 (1MEOX) (4TMS) MP',
                         'spectrumName' => 'Calystegine B3 (1MEOX) (4TMS) MP [A190008-ambient-na-3]',
                         'riDiscrepancy' => '311.291138',
                         'JaccardDistance' => '0.9976744',
                         'spectrumID' => 'b959c329-7037-486e-86be-e7ceeee8abaf',
                         'EuclideanDistance' => '0.06479256',
                         'HammingDistance' => '429',
                         'analyteID' => '8ac2d19a-a2d9-4120-8caa-76f48fe7cdbb',
                         'DotproductDistance' => '0.9025862',
                         'ri' => '1811.29114'
                       },
                       {
                         'spectrumName' => 'Quinic acid, 5-caffeoyl-, trans- (6TMS) [A319001-ambient-E--4]',
                         'riDiscrepancy' => '1677.08008',
                         'JaccardDistance' => '0.9946808',
                         'metaboliteID' => '656b3e48-4f1f-4fc8-a3b2-b0fadab84af5',
                         's12GowerLegendreDistance' => '0.9847951',
                         'analyteName' => 'Quinic acid, 5-caffeoyl-, trans- (6TMS)',
                         'HammingDistance' => '187',
                         'analyteID' => 'aa690cf2-1ec3-4e0a-99cf-dd24992eee9a',
                         'ri' => '3177.08',
                         'DotproductDistance' => '0.9025919',
                         'spectrumID' => 'b5e52986-bce5-4de6-bc80-6adfcc41c968',
                         'EuclideanDistance' => '0.0979900062'
                       },
                       {
                         'metaboliteID' => '2b316672-1b4e-4ba1-9347-b0d706846d8e',
                         's12GowerLegendreDistance' => '0.990911067',
                         'analyteName' => 'Malic acid, 3-oxalo- (1MEOX) (4TMS) MP',
                         'spectrumName' => 'Malic acid, 3-oxalo- (1MEOX) (4TMS) MP [A219010-ambient-na-2]',
                         'JaccardDistance' => '0.9980545',
                         'riDiscrepancy' => '690.4812',
                         'spectrumID' => '6e1acfb5-7c48-4cec-829a-e37c2efa2ea3',
                         'EuclideanDistance' => '0.0592624322',
                         'HammingDistance' => '513',
                         'analyteID' => 'fda144dd-1d94-40ea-88d6-ec4a0784ecc9',
                         'ri' => '2190.4812',
                         'DotproductDistance' => '0.9025932'
                       },
                       {
                         'spectrumName' => 'NA [A258003-13C-na-1]',
                         'riDiscrepancy' => '1072.58154',
                         'JaccardDistance' => '0.994012',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         's12GowerLegendreDistance' => '0.983831763',
                         'analyteName' => 'NA',
                         'HammingDistance' => '166',
                         'analyteID' => '385e6a31-92e7-429d-be97-ff906fd5e62d',
                         'DotproductDistance' => '0.902601957',
                         'ri' => '2572.58154',
                         'spectrumID' => '541916a8-7ecb-474e-83e1-032e7d1dbddf',
                         'EuclideanDistance' => '0.103969246'
                       },
                       {
                         'ri' => '2313.44141',
                         'DotproductDistance' => '0.902606964',
                         'analyteID' => 'aebaecd3-762d-43a1-b5fb-e19dc99655a5',
                         'HammingDistance' => '130',
                         'spectrumID' => '492e38c7-d1dc-4cc8-bb49-c4f39ec8ff57',
                         'EuclideanDistance' => '0.117389344',
                         'riDiscrepancy' => '813.4414',
                         'JaccardDistance' => '0.992366433',
                         'spectrumName' => 'Mannose-6-phosphate (1MEOX) (6TMS) BP [A233001-ambient-D--4]',
                         'analyteName' => 'Mannose-6-phosphate (1MEOX) (6TMS) BP',
                         'metaboliteID' => 'a074f4fa-f19b-4afa-af19-0e6f967a7e91',
                         's12GowerLegendreDistance' => '0.9816468'
                       },
                       {
                         'JaccardDistance' => '0.9949495',
                         'riDiscrepancy' => '1481.68042',
                         'spectrumName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS) [A299001-ambient-Z--1]',
                         'analyteName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS)',
                         'metaboliteID' => 'a88bcff0-2903-4b78-bbf5-5133683ec2c5',
                         's12GowerLegendreDistance' => '0.985197246',
                         'DotproductDistance' => '0.9026095',
                         'ri' => '2981.68042',
                         'HammingDistance' => '197',
                         'analyteID' => '5bb480fd-2d3a-4b4b-ad0f-7f689f761079',
                         'spectrumID' => 'cdc5000a-7742-40ab-97df-0a716a124d6b',
                         'EuclideanDistance' => '0.09548438'
                       },
                       {
                         'analyteID' => '5bb480fd-2d3a-4b4b-ad0f-7f689f761079',
                         'HammingDistance' => '395',
                         'DotproductDistance' => '0.90261066',
                         'ri' => '2981.68042',
                         'EuclideanDistance' => '0.0675177',
                         'spectrumID' => '3327438c-04d4-41d0-a4d3-e66ef46671a1',
                         'spectrumName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS) [A299001-ambient-Z--10]',
                         'riDiscrepancy' => '1481.68042',
                         'JaccardDistance' => '0.99747473',
                         's12GowerLegendreDistance' => '0.9896231',
                         'metaboliteID' => 'a88bcff0-2903-4b78-bbf5-5133683ec2c5',
                         'analyteName' => 'Quinic acid, 3-caffeoyl-, cis- (6TMS)'
                       },
                       {
                         'JaccardDistance' => '0.9852941',
                         'riDiscrepancy' => '951.2339',
                         'spectrumName' => 'NA [A246001-ambient-na-1]',
                         'analyteName' => 'NA',
                         's12GowerLegendreDistance' => '0.9739433',
                         'metaboliteID' => '00000000-0000-0000-0000-000000000000',
                         'DotproductDistance' => '0.9026178',
                         'ri' => '2451.234',
                         'analyteID' => '0ac466c8-0dca-4610-8648-afb15482dc86',
                         'HammingDistance' => '67',
                         'EuclideanDistance' => '0.162934288',
                         'spectrumID' => '8ec1230b-3a4c-4f76-ae33-8fa010149548'
                       },
                       {
                         'spectrumName' => 'Shikimic acid-3-phosphate (5TMS) [A221011-ambient-na-2]',
                         'riDiscrepancy' => '710.8571',
                         'JaccardDistance' => '0.997333348',
                         's12GowerLegendreDistance' => '0.9893312',
                         'metaboliteID' => 'fa4c6d38-4af2-4de9-9f8c-fd924dd675ce',
                         'analyteName' => 'Shikimic acid-3-phosphate (5TMS)',
                         'analyteID' => 'f97c6ac2-5509-4e52-878a-44b1c084e5d7',
                         'HammingDistance' => '374',
                         'ri' => '2210.85718',
                         'DotproductDistance' => '0.902617931',
                         'EuclideanDistance' => '0.06938272',
                         'spectrumID' => '77278d8c-ba82-44d3-b006-daada6fedd39'
                       },
                       {
                         'riDiscrepancy' => '1898.39893',
                         'JaccardDistance' => '0.9942857',
                         'spectrumName' => 'Quinic acid, 1-caffeoyl-, trans- (6TMS) [A340001-ambient-E--5]',
                         'analyteName' => 'Quinic acid, 1-caffeoyl-, trans- (6TMS)',
                         's12GowerLegendreDistance' => '0.9842199',
                         'metaboliteID' => '2848cbc5-0661-43ed-9eb3-3cdd3ab3bccd',
                         'DotproductDistance' => '0.902626932',
                         'ri' => '3398.399',
                         'analyteID' => '1b29cf38-19db-4ce6-820e-da8aefdf28b5',
                         'HammingDistance' => '174',
                         'EuclideanDistance' => '0.101566412',
                         'spectrumID' => '8781cb91-4c2c-41c4-bb23-adef6262706f'
                       }
                     ] ,
    "Method \'LibrarySearch\' returns a list of hits for a spectrum and parameters given in argument");
;

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;

##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $ri, $riWindow, $gcColumn, $spectrum
# Structure of res : @ret = [ %val1, %val2, ... %valN ]
print "\n** Test $current_test BUG LibrarySearch with a list of mzs, intensities and empty spectrum **\n" ; $current_test++;
is_deeply( LibrarySearchTest(1500,3000,'VAR5',''),
"The spectrum for query is empty, Golm soap will stop",
"Method \'LibrarySearch\' returns a list of hits for a spectrum and parameters given in argument");

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
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_mzs from a .msp file **\n" ; $current_test++;
is_deeply( get_mzsTest(
		#'/home/gabriel/Téléchargements/téléchargement_FILES/peakspectra.msp'
		'./peakspectra.msp'
	),
	[
		[73,147,157,160,205,217,272,319,320],
		[73,129,147,157,160,205,217,319,320]
	], 
"Method \'get_mzs\' return an array of arrays refs containing mzs of all the spectra from a msp file");

print "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n" ;



##		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ARGS : $msp_file
# Structure of res: [ $arr_ref1 , $arr_ref2 ... $arr_refN ]
print "\n** Test $current_test get_intensities from a .msp file **\n" ; $current_test++;
is_deeply(get_intensitiesTest(#'/home/gabriel/Téléchargements/téléchargement_FILES/peakspectra.msp'
								'./peakspectra.msp'																	),
	[
			[
              '5764652',
              '5244020',
              '3561241',
              '3454586',
              '4437872',
              '3601276',
              '30900.41',
              '5352581',
              '3587208'
            ],
            [
              '5551756',
              '3361335',
              '5231997',
              '3641748',
              '3947240',
              '4374348',
              '3683153',
              '5377373',
              '3621938'
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














