#ifndef INC_COLLINEAR_H
#define INC_COLLINEAR_H

#include "pt.h"

int is_collinear(const XYPointList *pts, double epsilon, int *is_collinear_out);

#endif