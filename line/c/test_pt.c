// Required by CMocka: 
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "pt.h"


void test_xypoint_get(void** state) {
    size_t count = 4;
    XYPointList* p = XYPointList_new(count);
    assert_non_null(p);
    assert_non_null(p->pts);
    assert_int_equal(count, p->count);

    XYPoint src = {.x = 0, .y = 1};

    int failure = XYPointList_set(p, 0, &src);
    assert_int_equal(failure, 0);
    
    XYPoint dest;
    failure = XYPointList_get(p, 0, &dest);
    assert_int_equal(src.x, dest.x);
    assert_int_equal(src.y, dest.y);
}


void test_xypoint_set(void** state) {

}