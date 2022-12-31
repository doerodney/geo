using Printf
import GSL

struct XYPt
    x::Float64
    y::Float64
    XYPt(x, y) = new(x, y)
end

struct FitLineResult {
    b::Cdouble
    m::Cdouble
    x::Cdouble
    vertical::Cint
    failure::Cint
}

function my_f(_v::Ptr{GSL.C.gsl_vector}, _params::Ptr{Cvoid})::Cdouble
    err::Cdouble = 0.0
    
    m = GSL.vector_get(_v, 0)
    # @show m
    b = GSL.vector_get(_v, 1)
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

    @show err
    return err
end


function my_df(_v::Ptr{GSL.C.gsl_vector}, _params::Ptr{Cvoid}, _df::Ptr{GSL.C.gsl_vector})::Cvoid
    dedm::Cdouble = 0.0
    dedb::Cdouble = 0.0

    m = GSL.vector_get(_v, 0)
    # @show m
    b = GSL.vector_get(_v, 1)
    # @show b

    params_vec = convert(Ptr{GSL.C.gsl_vector}, _params)
    params = GSL.wrap_gsl_vector(params_vec)
    # @show params
    # @show length(params)

    pt_count::Int64 = length(params)/2
    # @show pt_count
    idx = 1
    for i = 1:pt_count
        x = params[idx]
        idx += 1
        y = params[idx]
        idx += 1
        dedm += (x * (m * x - y + b))
        dedb += (m * x - y + b)
    end

    @show dedm
    @show dedb

    GSL.vector_set(_df, 0, dedm)
    GSL.vector_set(_df, 1, dedb)

end

function my_fdf(_v::Ptr{GSL.C.gsl_vector}, _params::Ptr{Cvoid}, f::Ptr{Cdouble}, _df::Ptr{GSL.C.gsl_vector})::Cvoid
    err = my_f(_v, _params)
    unsafe_store!(f, err)
    my_df(_v, _params, _df)
end


function FitLine(_params::Ptr{GSL.C.gsl_vector}, step_size::Cdouble, tol::Cdouble)
    iter = 0
    err::Cint = 0

    # Initial values of (m, b):
    v = GSL.vector_alloc(2)
    m = 1.0
    b = 0.0
    GSL.vector_set(v, 0, m)
    GSL.vector_set(v, 1, b)

    # Convert data points vector to void pointer for library:
    params = convert(Ptr{Cvoid}, _params)

    # Create/init minimizer struct:
    my_func::GSL.gsl_multimin_function_fdf
    my_func.n = 2           # number of function components
    my_func.f = my_f        # v error function    
    my_func.df = my_df      # gradient function  
    my_func.fdf = my_fdf    # error and gradient function
    my_func.params = params # data

    state = GSL.gsl_multimin_fdfminizer_alloc(GSL.gsl_multimin_fdfminimizer_conjugate_fr, 2)
    GSL.gsl_multimin_fdf_minimizer_set(state, my_func, v, step_size, tol)

    # TODO:  
    # Add iteration loop
    # Add return value
end


function main()
    step_size::Cdouble = 0.01
    tol::Cdouble = 0.0001

    # Generate data points for a different (m, b) that is not 
    # equal to the initial guess of (m, b):
    m_gen = 3.0
    b_gen = 4.0

    count = 10
    p = GSL.vector_alloc(count * 2)
    idx = 0

    # x,y points are put into the vector in Xn, Yn, Xn+1, Yn+1 ... order:
    for x in 1:count
        # x:
        GSL.vector_set(p, idx, x)
        idx += 1
        # Add random noise to y:
        noise = rand(-10.0:10.0)/100.0
        y = m_gen * x + b_gen + noise

        GSL.vector_set(p, idx, y)
        idx += 1
    end

    params = convert(Ptr{Cvoid}, p)

    