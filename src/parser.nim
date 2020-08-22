import strutils

include tokeniser

type
    ParseException* = object of CatchableError

type
    LispObjectKind = enum  # the different node types
        lispObjectInt,
        lispObjectFloat,
        lispObjectBool,
        lispObjectSymbol,
        lispObjectList,
        lispObjectProc
  
    LispObject = ref object
        case kind: LispObjectKind  # the ``kind`` field is the discriminator
        of lispObjectInt: intVal: int
        of lispObjectFloat: floatVal: float
        of lispObjectBool: boolVal: bool
        of lispObjectSymbol: symbolVal: string
        of lispObjectList: listVal: seq[LispObject]
        of lispObjectProc: procVal: (proc (l: varargs[LispObject]): LispObject)

###########################
## atom()
###########################

proc atom(token: string): LispObject =
    try:    
        return LispObject(kind: lispObjectInt, intVal: parseInt(token))
    except ValueError:
        try:
            return LispObject(kind: lispObjectFloat, floatVal: parseFloat(token))
        except:
            if (token == "T"):
                return LispObject(kind: lispObjectBool, boolVal: true)
            elif (token == "nil"):
                return LispObject(kind: lispObjectBool, boolVal: false)
            else:
                result = LispObject(kind: lispObjectSymbol, symbolVal: token)

###########################
## read_from_tokens()
###########################

proc read_from_tokens(tokens: var seq[string], depth: int): LispObject =
    if len(tokens) == 0:
        raise newException(ParseException, "Unexpected EOF")
        
    var token = tokens.pop()
    
    if token == "(":
        var new_list = LispObject(kind: lispObjectList, listVal: @[])
        while tokens[(len tokens)-1] != ")":            
            new_list.listVal.add(read_from_tokens(tokens, depth+1))
        token = tokens.pop()
        return new_list
    elif token == ")":
        raise newException(ParseException, "Unexpected ')'")
    else:
        return atom(token)
    
proc parse(str: string): LispObject =
    var tokens = tokenise(str)
    result = read_from_tokens(tokens, 0)
