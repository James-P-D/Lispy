import tables
import typetraits

type
    EvalException* = object of CatchableError

# GET RID OF THIS!
proc evalOutputLispObject(item: LispObject) =
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
            evalOutputLispObject(sub_item)
        stdout.write(") ")


###########################
## addInts()
###########################

proc lispAddInts(l: varargs[LispObject]): LispObject = 
    if len(l) < 1:
        raise newException(EvalException, "lispAddInts() - Not enough arguments")
    
    result = LispObject(kind: lispObjectInt, intVal: 0)
    var n = 0
    while n < len(l):
        var next = l[n]
        if (next.kind == lispObjectInt):
            if (n == 0):
                result.intVal = next.intVal
            else:
                result.intVal += next.intVal
        else:
            raise newException(EvalException, "lispAddInts() - Not an int")
        n += 1

###########################
## lispEquals()
###########################

proc lispEquals(l: varargs[LispObject]): LispObject =
    var first = l[0]
    var n = 1
    while n < len(l):
        var next = l[n]
        if (first.kind != next.kind):
            raise newException(EvalException, "lispEquals() - Not comparable types")
        
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
            raise newException(EvalException, "lispEquals() - Not comparable types")
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispList()
###########################

#proc lispList(l: varargs[LispObject]): LispObject =
#    return l

###########################
## lispCar()
###########################

proc lispCar(l: varargs[LispObject]): LispObject =
    if (len(l) > 0):
        return l[0]
        

###########################
## lispCdr()
###########################

proc lispCdr(l: varargs[LispObject]): LispObject =
    result = LispObject(kind: lispObjectList, listVal: @[])
    
    var n = 1
    while n < len(l):
        result.listVal.add(l[n])
        n += 1
    
    
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
                      
                      #"list" : LispObject(kind: lispObjectProc, procVal: lispList),
                      "car" : LispObject(kind: lispObjectProc, procVal: lispCar),
                      "cdr" : LispObject(kind: lispObjectProc, procVal: lispCdr),
                      
                      }.toTable

###########################
## eval()
###########################

proc eval(l: LispObject): LispObject =
    if (l.kind == lispObjectSymbol):
        if not function_table.hasKey(l.symbolVal):
            raise newException(EvalException, "'" & l.symbolVal & "' is not a callable type")
        return function_table[l.symbolVal]
    elif (l.kind == lispObjectInt):
        return l
    elif (l.kind == lispObjectFloat):
        return l
    elif (l.kind == lispObjectBool):
        return l
    else:
        if (l.listVal[0].kind == lispObjectSymbol):
            if (l.listVal[0].symbolVal == "quote"):
                return l.listVal[1]
        
        var lispFunc = eval(l.listVal[0])
        
        if (lispFunc.kind != lispObjectProc):
            raise newException(EvalException, "Not a not callable type")
        
        var evaluatedTail: seq[LispObject] #LispObject(kind: lispObjectList, listVal: @[])
        var n = 1
        while n < len(l.listVal):
            evaluatedTail.add(eval(l.listVal[n]))
            n += 1

        return lispFunc.procVal(evaluatedTail[0].listVal)
