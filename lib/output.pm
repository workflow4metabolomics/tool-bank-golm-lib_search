package lib::output ;

use strict;
use warnings ;
use Exporter ;
use Carp ;
use HTML::Template ;
use JSON ;

use FindBin ;
use lib $FindBin::Bin ;
my $binPath = $FindBin::Bin ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw(build_json_res_object excel_output write_html_body add_entries_to_tbody_object write_json_skel write_ajax_data_source excel_like_output);
our %EXPORT_TAGS = ( ALL => [qw(build_json_res_object excel_output write_html_body add_entries_to_tbody_object write_json_skel write_ajax_data_source excel_like_output)] );

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
#								'id' : 'int',
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
		
		if (@$res[0] eq 'no results'){
		
			my %hit_infos = () ;
			
			$json_results[$i]{'id'} = $spectrumID++ ;
			$json_results[$i]{'nb_hits'} = $nb_hits ;
			$hit_infos{'metaboliteID'} = "" ;
			$hit_infos{'distance_scores'}{'EuclideanDistance'} = "" ;
			$hit_infos{'distance_scores'}{'DotproductDistance'} = "" ;
			$hit_infos{'distance_scores'}{'HammingDistance'} = "" ;
			$hit_infos{'distance_scores'}{'JaccardDistance'} = "" ;
			$hit_infos{'distance_scores'}{'s12GowerLegendreDistance'} = "" ;
			$hit_infos{'ri_infos'}{'ri'} = "" ;
			$hit_infos{'ri_infos'}{'riDiscrepancy'} = "" ;
			$hit_infos{'analyte'}{'id'} = "" ;
			$hit_infos{'analyte'}{'name'} = "" ;
			$hit_infos{'spectrum'}{'id'} = "" ;
			$hit_infos{'spectrum'}{'name'} = "no results" ;
			
			push ( @{ $json_results[$i]{'searchResults'} } , \%hit_infos );
		}
		else {
			
			$nb_hits = scalar @$res;
			
			$json_results[$i]{'id'} = $spectrumID++ ;
			$json_results[$i]{'nb_hits'} = $nb_hits ;
			
			## Loop on each hit of a spectrum + build json
			foreach my $href (@$res) {
				
				if (!defined $href){
					
					last ;
				}
				else {
					my %hash_res = %$href ;
					my %hit_infos = () ;
					# Get rid of false results
					if ($hash_res{'metaboliteID'} eq '00000000-0000-0000-0000-000000000000') {
						--$json_results[$i]{'nb_hits'} ;
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
			}
		}
		$i++ ;
	}
    return \@json_results ;
}
## END of SUB



=head2 METHOD add_entries_to_tbody_object

	## Description : initialize and build the entries object needed by HTML::Template 
	## Input : $results
	## Output : \@tbody_entries
	## Usage : my ( $tbody_entries ) = add_entries_to_tbody_object( $results ) ;
=cut
## START of SUB
sub add_entries_to_tbody_object {
	## Retrieve Values
    my $self = shift ;
    my ( $results ) = @_ ;
    
    my @tbody_entries = () ;
								
		foreach my $href_grp (@$results) {
			
				foreach my $hit ( @{$href_grp->{'searchResults'}} ){
					my %grp_res = () ;
					
					## Add hyperlinks
					if ( $hit->{'spectrum'}{'name'} ne 'no results') {
						%grp_res = (
							ID => $href_grp->{id} ,
							ANALYTE_NAME => $hit->{analyte}{name} ,
							SPECTRUM_NAME => $hit->{spectrum}{name} ,
							RI => $hit->{ri_infos}{ri} ,
							RI_DISCREPANCY => $hit->{ri_infos}{riDiscrepancy} ,
							DOT_PRODUCT_DISTANCE => $hit->{distance_scores}{DotproductDistance} ,
							EUCLIDEAN_DISTANCE => $hit->{distance_scores}{EuclideanDistance} ,
							JACCARD_DISTANCE => $hit->{distance_scores}{JaccardDistance} ,
							HAMMING_DISTANCE => $hit->{distance_scores}{HammingDistance} ,
							S12_GOWER_LEGENDRE_DISTANCE => $hit->{distance_scores}{s12GowerLegendreDistance} ,
							SPECTRUM_ID => $hit->{spectrum}{id} ,
							METABOLITE_ID => $hit->{metaboliteID} ,
							ANALYTE_ID => $hit->{analyte}{id},
							ANALYTE_REF => 'http://gmd.mpimp-golm.mpg.de/Analytes/'.$hit->{analyte}{id}.'.aspx',
							SPECTRUM_REF => 'http://gmd.mpimp-golm.mpg.de/Spectrums/'.$hit->{spectrum}{id}.'.aspx',
							METABOLITE_REF => 'http://gmd.mpimp-golm.mpg.de/Metabolites/'.$hit->{metaboliteID}.'.aspx',
						) ;
					}
					else {
						%grp_res = (
							ID => $href_grp->{id} ,
							ANALYTE_NAME => $hit->{analyte}{name} ,
							SPECTRUM_NAME => $hit->{spectrum}{name} ,
							RI => $hit->{ri_infos}{ri} ,
							RI_DISCREPANCY => $hit->{ri_infos}{riDiscrepancy} ,
							DOT_PRODUCT_DISTANCE => $hit->{distance_scores}{DotproductDistance} ,
							EUCLIDEAN_DISTANCE => $hit->{distance_scores}{EuclideanDistance} ,
							JACCARD_DISTANCE => $hit->{distance_scores}{JaccardDistance} ,
							HAMMING_DISTANCE => $hit->{distance_scores}{HammingDistance} ,
							S12_GOWER_LEGENDRE_DISTANCE => $hit->{distance_scores}{s12GowerLegendreDistance} ,
							SPECTRUM_ID => $hit->{spectrum}{id} ,
							METABOLITE_ID => $hit->{metaboliteID} ,
							ANALYTE_ID => $hit->{analyte}{id},
							ANALYTE_REF => 'http://gmd.mpimp-golm.mpg.de/',
							SPECTRUM_REF => 'http://gmd.mpimp-golm.mpg.de/',
							METABOLITE_REF => 'http://gmd.mpimp-golm.mpg.de/',
						) ;
					}
					push (@tbody_entries , \%grp_res) ;
				}
		}
	return \@tbody_entries ;
}
## END of SUB
   
   
   
 
    
    
=head2 METHOD write_html_body

	## Description : Write the html output file 
	## Input : $results, $tbody_entries, $html_file, $html_template
	## Output :  $html_file
	## Usage : $o_output->write_html_body( $results, $tbody_entries, $html_file, $html_template ) ;
=cut
## START of SUB
sub write_html_body {
	## Retrieve Values
    my $self = shift ;
    my ( $results, $tbody_entries, $html_file_name, $html_template, $default_entries, $jsons_obj ) = @_ ;
    
    if (defined $html_file_name){
    	
	    	open (HTML, '>', $html_file_name) or die "Failed to open filehandle: $!" ;
	    
		    if (-e $html_template) {
		    	
		    	my $ohtml = HTML::Template->new(filename => $html_template) ;
#		    	$ohtml->param( DATA => $jsons_obj ) ;
				$ohtml->param( GROUPS => $tbody_entries ) ;
		    	$ohtml->param( DEFAULT_ENTRIES => $default_entries ) ;
		    	print HTML $ohtml->output ;
		    }	
	    	else {
				croak "Problem about your html template: no html template available\n" ;
			}
			close (HTML) ;
    }
    else {
    	croak "Problem with the html output file: $html_file_name is not defined\n" ;
    }
}
## END of SUB



=head2 METHOD excel_output

	## Description : create an excel XLS output of the results
	## Input : $jsons, $excel_file
	## Output :  excel file
	## Usage : $o_output->excel_output( $jsons, $excel_file ) ;
=cut
## START of SUB
#sub excel_output {
#	## Retrieve Values
#    my $self = shift ;
#    my ( $excel_file, $jsons ) = @_ ;
#        
#    # Create a new workbook and add a worksheet
#    my $workbook  = Excel::Writer::XLSX->new( $excel_file ) ;
#    my $worksheet = $workbook->add_worksheet() ;
#    
#    my $i = 0 ;
#    
#    # Create a format for the headings
#    my $format = $workbook->add_format() ;
#    $format->set_bold() ;
#    
#   $worksheet->write( $i, 0, "Num Spectre" , $format);
#	$worksheet->write( $i, 1, "Analyte Name" , $format);
#	$worksheet->write( $i, 2, "Spectrum Name" , $format);
#	$worksheet->write( $i, 3, "Retention Index" , $format);
#	$worksheet->write( $i, 4, "RI Discrepancy" , $format);
#	$worksheet->write( $i, 5, "DotproductDistance" , $format);
#	$worksheet->write( $i, 6, "EuclideanDistance" , $format);
#	$worksheet->write( $i, 7, "JaccardDistance" , $format);
#	$worksheet->write( $i, 8, "HammingDistance" , $format);
#	$worksheet->write( $i, 9, "s12GowerLegendreDistance" , $format);
#	$worksheet->write( $i, 10, "Spectrum ID" , $format);
#	$worksheet->write( $i, 11, "Metabolite ID" , $format);
#   $worksheet->write( $i, 12, "Analyte ID" , $format);
#   $i++;
#    
#   foreach my $href_grp (@$jsons) {
#		
#			foreach my $hit ( @{$href_grp->{'searchResults'}} ){
#				
#					$worksheet->write( $i, 0, $href_grp->{id} );
#			   		$worksheet->write( $i, 1, $hit->{analyte}{name} );
#			   		$worksheet->write( $i, 2, $hit->{spectrum}{name} );
#			   		$worksheet->write( $i, 3, $hit->{ri_infos}{ri} );
#			   		$worksheet->write( $i, 4, $hit->{ri_infos}{riDiscrepancy} );
#			   		$worksheet->write( $i, 5, $hit->{distance_scores}{DotproductDistance} );
#			   		$worksheet->write( $i, 6, $hit->{distance_scores}{EuclideanDistance} );
#			   		$worksheet->write( $i, 7, $hit->{distance_scores}{JaccardDistance} );
#			   		$worksheet->write( $i, 8, $hit->{distance_scores}{HammingDistance} );
#			   		$worksheet->write( $i, 9, $hit->{distance_scores}{s12GowerLegendreDistance} );
#			   		$worksheet->write( $i, 10, $hit->{spectrum}{id} );
#			   		$worksheet->write( $i, 11, $hit->{metaboliteID} );
#			   		$worksheet->write( $i, 12, $hit->{analyte}{id});
#			   		$i++;
#			}
#	}
#
#   $workbook->close();
#}
## END of SUB




=head2 METHOD excel_like_output

	## Description : create an excel like output of the results
	## Input : $jsons, $excel_file
	## Output :  excel file
	## Usage : $o_output->excel_like_output( $jsons, $excel_file ) ;
=cut
## START of SUB
sub excel_like_output {
	## Retrieve Values
    my $self = shift ;
    my ( $excel_file, $jsons ) = @_ ;
	
	open (OUT , ">" , $excel_file) or die "Error at opening file $excel_file" ;
	
	print OUT "Num Spectre\tAnalyte Name\tSpectrum Name\tRetention Index\tRI Discrepancy\tDotproductDistance\tEuclideanDistance\tJaccardDistance\tHammingDistance\ts12GowerLegendreDistance\tSpectrum ID\tMetabolite ID\tAnalyte ID\n" ;
	
	foreach my $href_grp (@$jsons) {
		
			foreach my $hit ( @{$href_grp->{'searchResults'}} ){
				
					print OUT "$href_grp->{id}\t$hit->{analyte}{name}\t$hit->{spectrum}{name}\t$hit->{ri_infos}{ri}\t$hit->{ri_infos}{riDiscrepancy}\t$hit->{distance_scores}{DotproductDistance}\t$hit->{distance_scores}{EuclideanDistance}\t$hit->{distance_scores}{JaccardDistance}\t$hit->{distance_scores}{HammingDistance}\t$hit->{distance_scores}{s12GowerLegendreDistance}\t$hit->{spectrum}{id}\t$hit->{metaboliteID}\t$hit->{analyte}{id}\n";
			}
	}
	close (OUT) ;
	
}
## END of SUB


=head2 METHOD write_json_skel

	## Description : prepare and write json output file
	## Input : $json_file, $scalar
	## Output : json file
	## Usage : $o_output->write_json_skel( $csv_file, $scalar ) ;
	
=cut
## START of SUB
sub write_json_skel {
	## Retrieve Values
    my $self = shift ;
    my ( $json_file, $json_obj ) = @_ ;
    
    my $utf8_encoded_json_text = encode_json $json_obj ;
    open(JSON, '>:utf8', $$json_file) or die "Can't create the file $$json_file\n" ;
    print JSON $utf8_encoded_json_text ;
    close(JSON) ;
    
}
## END of SUB



=head2 METHOD write_csv

	## Description : write csv output file
	## Input : $xlsx_file, $csv_file
	## Output : csv file
	## Usage : $o_output->write_csv( $xlsx_file, $csv_file ) ;
	
=cut
## START of SUB
sub write_csv {
	## Retrieve Values
    my $self = shift ;
    my ( $csv_file, $jsons ) = @_ ;
    
    open (CSV , ">" , $csv_file) or die "Can't create the file $csv_file\n" ;
     
    print CSV "\"Num Spectre\"\t\"Analyte Name\"\t\"Spectrum Name\"\t\"Retention Index\"\t\"RI Discrepancy\"\t\"DotproductDistance\"\t\"EuclideanDistance\"\t\"JaccardDistance\"\t\"HammingDistance\"\t\"s12GowerLegendreDistance\"\t\"Spectrum ID\"\t\"Metabolite ID\"\t\"Analyte ID\"\n" ;
			   		
    foreach my $href_grp (@$jsons) {
		
			foreach my $hit ( @{$href_grp->{'searchResults'}} ){
				
					print CSV "\"$href_grp->{id}\"\t\"$hit->{analyte}{name}\"\t\"$hit->{spectrum}{name}\"\t\"$hit->{ri_infos}{ri}\"\t\"$hit->{ri_infos}{riDiscrepancy}\"\t\"$hit->{distance_scores}{DotproductDistance}\"\t\"$hit->{distance_scores}{EuclideanDistance}\"\t\"$hit->{distance_scores}{JaccardDistance}\"\t\"$hit->{distance_scores}{HammingDistance}\"\t\"$hit->{distance_scores}{s12GowerLegendreDistance}\"\t\"$hit->{spectrum}{id}\"\t\"$hit->{metaboliteID}\"\t\"$hit->{analyte}{id}\"\n" ;
			}
	}
    close(CSV) ;
    
}
## END of SUB




=head2 METHOD write_ajax_data_source

	## Description : write csv output file
	## Input : $jsons_obj
	## Output : 
	## Usage : $o_output->write_ajax_data_source( $jsons_obj ) ;
	
=cut
## START of SUB
sub write_ajax_data_source {
	## Retrieve Values
    my $self = shift ;
    my ( $jsons_obj ) = @_ ;

	my %ajax = () ;
	my $i = 0 ;
	            
	#open (AJAX,">ajax.txt") or die "ERROR at opening file" ;
	            
	foreach my $href_grp (@$jsons_obj) {
			
				foreach my $hit ( @{$href_grp->{'searchResults'}} ){
		            	
					push (@{$ajax{ 'data' }[$i]} , $href_grp->{id}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{spectrum}{name}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{analyte}{name}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{ri_infos}{ri}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{ri_infos}{riDiscrepancy}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{distance_scores}{DotproductDistance}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{distance_scores}{EuclideanDistance}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{distance_scores}{JaccardDistance}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{distance_scores}{HammingDistance}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{distance_scores}{s12GowerLegendreDistance}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{spectrum}{id}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{metaboliteID}) ;
					push (@{$ajax{ 'data' }[$i]} , $hit->{analyte}{ID}) ;
					$i++ ;
				}
		}
	
	my $ajax = encode_json \%ajax ;
	return $ajax ;
	#print AJAX $ajax ;

}
#END of SUB



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
Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : ??

=cut
