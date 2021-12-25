#include "pt.h"
#include "vertical.h"

int is_collinear(const XYPointList *pts, double epsilon, int *is_vertical_out) {
    int err = 0;

    // Find min and max y values.  If they vary by less than epsilon, then 
    // the points define a vertical line.
    double min_y, max_y;

    err = XYPointList_get_min_y(pts, &min_y);
    
    if (!err) {
        err = XYPointList_get_max_y(pts, &max_y);
    }

    if (!err) {
        *is_vertical_out = (fabs(max_y - min_y) < epsilon) ? 1 : 0;
    } 
    
    return err;
}