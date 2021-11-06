#include <stdlib.h>
#include <string.h>
#include "pt.h"


XYPointList* XYPointList_new(size_t count) {
    XYPointList *p = calloc(sizeof(XYPointList), 1);
    XYPoint* pts = calloc(sizeof(XYPoint), count);

    p->count = count;
    p->pts = pts;

    return p;
}


XYPointList* XYPointList_copy(const XYPointList *src) {
    size_t count = src->count;

    XYPointList *dest = XYPointList_new(count);
    memcpy((void*) dest->pts, (const void*) src->pts, count * sizeof(XYPoint));

    return dest;
}


void XYPointList_free(XYPointList *p) {
    XYPoint *pts = p->pts;

    free((void*) pts);

    free((void*) p);
}


int XYPointList_get(const XYPointList* p, int idx, XYPoint* pt) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if (p->pts == NULL) { return PT_UNINITIALIZED; }
  if ((idx < 0) || (idx >= p->count)) { return PT_INVALID_INDEX; }
  
  XYPoint* src =  &(p->pts[idx]);
  memcpy((void*) pt, (void*) src, sizeof(XYPoint));

  return 0;
}


int XYPointList_set(XYPointList* p, int idx, XYPoint* pt) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if (p->pts == NULL) { return PT_UNINITIALIZED; }
  if ((idx < 0) || (idx >= p->count)) { return PT_INVALID_INDEX; }
  
  XYPoint* dest =  &(p->pts[idx]);
  memcpy((void*) dest, (void*) pt, sizeof(XYPoint));

  return 0;
}
