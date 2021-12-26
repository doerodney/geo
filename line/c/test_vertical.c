#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "vertical.h"

static const double epsilon = 0.01;

void test_vertical(void **state) {
    size_t count = 6, i = 0;
    XYPoint pt = {.x = 0.0, .y = 0.0};
    int err = 0, vertical = 0; 

    // Load with a set of vertical points:
    XYPointList *pts = XYPointList_new(count);
    for (i = 0; i < count; i++) {
        pt.y = (double) i;
        XYPointList_set(pts, i, &pt);
    }

    err = is_vertical(pts, epsilon, &vertical);

    assert_false(err);
    assert_true(vertical);

    // Load with a set of non-vertical points:
     for (i = 0; i < count; i++) {
        pt.x = ((i % 2) == 0) ? epsilon : -epsilon;
        // y is 0 for even and 1 for odd i
        pt.y = (double) i;
        XYPointList_set(pts, i, &pt);
    }

    err = is_vertical(pts, epsilon, &vertical);

    assert_false(err);
    assert_false(vertical);

    XYPointList_free(&pts);
}
