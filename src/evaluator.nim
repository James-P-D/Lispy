import tables
import typetraits

type
    EvalException* = object of CatchableError

###########################
## addInts()
###########################

proc lispAddInts(l: LispObject): LispObject = 
    if (l.kind != lispObjectList):
        raise newException(EvalException, "addInts() - Not a list")
        
    if len(l.listVal) < 1:
        raise newException(EvalException, "addInts() - Not enough arguments")
    
    result = LispObject(kind: lispObjectInt, intVal: 0)
    var n = 0
    while n < len(l.listVal):
        var next = l.listVal[n]
        if (next.kind == lispObjectInt):
            if (n == 0):
                result.intVal = next.intVal
            else:
                result.intVal += next.intVal
        else:
            raise newException(EvalException, "addInts() - Not an int")
        n += 1

###########################
## lispEquals()
###########################

proc lispEquals(l: LispObject): LispObject =
    if (l.kind == lispObjectList):
        if len(l.listVal) < 1:
            raise newException(EvalException, "equal() - Not enough arguments")

    var first = l.listVal[0]
    var n = 1
    while n < len(l.listVal):
        var next = l.listVal[n]
        if (first.kind != next.kind):
            raise newException(EvalException, "equal() - Not comparable types1")
        
        if (first.kind == lispObjectInt):
            if (first.intVal != next.intVal):
                return LispObject(kind: lispObjectBool, boolVal: false)
        elif (first.kind == lispObjectFloat):
            if (first.floatVal != next.floatVal):
                return LispObject(kind: lispObjectBool, boolVal: false)
        elif (first.kind == lispObjectBool):
            if (first.boolVal != next.boolVal):
                return LispObject(kind: lispObjectBool, boolVal: false)
        else:
            raise newException(EvalException, "equal() - Not comparable types2")
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## function_table()
###########################

var function_table = {
                      "+" : LispObject(kind: lispObjectProc, procVal: lispAddInts),
                      #"-" : LispObject(kind: lispObjectProc, procVal: lispSubInts)
                      #"*" : LispObject(kind: lispObjectProc, procVal: lispMulInts)
                      #"/" : LispObject(kind: lispObjectProc, procVal: lispDivInts)                      
                      #... And 'f+', 'f*' for floats
                      
                      "=" : LispObject(kind: lispObjectProc, procVal: lispEquals),
                      #... And '!=', '>=', 'not', 'and' etc. (not '&&' or '!' !)
                      
                      "car" : LispObject(kind: lispObjectProc, procVal: lispCar),
                      "cdr" : LispObject(kind: lispObjectProc, procVal: lispCdr),
                      }.toTable

###########################
## eval()
###########################

proc eval(l: LispObject): LispObject =
    if (l.kind == lispObjectSymbol):
        if not function_table.hasKey(l.symbolVal):
            raise newException(EvalException, "'" & l.symbolVal & "' is not callable type")
        return function_table[l.symbolVal]
    elif (l.kind == lispObjectInt):
        return l
    elif (l.kind == lispObjectFloat):
        return l
    elif (l.kind == lispObjectBool):
        return l
    else:
        var someProc = eval(l.listVal[0])
        
        if (someProc.kind != lispObjectProc):
            raise newException(EvalException, "Not a not callable type")
        
        var evaluatedTail = LispObject(kind: lispObjectList, listVal: @[])
        var n = 1
        while n < len(l.listVal):
            evaluatedTail.listVal.add(eval(l.listVal[n]))
            n += 1
                
        return someProc.procVal(evaluatedTail)
