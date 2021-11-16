#ifndef INC_FITLINE_H
#define INC_FITLINE_H

#include <stddef.h>
#include<gsl/gsl_multimin.h>
#include "pt.h"

void FitLine(gsl_multimin_function_fdf* my_func, double stepSize, double epsilon);

#endif