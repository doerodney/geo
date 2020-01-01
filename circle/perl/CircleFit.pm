package CircleFit;

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
  $self->{'raPts'} = undef;
  return $self;
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

1;
