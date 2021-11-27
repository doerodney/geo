#include <stdlib.h>
//#include <string.h>
#include "pt.h"


XYPointList* XYPointList_new(size_t count) {
    XYPointList *p = calloc(sizeof(XYPointList), 1);
    p->x = gsl_vector_calloc(count);
    p->y = gsl_vector_calloc(count);
    p->count = count;

    return p;
}


int XYPointList_count(const XYPointList* p, size_t* count) {
  
  if (p == NULL) { return PT_NULL_ARG; } 
  if (count == NULL) { return PT_NULL_ARG; }
  if ((p->x == NULL) || (p->y == NULL)) { return PT_UNINITIALIZED; }
  
  *count = p->count;
  
  return 0;
}


XYPointList* XYPointList_copy(const XYPointList *src) {
    size_t count = src->count;
    double x, y;

    XYPointList *dest = XYPointList_new(count);
    for (size_t i = 0; i < dest->count; i++) {
      x = gsl_vector_get(src->x, i);
      y = gsl_vector_get(src->y, i);
      gsl_vector_set(dest->x, i, x);
      gsl_vector_set(dest->y, i, y);
    }
    
    return dest;
}


void XYPointList_free(XYPointList **p) {
    gsl_vector_free((*p)->x);
    gsl_vector_free((*p)->y);

    free((void*) *p);
    *p = NULL;
}


int XYPointList_get(const XYPointList* p, size_t idx, XYPoint* pt) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if ((p->x == NULL) || (p->y == NULL) || (pt == NULL)) { 
    return PT_UNINITIALIZED; 
  }
  if (idx >= p->count) { return PT_INVALID_INDEX; }
  
  pt->x = gsl_vector_get(p->x, idx);
  pt->y = gsl_vector_get(p->y, idx);
  return 0;
}

int XYPointList_get_max_x(const XYPointList* p, double *x_out) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if (p->x == NULL) { 
    return PT_UNINITIALIZED; 
  }

  *x_out = gsl_vector_max(p->x);
  return 0;
}

int XYPointList_get_max_y(const XYPointList* p, double *y_out) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if (p->y == NULL) { 
    return PT_UNINITIALIZED; 
  }
  
  *y_out = gsl_vector_max(p->y);
  return 0;
}

int XYPointList_get_min_x(const XYPointList* p, double *x_out) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if (p->x == NULL) { 
    return PT_UNINITIALIZED; 
  }

  *x_out = gsl_vector_min(p->x);
  return 0;
}

int XYPointList_get_min_y(const XYPointList* p, double *y_out) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if (p->y == NULL) { 
    return PT_UNINITIALIZED; 
  }
  
  *y_out = gsl_vector_min(p->y);
  return 0;
}

int XYPointList_set(XYPointList* p, size_t idx, XYPoint* pt) {
  if (p == NULL) { return PT_NULL_ARG; } 
  if ((p->x == NULL) || (p->y == NULL) || (pt == NULL)) { 
    return PT_UNINITIALIZED; 
  }
  if (idx >= p->count) { return PT_INVALID_INDEX; }
  
  gsl_vector_set(p->x, idx, pt->x);
  gsl_vector_set(p->y, idx, pt->y);

  return 0;
}
