using Printf

using Optim

struct XYPt
    x
    y
    XYPt(x, y) = new(x, y)
end

 
function generate_points(m, b, count)
    xypts::Vector{XYPt} = []

    for i = 1:count
        x = i
        y = m * x + b
        pt = XYPt(x, y)
        push!(xypts, pt)
    end

    return xypts
end

 
function fit_line(m_initial, b_initial, xypts)

    function f(x)
        err = 0.0
        # m = x[1]
        # b = x[2]

        for pt in xypts
            y = x[1] * pt.x + x[2]
            diff = y - pt.y
            err += (diff * diff)
        end
        return err
    end


    function g!(G, x)
        dEdm = 0.0
        dEdb = 0.0
        # m = x[1]
        # b = x[2]
        for pt in xypts
            dEdm += pt.x * (x[1] * pt.x - pt.y + x[2])
            dEdb += x[1] * pt.x - pt.y + x[2]
        end

        G[1] = dEdm
        G[2] = dEdb
    end

    x = [m_initial, b_initial]
    results = optimize(f, g!, x, GradientDescent())
    @printf("minumum error: %g\n", results.minimum)
    @printf("optimized (m, b) = (%g, %g)\n", results.minimizer[1], results.minimizer[2])
    @printf("iterations: %d\n", results.iterations)
end


m = 1.23
b = 4.56
m_guess = -1.0
b_guess = -10.0
xypts = generate_points(m, b, 10)
fit_line(m_guess, b_guess, xypts)