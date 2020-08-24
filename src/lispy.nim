# Get rid of floats, just support ints ?
# Make camelCase/under_score_case consistent

import strutils
import sequtils
import sugar
import tables
import typetraits

include parser
include evaluator

###########################
## outputLispObject()
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
    # Test cases
    doAssert "10" == lispObjectToString(eval(parse("(+ 6 4)")))
    doAssert "true" == lispObjectToString(eval(parse("(= 10 10)")))
    doAssert "false" == lispObjectToString(eval(parse("(= 10 11)")))
    doAssert "true" == lispObjectToString(eval(parse("(= (+ 5 5) (+ 9 1))")))
    doAssert "(1 2 3)" == lispObjectToString(eval(parse("(list 1 2 3)")))
    doAssert "(1 2 3)" == lispObjectToString(eval(parse("(quote (1 2 3))")))
    doAssert "9" == lispObjectToString(eval(parse("(car (list 9 8 7))")))
    doAssert "(8 7)" == lispObjectToString(eval(parse("(cdr (list 9 8 7))")))
    doAssert "4" == lispObjectToString(eval(parse("(length (list 9 8 7 6))")))
    doAssert "true" == lispObjectToString(eval(parse("(member 2 (list 1 2 3))")))
    doAssert "false" == lispObjectToString(eval(parse("(member 9 (list 1 2 3))")))
    doAssert "true" == lispObjectToString(eval(parse("(member (list 1 2 3) (list (list 1 2 3)))")))
    doAssert "false" == lispObjectToString(eval(parse("(member (list 1 2 3) (list (list 0 1 2 3)))")))
    doAssert "(1 2 3 4)" == lispObjectToString(eval(parse("(cons 1 (list 2 3 4))")))

###########################
## main()
###########################

proc main() =
    testCases()

    stdout.write("Lisp Interpreter\n")
    stdout.write("Enter an expression, or 'quit' to exit\n");
    stdout.write("\n")
    
    var str = ""
    while str != "quit":
        stdout.write("Lispy> ")
        str = readInput()
        if (str != "quit"):
            try:    
                var parsed = parse(str)
                stdout.write("Parse: ")
                echo(lispObjectToString(parsed))
    
                var evaluated = eval(parsed)
                stdout.write("Eval: ")
                echo(lispObjectToString(evaluated))
            except ParseException:
                echo "PARSE ERROR: ", getCurrentExceptionMsg()
            except EvalException:
                echo "EVAL ERROR: ", getCurrentExceptionMsg()
                
main()