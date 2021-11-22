// Required by CMocka: 
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "pt.h"


void test_xypoint(void** state) {
    size_t count = 4;

    // Test creation:
    XYPointList* p = XYPointList_new(count);
    assert_non_null(p);
    assert_non_null(p->pts);
    assert_int_equal(count, p->count);

    // Test set/get:
    XYPoint src = {.x = 0, .y = 1};
    XYPoint dest;

    int failure = XYPointList_set(p, 0, &src);
    assert_int_equal(failure, 0);

    failure = XYPointList_get(p, 0, &dest);
    assert_int_equal(failure, 0);
    assert_int_equal((int) src.x, (int) dest.x);
    assert_int_equal((int) src.y, (int) dest.y);

    // Test index guards:
    failure = XYPointList_set(p, -1, &src);
    assert_int_equal(failure, PT_INVALID_INDEX);

    failure = XYPointList_set(p, count + 1, &src);
    assert_int_equal(failure, PT_INVALID_INDEX);

    // Test NULL pointer guards:
    XYPointList dummy;
    dummy.pts = NULL;

    failure = XYPointList_set(&dummy, 0, &src);
    assert_int_equal(failure, PT_UNINITIALIZED);

    failure = XYPointList_set(NULL, 0, &src);
    assert_int_equal(failure, PT_NULL_ARG);
}


void test_xypoint_set(void** state) {

}