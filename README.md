# Lispy

A basic Lisp interpreter in Nim

![Screenshot](https://github.com/James-P-D/Lispy/blob/master/screenshot.gif)

## Introduction

This a a simple console Lisp interpreter written in [Nim](https://nim-lang.org/). The application was written after following [Peter Norvig's Lisp interpreter in Python](http://norvig.com/lispy.html), although there were a number of changes which had to be made, largely due to Nim's inability to support lists (or rather, sequences, as they are known in Nim) which contain objects of different types, and Nim's static-typing.

## Compiling

The application was tested with Nim v1.2.4. You should be able to compile and run with the following command:

```
nim c -r lispy.nim
```
 
## Usage

After running the application you should see the following:

```
Lisp Interpreter
Enter an expression, or 'quit' to exit
Lispy>
```

We can use simple mathematical operations over integers:

```
Lispy> (+ 3 4)
7
```

Any mathematical operation involving floats will give a float result:

```
Lispy> (+ 3.0 4)
Eval: 7.0
Lispy> (+ 3.5 4)
Eval: 7.5
```

We can enter more complex mathematical operations:

```
Lispy> (+ (- 10 5) (* 3 4))
Eval: 17
```

We can use `list` and `quote` to create lists:

```
Lispy> (list 1 2 3)
Eval: (1 2 3)
Lispy> (quote (1 2 3))
Eval: (1 2 3)
```

In addition to integers and floats, we can use symbols:

```
Lispy> (list a b c)
Eval: (a b c)
```

We can use `length`, `car` and `cdr`:

```
Lispy> (length (list 1 2 3))
Eval: 3
Lispy> (car (list 1 2 3))
Eval: 1
Lispy> (cdr (list 1 2 3))
Eval: (2 3)
```

We can use `member` and `cons`:

```
Lispy> (member 2 (list 1 2 3))
Eval: true
Lispy> (member 9 (list 1 2 3))
Eval: false
Lispy> (cons 0 (list 1 2 3))
Eval: (0 1 2 3)
```

We have the usual `=`, `not`, `<`, `<=`, etc. operators:

```
Lispy> (= 5 5)
Eval: true
Lispy> (not (= 5 6))
Eval: true
Lispy> (> 5 6)
Eval: false
```

Note that the above operators expect parameters to be of the same type. If you wish to compare integers and floats you will need to use `int` and `float` to cast:

```
Lispy> (= 1 1.0)
Eval: false
Lispy> (= 1 (int 1.0))
Eval: true
Lispy> (= (float 1) 1.0)
Eval: true
```

We can use `if`:

```
Lispy> (if (= 10 (+ 5 5) ) 111 999)
Eval: 111
```

We can declare variables with `defvar`:

```
Lispy> (defvar nine 9)
Eval: nine
Lispy> (+ nine 10)
Eval: 19
```

We can declare functions with `deffun` and then call them:

```
Lispy> (deffun square (n) (* n n))
Eval: square
Lispy> (square 3)
Eval: 9
```

Note that the interpreter will not evaluate your expression until the number of open parentheses matches the number of closes. This allows you to enter multi-line expressions:

```
Lispy> (deffun factorial (x)
               (if (<= x 1)
                   1
                   (* x (factorial (- x 1)))))
Eval: factorial
Lispy> (factorial 5)
Eval: 120                            
```

When we are finished, enter `quit` to leave:

```
Lispy> quit
Bye!
```

## Known Issues

The biggest issue with this implementation is that there has been no attempt to cope with variable scoping. When you create a variable, or even create parameters when using `deffun`, you will be overwriting any previously known variables of the same name. Ideally the hash-table of variables should be housed inside a class which also contains a reference to a 'parent' instant of the class. This way newly added variables are added to the bottom of the chain. Any attempt to look-up the value of the variable will begin with the current (bottom) instant of the class, and then traceback through the chain until we find it. This way newly created variables don't clobber previous variables of the same name.

Perhaps this can be added later, but so far this project has taken up too much time already.