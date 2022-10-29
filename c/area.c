#include <math.h>
#include "pt.h"
#include "area.h"

// Uses Herron's formula:
double get_triangle_area(XYPoint v1, XYPoint v2, XYPoint v3) {
    double dx, dy;
    double a, b, c, s, area;
    
    dx = v1.x - v2.x;
    dy = v1.y - v2.y; 
    a = sqrt(dx * dx + dy * dy);

    dx = v2.x - v3.x;
    dy = v2.y - v3.y;
    b = sqrt(dx * dx + dy * dy);

    dx = v3.x - v1.x;
    dy = v3.y - v1.y;
    c = sqrt(dx * dx + dy * dy);

    s = (a + b + c) / 2.0;
    area = sqrt(s * (s - a) * (s - b) * (s - c));

    return area;
}