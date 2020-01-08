package CircleFit;

use strict;


sub new {
  my $class = shift;
  my $self = {};
  bless($self, $class);
  $self->{'minX'} = 0;
  $self->{'maxX'} = 10;
  $self->{'dX'} = 1;
  $self->{'minY'} = 0;
  $self->{'maxY'} = 10;
  $self->{'dY'} = 1;
  $self->{'minR'} = 0;
  $self->{'maxR'} = 10;
  $self->{'dR'} = 1;
  $self->{'raMeasPts'} = undef;
  return $self;
}  

sub generate_trial_points {
  my ($minX, $maxX, $dX, $minY, $maxY, $dY, $minR, $maxR, $dR) = @_;
  my @pts = ();
  
  my $x = $self->{'minX'};
  my $y = $self->{'minY'};
  my $r = $self->{'minR'};

  for ($x = $self->{'minX'}; $x <= $self->{'maxX'}; $x += $self->{'dX'}) {
    for ($y = $self->{'minY'}; $y <= $self->{'maxY'}; $y += $self->{'dY'}) {
      for ($r = $self->{'minR'}; $r <= $self->{'maxR'}; $r += $self->{'dR'}) {
        my %pt = ();
        $pt{'x'} = $x;
        $pt{'y'} = $y;
        $pt{'r'} = $r;
        push(@pts, \%pt);
      }
    }
  }

 return @pts;
}

sub get_trial_point_error {
  my ($rTrialPt, $raMeasPts) = @_;
  my $err = 0;
  my $totalErr = 0;
  my $x0 = $rTrialPt->{'x'};
  my $y0 = $rTrialPt->{'y'};
  my $r0 = $rTrialPt->{'r'};
  
  my $measPt = undef;
  my $xi = undef;
  my $yi = undef;
  foreach $measPt (@$raMeasPts) {
    $xi = $measPt->{'x'};
    $yi = $measPt->{'y'};
    $err = error($xi, $x0, $yi, $y0, $r0);
    $totalErr += $err * $err;
  }
  
  return $totalErr;
}

sub setMeasuredPts {
  my ($self, $raPts) = @_;
  $self->{'raMeasPts'} = $raPts;
}

sub setXRange {
  my ($self, $minX, $maxX, $dX) = @_;

  $self->{'minX'} = $minX;
  $self->{'maxX'} = $maxX;
  $self->{'dX'} = $dX;
}

sub setYRange {
  my ($self, $minY, $maxY, $dY) = @_;

  $self->{'minY'} = $minY;
  $self->{'maxY'} = $maxY;
  $self->{'dY'} = $dY;
}

sub setRRange {
  my ($self, $minR, $maxR, $dR) = @_;

  $self->{'minR'} = $minR;
  $self->{'maxR'} = $maxR;
  $self->{'dR'} = $dR;
}

sub setMeasuredPts {
  my ($self, $raPts) = @_;

  $self->{'raPts'} = $raPts;
}

sub solve {
  my ($self, $epsilon) = @_;

  my $minErrPt = undef;
  my $minErr = undef;
  
  $epsilon = 0.001 if !defined($epsilon);
  
  my $attempt = 0;
  my $maxAttempts = 5;

  $minErr = $self->{'maxX'}**2 + $self->{'maxY'}**2 + $self->{'maxR'}**2;

  while (($attempt < $maxAttempts) && ($minErr > $epsilon)) {
    # Generate trial points.
    my @trialPts = $self->generate_trial_points();

    # Find the trial point with the minimum error:
    foreach $rPt (@trialPts) {
      my $err = get_trial_point_error($rPt, \@measPts);
      if ($err < $minErr) {
        $minErr = $err;
        $minErrPt = $rPt;
      }  
    }

    if (($minErr >= $epsilon) && ($attempt < $maxAttempts)) {
      $minErrX = $minErrPt->{'x'};
      $minErrY = $minErrPt->{'y'};
      $minErrR = $minErrPt->{'r'};
      print("\nIteration: $attempt\n");
      print("Min err: $minErr\n");
      print("Min err point: x: $minErrX, y: $minErrY, r: $minErrR\n");

      $attempt++;
      
      # Define new region around min error context.
      $minX = $minErrX - $dX;
      $maxX = $minErrX + $dX;
      $dX = $dX / 10;

      $minY = $minErrY - $dY;
      $maxY = $minErrY + $dY;
      $dY = $dY / 10;
      
      $minR = $minErrR - $dR;
      $maxR = $minErrR + $dR;
      $dR = $dR / 10;
    }
  }
  
  return ($minErrPt, $minErr);
}

1;
