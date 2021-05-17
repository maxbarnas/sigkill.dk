-- # Finding roots of cubic equations using iterative versus analytic techniques
--
-- The book *Evaluating Derivatives* states that although "the roots
-- of cubic and even quartic equations can be expressed in terms of
-- arithmetic operations and fractional powers, it is usually more
-- efficient to calculate them by an iterative process", and then goes
-- on to describe [Newton's
-- method](https://en.wikipedia.org/wiki/Newton%27s_method).
-- Certainly, the analytical formulae for solving cubic equations [on
-- Wikipedia](https://en.wikipedia.org/wiki/Cubic_equation#Depressed_cubic)
-- look awful, but Newton's method uses loops!  Surely that's worse.

-- ## The iterative solution
--
-- Well, let's see.  This is implemented in [my favourite programming
-- language](https://futhark-lang.org).  We'll start by defining
-- Newton's method for functions of type `f64 -> f64` in a
-- straightforward manner, parameterised by tolerance `eps` and
-- starting point `x0`:

let newton (eps: f64) (x0: f64) (f: f64 -> f64) (f': f64 -> f64) =
  loop x = x0 while f64.abs(f x) > eps do x - f x / f' x

-- Then we define an evaluation function for cubic functions of the
-- form *ax³+bx²+cx+d*, as well as the derivative *3ax²+2bx+c*.

let cubic a b c d x : f64 =
  a*x**3 + b*x**2 + c*x + d

let cubic' a b c _d x : f64 =
  3 * a * x**2 + 2 * b * x + c

-- Now we can put these pieces together and get an iterative solver
-- for finding a root of a cubic function:

let newton_cubic_root eps x0 a b c d =
  newton eps x0 (cubic a b c d) (cubic' a b c d)

-- Cubic functions always have at least one real root, but may have
-- more.  This method finds one of them:

-- > newton_cubic_root 0.0001 0.0 4.0 5.0 (-6.0) (-8.0)

-- > cubic 4.0 5.0 (-6.0) (-8.0) (newton_cubic_root 0.00001 0.0 4.0 5.0 (-6.0) (-8.0))

-- ## The analytical solution
--
-- The following is the analytical solution.  As above, it finds the
-- first real root and ignores the others (if they exist).

let cubic_root a b c d : f64 =
  let b = b / a
  let c = c / a
  let d = d / a
  let q = (3*c - b*b)/9
  let r = -27*d + 9*c*b - 2*(b*b*b)
  let r = r / 54
  let disc = q*q*q + r*r
  let term1 = b/3
  in if disc > 0 then
        let s = r + f64.sqrt disc
        let s = if s < 0 then -((-s)**(1/3)) else s**(1/3)
        let t = r - f64.sqrt disc
        let t = if t < 0 then -((-t)**(1/3)) else t**(1/3)
        in -term1 + s + t
     else if disc == 0 then
          let r13 = if r < 0 then -(-r)**(1/3) else r**(1/3)
          in -term1 + 2*r13
     else let q = -q
          let r13 = 2*f64.sqrt q
          in -term1 + r13*f64.cos(q**3/3)

-- "Analytic" it may be, but given the vagaries of floating point
-- computation, I'm not certain it's significantly more accurate than
-- the iterative method in practice.

-- > cubic_root 4.0 5.0 (-6.0) (-8.0)

-- > cubic 4.0 5.0 (-6.0) (-8.0) (cubic_root 4.0 5.0 (-6.0) (-8.0))

-- ## Benchmarking
--
-- Now let's try benchmarking.  Newton's method is extremely sensitive
-- to the starting point.  I somewhat arbitrarily decide on `x0=0`.
-- It would run substantially faster with `x0=-1` for the randomly
-- generated coefficients we'll use (all uniformly drawn from
-- `[0,1]`), but that feels like cheating.

entry bench_newton = map4 (newton_cubic_root 0.00001 0)

entry bench_cubic_root = map4 cubic_root

-- We'll benchmark on 100k sets of coefficients.

-- ==
-- entry: bench_newton bench_cubic_root
-- random input { [100000]f64 [100000]f64 [100000]f64 [100000]f64 }

-- And the results, using plain sequential execution:

-- ```
-- cubic.fut:bench_newton:
-- [100000]f64 [100000]f64 [100000]f64 [...:       2718μs (RSD: 0.081; min:  -6%; max: +17%)
--
-- cubic.fut:bench_cubic_root:
-- [100000]f64 [100000]f64 [100000]f64 [...:       5574μs (RSD: 0.010; min:  -1%; max:  +2%)
-- ```

-- So indeed, Newton's method seems faster.  And this is with a very
-- naive implementation: it would be *much* faster (10x for `x0=-1`)
-- if we put a little bit more effort into finding a good starting
-- point.  In contrast, while there are special cases of cubic
-- functions that are easier to find roots for, I don't think the
-- general case can be solved much better than we are doing here.  But
-- who knows, maybe it can - I'm not that much of an expert here.
