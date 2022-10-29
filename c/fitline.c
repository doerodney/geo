#include <stddef.h>
#include <gsl/gsl_multimin.h>
#include <gsl/gsl_vector.h>
#include "fitline.h"
#include "pt.h"
#include "vertical.h"

static double my_f(const gsl_vector *v, void *params) {
  double m = gsl_vector_get(v, 0);
  double b = gsl_vector_get(v, 1);
  XYPointList *pts = (XYPointList*) params;

  double diff = 0.0;
  double err = 0.0;
  XYPoint pt;
  int failure;
  for (int i = 0; i < pts->count; i++) {
    failure = XYPointList_get(pts, i, &pt);
    if (failure) {
      break;
    } else {
      diff = (pt.y - (m * pt.x) - b);
      err += diff * diff;
    }
  }

  return err;
}


static void my_df(const gsl_vector *v, void *params, gsl_vector *df) {
  double m = gsl_vector_get(v, 0);
  double b = gsl_vector_get(v, 1);
  XYPointList *pts = (XYPointList*) params;

  int failure;
  XYPoint pt;
  double dedm = 0.0;
  double dedb = 0.0;

  for (int i = 0; i < pts->count; i++) {
    failure = XYPointList_get(pts, i, &pt);
    if (failure) {
      break;
    } else {
      dedm += m * pt.x * pt.x - pt.x * pt.y + b * pt.x;
      dedb += m * pt.x - pt.y + b;
    }
  }

  gsl_vector_set(df, 0, dedm);
  gsl_vector_set(df, 1, dedb);
}


static void my_fdf (const gsl_vector *x, void *params, double *f, gsl_vector *df)
{
  *f = my_f(x, params);
  my_df(x, params, df);
}


void get_line_test_points(double m, double b, XYPointList *pts) {
  XYPoint pt;

  for (size_t i = 0; i < pts->count; i++) {
    pt.x = (double) i;
    pt.y = m * pt.x + b;
    XYPointList_set(pts, i, &pt);
  }
}


FitLineResult FitLine(const XYPointList* pts, double stepSize, double epsilon) {
  FitLineResult result = {.b = 0, .m = 0, .x = 0, .vertical = 0, .failure = 1};

  size_t iter = 0;
  int err = 0;
  int status;
  int vertical = 1;

  double sum_x;
  size_t count_pts;

  gsl_multimin_function_fdf my_func;

  my_func.n = 2;                  /* number of function components */
  my_func.f = &my_f;              /* error function */   
  my_func.df = &my_df;            /* gradient function */  
  my_func.fdf = &my_fdf;          /* error and gradient function */
  my_func.params = (void *) pts;  /* data */

  const gsl_multimin_fdfminimizer_type *T =  gsl_multimin_fdfminimizer_conjugate_fr;
  gsl_multimin_fdfminimizer *s = gsl_multimin_fdfminimizer_alloc(T, 2);
  gsl_vector *x  = gsl_vector_alloc(2);

  // Test if points fit a vertical line:
  err = is_vertical(pts, epsilon, &vertical);
  if (!err && vertical) {
    result.vertical = 1;
    (void) XYPointList_get_sum_x(pts, &sum_x); 
    (void) XYPointList_count(pts, &count_pts);
    result.x = sum_x / (double) count_pts;
  }

  if (!vertical) {
    /* Starting point, m,b = (1,0) */
    gsl_vector_set(x, 0, 1.0);
    gsl_vector_set(x, 1, 0.0);

    gsl_multimin_fdfminimizer_set(s, &my_func, x, stepSize, epsilon);

    do {
      iter++;
      status = gsl_multimin_fdfminimizer_iterate(s);

      if (status)
        break;

      status = gsl_multimin_test_gradient(s->gradient, epsilon);

      if (status == GSL_SUCCESS) {
        result.failure = 0;
        result.m = gsl_vector_get(s->x, 0);
        result.b = gsl_vector_get(s->x, 1);
        // printf("Minimum found at:\n");
      }

      /*--
      printf ("%5d %.5f %.5f %10.5f\n", (int) iter,
          gsl_vector_get(s->x, 0),
          gsl_vector_get(s->x, 1),
          s->f);
      --*/

    } while (status == GSL_CONTINUE && iter < 100);
  }

  gsl_multimin_fdfminimizer_free(s);
  gsl_vector_free(x);

  return result;
}
