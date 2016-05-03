package lib::output ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw(build_json_res_object );
our %EXPORT_TAGS = ( ALL => [qw(build_json_res_object )] );

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
	my %hit_infos = () ;
	my $nb_hits = 0 ;
	my $i = 0 ;
	my $spectrumID = 1 ;
	
	## Loop on each spectra
	foreach my $res (@array_results) {
		
		$nb_hits = scalar @$res;
		$json_results[$i]{'id'} = $spectrumID++ ;
		$json_results[$i]{'nb_hits'} = $nb_hits ;
		
		## Loop on each hit of a spectrum + build json
		foreach my $href (@$res) {
			
			my %hash_res = %$href ;
			
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
			
			print "coucou".Dumper @{ $json_results[$i]{'searchResults'} } ;
			push ( @{ $json_results[$i]{'searchResults'} } , \%hit_infos ) ;
			
		}
		#print "yop".Dumper $json_results[$i]{'searchResults'} ;
		$i++ ;
	}
    return \@json_results ;
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