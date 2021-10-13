#ifndef INC_FITCIRC_H
#define INC_FITCIRC_H

#include <stddef.h>
#include "pt.h"

void FitCircle(XYPoint *pts, size_t nPts, double stepSize, double epsilon);

#endif