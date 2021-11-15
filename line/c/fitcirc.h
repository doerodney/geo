#ifndef INC_FITCIRC_H
#define INC_FITCIRC_H

#include <stddef.h>
#include<gsl/gsl_multimin.h>
#include "pt.h"

void FitCircle(gsl_multimin_function_fdf my_func, double stepSize, double epsilon);

#endif