# Get rid of floats, just support ints

import strutils
import sequtils
import sugar
import tables
import typetraits

include tokeniser
include parser
include evaluator

proc display(str: string, depth: int) =
    for i in countup(0, depth):
        stdout.write("  ")
    echo str

proc outputItem(item: LispObject) =
    if (item.kind == lispObjectInt):
        stdout.write(item.intVal)
        stdout.write(" ")
    elif (item.kind == lispObjectFloat):
        stdout.write(item.floatVal)
        stdout.write(" ")
    elif (item.kind == lispObjectSymbol):
        stdout.write(item.symbolVal)
        stdout.write(" ")
    elif (item.kind == lispObjectList):
        stdout.write(" (")
        for sub_item in item.listVal:
            outputItem(sub_item)
        stdout.write(") ")
    
proc outputLispList(items: LispObject) =
    stdout.write("(")
    for item in items.listVal:
        outputItem(item)
    stdout.write(")")
        


# # # # # # # # #
# Program Starts
# # # # # # # # #

stdout.write("Lisp Interpreter\n")
stdout.write("Enter an expression, or 'quit' to exit\n");
stdout.write("\n")

#echo(function_table["abs"](3.4))

var str = ""
#while str != "quit":
stdout.write("Lispy> ")
str = readLine(stdin)
if (str != "quit"):
    var foo = parse(str)
    stdout.write("Parse: ")
    outputLispList(foo)
    stdout.write("\n")
    
    var bar = eval(foo)
    stdout.write("Eval: ")
    outputLispList(bar)
    stdout.write("\n")
        