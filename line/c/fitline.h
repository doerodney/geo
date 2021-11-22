#ifndef INC_FITLINE_H
#define INC_FITLINE_H

#include <stddef.h>
#include<gsl/gsl_multimin.h>
#include "pt.h"

typedef struct {
    double b;
    double m;
    int failure;
} FitLineResult;


FitLineResult FitLine(const XYPointList *pts, double stepSize, double epsilon);

void get_line_test_points(double m, double b, XYPointList *pts);

#endif