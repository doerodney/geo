#ifndef COLLINEAR_H
#define COLLINEAR_H

#include "pt.h"

int is_collinear(const XYPointList *pts, double epsilon, int *is_collinear_out);

#endif