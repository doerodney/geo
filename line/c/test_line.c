#include <math.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "fitline.h"


void test_line(void **state) {
    /* Fit non-vertical lines */
    double b = 0.0;
    size_t nPts = 10;
    XYPointList *pts = XYPointList_new(nPts);
    FitLineResult result;
    double stepsize = 0.01;
    double epsilon = 0.0001;
    double m = 0.0;

    for (m = 0.0; m < 1.0; m += 0.25) {
        get_line_test_points(m, b, pts);
        result = FitLine(pts, stepsize, epsilon);
        assert_true(fabs(result.m - m) < epsilon);
        assert_true(fabs(result.b - b) < epsilon);
    }

    // Vertical points:
    XYPoint pt;
    for (size_t i = 0; i < nPts; i++) {
        pt.x = 0.0;
        pt.y = (double) i;
        XYPointList_set(pts, i, &pt);
    }

    


    XYPointList_free(&pts);
}

