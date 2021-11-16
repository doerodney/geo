#include <stddef.h>
#include <gsl/gsl_multimin.h>
#include "pt.h"

void FitLine(gsl_multimin_function_fdf* my_func, double stepSize, double epsilon) {
  size_t iter = 0;
  int status;

  const gsl_multimin_fdfminimizer_type *T =  gsl_multimin_fdfminimizer_conjugate_fr;
  gsl_multimin_fdfminimizer *s = gsl_multimin_fdfminimizer_alloc(T, 2);
  gsl_vector *x  = gsl_vector_alloc(2);

  /* Starting point, m,b = (1,0) */
  gsl_vector_set(x, 0, 1.0);
  gsl_vector_set(x, 1, 0.0);

  gsl_multimin_fdfminimizer_set(s, my_func, x, stepSize, epsilon);

  do {
    iter++;
    status = gsl_multimin_fdfminimizer_iterate(s);

    if (status)
      break;

    status = gsl_multimin_test_gradient(s->gradient, epsilon);

    if (status == GSL_SUCCESS) {
      printf("Minimum found at:\n");
    }

    printf ("%5d %.5f %.5f %10.5f\n", (int) iter,
        gsl_vector_get(s->x, 0),
        gsl_vector_get(s->x, 1),
        s->f);


  } while (status == GSL_CONTINUE && iter < 100);

  gsl_multimin_fdfminimizer_free(s);
  gsl_vector_free(x);
}
