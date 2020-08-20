import tables
import typetraits

type
    EvalException* = object of CatchableError

###########################
## addInts()
###########################

proc addInts(l: LispObject): LispObject = 
    if (l.kind != lispObjectList):
        raise newException(EvalException, "addInts() - Not a list")
        
    if len(l.listVal) < 1:
        raise newException(EvalException, "addInts() - Not enough arguments")
    # TODO: Change this to 'result'
    var retVal: int = 0
    var n = 0
    while n < len(l.listVal):
        var sub_item = l.listVal[n]
        if (sub_item.kind == lispObjectInt):
            if (n == 0):
                retVal = sub_item.intVal
            else:
                retVal += sub_item.intVal
        else:
            raise newException(EvalException, "addInts() - Not an int")
        n += 1
    result = LispObject(kind: lispObjectInt, intVal: retVal)

###########################
## equal()
###########################

proc equal(l: LispObject): LispObject =
    if (l.kind == lispObjectList):
        if len(l.listVal) < 1:
            raise newException(EvalException, "equal() - Not enough arguments")

    var first = l.listVal[0]
    var n = 1
    while n < len(l.listVal):
        var next = l.listVal[n]
        if (first.kind != next.kind):
            raise newException(EvalException, "equal() - Not comparable types")
        
        if (first.kind == lispObjectInt) and (first.intVal != next.intVal):
            return LispObject(kind: lispObjectBool, boolVal: false)
        elif (first.kind == lispObjectFloat) and (first.floatVal != next.floatVal):
            return LispObject(kind: lispObjectBool, boolVal: false)
        elif (first.kind == lispObjectBool) and (first.boolVal != next.boolVal):
            return LispObject(kind: lispObjectBool, boolVal: false)
        else:
            raise newException(EvalException, "equal() - Not comparable types")
    return LispObject(kind: lispObjectBool, boolVal: true)
    
###########################
## function_table()
###########################

var function_table = {
                      "+" : LispObject(kind: lispObjectProc, procVal: addInts),
                      #"-" : LispObject(kind: lispObjectProc, procVal: subInts)
                      #"*" : LispObject(kind: lispObjectProc, procVal: mulInts)
                      #"/" : LispObject(kind: lispObjectProc, procVal: divInts) # And 'f+', 'f*' for floats
                      "=" : LispObject(kind: lispObjectProc, procVal: equal)    # And '!=', '>=' etc.
                      }.toTable

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
