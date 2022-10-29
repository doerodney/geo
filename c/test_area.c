#include <math.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "area.h"

static const double epsilon = 0.0001;

void test_area(void **state) {
    
    XYPoint v1 = {.x = 0.0, .y = 0.0};
    XYPoint v2 = {.x = 1.0, .y = 0.0};
    XYPoint v3 = {.x = 1.0, .y = 2.0};

    double expected = 1.0;
    double observed = get_triangle_area(v1, v2, v3);
    assert_true(fabs(expected - observed) < epsilon);
}