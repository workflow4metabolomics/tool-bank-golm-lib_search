package lib::output ;

use strict;
use warnings ;
use Exporter ;
use Carp ;
use Excel::Writer::XLSX ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw(build_json_res_object html_output excel_output);
our %EXPORT_TAGS = ( ALL => [qw(build_json_res_object html_output excel_output)] );

=head1 NAME
My::Module - An example module

=head1 SYNOPSIS

    use My::Module;
    my $object = My::Module->new();
    print $object->as_string;

=head1 DESCRIPTION

This module does not really exist, it
was made for the sole purpose of
demonstrating how POD works.

=head1 METHODS

Methods are :

=head2 METHOD new

	## Description : new
	## Input : $self
	## Ouput : bless $self ;
	## Usage : new() ;

=cut

sub new {
    ## Variables
    my $self={};
    bless($self) ;
    return $self ;
}
### END of SUB



=head2 METHOD build_json_res_object

	## Description : build json from array of hits
	## Input : $results
	## Output : \@json_results 
	## Usage : my ( \@json_results ) = build_json_res_object( $results ) ;
	## JSON structure: [
#							{
#								'id' : 'Unknown 1',
#								'nb_hits' : int, 
#								'searchResults'	:	[
#														{
#															'metaboliteID' : GUID
#															'distance_scores' : {
#																					'EuclideanDistance' : float
#																					'DotproductDistance' : int
#																					'HammingDistance' : int
#																					'JaccardDistance' : int
#																					's12GowerLegendreDistance' : int
#																				}
#															'ri_infos' : {
#																			'ri' : float
#																			'riDiscrepancy' : float
#																		 }
#															'analyte' : {
#																			'id' : GUID
#																			'name' : string
#																		 }
#															'spectrum' : {
#																			'id' : GUID
#																			'name' : string
#																		 }
#														},
#														.
#														.
#														.
#													]
#							}
#							.
#							.
#							.
#						]
=cut
## START of SUB
sub build_json_res_object {
	## Retrieve Values
    my $self = shift ;
    my ( $results ) = @_ ;
  	
	my @json_results ;
	my @array_results = @$results ;
	
	my $nb_hits = 0 ;
	my $i = 0 ;
	my $spectrumID = 1 ;
	
	## Loop on each spectra
	foreach my $res (@array_results) {
		
		$nb_hits = scalar @$res;
		
		if ($nb_hits != 0) {
			$json_results[$i]{'id'} = $spectrumID++ ;
			$json_results[$i]{'nb_hits'} = $nb_hits ;
			
			## Loop on each hit of a spectrum + build json
			foreach my $href (@$res) {
				
				my %hash_res = %$href ;
				my %hit_infos = () ;
				# Get rid of false results
				if ($hash_res{'metaboliteID'} eq '00000000-0000-0000-0000-000000000000') {
					--$json_results[$i]{'nb_hits'} ;
					next ;
				}
				else {
					$hit_infos{'metaboliteID'} = $hash_res{'metaboliteID'} ;
					$hit_infos{'distance_scores'}{'EuclideanDistance'} = $hash_res{'EuclideanDistance'} ;
					$hit_infos{'distance_scores'}{'DotproductDistance'} = $hash_res{'DotproductDistance'} ;
					$hit_infos{'distance_scores'}{'HammingDistance'} = $hash_res{'HammingDistance'} ;
					$hit_infos{'distance_scores'}{'JaccardDistance'} = $hash_res{'JaccardDistance'} ;
					$hit_infos{'distance_scores'}{'s12GowerLegendreDistance'} = $hash_res{'s12GowerLegendreDistance'} ;
					$hit_infos{'ri_infos'}{'ri'} = $hash_res{'ri'} ;
					$hit_infos{'ri_infos'}{'riDiscrepancy'} = $hash_res{'riDiscrepancy'} ;
					$hit_infos{'analyte'}{'id'} = $hash_res{'analyteID'} ;
					$hit_infos{'analyte'}{'name'} = $hash_res{'analyteName'} ;
					$hit_infos{'spectrum'}{'id'} = $hash_res{'spectrumID'} ;
					$hit_infos{'spectrum'}{'name'} = $hash_res{'spectrumName'} ;
					
					push ( @{ $json_results[$i]{'searchResults'} } , \%hit_infos );
				}
			}
			$i++ ;
		}
	}
    return \@json_results ;
}
## END of SUB


=head2 METHOD html_output

	## Description : generate html file to visualize results
	## Input : 
	## Output : 
	## Usage : my (  ) = html_output(  ) ;
=cut
## START of SUB
sub html_output {
	## Retrieve Values
    my $self = shift ;
    my ( $results ) = @_ ;
    
    my $htmlFile = "html_output.html" ;
    
    open (HTML , ">", $htmlFile) or die ("Error at opening file $htmlFile") ;
    
	print HTML "<!DOCTYPE html>
<html>
<head>
	<meta charset='UTF-8'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/1.10.11/css/jquery.dataTables.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/buttons/1.1.2/css/buttons.dataTables.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/r/dt/jq-2.1.4,jszip-2.5.0,pdfmake-0.1.18,dt-1.10.9,af-2.0.0,b-1.0.3,b-colvis-1.0.3,b-html5-1.0.3,b-print-1.0.3,se-1.0.1/datatables.min.css'/>
	<link rel='stylesheet' href='https://code.getmdl.io/1.1.3/material.light_green-orange.min.css' /> 
	<link rel='stylesheet' href='https://fonts.googleapis.com/icon?family=Material+Icons'>
	<style type='text/css' class='init'>
		.card-wide.mdl-card {
		  width: 900px;
		  height: 550px;
		}
		.card-wide > .mdl-card__menu {
		  color: #fff;
		}
	
		.list-icon {
		  width: 800px;
		}
		/*Force css to prevent a shift of the table when sorting*/
		#table_id_wrapper { 
			overflow-x: auto;
		    margin-left: 100px;
		    margin-right: 100px;
		}
				
		.toolbar {
		    float: left;
		}
		
		.dt-buttons {
			padding-right: 10px ;	
			margin-bottom: 20px;
		}
		
		table.dataTable thead th, table.dataTable thead td {
		    border-bottom: 1px solid #A7A7A7;
		}
		
		div.dt-button-collection {
		    width: 140px;
		    margin-top: 7px;
		    padding: 6px 6px 3px 6px;
		    border: 1px solid rgba(0,0,0,0.4);
		    background-color: rgba(171, 171, 171, 0.8);
		    border-radius: 10px;
		    box-shadow: 0px 0px 100px rgba(255, 255, 255, 0.3);
		}
		
		div.dt-button-collection a.dt-button.active:not(.disabled) {
		    box-shadow: inset 1px 1px 6px rgba(102, 102, 102, 0.69);
		}
		
		.buttons-copy, .buttons-print, .buttons-collection {
			height: 40px;
		    margin-right: 10px;
		    padding-right: 0px;
		    padding-left: 0px;
		    margin-left: 10px;
		}
		
		.mdl-button--accent.mdl-button--accent.mdl-button--raised, .mdl-button--accent.mdl-button--accent.mdl-button--fab {
		    background-color: #E3E3E3;
		}
		
		.mdl-shadow--3dp {
		    box-shadow: 0 25px 150px rgba(0,0,0,.14),0 3px 3px -2px rgba(0,0,0,.2),0 1px 8px 0 rgba(0,0,0,.12);
		}
		
		.dataTables_wrapper .dataTables_length {
		    float: left;
		    padding-top: 11px;
		    padding-left: 30px;
		}
		
		.dataTables_wrapper {
			text-align: center;
		}
		
		table.display tbody tr:hover td {
		    background-color: #B9DBD5 !important;
		}
		
		.selected {
		    background-color: #96ADA6 !important ;
		 }
		 
		.buttons-colvis {
		 	padding-left: 15px; 
		 	padding-right: 15px;	
		}		
		
	</style>
	
	
	<script type='text/javascript' language='javascript' src='https://code.jquery.com/jquery-1.12.0.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/select/1.1.2/js/dataTables.select.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/buttons/1.1.2/js/dataTables.buttons.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/buttons/1.1.2/js/buttons.html5.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/buttons/1.1.2/js/buttons.print.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/1.10.11/js/jquery.dataTables.min.js'></script>
	<script type='text/javascript' src='https://cdn.datatables.net/r/dt/jq-2.1.4,jszip-2.5.0,pdfmake-0.1.18,dt-1.10.9,af-2.0.0,b-1.0.3,b-colvis-1.0.3,b-html5-1.0.3,b-print-1.0.3,se-1.0.1/datatables.min.js'></script>
	<script defer src='https://code.getmdl.io/1.1.3/material.min.js'></script>
	<script type='text/javascript' class='init'>
		\$(document).ready( function () {
		    var table = \$('#table_id').DataTable( {
		    	order: [[ 5, 'asc' ],[ 6, 'asc' ],[ 7, 'asc' ],[ 8, 'asc' ],[ 9, 'asc' ]],
		    	'orderClasses': false,
		    	'dom': 'B<\"toolbar\">frtilp',
		        buttons: [
		            {
		                extend:    'copyHtml5',
		                text:      '<i class=\"material-icons\" style=\"height:20px\">content_copy</i>',
		                titleAttr: 'Copy'
		            },
		            {
		                extend: 'print',
		                text:      '<i class=\"material-icons\" style=\"height:20px ; padding:\">print</i>',
		                titleAttr: 'Print',
		                exportOptions: {
		                    columns: ':visible'
		                }
		            },
		            {
		                extend: 'collection',
		                text:		'<i class=\"material-icons\" style=\"height:20px\">file_download</i>',
		                titleAttr: 'Export',
		                buttons: [
		                    'excelHtml5',
		            		'csvHtml5'
		                ]
		            },
		            {
		            	text: 'SHOW MORE',
		                extend: 'colvis',
		                postfixButtons: [ 'colvisRestore' ]
		            }
		        ],
		        'columnDefs': [
		            {
		                'targets': [ 10 ],
		                'visible': false,
		            },
		            {
		                'targets': [ 11 ],
		                'visible': false
		            }
		        ],
		        'scrollY': '50vh',
		    	'responsive': true,
		    	'paginationType': 'full_numbers',
        		'scrollCollapse': true,
        		'lengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, 'All']],

        		
		     	initComplete: function () {
		             this.api().columns().every( function () {
		                 var column = this;
		                 var select = \$('<select><option value=\"\"></option></select>')
		                     .appendTo( \$(column.footer()).empty() )
		                     .on( 'change', function () {
		                         var val = \$.fn.dataTable.util.escapeRegex(
		                             \$(this).val()
		                         );
		 
		                         column
		                             .search( val ? '^'+val+'\$' : '', true, false )
		                             .draw();
		                     } );
 
	                 column.data().unique().sort().each( function ( d, j ) {
	                    select.append( '<option value=\"'+d+'\">'+d+'</option>' )
	                 } );
             		} );
		         }


		    } );
		    
		    \$('div.toolbar').html(\"<button class='mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent' id='delete'>Delete selected rows</button>\");
		    
			\$('#table_id tbody').on( 'click', 'tr', function () {
		        \$(this).toggleClass('selected');
		    } );
		     
		    /* Add a click handler for the delete button */
		    \$('#delete').click( function() {
		        table.rows( '.selected' ).remove().draw();
		    } );
		    
		    \$('.buttons-copy, .buttons-print, .buttons-collection, .buttons-colvis, .buttons-columnVisibility').each(function() {
			   \$(this).removeClass('dt-button').addClass('mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent')
			})
		});

	</script>

<title>Golm Search Results</title>

</head>

<body>


<div class='mdl-layout mdl-js-layout mdl-layout--fixed-header'>
  <header class='mdl-layout__header'>
    <div class='mdl-layout__header-row'>
      <!-- Title -->
      <span class='mdl-layout-title'><h3><b>Visualization of Golm Database Results</b></h3></span>
    </div>
      <!-- Tabs -->
    <div class='mdl-layout__tab-bar mdl-js-ripple-effect'>
      <a href='#fixed-tab-1' class='mdl-layout__tab is-active'><b>Table</b></a>
      <a href='#fixed-tab-2' class='mdl-layout__tab'><b>Help</b></a>
    </div>
  </header>
  <main class='mdl-layout__content'>
  	<section class='mdl-layout__tab-panel is-active' id='fixed-tab-1'>
		      <div class='page-content'>
		      		</br></br></br></br>
					<table id='table_id' class='display stripe' cellspacing='0' width='100%' >
						<thead>
							<tr>
					            <th colspan='1'></th>
					            <th colspan='2' style='text-align:center'>NAMES</th>
					            <th colspan='2' style='text-align:center'>RETENTION INFOS</th>
					            <th colspan='5' style='text-align:center'>DISTANCE SCORES</th>
					            <th colspan='2' style='text-align:center'>IDs</th>
					        </tr>
							<tr>
								<th style='text-align:center;border-left: 1px solid #A7A7A7;'>N° Spectres</th>
								<th style='text-align:center;border-left: 1px solid #A7A7A7;'>Analyte Name</th>
								<th style='text-align:center;border-right: 1px solid #A7A7A7;'>Spectrum Name</th>
								<th style='text-align:center'>Retention Index</th>
								<th style='text-align:center;border-right: 1px solid #A7A7A7;'>RI Discrepancy</th>
								<th style='text-align:center'>Dot product</th>
								<th style='text-align:center'>Euclidean</th>
								<th style='text-align:center'>Jaccard</th>
								<th style='text-align:center'>Hamming</th>
								<th style='text-align:center;border-right: 1px solid #A7A7A7;'>s12 Gower-Legendre</th>
								<th style='text-align:center'>Spectrum</th>
								<th style='text-align:center;border-right: 1px solid #A7A7A7;'>Metabolite</th>
							</tr>
						</thead>
						<tfoot>
							<tr>
								<th style='text-align:center'>N° Spectre</th>
								<th style='text-align:center'>Analyte Name</th>
								<th style='text-align:center'>Spectrum Name</th>
								<th style='text-align:center'>Retention Index</th>
								<th style='text-align:center'>RI Discrepancy</th>
								<th style='text-align:center'>Dot product</th>
								<th style='text-align:center'>Euclidean</th>
								<th style='text-align:center'>Jaccard</th>
								<th style='text-align:center'>Hamming</th>
								<th style='text-align:center'>s12 Gower-Legendre</th>
								<th style='text-align:center'>Spectrum</th>
								<th style='text-align:center'>Metabolite</th>
							</tr>
						</tfoot>
						<tbody>";
						
						foreach my $href_grp (@$results) {
							
								foreach my $hit ( @{$href_grp->{'searchResults'}} ){
										
										print HTML "<tr><td>".$href_grp->{id}."</td>" ;
										print HTML "<td>".$hit->{analyte}{name}."</td>" ;
										print HTML "<td>".$hit->{spectrum}{name}."</td>" ;
										print HTML "<td>".$hit->{ri_infos}{ri}."</td>" ;
										print HTML "<td>".$hit->{ri_infos}{riDiscrepancy}."</td>" ;
										print HTML "<td>".$hit->{distance_scores}{DotproductDistance}."</td>" ;
										print HTML "<td>".$hit->{distance_scores}{EuclideanDistance}."</td>" ;
										print HTML "<td>".$hit->{distance_scores}{JaccardDistance}."</td>" ;
										print HTML "<td>".$hit->{distance_scores}{HammingDistance}."</td>" ;
										print HTML "<td>".$hit->{distance_scores}{s12GowerLegendreDistance}."</td>" ;
										print HTML "<td>".$hit->{spectrum}{id}."</td>" ;
										print HTML "<td>".$hit->{metaboliteID}."</td></tr>" ;
								}	
						}
						print HTML "
						</tbody>
					</table>
			</div>
		</section>
		<section class='mdl-layout__tab-panel' id='fixed-tab-2'>
			<div class='page-content'>
				<br/><br/><br/>
				<div class='mdl-grid'>
					<div class='mdl-cell mdl-cell--1-col'></div>
					    <div class='card-wide mdl-card mdl-cell mdl-cell--4-col mdl-shadow--3dp'>
					    	<figure class='mdl-card__media' style='background-color: white'>
					    		<img src='http://m.hiapphere.com/data/icon/201506/HiAppHere_com_com.javiersantos.materialid.png' style='height: 60px; width: 60px;'>
					    	</figure>
					    	<div class='mdl-card__title'>
							    <h1 class='mdl-card__title-text'>What can the table do ?</h1>
							</div>
							<div class='mdl-card__supporting-text'>
				      		<ul class='list-icon mdl-list'>
									  <li class='mdl-list__item'>
									    <span class='mdl-list__item-primary-content'>
										    <i class='material-icons mdl-list__item-icon'>filter_list</i>
										    By default, the 5 distance scores are ordered by ascending values.
										    You can manage your data ordering as you wish. You can even order data according to multiple columns:
										    	SHIFT + LEFT CLICK on column headers.
										    You can sort data specifically by clicking on any entry in boxes under each columns.
										</span>
									  </li>
									  <li class='mdl-list__item'>
									    <span class='mdl-list__item-primary-content'>
										    <i class='material-icons mdl-list__item-icon'>delete_sweep</i>
										    You can delete multiple lines selected:
										    Select lines and click on the button DELETE SELECTED ROWS.
									  	</span>
									  </li>
									  <li class='mdl-list__item'>
									    <span class='mdl-list__item-primary-content'>
										    <i class='material-icons mdl-list__item-icon'>remove_red_eye</i>
										    You have the possibility to toggle columns by clicking on SHOW MORE.
									  </span>
									  </li>
									  <li class='mdl-list__item'>
									    <span class='mdl-list__item-primary-content'>
										    <i class='material-icons mdl-list__item-icon'>get_app</i>
										    You can print, copy, or export to excel and csv the table with the buttons above the table.
									  </span>
									  </li>
							</ul>
						</div>
					</div>
				</div>
			</div>
	    </section>
	
  </main>
  
</div>

</body>


</html>" ;
    
    
    
}
## END of SUB


=head2 METHOD excel_output

	## Description : create an excel output of the results
	## Input : $jsons, $excel_file
	## Output :  $xls_output
	## Usage : my ( $xls_output ) = excel_output( $jsons, $excel_file ) ;
=cut
## START of SUB
sub excel_output {
	## Retrieve Values
    my $self = shift ;
    my ( $excel_file, $jsons ) = @_ ;
    
    open (FILE, '>', $excel_file) or die "Failed to open filehandle: $!" ;
    
    # Create a new workbook and add a worksheet
    my $workbook  = Excel::Writer::XLSX->new( \*FILE ) ;
    my $worksheet = $workbook->add_worksheet() ;
    
    my $i = 0 ;
    
    # Create a format for the headings
    my $format = $workbook->add_format() ;
    $format->set_bold() ;
    
    $worksheet->write( $i, 0, "Num Spectre" , $format);
	$worksheet->write( $i, 1, "Analyte Name" , $format);
	$worksheet->write( $i, 2, "Spectrum Name" , $format);
	$worksheet->write( $i, 3, "Retention Index" , $format);
	$worksheet->write( $i, 4, "RI Discrepancy" , $format);
	$worksheet->write( $i, 5, "DotproductDistance" , $format);
	$worksheet->write( $i, 6, "EuclideanDistance" , $format);
	$worksheet->write( $i, 7, "JaccardDistance" , $format);
	$worksheet->write( $i, 8, "HammingDistance" , $format);
	$worksheet->write( $i, 9, "s12GowerLegendreDistance" , $format);
	$worksheet->write( $i, 10, "Spectrum ID" , $format);
	$worksheet->write( $i, 11, "Metabolite ID" , $format);
   
    $i++;
    
   foreach my $href_grp (@$jsons) {
		
			foreach my $hit ( @{$href_grp->{'searchResults'}} ){
				
					$worksheet->write( $i, 0, $href_grp->{id} );
			   		$worksheet->write( $i, 1, $hit->{analyte}{name} );
			   		$worksheet->write( $i, 2, $hit->{spectrum}{name} );
			   		$worksheet->write( $i, 3, $hit->{ri_infos}{ri} );
			   		$worksheet->write( $i, 4, $hit->{ri_infos}{riDiscrepancy} );
			   		$worksheet->write( $i, 5, $hit->{distance_scores}{DotproductDistance} );
			   		$worksheet->write( $i, 6, $hit->{distance_scores}{EuclideanDistance} );
			   		$worksheet->write( $i, 7, $hit->{distance_scores}{JaccardDistance} );
			   		$worksheet->write( $i, 8, $hit->{distance_scores}{HammingDistance} );
			   		$worksheet->write( $i, 9, $hit->{distance_scores}{s12GowerLegendreDistance} );
			   		$worksheet->write( $i, 10, $hit->{spectrum}{id} );
			   		$worksheet->write( $i, 11, $hit->{metaboliteID} );
			   		
			   		$i++;
			}	
	}

   $workbook->close();
   
   binmode STDOUT ;
}
## END of SUB






1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc csv.pm

=head1 Exports

=over 4

=item :ALL is get_spectra

=back

=head1 AUTHOR

Gabriel Cretin E<lt>gabriel.cretin@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : ??

=cut