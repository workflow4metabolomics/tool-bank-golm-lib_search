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
	<style type='text/css' class='init'>
		.row_selected{
			background-color: #b2b2b2 !important;
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
		    	'orderClasses': false,
		    	'dom': 'Bfrtip',
		        buttons: [
		            'copyHtml5',
		            'excelHtml5',
		            'csvHtml5',
		            'print'
		        ],
		        'scrollY': '50vh',
		    	'responsive': true,
		    	'paging': false,
        		'scrollCollapse': true
		    	// Problem quand on clique sur colonne pour trier: le tableau se décale à droite + plus de scroll bar X

		  //   	initComplete: function () {
		  //           this.api().columns().every( function () {
		  //               var column = this;
		  //               var select = \$('<select><option value=\"\"></option></select>')
		  //                   .appendTo( \$(column.footer()).empty() )
		  //                   .on( 'change', function () {
		  //                       var val = \$.fn.dataTable.util.escapeRegex(
		  //                           \$(this).val()
		  //                       );
		 
		  //                       column
		  //                           .search( val ? '^'+val+'\$' : '', true, false )
		  //                           .draw();
		  //                   } );
 
    //             column.data().unique().sort().each( function ( d, j ) {
     //               select.append( '<option value=\"'+d+'\">'+d+'</option>' )
     //           } );
		  //           } );
		  //       }
		    } );


		    \$('a.toggle-vis').on( 'click', function (e) {
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


	</script>

<title>Golm Search Results</title>

</head>

<body>


<div class='mdl-layout mdl-js-layout mdl-layout--fixed-header'>
  <header class='mdl-layout__header'>
    <div class='mdl-layout__header-row'>
      <!-- Title -->
      <span class='mdl-layout-title'><h3><b>Visualisation of Golm Database Results</b></h3></span>
      <!-- Add spacer, to align navigation to the right -->
      <div class='mdl-layout-spacer'></div>
    </div>
  </header>
  
  <main class='mdl-layout__content'>
    <div class='page-content'>


</br></br></br>

<div style='text-align: center'>
	<b>Click to hide/show a column:</b> <a class='toggle-vis' data-column='0'><b>N°</b></a> - <a class='toggle-vis' data-column='1'><b>Analyte Name</b></a> - <a class='toggle-vis' data-column=
	'2'><b>Spectrum Name</b></a> - <a class='toggle-vis' data-column='3'><b>Retention Index</b></a> - <a class='toggle-vis' data-column='4'><b>RI Discrepancy</b></a> - <a class='toggle-vis' data-column=
	'5'><b>Dot product</b></a> - <a class='toggle-vis' data-column='6'><b>Euclidean</b></a> - <a class='toggle-vis' data-column='7'><b>Jaccard</b></a>
	 - <a class='toggle-vis' data-column='8'><b>Hamming</b></a> - <a class='toggle-vis' data-column='9'><b>s12 Gower-Legendre</b></a> - <a class='toggle-vis' data-column='10'><b>SpectrumID</b></a>
	  - <a class='toggle-vis' data-column='11'><b>MetaboliteID</b></a>
</div>
</br></br>
<center>
	<button class='mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent' id='delete'>Delete selected rows</button>
<center>
<!-- <table id='table_id' class='mdl-data-table mdl-js-data-table mdl-shadow--2dp' cellpadding='0' cellspacing='0' border='0' width='100%' > -->
<table id='table_id' class='display stripe nowrap' cellspacing='0' width='100%' >
	<thead>
		<tr>
            <th rowspan='2' style='text-align:center'>N°</th>
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
			<th style='text-align:center'>N°</th>
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