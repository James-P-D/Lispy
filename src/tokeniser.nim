###########################
## Imports
###########################

import strutils
import sequtils
import sugar

###########################
## tokenise()
###########################

proc tokenise(str1: string): seq[string] = 
    var str2 = replace(str1, ")", " ) ") # Enforce spaces around open brackets
    var str3 = replace(str2, "(", " ( ") # Enforce spaces around close brackets
    var seq1 = splitWhitespace(str3)     # Split on space character
    var seq2 = seq1.filter(x => x != "") # Filter out empty strings (Why Nim's split() method returns empty strings is anyones guess :D )
    
    for i in seq2:
        result.insert(i, 0)
