#include <stdio.h>
#include "fitcirc.h"
#include "pt.h"

void get_measured_points(double m, double b, size_t count, XYPoint *pts) {
  
  for (size_t i = 0; i < count; i++) {
    pts[i].x = (double) i;
    pts[i].y = m * pts[i].x + b;
  }
}


int main (void)
{
  double b = 0.0;
  double m = 2.0;
  const size_t nPts = 10;
  XYPoint pts[nPts];

  get_measured_points(m, b, nPts, pts);
 
  return 0;
}
