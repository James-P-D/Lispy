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

proc outputLispObject(item: LispObject) =
    if (item.kind == lispObjectInt):
        stdout.write(item.intVal)
        stdout.write(" ")
    elif (item.kind == lispObjectFloat):
        stdout.write(item.floatVal)
        stdout.write(" ")
    elif (item.kind == lispObjectBool):
        stdout.write(item.boolVal)
        stdout.write(" ")
    elif (item.kind == lispObjectSymbol):
        stdout.write(item.symbolVal)
        stdout.write(" ")
    elif (item.kind == lispObjectList):
        stdout.write(" (")
        for sub_item in item.listVal:
            outputLispObject(sub_item)
        stdout.write(") ")
        
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
## main()
###########################

proc main() =
    stdout.write("Lisp Interpreter\n")
    stdout.write("Enter an expression, or 'quit' to exit\n");
    stdout.write("\n")

    var str = ""
    while str != "quit":
        stdout.write("Lispy> ")
        #str = "(length (quote (1 2 3)))"
        str = readInput()
        if (str != "quit"):
            try:    
                var parsed = parse(str)
                stdout.write("Parse: ")
                outputLispObject(parsed)
                stdout.write("\n")
    
                var evaluated = eval(parsed)
                stdout.write("Eval: ")
                outputLispObject(evaluated)
                stdout.write("\n")
            except ParseException:
                echo "PARSE ERROR: ", getCurrentExceptionMsg()
            except EvalException:
                echo "EVAL ERROR: ", getCurrentExceptionMsg()
                
main()