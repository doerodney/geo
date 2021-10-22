#include <stdlib.h>
#include <string.h>
#include "pt.h"


XYPoints* XYPoints_new(size_t count) {
    XYPoints *p = calloc(sizeof(XYPoints), 1);
    XYPoint* pts = calloc(sizeof(XYPoint), count);

    p->count = count;
    p->pts = pts;

    return p;
}


XYPoints* XYPoints_copy(const XYPoints *src) {
    size_t count = src->count;

    XYPoints *dest = XYPoints_new(count);
    memcpy((void*) dest->pts, (const void*) src->pts, count * sizeof(XYPoint));

    return dest;
}


void XYPoints_free(XYPoints *p) {
    XYPoint *pts = p->pts;

    free((void*) pts);

    free((void*) p);
}


