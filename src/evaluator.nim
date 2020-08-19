import tables
import typetraits

var function_table = {"+"   : (proc (x, y: int): int = x + y),
                      "-"   : (proc (x, y: int): int = x - y),
                      "*"   : (proc (x, y: int): int = x * y),
                      "/"   : (proc (x, y: int): int = x div y)#,
                      #"abs" : (proc (x: float): int = abs(x))
                      }.toTable

proc eval(l: LispObject): LispObject =
    if (l.kind == lispObjectSymbol):
        return l
        #return function_table[l.symbolVal]
    elif (l.kind == lispObjectInt):
        return l
    elif (l.kind == lispObjectList):
        echo "list!"
        var foo = l.listVal[0]
        echo foo.type.name
        return l
