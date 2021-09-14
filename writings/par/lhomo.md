---
title: List Homomorphisms and Parallelism
---

# List Homomorphisms and Parallelism

A *list homomorphism* is a function `h` on lists for which there
exists an
[associative](https://www.theochem.ru.nl/~pwormer/Knowino/knowino.org/wiki/Associativity.html)
binary operator `⊙` such that

```
h (x ++ y) = h x ⊙ h y
```

for any `x` and `y`, where `++` denotes list concatenation.  Or to put
it another way, a function `h` is a list homomorphism if we can split
the input list any way we wish, apply `h` to the parts independently,
and combine the results using some operator `⊙`.

Simple examples of list homomorphisms:

* The identity function, with `⊙` being `++`.
* Summation, with `⊙` being `+`.

Operationally, when computing a list homomorphism we can split the
input into any number of *chunks*, compute a result per chunk, and
then combine the results into a final result for the whole list.  Each
chunk can be processed independently of the others, in parallel.  For
the purpose of this text, we can consider "list" to mean "array",
which is perhaps more practical.  We will not depend on our "lists"
having the behaviour of linked lists, and using linked lists would
actually inhibit parallelisation.

In principle `h` need not be defined for empty inputs, but we'll assume that it is, such that
```
h [] = e
```
where `e` is necessarily an [identity element](https://en.wikipedia.org/wiki/Identity_element) for `⊙`.  This is strictly not required for a list homomorphism, but it makes the following discussion simpler.

## Example of a nontrivial homomorphism

The [maximum sum subarray
problem](https://en.wikipedia.org/wiki/Maximum_subarray_problem) (also
known as *maximum segment sum*) is about finding the largest sum of a
subarray `A[i:j]` of some array `A`.  This is not a list
homomorphism - knowing `mssp x` and `mssp y` is not enough to compute
`mssp (x++y)`.  Example:

```
mssp [3,-1,2]               = 3
mssp [2,-1,3]               = 3
mssp ([3,-1,2] ++ [2,-1,3]) = 4
```

But if we extend the domain a bit, we can indeed obtain a
homomorphism.  Instead of computing just the maximum sum, we will
compute a tuple with four non-negative integer elements:

1. The maximum subarray sum (i.e., the final result we are actually interested in).

2. The maximum subarray sum starting from the *first* element.

3. The maximum subarray sum ending at the *last* element.

4. The sum of the entire array.

Now define a function `f` that morally computes such a tuple for
single element subarrays:

```
f x = (max x 0, max x 0, max x 0, x)
```

Then we define an associative operator for combining our tuples:

```
(mssx, misx, mcsx, tsx) ⊙ (mssy, misy, mcsy, tsy) =
  (max mssx (max mssy (mcsx + misy)),
   max misx (tsx+misy),
   max mcsy (mcsx+tsy),
   tsx + tsy)
```

(Proof of associativity left for the reader.)  This operator has an
identity element:

```
e = (0, 0, 0, 0)
```

Now we can define a list homomorphism for solving the MSSP:

```
h []       = e
h [x]      = f x
h (x ++ y) = h x ⊙ h y
```

In a real parallel language, we would probably write this as

```
reduce ⊙ e (map f A)
```

Why is this the same?  Keep reading!

## The list homomorphism theorems

The first two *list homomorphism theorems* were published by Richard
S. Bird in 1987, and the third by Gibbons in 1995 (although he notes
it had appeared as a "folk theorem" before then).  Especially the
Gibbons paper (link below) is recommended reading for a precise
exposition that clarifies some things I'm leaving fuzzy here.

### The first homomorphism theorem

If `h` is a list homomorphism, then there is an operator `⊙` and
function `f` such that

```
h xs = reduce ⊙ e (map f xs)
```

This theorem means that we can represent a list homomorphism as a
function `f : a -> b`, an associative binary operator `⊙ : b -> b ->
b`, and its identity element `e`.  In many cases `f` is merely the
identity function, which gives us the `reduce` commonly found in
parallel programming systems.

### The second homomorphism theorem

If `(f,⊙,e)` represents a list homormorphism, then

```
reduce ⊙ e (map f xs) = foldl ⊕ e xs = foldr ⊗ e ys
```

where
```
a ⊕ b = f a ⊙ b
```
and
```
a ⊗ b = a ⊙ f b
```

This means that any list homomorphism can be computed with either a
left or a right
[fold](https://en.wikipedia.org/wiki/Fold_(higher-order_function))
using a *specialised function* derived from `⊙` and `f`.  This is
essentially a form of [loop
fusion](https://en.wikipedia.org/wiki/Loop_fission_and_fusion), as it
allows us to avoid manifesting the result of the `map`.  In a parallel
implementation of reduction, we might break the input into a chunk per
processor, then use the second list homomorphism theorem to compute an
optimised sequential fold for each chunk.

### The third homomorphism theorem

If `h` can be expressed with both a leftwards and rightwards fold,
then `h` is also a list homomorphism.  This implies that if we can
write a function as both a leftwards and a rightwards fold, *then we
can write that function as a parallel reduction*.

Unfortunately, Gibbons' proof of the theorem does not tell us exactly
how to construct the (`f`, `⊙`, `e`).  We know it must exist, but not
what it looks like.  It also does not promise that the homomorphism is
going to be as asymptotically efficient as any of the original folds.
In particular, it would be nice if we could take a fold implementing
[Kadane's
algorithm](https://en.wikipedia.org/wiki/Maximum_subarray_problem#Kadane's_algorithm)
and mechanically derive the solution to MSSP shown above.  Still, this
theorem can inspire us to look for a parallel implementation.

## References

* *An Introduction to the Theory of Lists* ([pdf](https://www.cs.ox.ac.uk/files/3378/PRG56.pdf)), by Richard S. Bird (1987)

* *The Third Homomorphism Theorem* ([pdf](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.45.2247&rep=rep1&type=pdf)), by Jeremy Gibbons (1995)
