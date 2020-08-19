type
    ParseException* = object of CatchableError

type
    LispObjectKind = enum  # the different node types
        lispObjectInt,
        lispObjectFloat,
        lispObjectSymbol,
        lispObjectList
  
    LispObject = ref object
        case kind: LispObjectKind  # the ``kind`` field is the discriminator
        of lispObjectInt: intVal: int
        of lispObjectFloat: floatVal: float
        of lispObjectSymbol: symbolVal: string
        of lispObjectList: listVal: seq[LispObject]

proc atom(token: string): LispObject =
    try:    
        result = LispObject(kind: lispObjectInt, intVal: parseInt(token))
    except ValueError:
        try:
            result = LispObject(kind: lispObjectFloat, floatVal: parseFloat(token))
        except:
            result = LispObject(kind: lispObjectSymbol, symbolVal: token)

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
