# Lispy

A basic Lisp interpreter in Nim

![Screenshot](https://github.com/James-P-D/Lispy/blob/master/screenshot.gif)

## Introduction

This a a simple console Lisp interpreter written in [Nim](https://nim-lang.org/). The application was written after following [Peter Norvig's Lisp interpreter in Python](http://norvig.com/lispy.html), although there were a number of changes which had to be made, largely due to Nim's inability to support lists (or rather, sequences, as they are known in Nim) which contain objects of different types, and Nim's static-typing.
 
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

We can enter more complex mathematical operations:

```
Lispy> (+ (- 10 5) (* 3 4))
17
```

We cna use `list` and `quote` to create lists:

```
Lispy> (list 1 2 3)
(1 2 3)
Lispy> (quote (1 2 3))
(1 2 3)
```

We can use `length`, `car` and `cdr`:

```
Lispy> (length (list 1 2 3))
3
Lispy> (car (list 1 2 3))
1
Lispy> (cdr (list 1 2 3))
(2 3)
```

We can use `member` and `cons`:

```
Lispy> (member 2 (list 1 2 3))
true
Lispy> (member 9 (list 1 2 3))
false
Lispy> (cons 0 (list 1 2 3))
(0 1 2 3)
```

We can use `if` and `=`, `!=`, `<`, `>`, `<=`, `>=`:

```
Lispy> (if (= 10 (+ 5 5) ) 111 999)
111
```

Note that the interpreter will not evaluate your expression until the number of open parentheses matches the number of closes. This allows you to enter multi-line expressions:

```
EXAMPLE HERE
```

When we are finished, enter `quit` to leave:

```
Lispy> quit
Bye!
```

## Compiling

The application was tested with Nim v1.2.4. You should be able to compile and run with the following command:

```
nim c -r lispy.nim
```