#include "collinear.h"
#include "area.h"

int is_collinear(const XYPointList *pts, double epsilon, int *is_collinear_out) {
    int err = 0;
    size_t count = 0, i = 0;
    XYPoint v1, v2, v3;
    double area = 0.0;

    // Claim collinear until proven otherwise.
    *is_collinear_out = 1;

    err = XYPointList_count(pts, &count);

    for (i = 0; i < (count - 3) && !err; i++) {
        err = XYPointList_get(pts, i, &v1);
        if (!err) {
            err = XYPointList_get(pts, i + 1, &v2);
        }
        if (!err) {
            err = XYPointList_get(pts, i + 2, &v3);
        }
        
        if (!err) {
            area = get_triangle_area(v1, v2, v3);
            if (area > epsilon) {
                *is_collinear_out = 0;
                break;
            }
        }

        if (err) {
            *is_collinear_out = 0;
        }
    }

    return err;
}