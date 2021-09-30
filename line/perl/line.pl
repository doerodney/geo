use strict;

sub fitLine {
  my ($raMeasPts, $maxAttempts, $epsilon) = @_;

  my $minErr = undef;
  my $minErrM = undef;
  my $minErrB = undef;

  my $attempt = 0;

  my $m = 1;
  my $b = 0;

  my $step = 0.01;

  my ($dedm, $dedb) = get_gradient($raMeasPts, $m, $b); 

  my $err = undef;
  my $prevErr = 1024**2;

  my $msg = undef;

  while ($attempt < $maxAttempts) {
    # Given the current m and b, calculate the error:
    $err = get_error($raMeasPts, $m, $b);
    
    # Report the context:
    $msg = sprintf("attempt %d error %.3f m %2.3f b %2.3f dE/dm %2.3f dE/db %2.3f", $attempt, $err, $m, $b, $dedm, $dedb); 
    print("$msg\n");

    $attempt++;
    last if ($err < $epsilon);

    if ($err > $prevErr) {
      # Get the  gradient for the current m,b:
      ($dedm, $dedb) = get_gradient($raMeasPts, $m, $b);  
    } else {
      $m -= ($step * $dedm);
      $b -= ($step * $dedb);
    }

    $prevErr = $err;
  }
}


sub get_error {
  my ($raMeasPts, $m, $b) = @_;

  my $error = 0;
  my $measPt = undef;
  my $xi = 0;
  my $yi = 0;

  foreach $measPt (@$raMeasPts) {
    $xi = $measPt->{'x'};
    $yi = $measPt->{'y'};
    $error += ($yi - ($m * $xi) - $b)**2;
  }

  return $error;
}

# E = sigma(yi - m*xi - b)**2
# dE/dm = sigma(yi - m * xi -b)*(-xi)
# dE/dm = sigma(m * xi * xi - xi * yi + bxi) <---
# dE/db = sigma(yi - m * xi - b)*(-1)
# dE/db = sigma(m * xi - yi + b)  <---
sub get_gradient {
  my ($raMeasPts, $m, $b) = @_;

  my $dedm = 0;
  my $dedb = 0;

  my $measPt = undef;
  my $xi = undef;
  my $yi = undef;
  foreach $measPt (@$raMeasPts) {
    $xi = $measPt->{'x'};
    $yi = $measPt->{'y'};
    
    $dedm += $m * $xi * $xi - $xi * $yi + $b * $xi;
    $dedb += $m * $xi - $yi + $b;
  }

  # Normalize the raw gradient:
  my $h = sqrt($dedm * $dedm + $dedb * $dedb);
  my $dm = $dedm / $h;
  my $db = $dedb / $h;

  return ($dm, $db);
}


sub get_measured_points {
  my ($m, $b) = @_;

  my $x = undef;
  my $y = undef; 
  my @pts = ();
  for (my $x = 0; $x < 10; $x++) {
    $y = $m * $x + $b;
    my %pt = ();
    $pt{'x'} = $x;
    $pt{'y'} = $y;
    print("Point $x, $y\n");
    push(@pts, \%pt);
  }

  return @pts;
}


sub get_random_line() {
  my $maxValue = shift || 10;
  my $m = rand($maxValue);
  my $b = rand($maxValue);

  return($m, $b);
}


#---main-----------------------------------------------------------------------
my ($m, $b) = (2, 1); #get_random_line();

my $msg = sprintf("Random line at m: %2.2f, b: %2.2f", $m, $b);
print("$msg\n");

my @measPts = get_measured_points($m, $b);
my $epsilon = 0.001;
my $maxAttempts = 10000;

fitLine(\@measPts, $maxAttempts, $epsilon);

