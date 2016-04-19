package lib::msp ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( get_spectrum );
our %EXPORT_TAGS = ( ALL => [qw( get_spectrum )] );

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

=head2 METHOD get_spectrum

	## Description : parse the msp file and generate the spectrum string formatted for the WS query (html) 
	## Input : $msp_file
	## Output : $msp_spectra
	## Usage : my ( $msp_spectra ) = get_spectrum( $msp_file ) ;
	
=cut
## START of SUB
sub get_spectrum {
	## Retrieve Values
    my $self = shift ;
    my ( $msp_file ) = @_ ;
    
    my @msp_spectra ;
    my @ions ;
    my $spectrum ;
    my $spectrumTot = "";
    my $bool = 0;
    my $mz ;
    my $intensity ;
    
    # Extract spectrum
    while(<$msp_file>) {
    	chomp ;
    	#Detect spectra
    	if (/^\s(.+)/) { 
    		@ions = split /;/ , $1 ;
    		foreach my $ion (@ions) {
    			if ($ion =~ /^\s+(\d+)\s+(\d+\.?\d*)$/) {
    				$mz = $1 ;
    				$intensity = $2 ;
    			}
    			$spectrum = $mz . "%20" . $intensity  ;
    			$spectrumTot .= $spectrum . "%20" ;
    		}
    		$bool = 1 ;
    	}
    	elsif(/^$/ && $bool == 1) {
    		push (@msp_spectra , $spectrumTot) ;
    		$bool = 0;
    	}
    }
    return(\@msp_spectra) ;
}
## END of SUB



1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc csv.pm

=head1 Exports

=over 4

=item :ALL is get_spectrum

=back

=head1 AUTHOR

Gabriel Cretin E<lt>gabriel.cretin@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : ??

=cut