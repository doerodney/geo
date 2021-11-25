#include "pt.h"
#include "area.h"

double get_triangle_area(XYPoint v1, XYPoint v2, XYPoint v3) {
    double area = (v1.x * v2.y + 
                   v2.x * v3.y + 
                   v3.x * v1.y - 
                   v1.y * v2.x - 
                   v2.y * v3.x - 
                   v3.y * v1.x) / 2.0;
   
    return area;
}