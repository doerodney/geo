#include <stdio.h>
#include "fitline.h"
#include "pt.h"
#include <gsl/gsl_vector.h>
#include <gsl/gsl_multimin.h>

#include "test_line.h"

int main (void)
{
  double b = 1.0;
  double m = 2.0;
  const size_t nPts = 10;

  XYPointList* pts = XYPointList_new(nPts);

  get_line_test_points(m, b, pts);

  double stepsize = 0.01;
  double epsilon = 0.0001;
  
  FitLineResult result = FitLine(pts, stepsize, epsilon);
  printf("failure = %d, m = %f, b = %f\n", result.failure, result.m, result.b);

  XYPointList_free(&pts);
 
  return 0;
}
