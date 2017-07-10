Writing a Single-Stepping Interpreter with Monads
===

One nice thing about Haskell monads - perhaps the nicest - is how they
permit separation of concerns.  You can write code in a
straightforward way, without knowing that underneath it all, all kinds
of implicit control flow may be happening.  Usually, when we use
monads in Haskell, we use the standard ones: `Maybe`, `Either`, lists,
and so on.  When we design our programs, use tend to use compositions
of `Reader`, `Writer`, `State`, and probably `IO` somewhere.  This is
fine.  Going overboard with odd monadic effects is probably not good
for readability.  But, sometimes it is important to remember that
defining your own idiosyncratic monad can allow an elegant
implementation of something seemingly very complicated.  In this
Literate Haskell program, we will see how to implement an
single-stepping interpreter for a very simple Lisp dialect, structured
in a monadic style.  In fact, the single-stepping support is going to
be a minuscule part of the overall code.  Please note that when we
write "Lisp", we mean a highly cut-down and simplified language that
bears only a superficial resemblance to modern industrial Lisp
dialects.

This is not a monad tutorial.  This program will not be comprehensible
unless you already know how to work with monads in Haskell.  All I am
trying to do is demonstrate a technique that I find cool.

First, we need the usual module boilerplate.  Three of the four
imports are for the small command line interface we will add near the
end.

> module Main (main) where
>
> import Control.Monad (ap, liftM)
> import Data.Char (isSpace, isDigit)
> import System.Environment (getArgs)
> import Text.ParserCombinators.ReadP

S-Expressions
---

In Lisp, the same structure is used for representing both code and
data values: the so-called *S-expression*.  An S-expression is either
an *atom* or a *cons cell* (or just *cons*).  A cons is just a pair of
two other values, called `car` and `cdr` for ancient and arcane
reasons.  An atom is either a symbol or a number.  We encapsulate this
as one data type:

> data SExp = Cons SExp SExp | Symbol String | Number Int

We print a cons as `(a . b)`, where `a` and `b` are its constituents.
There are two special cases:

  * if `b` is itself a cons `(c . d)`, we print `(a c . d)`, and
    recursively.

  * if `b` is the symbol `nil`, then we print simply `(a)`.

By convention, the empty list is represented as the symbol `nil`.
These conventions let us print the common case of a linked list as `(a
b c)` instead of `(a . (b . (c . nil)))`.  We implement the printing
as an instance of the `Show` typeclass - I am not normally a fan of
using this for human-readable information, but I do not wish to
include a prettyprinting library for this program.

> instance Show SExp where
>  show (Symbol s) = s
>  show (Number x) = show x
>  show (Cons a b) = "(" ++ show a ++ recurse b ++ ")"
>    where recurse (Symbol "nil")          = ""
>          recurse (Cons c d)              = " " ++ show c ++ recurse d
>          recurse x                       = " . " ++ show x

We can turn any Haskell list of S-expressions into an S-expression
that represents that same list, using the `car`s to contain the head,
and the `cdr` the link to the tail of the list.  We use the symbol
`nil` to represent the empty list.

> toSExp :: [SExp] -> SExp
> toSExp []     = Symbol "nil"
> toSExp (x:xs) = Cons x (toSExp xs)

We can also try to convert a SExp to a Haskell list of SExps, although
this is not guaranteed to work.

> fromSExp :: SExp -> Maybe [SExp]
> fromSExp (Symbol "nil") = Just []
> fromSExp (Cons car cdr) = do cdr' <- fromSExp cdr
>                              Just $ car : cdr'
> fromSExp _              = Nothing

The Monad
---

Before we write the evaluation functions, we'll define the `InterpM`
monad we will be using.  Computation can be in three different states:
either we have a value (`Result`), we have encountered an error during
evaluation (`Error`), or we are at a *stepping point* (`Step`).  This
is a labeled breakpoint in execution where we have the option of
continuing execution by executing the embedded monadic value.  Or we
can stop.  Or we can save the state for later.  This is very similar
to continuation-passing style (and indeed, the `InterpM` monad is just
a special case of a continuation monad).

> data InterpM a = Result a
>                | Error String
>                | Step String (InterpM a)

The `Monad` instance is completely straightforward by the types.

> instance Monad InterpM where
>   return = Result
>   fail = Error
>
>   Result x       >>= f = f x
>   Error s        >>= _ = Error s
>   Step desc path >>= f = Step desc (path >>= f)

The `Functor` and `Applicative` instances, which are required in GHC
versions newer than 7.8, are completely mechanical.

> instance Functor InterpM where
>   fmap = liftM
>
> instance Applicative InterpM where
>   pure = return
>   f <*> x = f `ap` x

We wrap the `Step` constructor in a function to create a veneer of
abstraction.  In principle, the monad could be much more complicated
(it would be in most practical implementations), but with a similarly
simple interface.

> step :: String -> InterpM a -> InterpM a
> step = Step

The Interpreter
---

We are now ready to implement our Lisp interpreter.  First, we define
our variable table, which is a mapping from variable names to their
values.  Values are, of course, just S-expressions.

> type VarTable = [(String,SExp)]

Evaluation with the `eval` function happens in the context of a
variable table, and evaluates an S-expression, giving back an
`InterpM` action.  Thus, we might get a result (if evaluation
finished), an error, or a stepping point, where we can choose to
continue execution.

> eval :: VarTable -> SExp -> InterpM SExp

We will need a few building blocks before we can define the `eval`
function itself.  And most importantly, we must understand how Lisp is
evaluated.  A Lisp *form* is a list `(x y z...)`.  The first element
of the list is called the *operator*, and the remaining elements the
*operands*.  In the general case, the operator is the name of a
function, and the operands are recursively evaluated, with the
operator applied to the results.  However, some forms are *special
forms*, which have specialised evaluation semantics.  Our Lisp dialect
has a few of those, which we will discuss when we get to them.

The most basic evaluation rule is that the operator of a form must be
a symbol, so we define a helper function for determining whether an
S-expression is a symbol.

> isSymbol :: SExp -> Maybe String
> isSymbol (Symbol v) = Just v
> isSymbol _          = Nothing

The operands of a form must constitute a valid list, which we can
check using the previously defined `fromSExp` function.

> getOperands :: SExp -> InterpM [SExp]
> getOperands = maybe (fail "Invalid form") return . fromSExp

Once we have the name of a function, we must also be able to call it.
This is the job of `getFunction`, which returns a Haskell function
corresponding to a named Lisp function.

> getFunction :: String -> InterpM (VarTable -> [SExp] -> InterpM SExp)

Before we give `getFunction` a definition, let's define `eval`.  We
use `step` to create a stepping point before any S-expression is
evaluated, followed by matching on the structure of the S-expression.

> eval vt sexp = step ("Evaluating " ++ show sexp) $
>   case sexp of

The simplest case is a number, which evaluates to itself.

>     Number x -> return $ Number x

Symbols are looked up in the variable table.

>     Symbol v -> case lookup v vt of
>                     Nothing -> fail $ "Unknown variable: " ++ v
>                     Just se -> return se

The only special form in our Lisp is `quote`, which produces its
single operand *without evaluating it*.  Thus, `(quote a)` evaluates
to the symbol `a`, and `(quote (a b c))` to the list `(a b c)`.  This
special form is how we write literal Lisp data.

>     Cons (Symbol "quote") cdr ->
>       case fromSExp cdr of
>         Just [x] -> return x
>         _        -> fail $ "Bad arguments to quote: " ++ show cdr

If the operator is not `quote`, then it must be the name of a
function.  We use `getFunction` to get the corresponding Haskell
function, evaluate the operands, then apply the function to the
evaluated operands.  We also create a stepping point, just for good
measure.

>     Cons (Symbol operator) rest -> do
>       operator' <- getFunction operator
>       args <- getOperands rest
>       args' <- mapM (eval vt) args
>       step ("Applying " ++ operator ++ " to " ++ show (toSExp args')) $
>         operator' vt args'

If none of the previous cases matched, then the S-expression must be
malformed.

>     Cons car cdr ->
>      fail ("Bad form: " ++ show (Cons car cdr))

The definition of `getFunction` is mostly uninteresting.  This is
where we put built-in functions.  One of those is `list`, which takes
any number of arguments, and simply returns them.

> getFunction "list" = return $ const $ return . toSExp

The `cons` function takes two arguments, and returns a cons cell
containing them.

> getFunction "cons" = return $ \_ args ->
>   case args of
>     [x, y] -> return $ Cons x y
>     _      -> fail $ "Wrong number of arguments to cons: " ++ show args

The functions `car` and `cdr` are used to access the components of a
cons cell.

> getFunction "car" = return $ \_ args ->
>   case args of
>     [Cons car _] -> return car
>     _            -> fail $ "Bad arguments to car: " ++ show args
> getFunction "cdr" = return $ \_ args ->
>   case args of
>     [Cons _ cdr] -> return cdr
>     _            -> fail $ "Bad arguments to cdr: " ++ show args

We also have the usual arithmetic operators on numbers.

> getFunction "+" = return $ \_ args ->
>   case args of
>     [Number x, Number y] -> return $ Number $ x+y
>     _                    -> fail $ "Invalid arguments to +: " ++ show args
> getFunction "-" = return $ \_ args ->
>   case args of
>     [Number x, Number y] -> return $ Number $ x-y
>     _                    -> fail $ "Invalid arguments to -: " ++ show args
> getFunction "/" = return $ \_ args ->
>   case args of
>     [Number x, Number y] -> return $ Number $ x `div` y
>     _                    -> fail $ "Invalid arguments to /: " ++ show args
> getFunction "*" = return $ \_ args ->
>   case args of
>     [Number x, Number y] -> return $ Number $ x*y
>     _                    -> fail $ "Invalid arguments to *: " ++ show args

The most interesting built-in function is `apply`.  The `apply`
function takes two arguments: the first represents a function, the
second a list of arguments, and `apply` applies the function to those
arguments.  The simplest case is the one where the first argument is a
symbol - we just call the function with that name.

> getFunction "apply" = return $ \vt args ->
>   case args of
>     [Symbol fname, fargs]
>       | Just fargs' <- fromSExp fargs -> do
>           f <- getFunction fname
>           step ("Calling " ++ fname ++ " with arguments " ++ show fargs) $
>             f vt fargs'

More interestingly, we also permit the function argument to be a
*lambda form*.  This is an S-expression with the structure `(lambda
(params...) body)`.  When `apply` is given a lambda form, it binds the
named parameters to given arguments (they must match in number) and
evaluates the body.

>     [Cons (Symbol "lambda") rest, fargs]
>       | Just fargs' <- fromSExp fargs,
>         Just [params, body] <- fromSExp rest,
>         Just params' <- mapM isSymbol =<< fromSExp params,
>         length params' == length fargs' -> do
>        step ("Calling lambda with parameters " ++ show params ++
>              " bound to " ++ show fargs) $
>          eval (zip params' fargs' ++ vt) body
>     _ -> fail $ "Invalid arguments to funcall: " ++ show args

If `apply` is given anything else, it reports an error.

> getFunction f = fail ("Unknown function: " ++ f)

Apart from the calls to `step`, the above Lisp interpreter is
completely bog-standard.  The single-stepping capability has not
intruded upon the way we structured the functions.  Yet, the
capability is there, and we can use it to create an interesting
frontend, where the user is prompted before every evaluation step.

> stepIO :: SExp -> IO ()
> stepIO = loop . eval mempty
>   where loop (Result v) = do
>           putStrLn $ "Evaluation finished.  Result: " ++ show v
>         loop (Error err) = do
>           error err
>         loop (Step desc s) = do
>           putStrLn $ desc ++ " (press Enter to continue)"
>           _ <- getLine
>           loop s

This frontend could easily be made much more sophisticated - for
example, it could allow the user to move backwards in time, or inspect
the variable table (although this would require an extension of the
monad).

A Small Parser
---

To tie it all together, we define a quick little Lisp parser.  Note
that this one does not support the dotted-pair notation for conses.

> token :: ReadP a -> ReadP a
> token p = skipSpaces >> p
>
> schar :: Char -> ReadP Char
> schar = token . char
>
> numberOrSymbol :: ReadP SExp
> numberOrSymbol = token $ do s <- munch1 $ \c -> not (isSpace c || c `elem` "()")
>                             return $ if all isDigit s then Number $ read s
>                                      else Symbol s
> readSExp :: ReadP SExp
> readSExp = numberOrSymbol
>        +++ between (schar '(') (schar ')') sexps
>   where sexps = many readSExp >>= return . toSExp
>
> parseString :: String -> Either String SExp
> parseString s =
>   case readP_to_S (do {e <- readSExp; token eof; return e}) s of
>       [(e, [])] -> Right e
>       _         -> Left "Parse error"
>

Command Line Usage
---

Finally, we create a `main` function that allows us to run this very
file as a Haskell program.

> main :: IO ()
> main = do
>   args <- getArgs
>   case args of
>     [f] -> do s <- readFile f
>               case parseString s of
>                 Right sexp -> stepIO sexp
>                 Left err   -> error err
>     _ -> error "Needs an argument."

While this Lisp dialect is quite limited (in particular, dynamic
scoping is an anachronism), it is still more expressive than you may
think.  We can use lambda forms to simulate local variables and named
functions.  For example, if we put the following program in `double.lisp`:

```
(apply (quote (lambda (square)
                 (apply square (list 2))))
 (list (quote (lambda (x) (* x x)))))
```

Then we can run our interpreter on it as such:

```
$ runhaskell stepping.lhs double.lisp
Evaluating (apply (quote (lambda (square) (apply square (list 2)))) (list (quote (lambda (x) (* x x))))) (press Enter to continue)

Evaluating (quote (lambda (square) (apply square (list 2)))) (press Enter to continue)

Evaluating (list (quote (lambda (x) (* x x)))) (press Enter to continue)

Evaluating (quote (lambda (x) (* x x))) (press Enter to continue)

Applying list to ((lambda (x) (* x x))) (press Enter to continue)

Applying apply to ((lambda (square) (apply square (list 2))) ((lambda (x) (* x x)))) (press Enter to continue)

Calling lambda with parameters (square) bound to ((lambda (x) (* x x))) (press Enter to continue)

Evaluating (apply square (list 2)) (press Enter to continue)

Evaluating square (press Enter to continue)

Evaluating (list 2) (press Enter to continue)

Evaluating 2 (press Enter to continue)

Applying list to (2) (press Enter to continue)

Applying apply to ((lambda (x) (* x x)) (2)) (press Enter to continue)

Calling lambda with parameters (x) bound to (2) (press Enter to continue)

Evaluating (* x x) (press Enter to continue)

Evaluating x (press Enter to continue)

Evaluating x (press Enter to continue)

Applying * to (2 2) (press Enter to continue)

Evaluation finished.  Result: 4
```

Limitations and Extensions
---

The interpreter implemented here is a toy.  The primary limitation is
that the monad is entirely special-purpose.  We do not re-use a
standard error monad, nor do we use a `Reader` for passing around the
variable table.  Futhermore, the stepping points give us too little
information.  One bit that would be nice to have would be the
*evaluation depth*, which would allow us to create a command for
saying "evaluate the current expression to completeness without
prompting me about the intermediate steps".  This command would be
implemented by always following `Step`s (without prompting) until the
starting depth is reached again.  Such a facility is crucial for
fast-forwarding to the interesting parts of the computation.
