#ifndef INC_FITCIRC_H
#define INC_FITCIRC_H

#include <stddef.h>
#include<gsl/gsl_multimin.h>
#include "pt.h"

typedef struct {
    double x;
    double y;
    double r;
    int failure;
} FitCircleResult;


FitCircleResult FitCircle(const XYPointList *pts, double stepSize, double epsilon);


#endif