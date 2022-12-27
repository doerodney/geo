using Printf

struct XYPt
    x
    y
    XYPt(x, y) = new(x, y)
end


function generate_points(count, m, b)
    xypts = []

    for x = 1:count
        y = m * x + b
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


function get_point_errorsq(xypt, m, b)
    err = xypt.y - m * xypt.x - b

    return err * err
end


function line_gradient_descent(xypts, mi, bi, step, max_steps, epsilon)
    m = mi
    b = bi

    err = get_error(xypts, m, b)
    (dm, db) = get_gradient(xypts, m, b)
    prev_err = 0

    found = false
    
    for step = 1:max_steps
        prev_err = err
        # Take a step down the gradient:
        m -= step * dm
        b -= step * db

        # Test the error in the new position:
        err = get_error(xypts, m, b)

        # As we get close to the solution, dm and db become zero.
        # Test for convergence:
        if abs(dm) < epsilon && abs(db) < epsilon
            @printf("(m, b) = (%g, %g) on step %d\n", m, b, step)
            found = true
            break
        end
        
        # Did the error increase?  If so, get a new gradient:
        if err > prev_err
            (dm, db) = get_gradient(xypts, m, b)
        end
    end
    
    if !found
        @printf("(m, b) = (%g, %g) after %d steps exhausted\n", m, b, max_steps)
    end

    return (m, b)
end


#--main--
xypts = generate_points(10, 2, 0)
err = get_error(xypts, 2, 0)
@printf("Error = %g for m = %g, b = %g\n", err, 2, 0)
# println(xypts)
m = 1
b = 1
err = get_error(xypts, m, b)
@printf("Error = %g for m = %g, b = %g\n", err, m, b)
step = 0.01
count = 100
epsilon = 0.01
line_gradient_descent(xypts, 1, 0, step, count, epsilon)