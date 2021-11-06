#include <stdio.h>
#include "fitcirc.h"
#include "pt.h"
#include <gsl/gsl_vector.h>

void get_measured_points(double m, double b, XYPointList *pts) {
  XYPoint pt;

  for (int i = 0; i < pts->count; i++) {
    pt.x = (double) i;
    pt.y = m * pt.x + b;
    XYPointList_set(pts, i, &pt);
  }
}

double my_f(const gsl_vector *v, void *params) {
  double m, b;
  XYPointList *pts = (XYPointList*) params;
  m = gsl_vector_get(v, 0);
  b = gsl_vector_get(v, 1);

  double diff = 0.0;
  double err = 0.0;
  XYPoint pt;
  int failure;
  for (int i = 0; i < pts->count; i++) {
    failure = XYPointList_get(pts, i, &pt);
    if (failure) {
      break;
    } else {
      diff = (pt.y - (m * pt.x) - b);
      err += diff * diff;
    }
  }

  return err;
}


void mydf(const gsl_vector *v, void *params, gsl_vector *df) {
  double m, b;
  XYPointList *pts = (XYPointList*) params;
  m = gsl_vector_get(v, 0);
  b = gsl_vector_get(v, 1);

  int failure;
  XYPoint pt;
  double dedm = 0.0;
  double dedb = 0.0;

  for (int i = 0; i < pts->count; i++) {
    failure = XYPointList_get(pts, i, &pt);
    if (failure) {
      break;
    } else {
      dedm += m * pt.x * pt.x - pt.x * pt.y + b * pt.x;
      dedb += m * pt.x - pt.y + b;
    }
  }

  gsl_vector_set(df, 0, dedm);
  gsl_vector_set(df, 0, dedb);
}

int main (void)
{
  double b = 0.0;
  double m = 2.0;
  const size_t nPts = 10;

  XYPointList* pts = XYPointList_new(nPts);

  get_measured_points(m, b, pts);
 
  return 0;
}
