#ifndef INC_PT_H
#define INC_PT_H

typedef struct {
    double x;
    double y;
} XYPoint;

typedef struct {
    size_t count;
    XYPoint *pts;

} XYPoints;

XYPoints* XYPoints_new(size_t count);
XYPoints* XYPoints_copy(const XYPoints *src);
void XYPoints_free(XYPoints *p);

typedef struct {
    double x;
    double y;
    double z;
} XYZPoint;

#endif