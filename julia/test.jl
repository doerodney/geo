import GSL
using Printf


struct XYPt
    x::Float64
    y::Float64
    XYPt(x, y) = new(x, y)
end



# function my_df(v::Ptr{GSL.C.gsl_vector}, params::Ptr{Cvoid}, df::Ptr{GSL.C.gsl_vector})::Cvoid
#     dedm::Cdouble = 0.0
#     dedb::Cdouble = 0.0

function my_f(_v::Ptr{GSL.C.gsl_vector}, _params::Ptr{Cvoid})::Cdouble
    err::Cdouble = 0.0
    
    vec = GSL.wrap_gsl_vector(_v)
    # @show vec
    m = vec[1]
    # @show m
    b = vec[2]
    # @show b

    params_vec = convert(Ptr{GSL.C.gsl_vector}, _params)
    params = GSL.wrap_gsl_vector(params_vec)
    # @show data
    # @show length(data)

    pt_count::Int64 = length(params)/2
    # @show pt_count
    idx = 1
    for i = 1:pt_count
        x = params[idx]
        idx += 1
        y = params[idx]
        idx += 1
        diff = y - m*x - b
        err += (diff * diff)
    end

    return err
end


function main()
    n = 2
    v = GSL.vector_alloc(2)
    m = 2.0
    b = 1.0
    GSL.vector_set(v, 0, m)
    GSL.vector_set(v, 1, b)
    # @show v

    count = 10
    p = GSL.vector_alloc(count * 2)
    idx = 0
    for x in 1:count
        # x:
        GSL.vector_set(p, idx, x)
        idx += 1
        # y = 3x + 4
        y = 3 * x + 4
        GSL.vector_set(p, idx, y)
        idx += 1
    end

    params = convert(Ptr{Cvoid}, p)

    err = my_f(v, params)
    @show err
end

main()

