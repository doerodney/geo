#ifndef INC_PT_H
#define INC_PT_H

#define PT_NULL_ARG 1
#define PT_UNINITIALIZED 2
#define PT_INVALID_INDEX 3

#include <stddef.h>
#include <gsl/gsl_vector.h>

typedef struct {
    double x;
    double y;
} XYPoint;

typedef struct {
    size_t count;
    gsl_vector *x;
    gsl_vector *y;
} XYPointList;

XYPointList* XYPointList_new(size_t count);
XYPointList* XYPointList_copy(const XYPointList *src);
void XYPointList_free(XYPointList **p);

int XYPointList_count(const XYPointList* p, size_t* count);
int XYPointList_get(const XYPointList* p, size_t idx, XYPoint* pt);
int XYPointList_set(XYPointList* p, size_t idx, XYPoint* pt);

typedef struct {
    double x;
    double y;
    double z;
} XYZPoint;

#endif
