###########################
## Imports
###########################

import strutils
import sequtils
import sugar
import tables
import typetraits

include parser
include evaluator

###########################
## lispObjectToString1()
###########################

proc lispObjectToString1(item: LispObject): string =
    result = ""
    if (item.kind == lispObjectInt):
        result = result & $(item.intVal) & " "
    elif (item.kind == lispObjectFloat):
        result = result & $(item.floatVal) & " "
    elif (item.kind == lispObjectBool):
        result = result & $(item.boolVal) & " "
    elif (item.kind == lispObjectSymbol):
        result = result & $(item.symbolVal) & " "
    elif (item.kind == lispObjectList):
        result = result & " ("
        for sub_item in item.listVal:
            result = result & lispObjectToString1(sub_item)
        result = result.strip(trailing = true)
        result = result & ") "

###########################
## lispObjectToString()
###########################
        
proc lispObjectToString(item: LispObject): string =
    result = lispObjectToString1(item)
    result = result.strip(trailing = true)
    
###########################
## readInput()
###########################

proc readInput(): string =
    # Read string from stdin
    result = readLine(stdin)
    # And keep reading until the number of open and close parentheses matches.
    # This will allow for multi-line input. Don't worry about balencing of
    # parentheses, parse() can figure that out
    while (count(result, "(") != count(result, ")")):
        result = result & " " & readLine(stdin)

###########################
## testCases()
###########################

proc testCases() =     
    # Arithmatic Test Cases
    doAssert "10"                   == lispObjectToString(eval(parse("(+ 6 4)")))
    doAssert "10.0"                 == lispObjectToString(eval(parse("(+ 6.0 4)")))
    doAssert "10.5"                 == lispObjectToString(eval(parse("(+ 6.0 4.5)")))
    doAssert "2"                    == lispObjectToString(eval(parse("(- 6 4)")))
    doAssert "2.0"                  == lispObjectToString(eval(parse("(- 6.0 4)")))
    doAssert "1.5"                  == lispObjectToString(eval(parse("(- 6.0 4.5)")))
    doAssert "12"                   == lispObjectToString(eval(parse("(* 3 4)")))
    doAssert "12.0"                 == lispObjectToString(eval(parse("(* 3 4.0)")))
    doAssert "3"                    == lispObjectToString(eval(parse("(/ 10 3)")))
    doAssert "3.333333333333334"    == lispObjectToString(eval(parse("(/ 10 3.0)")))
    
    # Casting Test Cases
    doAssert "1"                    == lispObjectToString(eval(parse("(int 1.1)")))
    doAssert "2"                    == lispObjectToString(eval(parse("(int 1.9)")))
    doAssert "1.0"                  == lispObjectToString(eval(parse("(float 1)")))    
    
    # Equality Test Cases
    doAssert "true"                 == lispObjectToString(eval(parse("(= 10 10)")))
    doAssert "false"                == lispObjectToString(eval(parse("(= 10 11)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(= (+ 5 5) (+ 9 1))")))    
    doAssert "true"                 == lispObjectToString(eval(parse("(> 6 5)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(> 6 5 4 3 2 1)")))
    doAssert "false"                == lispObjectToString(eval(parse("(> 5 6)")))
    doAssert "false"                == lispObjectToString(eval(parse("(> 6 5 4 3 2 7)")))    
    doAssert "true"                 == lispObjectToString(eval(parse("(< 5 6)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(< 1 2 3 4 5 6)")))
    doAssert "false"                == lispObjectToString(eval(parse("(< 6 5)")))
    doAssert "false"                == lispObjectToString(eval(parse("(< 7 2 3 4 5 6)")))    
    doAssert "true"                 == lispObjectToString(eval(parse("(>= 6 5)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(>= 6 6)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(>= 6 5 4 4 2 1)")))
    doAssert "false"                == lispObjectToString(eval(parse("(>= 2 5)")))
    doAssert "false"                == lispObjectToString(eval(parse("(>= 6 5 4 4 2 7)")))    
    doAssert "true"                 == lispObjectToString(eval(parse("(<= 5 6)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(<= 6 6)")))
    doAssert "true"                 == lispObjectToString(eval(parse("(<= 1 2 4 4 5 6)")))
    doAssert "false"                == lispObjectToString(eval(parse("(<= 5 2 )")))
    doAssert "false"                == lispObjectToString(eval(parse("(<= 1 2 4 4 5 1)")))
    
    # Boolean Test Cases
    doAssert "true"                 == lispObjectToString(eval(parse("(not (= 5 6))")))
    doAssert "false"                == lispObjectToString(eval(parse("(not (= 5 5))")))    
    doAssert "true"                 == lispObjectToString(eval(parse("(and (= 5 5) (= 6 6))")))    
    doAssert "false"                == lispObjectToString(eval(parse("(and (= 5 5) (= 6 7))")))
    doAssert "true"                 == lispObjectToString(eval(parse("(or (= 5 5) (= 6 7))")))
    doAssert "false"                == lispObjectToString(eval(parse("(or (= 5 7) (= 6 7))")))
    
    # List Test Cases
    doAssert "(1 2 3)"              == lispObjectToString(eval(parse("(list 1 2 3)")))
    doAssert "(1 2 3)"              == lispObjectToString(eval(parse("(quote (1 2 3))")))
    doAssert "9"                    == lispObjectToString(eval(parse("(car (list 9 8 7))")))
    doAssert "(8 7)"                == lispObjectToString(eval(parse("(cdr (list 9 8 7))")))
    doAssert "4"                    == lispObjectToString(eval(parse("(length (list 9 8 7 6))")))
    doAssert "true"                 == lispObjectToString(eval(parse("(member 2 (list 1 2 3))")))
    doAssert "false"                == lispObjectToString(eval(parse("(member 9 (list 1 2 3))")))
    doAssert "true"                 == lispObjectToString(eval(parse("(member (list 1 2 3) (list (list 1 2 3)))")))
    doAssert "false"                == lispObjectToString(eval(parse("(member (list 1 2 3) (list (list 0 1 2 3)))")))
    doAssert "(1 2 3 4)"            == lispObjectToString(eval(parse("(cons 1 (list 2 3 4))")))
    
    # Variable Test Cases
    doAssert "five"                 == lispObjectToString(eval(parse("(defvar five 5)")))
    doAssert "5"                    == lispObjectToString(eval(parse("five")))
    
    # Function Test Cases
    doAssert "doubler"              == lispObjectToString(eval(parse("(deffun doubler (x) (* x 2))")))
    doAssert "4"                    == lispObjectToString(eval(parse("(doubler 2)")))
    doAssert "10"                   == lispObjectToString(eval(parse("(doubler five)")))
    
###########################
## main()
###########################

proc main() =
    #testCases()
    
    stdout.write("Lisp Interpreter\n")
    stdout.write("Enter an expression, or 'quit' to exit\n");
    stdout.write("\n")
    
    var str = ""
    while str != "quit":
        stdout.write("Lispy> ")
        str = readInput()
        if (str != "quit"):
            try:    
                var evaluated = eval(parse(str))
                stdout.write("Eval: ")
                echo(lispObjectToString(evaluated))
            except ParseException:
                echo "PARSE ERROR: ", getCurrentExceptionMsg()
            except EvalException:
                echo "EVAL ERROR: ", getCurrentExceptionMsg()
    echo "Bye!"
    
main()