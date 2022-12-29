using Printf
import GSL

struct XYPt
    x::Float64
    y::Float64
    XYPt(x, y) = new(x, y)
end


# static double my_f(const gsl_vector *v, void *params) {
#   double m = gsl_vector_get(v, 0);
#   double b = gsl_vector_get(v, 1);
#   XYPointList *pts = (XYPointList*) params;

#   double diff = 0.0;
#   double err = 0.0;
#   XYPoint pt;
#   int failure;
#   for (int i = 0; i < pts->count; i++) {
#     failure = XYPointList_get(pts, i, &pt);
#     if (failure) {
#       break;
#     } else {
#       diff = (pt.y - (m * pt.x) - b);
#       err += diff * diff;
#     }
#   }

#   return err;
# }

function error_func(v::GSL.gsl_vector, params::Ptr{Cvoid})::Cdouble
    # Extract m,b from gsl_vector:
    covariates = GSL.wrap_gsl_vector(v)
    m = covariates[1]
    b = covariates[2]
    
    # Convert params from C void* to 
    


end

function generate_points(count, m, b)::Vector{XYPt}
    xypts = []::Vector{XYPt}

    for x = 1:count
        noise = rand(-10.0:10.0)/10.0
        y = m * x + b # + noise
        push!(xypts, XYPt(x, y))
    end

    return xypts
end


function get_error(xypts, m, b)
    err = 0

    for pt in xypts
        err += get_point_errorsq(pt, m, b)
    end

    # Convert residual sum of squares (a large number) to 
    # mean sum of squares (a smaller number)
    err /= length(xypts)

    return err
end


function get_gradient(xypts, m, b)
    dedm = 0
    dedb = 0

    for pt in xypts
        dedm += pt.x * (m * pt.x - pt.y + b)
        # dedm += m * pt.x * pt.x - pt.x * pt.y + b * pt.x;
        dedb += m * pt.x - pt.y + b;
    end

    return (dedm, dedb)
end


#--main--
n = 2

# Initial values of (m, b):
v0 = Cdouble[1.0, 0.0]
vinit = GSL.vector_alloc(n)
for i = 1:n
    GSL.vector_set(vinit, i - 1, v0[i])
end


xypts = generate_points(10, 2, 0)
err = get_error(xypts, 2, 0)
@printf("Error = %g for m = %g, b = %g\n", err, 2, 0)


my_func = GSL.gsl_multimin_function_fdf

my_func.

my_func.n = 2;                  /* number of function components */
my_func.f = &my_f;              /* error function */   
my_func.df = &my_df;            /* gradient function */  
my_func.fdf = &my_fdf;          /* error and gradient function */
my_func.params = (void *) pts;  /* data */
# println(xypts)
m = 1
b = 1
err = get_error(xypts, m, b)
@printf("Error = %g for m = %g, b = %g\n", err, m, b)
step = 0.01
count = 100
epsilon = 0.01
line_gradient_descent(xypts, 1, 0, step, count, epsilon)