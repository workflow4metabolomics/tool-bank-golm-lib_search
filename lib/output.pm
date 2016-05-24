package lib::output ;

use strict;
use warnings ;
use Exporter ;
use Carp ;
use Excel::Writer::XLSX ;
use HTML::Template ;
use JSON ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw(build_json_res_object excel_output write_html_body add_entries_to_tbody_object write_json_skel);
our %EXPORT_TAGS = ( ALL => [qw(build_json_res_object excel_output write_html_body add_entries_to_tbody_object write_json_skel)] );

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
						
					my %grp_res = (	
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
					) ;
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
	## Usage : my ( $html_file ) = write_html_body( $results, $tbody_entries, $html_file, $html_template ) ;
=cut
## START of SUB
sub write_html_body {
	## Retrieve Values
    my $self = shift ;
    my ( $results, $tbody_entries, $html_file_name, $html_template, $default_entries ) = @_ ;
    
    my $html_file = $html_file_name ;
    
    if (defined $html_file){
    	
	    	open (HTML, '>', "output/".$html_file) or die "Failed to open filehandle: $!" ;
	    
		    if (-e $html_template) {
		    	
		    	my $ohtml = HTML::Template->new(filename => $html_template) ;
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
    	croak "Problem with the html output file: $html_file is not defined\n" ;
    }
    return(\$html_file) ;
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
    
    open (FILE, '>', "output/".$excel_file) or die "Failed to open filehandle: $!" ;
    
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


=head2 METHOD write_json_skel

	## Description : prepare and write json output file
	## Input : $json_file, $scalar
	## Output : $json_file
	## Usage : my ( $json_file ) = write_json_skel( $csv_file, $scalar ) ;
	
=cut
## START of SUB
sub write_json_skel {
	## Retrieve Values
    my $self = shift ;
    my ( $json_file, $json_obj ) = @_ ;
    
    my $utf8_encoded_json_text = encode_json $json_obj ;
    open(JSON, '>:utf8', "output/".$$json_file) or die "Cant' create the file $$json_file\n" ;
    print JSON $utf8_encoded_json_text ;
    close(JSON) ;
    
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
Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : ??

=cut