---
title: Are functions everything in Haskell?
author: Peirong
github: peironggg
description: Functions are first-class in Haskell, but there are other interesting and important constructs in Haskell.
tags: haskell
---

# Learning Haskell

When I first started picking up Haskell, there was an overwhelming
emphasis on treating functions as "first-class citizens". As I peeled
away the layers of abstraction and understood what I am actually
learning, I came to realise that having functions as king isn't
necessarily the defining characteristic of Haskell. You see, functions
are also accorded "first-class citizens" status in other languages like
Java or JavaScript. You can pass them around as arguments, return them
from functions and do almost everything you can with them as if they
were primitives like booleans or numbers. So if functions aren't what
makes Haskell unique, what makes a functional programming language like
Haskell special compared to other languages?

I think my answer is monads. Monads are basically contexts that wrap
around a value and give meaning - whether a value exists for instance -
to the numbers or strings that are encapsulated within them. They affect
the values you get when you operate on them (depending on what the
context is) and are stackable. That means if you have one monad called
*Maybe* which contains information on whether the value underneath
exists, you can stack another monad called *IO* on top of it that
asserts that you are performing I/O operations on the value underneath.

![lego-piece](/images/blogposts/lego-piece.jpg)

*Figure 1: One single monad*

![lego-stack](/images/blogposts/lego-stack.jpg)

*Figure 2: Monads in a conventional Haskell project*

This means that it is easy for a person coming from an imperative
background to get lost amid the multiple monads you are operating under.
Each time you need a new functionality/context, stack another monad on
top. In a way, there are n-dimensions going on at any point in time
(corresponding to the n monads stacked together)[^1]. Contrast this to
programming in JavaScript, where all the information you need are either
laid out in a 1-dimensional object consisting of key-value pairs OR you
have to do a manual check for whether a value is *undefined* instead of
wrapping it in a *Maybe* container. This means navigating a Haskell
codebase requires more vertical traversals -- you move up/down from one
monad to another -- while navigating a JavaScript codebase involves more
horizontal traversals -- you move from one component of the codebase to
another -- and that is a change in approach that stumped me initially.

The reason why I am emphasising monads is because MOST MEANINGFUL THINGS
you want to do in Haskell involves monads but I think they are not
emphasised enough in introductory courses and students like myself will
not pay extra attention to them because they sound so strange. But
monads are the core of functional programming!

Another thing that makes Haskell special is the soundness of its type
checks. Wait, you go. Don't all strongly-typed languages enforce types
by definition? Well, not exactly. Most people who start learning Haskell
usually have some experience with strongly-typed languages like Java.
But because of the need for backward-compatibility, generic types --
basically types that can change depending on the use-case -- are
"erased" during compilation. That means that you can assign
wrongly-typed variables on purpose and the Java compiler will not catch
it until the variable hits some function expecting something else during
runtime and explodes! [^2]

```java
static String firstOfFirst(List<String>... strings) {
    List<Integer> ints = Collections.singletonList(42);
    Object[] objects = strings;
    objects[0] = ints; // Heap pollution

    return strings[0].get(0); // ClassCastException
}
```

*Figure 3: Example of ClassCastException (explosion) in Java*

Haskell is able to avoid this by staying true to the meaning of types
and not budging on type checks. This means a ***String is a String***. It is not "similar" to another type like *Text*
or a subclass because Haskell's type system doesn't support subtyping!

Once you understand everything is based on monads and the types of the
monads mean only ONE thing, I think you are well on your way to
dissecting a full-fledged Haskell codebase. Just keep in mind: whenever
you are frustrated at trying to figure out what the type is, take a deep
breath and hark back to the days when you received a value of
*undefined* in Javascript.

[^1]: This may sound like Haskell is more complicated than other
    languages for the sake of complexity but that's not true. Rather, it
    is just a different way of using structures to do stuff and that may
    be unfamiliar to most of us that start off with Java or JavaScript.

[^2]: Of course, it is a little bit more complicated than that.

# References
    https://docs.oracle.com/javase/tutorial/java/generics/nonReifiableVarargsType.html
