package lib::output ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw(build_json_res_object html_output);
our %EXPORT_TAGS = ( ALL => [qw(build_json_res_object html_output)] );

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
#								.
#								.
#								.
#							}
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
	<!-- <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/material-design-lite/1.1.0/material.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/1.10.11/css/dataTables.material.min.css'> -->
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/1.10.11/css/jquery.dataTables.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/select/1.1.2/css/select.dataTables.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/buttons/1.1.2/css/buttons.dataTables.min.css'>
	<link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/r/dt/jq-2.1.4,jszip-2.5.0,pdfmake-0.1.18,dt-1.10.9,af-2.0.0,b-1.0.3,b-colvis-1.0.3,b-html5-1.0.3,b-print-1.0.3,se-1.0.1/datatables.min.css'/>
	<link rel='stylesheet' href='https://code.getmdl.io/1.1.3/material.light_green-orange.min.css' /> 
	<link rel='stylesheet' href='https://fonts.googleapis.com/icon?family=Material+Icons'>
	<style type='text/css' class='init'>
		.row_selected{
			background-color: #b2b2b2 !important;
		}
		
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
		#table_id_wrapper { overflow-x: auto; }
	</style>
	<style type='text/css' class='init'>
		.mdl-dialog {
		    border: none;
		    box-shadow: 0 9px 46px 8px rgba(0,0,0,.14),0 11px 15px -7px rgba(0,0,0,.12),0 24px 38px 3px rgba(0,0,0,.2);
		    width: 45%;
		}
		.mdl-button {
			height: 40px;
		}
	</style>
	
	
    <!-- <script type='text/javascript' language='javascript' src='https://cdn.datatables.net/1.10.11/js/dataTables.material.min.js'></script> -->
	<script type='text/javascript' language='javascript' src='https://code.jquery.com/jquery-1.12.0.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/select/1.1.2/js/dataTables.select.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/buttons/1.1.2/js/dataTables.buttons.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/buttons/1.1.2/js/dataTables.buttons.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/buttons/1.1.2/js/buttons.html5.min.js'></script>
	<script type='text/javascript' language='javascript' src='https://cdn.datatables.net/1.10.11/js/jquery.dataTables.min.js'></script>
	<script type='text/javascript' src='https://cdn.datatables.net/r/dt/jq-2.1.4,jszip-2.5.0,pdfmake-0.1.18,dt-1.10.9,af-2.0.0,b-1.0.3,b-colvis-1.0.3,b-html5-1.0.3,b-print-1.0.3,se-1.0.1/datatables.min.js'></script>
	<script defer src='https://code.getmdl.io/1.1.3/material.min.js'></script>
	<script type='text/javascript' class='init'>
		\$(document).ready( function () {
		    var table = \$('#table_id').DataTable( {
		    	order: [[ 4, 'asc' ],[ 5, 'asc' ],[ 6, 'asc' ],[ 7, 'asc' ],[ 8, 'asc' ]],
		    	'orderClasses': false,
		    	'dom': 'Bfrltip',
		        buttons: [
		        	{
		                extend: 'colvisGroup',
		                text: 'Show all',
		                show: ':hidden'
		            },
		            {
		                extend: 'colvis',
		            },
		            'copyHtml5',
		            'excelHtml5',
		            'csvHtml5',
		            'print'
		        ],
		        'scrollY': '50vh',
		    	'responsive': true,
		    	'paging': true,
        		'scrollCollapse': true,
        		'lengthMenu': [[10, 25, 50, -1], [10, 25, 50, 'All']],

        		
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


		    \$('button.toggle-vis').on( 'click', function (e) {
		        e.preventDefault();
		 
		        // Get the column API object
		        var column = table.column( \$(this).attr('data-column') );
		 
		        // Toggle the visibility
		        column.visible( ! column.visible() );
			} );
			
			
			/* Add a click handler to the rows - this could be used as a callback */
		    \$('#table_id tbody tr').click( function( e ) {
		        if ( \$(this).hasClass('row_selected') ) {
		            \$(this).removeClass('row_selected');
		        }
		        else {
		            table.\$('tr.row_selected')
		            \$(this).addClass('row_selected');
		        }
		    });

		     
		    /* Add a click handler for the delete row */
		    \$('#delete').click( function() {
		        var anSelected = fnGetSelected( table );
		        \$(anSelected).remove().draw();
		    } );
		 
		 
		/* Get the rows which are currently selected */
		function fnGetSelected( oTableLocal )
		{
		    return oTableLocal.\$('tr.row_selected');
		}
		});

	</script>

<title>Golm Search Results</title>

</head>

<body>


<div class='mdl-layout mdl-js-layout mdl-layout--fixed-header'>
  <header class='mdl-layout__header'>
    <div class='mdl-layout__header-row'>
      <!-- Title -->
      <span class='mdl-layout-title'><h2><b>Visualisation of Golm Database Results</b></h2></span>
      <!-- Add spacer, to align navigation to the right -->
      <div class='mdl-layout-spacer'></div>
      <!-- Navigation -->
      <nav class='mdl-navigation'>
        <button id='show-dialog' type='button' class='mdl-button'><img src='http://m.hiapphere.com/data/icon/201506/HiAppHere_com_com.javiersantos.materialid.png' style='height: 40px; width: 40px;'></button>
		  <dialog class='mdl-dialog'>
		    <h4 class='mdl-dialog__title'>What can the table do ?</h4>
		    <div class='mdl-dialog__content'>
		      <ul class='list-icon mdl-list'>
					  <li class='mdl-list__item'>
					    <span class='mdl-list__item-primary-content'>
						    <i class='material-icons mdl-list__item-icon'>filter_list</i>
						    By default, the 5 distance scores are ordered by ascending values.
						    You can change ordering as you wish. You can even order data according to multiple columns:
						    	SHIFT + LEFT CLICK on column headers.
						</span>
					  </li>
					  <li class='mdl-list__item'>
					    <span class='mdl-list__item-primary-content'>
						    <i class='material-icons mdl-list__item-icon'>delete_sweep</i>
						    You can delete multiple lines selected:
						    Select lines and click on the button Delete selected rows.
					  	</span>
					  </li>
					  <li class='mdl-list__item'>
					    <span class='mdl-list__item-primary-content'>
						    <i class='material-icons mdl-list__item-icon'>remove_red_eye</i>
						    You have the possibility to toggle columns by clicking on the buttons above the table.
					  </span>
					  </li>
					  <li class='mdl-list__item'>
					    <span class='mdl-list__item-primary-content'>
						    <i class='material-icons mdl-list__item-icon'>get_app</i>
						    You can export the table in different formats: CSV & EXCEL, or print and copy it.
					  </span>
					  </li>
				</ul>
		    </div>
		    <div class='mdl-dialog__actions'>
		      <button type='button' class='mdl-button close'>Thanks!</button>
		    </div>
		  </dialog>
		  <script>
		    var dialog = document.querySelector('dialog');
		    var showDialogButton = document.querySelector('#show-dialog');
		    if (! dialog.showModal) {
		      dialogPolyfill.registerDialog(dialog);
		    }
		    showDialogButton.addEventListener('click', function() {
		      dialog.showModal();
		    });
		    dialog.querySelector('.close').addEventListener('click', function() {
		      dialog.close();
		    });
		  </script>
      </nav>
    </div>
  </header>
  <br/>
  <main class='mdl-layout__content'>

</br></br>
<center>
	<button class='mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent' id='delete'>Delete selected rows</button>
<center>
</br>
<!-- <table id='table_id' class='mdl-data-table mdl-js-data-table mdl-shadow--2dp' cellpadding='0' cellspacing='0' border='0' width='100%' > -->
<table id='table_id' class='display stripe nowrap' cellspacing='0' width='100%' >
	<thead>
		<tr>
            <th rowspan='2' style='text-align:center'>N° Spectre</th>
            <th colspan='2' style='text-align:center'>Names</th>
            <th colspan='2' style='text-align:center'>Retention Infos</th>
            <th colspan='5' style='text-align:center'>Distance Scores</th>
            <th colspan='2' style='text-align:center'>IDs</th>
        </tr>
		<tr>
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
  </main>
</div>
</body>


</html>" ;
    
    
    
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