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
## match()
###########################

proc match(a, b: LispObject): bool =
    if (a.kind != b.kind):
        return false
        
    if (a.kind == lispObjectInt):
        if (a.intVal != b.intVal):
            return false
    elif (a.kind == lispObjectFloat):
        if (a.floatVal != b.floatVal):
            return false
    elif (a.kind == lispObjectBool):
        if (a.boolVal != b.boolVal):
            return false
    elif (a.kind == lispObjectList):
        if (len(a.listVal) != len (b.listVal)):
            return false
        else:
            for i in countup(0, len(a.listVal) - 1):
                if not match(a.listVal[i], b.listVal[i]):
                    return false
    else:
        return false
    return true

###########################
## lispAddInts()
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
        if not match(first, next):
            return LispObject(kind: lispObjectBool, boolVal: false)
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispList()
###########################

proc lispList(l: varargs[LispObject]): LispObject =
    result = LispObject(kind: lispObjectList, listVal: @[])
    var n = 0
    while n < len(l):
        result.listVal.add(l[n])
        n += 1
        
###########################
## lispCar()
###########################

proc lispCar(l: varargs[LispObject]): LispObject =
    if (len(l[0].listVal) > 0):
        return l[0].listVal[0]
    else:
        return LispObject(kind: lispObjectList, listVal: @[])
        

###########################
## lispCdr()
###########################

proc lispCdr(l: varargs[LispObject]): LispObject =
    result = LispObject(kind: lispObjectList, listVal: @[])
    
    var n = 1
    while n < len(l[0].listVal):
        result.listVal.add(l[0].listVal[n])
        n += 1

###########################
## lispLength()
###########################

proc lispLength(l: varargs[LispObject]): LispObject =
    result = LispObject(kind: lispObjectInt, intVal: len(l[0].listVal))    
    
###########################
## lispMember()
###########################

proc lispMember(l: varargs[LispObject]): LispObject =
    var n = 0
    while n < len(l[1].listVal):
        if match(l[0], l[1].listVal[n]):
            return LispObject(kind: lispObjectBool, boolVal: true)
        n += 1
    
    return LispObject(kind: lispObjectBool, boolVal: false)

###########################
## lispCons()
###########################

proc lispCons(l: varargs[LispObject]): LispObject =    
    result = LispObject(kind: lispObjectList, listVal: @[])
    
    result.listVal.add(l[0])
    var n = 0
    while n < len(l[1].listVal):
        result.listVal.add(l[1].listVal[n])        
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
                      
                      "list" : LispObject(kind: lispObjectProc, procVal: lispList),
                      "car" : LispObject(kind: lispObjectProc, procVal: lispCar),
                      "cdr" : LispObject(kind: lispObjectProc, procVal: lispCdr),
                      "length" : LispObject(kind: lispObjectProc, procVal: lispLength),
                      "member": LispObject(kind: lispObjectProc, procVal: lispMember),
                      "cons": LispObject(kind: lispObjectProc, procVal: lispCons),
                      }.toTable

###########################
## eval()
###########################

proc eval(l: LispObject): LispObject =
    #echo "eval"
    #evalOutputLispObject(l)
    #echo ""
    
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
            elif (l.listVal[0].symbolVal == "if"):
                if (len(l.listVal) != 4):
                    raise newException(EvalException, "'if' must have precisely 3 parameters")
                    
                var conditionEvaluated = eval(l.listVal[1]) # Condition
                if (conditionEvaluated.kind != lispObjectBool):
                    raise newException(EvalException, "'if' condition does not evaluate to a boolean")
                    
                if (conditionEvaluated.boolVal == true):
                    return eval(l.listVal[2]) # Then expression
                else:
                    return eval(l.listVal[3]) # Else expression
        
        var lispFunc = eval(l.listVal[0])
        
        if (lispFunc.kind != lispObjectProc):
            raise newException(EvalException, "Not a not callable type")
        
        var evaluatedTail: seq[LispObject]
        var n = 1
        while n < len(l.listVal):
            evaluatedTail.add(eval(l.listVal[n]))
            n += 1
        
        return lispFunc.procVal(evaluatedTail)