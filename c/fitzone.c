#include <math.h>
#include "fitzone.h"

int CalculateLineFitZone(double m, double b, const XYPointList *pts, double *zoneWidth) {
  int error = 0;
  int nPts = XYPointList_count(pts);
  XPoint pt{0, 0};

  *zoneWidth = NAN;
  double below = 0.0;
  double above = 0.0;
  double y = 0.0;
  double dy = 0.0;

  for (size_t = 0; i < nPts && !error; i++) {
    error = XYPointList_get(pts, i, *pt);
    if (!error) {
      y = m * pt.x + b;
      dy = y - pt.y;
      if (dy > 0) {
        above = (dy > above) ? dy : above;
      } else {
        below = (dy < below) ? dy : below;
      }
    }
  }

  *zoneWidth = above - below;

  return error;
}

