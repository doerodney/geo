#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "collinear.h"

static const double epsilon = 0.0001;

void test_collinear(void **state) {
    size_t count = 6, i = 0;
    XYPoint pt = {.x = 0.0, .y = 0.0};
    int err = 0, collinear = 0; 

    // Load with a set of collinear points:
    XYPointList *pts = XYPointList_new(count);
    for (i = 0; i < count; i++) {
        pt.x = (double) i;
        XYPointList_set(pts, i, &pt);
    }

    err = is_collinear(pts, epsilon, &collinear);

    assert_false(err);
    assert_true(collinear);

    // Load with a set of non-collinear points:
     for (i = 0; i < count; i++) {
        pt.x = (double) i;
        // y is 0 for even and 1 for odd i
        pt.y = ((i % 2) == 0) ? 0.0 : 1.0;
        XYPointList_set(pts, i, &pt);
    }

    err = is_collinear(pts, epsilon, &collinear);

    assert_false(err);
    assert_false(collinear);

    XYPointList_free(&pts);
}
