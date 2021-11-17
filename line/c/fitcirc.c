#include <math.h>
#include <stddef.h>
#include <gsl/gsl_multimin.h>
#include <gsl/gsl_vector.h>
#include "fitcirc.h"
#include "pt.h"

double diff(double x, double y, double r, const XYPoint *pt) {
    double diff = (pow((pt->x - x), 2.0) +pow((pt->y - y), 2.0) - pow(r, 2.0));

    return diff;
}

static double my_f(const gsl_vector *v, void *params) {
  double x = gsl_vector_get(v, 0);
  double y = gsl_vector_get(v, 1);
  double r = gsl_vector_get(v, 2);
  XYPointList *pts = (XYPointList*) params;

  double err = 0.0;
  double errsq = 0.0;
  XYPoint pt;
  int failure;
  for (int i = 0; i < pts->count; i++) {
    failure = XYPointList_get(pts, i, &pt);
    if (failure) {
      break;
    } else {
      err = diff(x, y, r, &pt);
      errsq += err * err;
    }
  }

  return errsq;
}


static void my_df(const gsl_vector *v, void *params, gsl_vector *df) {
  double x = gsl_vector_get(v, 0);
  double y = gsl_vector_get(v, 1);
  double r = gsl_vector_get(v, 2);
  XYPointList *pts = (XYPointList*) params;

  int failure;
  XYPoint pt;
  double dedx = 0.0;
  double dedy = 0.0;
  double dedr = 0.0;
  double err = 0.0;

  for (size_t i = 0; i < pts->count; i++) {
    failure = XYPointList_get(pts, i, &pt);
    if (failure) {
      break;
    } else {
      err = diff(x, y, r, &pt);  
      dedx += err * (pt.x - x);
      dedy += err * (pt.y - y);
      dedr += err * r;
    }
  }

  gsl_vector_set(df, 0, dedx);
  gsl_vector_set(df, 1, dedy);
  gsl_vector_set(df, 2, dedr);
}


static void my_fdf (const gsl_vector *x, void *params, double *f, gsl_vector *df)
{
  *f = my_f(x, params);
  my_df(x, params, df);
}



FitCircleResult FitCircle(const XYPointList *pts, double stepSize, double epsilon) {  
  FitCircleResult result = {.x = 0, .y = 0, .r = 0, .failure = 1};

  size_t iter = 0;
  int status;

  gsl_multimin_function_fdf my_func;

  my_func.n = 3;                  /* number of function components */
  my_func.f = &my_f;              /* error function */   
  my_func.df = &my_df;            /* gradient function */  
  my_func.fdf = &my_fdf;          /* error and gradient function */
  my_func.params = (void *) pts;  /* data */

  const gsl_multimin_fdfminimizer_type *T =  gsl_multimin_fdfminimizer_conjugate_fr;
  gsl_multimin_fdfminimizer *s = gsl_multimin_fdfminimizer_alloc(T, 2);
  gsl_vector *x  = gsl_vector_alloc(2);

  /* Starting point, x, y, r = (0, 0, 1) */
  gsl_vector_set(x, 0, 0.0);
  gsl_vector_set(x, 1, 0.0);
  gsl_vector_set(x, 2, 0.0);

  gsl_multimin_fdfminimizer_set(s, &my_func, x, stepSize, epsilon);

  do {
    iter++;
    status = gsl_multimin_fdfminimizer_iterate(s);

    if (status)
      break;

    status = gsl_multimin_test_gradient(s->gradient, epsilon);

    if (status == GSL_SUCCESS) {
      result.failure = 0;
      result.x = gsl_vector_get(s->x, 0);
      result.y = gsl_vector_get(s->x, 1);
      result.r = gsl_vector_get(s->x, 2);
      printf("Minimum found at:\n");
    }

    printf ("%5d %.5f %.5f %.5f %10.5f\n", (int) iter,
        gsl_vector_get(s->x, 0),
        gsl_vector_get(s->x, 1),
        gsl_vector_get(s->x, 2),
        s->f);

  } while (status == GSL_CONTINUE && iter < 100);

  gsl_multimin_fdfminimizer_free(s);
  gsl_vector_free(x);

  return result;
}
