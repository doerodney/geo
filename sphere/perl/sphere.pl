use strict;

sub error {
  my ($xi, $x0, $yi, $y0, $zi, $z0, $r) = @_;

  my $error = ($xi - $x0)**2 + ($yi - $y0)**2 + ($zi - $z0)**2 - $r**2;
  
  return $error;
}

sub generate_trial_points {
  my ($minX, $maxX, $dX, $minY, $maxY, $dY, $minZ, $maxZ, $dZ, $minR, $maxR, $dR) = @_;
  my @pts = ();
  
  my $x = $minX;
  my $y = $minY;
  my $z = $minZ;
  my $r = $minR;

  for ($x = $minX; $x <= $maxX; $x += $dX) {
    for ($y = $minY; $y <= $maxY; $y += $dY) {
      for ($z = $minZ; $z <= $maxZ; $z += $dZ) {
        for ($r = $minR; $r <= $maxR; $r += $dR) {
          my %pt = ();
          $pt{'x'} = $x;
          $pt{'y'} = $y;
          $pt{'z'} = $z;
          $pt{'r'} = $r;
          push(@pts, \%pt);
        }
      }
    }
  }

 return @pts;
} 

sub get_measured_points {
  my ($x0, $y0, $z0, $r) = @_;

  my @pts = ();

  # Generate evenly spaced points on circle.
  my @multipliers = (-1, 1);
  my $multiplier = undef;
  # x values...
  foreach $multiplier (@multipliers) {
    my %pt = ();
    $pt{'x'} = $x0 + $multiplier * $r;
    $pt{'y'} = $y0;
    $pt{'z'} = $z0;
    push(@pts, \%pt);
  }
  # y values...
  foreach $multiplier (@multipliers) {
    my %pt = ();
    $pt{'x'} = $x0;
    $pt{'y'} = $y0 + $multiplier * $r;
    $pt{'z'} = $z0;
    push(@pts, \%pt);
  }
  # z values...
  foreach $multiplier (@multipliers) {
    my %pt = ();
    $pt{'x'} = $x0;
    $pt{'y'} = $y0;
    $pt{'z'} = $z0 + $multiplier * $r;
    push(@pts, \%pt);
  }
  
  return @pts;
}

sub get_random_sphere {
  my $maxValue = shift || 10;
  my $x0 = rand($maxValue);
  my $y0 = rand($maxValue);
  my $z0 = rand($maxValue);
  my $r0 = rand($maxValue);

  return ($x0, $y0, $z0, $r0);
}

sub get_trial_point_error {
  my ($rTrialPt, $raMeasPts) = @_;
  my $err = 0;
  my $totalErr = 0;
  my $x0 = $rTrialPt->{'x'};
  my $y0 = $rTrialPt->{'y'};
  my $z0 = $rTrialPt->{'z'};
  my $r = $rTrialPt->{'r'};
  
  my $measPt = undef;
  my $xi = undef;
  my $yi = undef;
  my $zi = undef;
  foreach $measPt (@$raMeasPts) {
    $xi = $measPt->{'x'};
    $yi = $measPt->{'y'};
    $zi = $measPt->{'z'};
    $err = error($xi, $x0, $yi, $y0, $zi, $z0, $r);
    $totalErr += $err * $err;
  }
  
  return $totalErr;
}

sub fitSphere {
  my ($raMeasPts, 
      $epsilon, 
      $maxX, $maxY, $maxZ,
      $minX, $minY, $minZ,
      $minR, $maxR, 
      $dX, $dY, $dZ, $dR) = @_;

  $epsilon = 0.001 if !(defined($epsilon));
  $minX = 0 if !(defined($minX));
  $maxX = 10 if !(defined($maxX));
  $dX = 1 if !(defined($dX));

  $minY = 0 if !(defined($minY));
  $maxY = 10 if !(defined($maxY));
  $dY = 1 if !(defined($dY));

  $minZ = 0 if !(defined($minZ));
  $maxZ = 10 if !(defined($maxZ));
  $dZ = 1 if !(defined($dZ));

  $minR = 0 if !(defined($minR));
  $maxR = 10 if !(defined($maxR));
  $dR = 1 if !(defined($dR));
  
  my $rPt = undef;
  my $x = undef;
  my $y = undef;
  my $z = undef;

  my $minErrX = 0;
  my $minErrY = 0;
  my $minErrZ = 0;
  my $minErrR = 0;

  my $minErr = $maxX**2 + $maxY**2 + $maxR**2;
  my $minErrPt = undef;
  my $msg = undef;
  
  my $attempt = 0;
  my $maxAttempts = 4;

  while (($minErr > $epsilon) && ($attempt < $maxAttempts)) {
    # Generate trial points.
    my @trialPts = generate_trial_points($minX, $maxX, $dX,
      $minY, $maxY, $dY, 
      $minZ, $maxZ, $dZ,
      $minR, $maxR, $dR);

    # Find the trial point with the minimum error:
    foreach $rPt (@trialPts) {
      my $err = get_trial_point_error($rPt, $raMeasPts);
      if ($err < $minErr) {
        $minErr = $err;
        $minErrPt = $rPt;
      }  
    }

    $minErrX = $minErrPt->{'x'};
    $minErrY = $minErrPt->{'y'};
    $minErrZ = $minErrPt->{'z'};
    $minErrR = $minErrPt->{'r'};
    print("\nIteration: $attempt\n");
    $msg = sprintf("Min err: %3.2f\n", $minErr);
    print $msg;
    # print("Min err: $minErr\n");
    # $msg = sprintf("Min err point: x: %2.2f, y: %2.2f, z: %2.2f, r: %2.2f\n",
    #  $minErrX, $minErrY, $minErrZ, $minErrR);
    # print $msg;
    print("Min err point: x: $minErrX, y: $minErrY, z: $minErrZ, r: $minErrR\n");

    $attempt++;
    
    # Define new region around min error context.
    $minX = $minErrX - $dX;
    $maxX = $minErrX + $dX;
    $dX = $dX / 10;

    $minY = $minErrY - $dY;
    $maxY = $minErrY + $dY;
    $dY = $dY / 10;
    
    $minZ = $minErrZ - $dZ;
    $maxZ = $minErrZ + $dZ;
    $dZ = $dZ / 10;
    
    $minR = $minErrR - $dR;
    $maxR = $minErrR + $dR;
    $dR = $dR / 10;
  }

  return($minErrR, $minErr);
}

#---main-----------------------------------------------------------------------
my ($x0, $y0, $z0, $r0) = get_random_sphere(10);
my $msg = sprintf("Random circle at x: %2.2f, y: %2.2f, z: %2.2f, r: %2.2f", $x0, $y0, $z0, $r0);
print("$msg\n");

# Generate "measured" points.
my @measPts = get_measured_points($x0, $y0, $z0, $r0);
my $epsilon = 0.01;

my ($minErrPt, $minErr) = fitSphere(\@measPts, $epsilon);
