#include "pt.h"
#include "vertical.h"

int is_vertical(const XYPointList *pts, double epsilon, int *is_vertical_out) {
    int err = 0;

    // Find min and max x values.  If they vary by less than epsilon, then 
    // the points define a vertical line.
    double min_x, max_x;

    err = XYPointList_get_min_x(pts, &min_x);
    
    if (!err) {
        err = XYPointList_get_max_x(pts, &max_x);
    }

    if (!err) {
        *is_vertical_out = ((max_x - min_x) < epsilon) ? 1 : 0;
    } 
    
    return err;
}