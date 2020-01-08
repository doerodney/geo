use strict;
use CircleFit;

sub get_measured_points {
  my ($x0, $y0, $r) = @_;

  my @pts = ();

  # Generate evenly spaced points on circle.
  my @multipliers = (-1, 1);
  my $multiplier = undef;
  # x values...
  foreach $multiplier (@multipliers) {
    my %pt = ();
    $pt{'x'} = $x0 + $multiplier * $r;
    $pt{'y'} = $y0;
    push(@pts, \%pt);
  }
  # y values...
  foreach $multiplier (@multipliers) {
    my %pt = ();
    $pt{'x'} = $x0;
    $pt{'y'} = $y0 + $multiplier * $r;
    push(@pts, \%pt);
  }
  
  return @pts;
}


# Create points on a circle of radius 2 centered at (5, 5):
my $x0 = 5.0;
my $y0 = 5.0;
my $r = 2.0;
my @measPts = get_measured_points($x0, $y0, $r);

my $fit = CircleFit->new();
$fit->setMeasuredPts(\@measPts);

my ($minErrPt, $minErr) = $fit->solve();

