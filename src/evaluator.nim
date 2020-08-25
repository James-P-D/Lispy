###########################
## Imports
###########################

import tables
import typetraits

###########################
## EvalException
###########################

type
    EvalException* = object of CatchableError

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
## containsFloat()
###########################

proc containsFloat(l: varargs[LispObject]): bool = 
    return len(l.filter(x => x.kind == lispObjectFloat)) > 0
    
###########################
## lispAdd()
###########################

proc lispAdd(l: varargs[LispObject]): LispObject = 
    if len(l) < 1:
        raise newException(EvalException, "lispAdd() - Not enough arguments")
    
    if containsFloat(l):        
        result = LispObject(kind: lispObjectFloat, floatVal: 0)
        for item in l:
            if (item.kind == lispObjectInt):
                result.floatVal += toFloat(item.intVal)
            elif (item.kind == lispObjectFloat):
                result.floatVal += item.floatVal
            else:
                raise newException(EvalException, "lispAdd() - Not an int or float")
    else:
        result = LispObject(kind: lispObjectInt, intVal: 0)
        for item in l:
            if (item.kind == lispObjectInt):
                result.intVal += item.intVal
            else:
                raise newException(EvalException, "lispAdd() - Not an int or float")
    

###########################
## lispSub()
###########################

proc lispSub(l: varargs[LispObject]): LispObject = 
    if len(l) < 1:
        raise newException(EvalException, "lispSub() - Not enough arguments")

    if containsFloat(l):        
        if len(l) == 1:
            return LispObject(kind: lispObjectFloat, floatVal: -(l[0].floatVal))
    
        result = LispObject(kind: lispObjectFloat, floatVal: 0)
        var n = 0
        while n < len(l):
            var item = l[n]
            if (item.kind == lispObjectInt):
                if (n == 0):
                    result.floatVal = toFloat(item.intVal)
                else:
                    result.floatVal -= toFloat(item.intVal)
            elif (item.kind == lispObjectFloat):
                if (n == 0):
                    result.floatVal = item.floatVal
                else:
                    result.floatVal -= item.floatVal
            else:
                raise newException(EvalException, "lispSub() - Not an int or float")
            n += 1
    else:
        if len(l) == 1:
            return LispObject(kind: lispObjectInt, intVal: -(l[0].intVal))
    
        result = LispObject(kind: lispObjectInt, intVal: 0)
        var n = 0
        while n < len(l):
            var item = l[n]
            if (item.kind == lispObjectInt):
                if (n == 0):
                    result.intVal = item.intVal
                else:
                    result.intVal -= item.intVal
            else:
                raise newException(EvalException, "lispSub() - Not an int or float")
            n += 1
    

###########################
## lispMul()
###########################

proc lispMul(l: varargs[LispObject]): LispObject = 
    if len(l) < 1:
        raise newException(EvalException, "lispMul() - Not enough arguments")

    if containsFloat(l):        
        if len(l) == 1:
            return LispObject(kind: lispObjectFloat, floatVal: -(l[0].floatVal))
    
        result = LispObject(kind: lispObjectFloat, floatVal: 0)
        var n = 0
        while n < len(l):
            var item = l[n]
            if (item.kind == lispObjectInt):
                if (n == 0):
                    result.floatVal = toFloat(item.intVal)
                else:
                    result.floatVal *= toFloat(item.intVal)
            elif (item.kind == lispObjectFloat):
                if (n == 0):
                    result.floatVal = item.floatVal
                else:
                    result.floatVal *= item.floatVal
            else:
                raise newException(EvalException, "lispMul() - Not an int or float")
            n += 1
    else:
        if len(l) == 1:
            return LispObject(kind: lispObjectInt, intVal: -(l[0].intVal))
    
        result = LispObject(kind: lispObjectInt, intVal: 0)
        var n = 0
        while n < len(l):
            var item = l[n]
            if (item.kind == lispObjectInt):
                if (n == 0):
                    result.intVal = item.intVal
                else:
                    result.intVal *= item.intVal
            else:
                raise newException(EvalException, "lispMul() - Not an int or float")
            n += 1

###########################
## lispDiv()
###########################

proc lispDiv(l: varargs[LispObject]): LispObject = 
    if len(l) < 1:
        raise newException(EvalException, "lispDiv() - Not enough arguments")

    if containsFloat(l):        
        if len(l) == 1:
            return LispObject(kind: lispObjectFloat, floatVal: -(l[0].floatVal))
    
        result = LispObject(kind: lispObjectFloat, floatVal: 0)
        var n = 0
        while n < len(l):
            var item = l[n]
            if (item.kind == lispObjectInt):
                if (n == 0):
                    result.floatVal = toFloat(item.intVal)
                else:
                    result.floatVal /= toFloat(item.intVal)
            elif (item.kind == lispObjectFloat):
                if (n == 0):
                    result.floatVal = item.floatVal
                else:
                    result.floatVal /= item.floatVal
            else:
                raise newException(EvalException, "lispDiv() - Not an int or float")
            n += 1
    else:
        if len(l) == 1:
            return LispObject(kind: lispObjectInt, intVal: -(l[0].intVal))
    
        result = LispObject(kind: lispObjectInt, intVal: 0)
        var n = 0
        while n < len(l):
            var item = l[n]
            if (item.kind == lispObjectInt):
                if (n == 0):
                    result.intVal = item.intVal
                else:
                    result.intVal = result.intVal div item.intVal
            else:
                raise newException(EvalException, "lispDiv() - Not an int or float")
            n += 1

###########################
## lispFloatToInt()
###########################

proc lispFloatToInt(l: varargs[LispObject]): LispObject = 
    if len(l) != 1:
        raise newException(EvalException, "lispFloatToInt() - Incorrect number of parameters")
    
    if l[0].kind != lispObjectFloat:
        raise newException(EvalException, "lispFloatToInt() - Parameter should be float")
        
    return LispObject(kind: lispObjectInt, intVal: toInt(l[0].floatVal))

###########################
## lispIntToFloat()
###########################

proc lispIntToFloat(l: varargs[LispObject]): LispObject = 
    if len(l) != 1:
        raise newException(EvalException, "lispIntToFloat() - Incorrect number of parameters")
    
    if l[0].kind != lispObjectInt:
        raise newException(EvalException, "lispIntToFloat() - Parameter should be float")
        
    return LispObject(kind: lispObjectFloat, floatVal: toFloat(l[0].intVal))

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
## lispLessThan()
###########################

proc lispLessThan(l: varargs[LispObject]): LispObject =    
    var n = 1
    while n < len(l):
        var current = l[n-1]
        var next = l[n]
        if current.kind != next.kind:
            raise newException(EvalException, "lispLessThan() - Parameters are not of same type")
        
        if current.kind == lispObjectInt:
            if current.intVal >= next.intVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        elif current.kind == lispObjectFloat:
            if current.floatVal >= next.floatVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        else:
            raise newException(EvalException, "lispLessThan() - Parameters should be int or float")
        
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispGreaterThan()
###########################

proc lispGreaterThan(l: varargs[LispObject]): LispObject =    
    var n = 1
    while n < len(l):
        var current = l[n-1]
        var next = l[n]
        if current.kind != next.kind:
            raise newException(EvalException, "lispGreaterThan() - Parameters are not of same type")
        
        if current.kind == lispObjectInt:
            if current.intVal <= next.intVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        elif current.kind == lispObjectFloat:
            if current.floatVal <= next.floatVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        else:
            raise newException(EvalException, "lispGreaterThan() - Parameters should be int or float")
        
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispLessThanOrEquals()
###########################

proc lispLessThanOrEquals(l: varargs[LispObject]): LispObject =    
    var n = 1
    while n < len(l):
        var current = l[n-1]
        var next = l[n]
        if current.kind != next.kind:
            raise newException(EvalException, "lispLessThanOrEquals() - Parameters are not of same type")
        
        if current.kind == lispObjectInt:
            if current.intVal > next.intVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        elif current.kind == lispObjectFloat:
            if current.floatVal > next.floatVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        else:
            raise newException(EvalException, "lispLessThanOrEquals() - Parameters should be int or float")
        
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispGreaterThanOrEquals()
###########################

proc lispGreaterThanOrEquals(l: varargs[LispObject]): LispObject =    
    var n = 1
    while n < len(l):
        var current = l[n-1]
        var next = l[n]
        if current.kind != next.kind:
            raise newException(EvalException, "lispGreaterThanOrEquals() - Parameters are not of same type")
        
        if current.kind == lispObjectInt:
            if current.intVal < next.intVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        elif current.kind == lispObjectFloat:
            if current.floatVal < next.floatVal:
                return LispObject(kind: lispObjectBool, boolVal: false)
        else:
            raise newException(EvalException, "lispGreaterThanOrEquals() - Parameters should be int or float")
        
        n += 1
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispNot()
###########################

proc lispNot(l: varargs[LispObject]): LispObject =
    if len(l) != 1:
        raise newException(EvalException, "lispNot() - Incorrect number of parameters")
    if l[0].kind != lispObjectBool:
        raise newException(EvalException, "lispNot() - Parameter is not boolean")

    if l[0].boolVal:
        return LispObject(kind: lispObjectBool, boolVal: false)
    else:
        return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispAnd()
###########################

proc lispAnd(l: varargs[LispObject]): LispObject =
    if len(l) == 0:
        raise newException(EvalException, "lispAnd() - Incorrect number of parameters")

    for item in l:
        if item.kind != lispObjectBool:
            raise newException(EvalException, "lispAnd() - Parameter is not boolean")
        if not item.boolVal:
            return LispObject(kind: lispObjectBool, boolVal: false)
        
    return LispObject(kind: lispObjectBool, boolVal: true)

###########################
## lispOr()
###########################

proc lispOr(l: varargs[LispObject]): LispObject =
    if len(l) == 0:
        raise newException(EvalException, "lispOr() - Incorrect number of parameters")

    for item in l:
        if item.kind != lispObjectBool:
            raise newException(EvalException, "lispOr() - Parameter is not boolean")
        if item.boolVal:
            return LispObject(kind: lispObjectBool, boolVal: true)
        
    return LispObject(kind: lispObjectBool, boolVal: false)

###########################
## lispList()
###########################

proc lispList(l: varargs[LispObject]): LispObject =
    result = LispObject(kind: lispObjectList, listVal: @[])

    for item in l:
        result.listVal.add(item)
        
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
## variableTable
###########################

var variableTable = initTable[string, LispObject]()

###########################
## userFunctionTable
###########################

var userFunctionTable = initTable[string, LispObject]()
               
###########################
## functionTable
###########################

var functionTable = {
                     "+" : LispObject(kind: lispObjectProc, procVal: lispAdd),
                     "-" : LispObject(kind: lispObjectProc, procVal: lispSub),
                     "*" : LispObject(kind: lispObjectProc, procVal: lispMul),
                     "/" : LispObject(kind: lispObjectProc, procVal: lispDiv),                     
                     "int": LispObject(kind: lispObjectProc, procVal: lispFloatToInt),
                     "float": LispObject(kind: lispObjectProc, procVal: lispIntToFloat),
                     
                     "=" : LispObject(kind: lispObjectProc, procVal: lispEquals),
                     "<" : LispObject(kind: lispObjectProc, procVal: lispLessThan),
                     ">" : LispObject(kind: lispObjectProc, procVal: lispGreaterThan),
                     "<=" : LispObject(kind: lispObjectProc, procVal: lispLessThanOrEquals),
                     ">=" : LispObject(kind: lispObjectProc, procVal: lispGreaterThanOrEquals),
                     "not" : LispObject(kind: lispObjectProc, procVal: lispNot),
                     "and" : LispObject(kind: lispObjectProc, procVal: lispAnd),
                     "or" : LispObject(kind: lispObjectProc, procVal: lispOr),
                     
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
    if (l.kind == lispObjectSymbol):
        if variableTable.hasKey(l.symbolVal):
            return variableTable[l.symbolVal]
        elif userFunctionTable.hasKey(l.symbolVal):
            return userFunctionTable[l.symbolVal]
        elif functionTable.hasKey(l.symbolVal):
            return functionTable[l.symbolVal]    
        else:
            raise newException(EvalException, "'" & l.symbolVal & "' is not a callable type")        
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
            elif (l.listVal[0].symbolVal == "defvar"):
                variableTable.add(l.listVal[1].symbolVal, eval(l.listVal[2]))
                return l.listVal[1]
            elif (l.listVal[0].symbolVal == "deffun"):
                userFunctionTable.add(l.listVal[1].symbolVal, LispObject(kind: lispObjectUserProc,
                                                                         userProcTuple: (userProcParams: l.listVal[2].listVal,
                                                                                         userProcVal: l.listVal[3])))
                return l.listVal[1];
        
        var lispFunc = eval(l.listVal[0])
        
        if lispFunc.kind == lispObjectProc:
            var evaluatedTail: seq[LispObject]
            var n = 1
            while n < len(l.listVal):
                evaluatedTail.add(eval(l.listVal[n]))
                n += 1
            return lispFunc.procVal(evaluatedTail)
        elif lispFunc.kind == lispObjectUserProc:
            var evaluatedTail: seq[LispObject]
            var n = 1
            while n < len(l.listVal):
                evaluatedTail.add(eval(l.listVal[n]))
                n += 1
            
            if len(evaluatedTail) != len(lispFunc.userProcTuple.userProcParams):
                raise newException(EvalException, "Incorrect number of parameters")

            n = 0
            while n < len(evaluatedTail):
                variableTable[lispFunc.userProcTuple.userProcParams[n].symbolVal] = evaluatedTail[n]
                n += 1
            
            return eval(lispFunc.userProcTuple.userProcVal)
        else:
            raise newException(EvalException, "Not a not callable type")