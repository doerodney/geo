// Required by CMocka: 
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

//#include "test_area.h"
//#include "test_collinear.h"
#include "test_line.h"
#include "test_pt.h"
#include "test_vertical.h"

int setup(void** state) { return 0; }

int tear_down(void** state) { return 0; }

int main(int argc, char* argv[]) {
    const struct CMUnitTest tests[] = {
        //cmocka_unit_test(test_area),
        //cmocka_unit_test(test_collinear),
        cmocka_unit_test(test_line),
        cmocka_unit_test(test_vertical),
        cmocka_unit_test(test_xypoint)
    };

    return cmocka_run_group_tests(tests, setup, tear_down);
}
