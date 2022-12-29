import GSL
using Printf


struct XYPt
    x::Float64
    y::Float64
    XYPt(x, y) = new(x, y)
end


function my_f(vars::Ptr{GSL.C.gsl_vector}, params::Ptr{Cvoid})
    varg = GSL.wrap_gsl_vector(vars)
    @show varg

    p = unsafe_load(params)
    pvec = convert(Ptr{GSL.C.gsl_vector}, params)
    parg = GSL.wrap_gsl_vector(pvec)
    @show parg
end


function main()
    n = 2
    v = GSL.vector_alloc(2)
    m = 1.414
    b = 1.732
    GSL.vector_set(v, 0, m)
    GSL.vector_set(v, 1, b)
    @show v

    p = GSL.vector_alloc(n)
    for i in 1:n
        GSL.vector_set(p, i - 1, i * 2.0)
    end
    @show p

    params = convert(Ptr{Cvoid}, p)

    my_f(v, params)
end

main()

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
