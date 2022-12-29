import GSL
using Printf


struct XYPt
    x::Float64
    y::Float64
    XYPt(x, y) = new(x, y)
end


function my_f(v::Ptr{GSL.C.gsl_vector}, params::Ptr{Cvoid})
    vec = GSL.wrap_gsl_vector(v)
    @show vec

    pvec = convert(Ptr{GSL.C.gsl_vector}, params)
    data = GSL.wrap_gsl_vector(pvec)
    @show data
    @show length(data)
end


function main()
    n = 2
    v = GSL.vector_alloc(2)
    m = 2.0
    b = 1.0
    GSL.vector_set(v, 0, m)
    GSL.vector_set(v, 1, b)
    @show v

    count = 10
    p = GSL.vector_alloc(count * 2)
    idx = 0
    for x in 1:count
        # x:
        GSL.vector_set(p, idx, x)
        idx += 1
        # y:
        y = m * x + b
        GSL.vector_set(p, idx, y)
        idx += 1
    end

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
