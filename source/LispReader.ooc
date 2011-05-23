import io/[Reader, StringReader]
import structs/ArrayList
import text/EscapeSequence

import runtime/[LispObject, LispSymbol, LispKeyword, LispNumber]

// Extra Reader methods
// TODO: Perhaps move this to another file or get this merged into the
//       sdk proper
extend Reader {
    readWhile: func (chars: String) -> String {
        // Based on readUntil
        sb := Buffer new(1024)
        while (hasNext?()) {
            c := read()
            if (!chars contains?(c) || (!hasNext?() && c == 8)) {
                break
            }
            sb append(c)
        }
        return sb toString()
    }
    
    skipWhile: func ~chars (chars: String) {  
        // Based on skipWhile
        while (hasNext?()) {
            c := read()
            if (!chars contains?(c)) {
                rewind(1)
                break
            }
        }
    }
    
    readUntil: func ~chars (chars: String) -> String {
        // Based on readUntil
        sb := Buffer new(1024)
        while (hasNext?()) {
            c := read()
            if (chars contains?(c) || (!hasNext?() && c == 8)) {
                rewind(1)
                break
            }
            sb append(c)
        }
        return sb toString()
    }
}

// Reader Exceptions
SyntaxException: class extends Exception {
    init: func (=message)
}

EOFException: class extends SyntaxException {
    init: func (clazz: Class) {
        message = "Unexpected EOF while reading %s" format(clazz name)
    }
}

WHITESPACE: const String = " \t\r\n"

// Where the real magic happens
LispReader: class {
    // Yo dwag i herd u liek readers
    reader: Reader
    
    init: func (=reader)
    
    init: func ~string (str: String) {
        init(StringReader new(str))
    }
    
    hasNext?: func -> Bool {
        reader hasNext?()
    }
    
    skipWhitespace: func {
        reader skipWhile(WHITESPACE)
    }
    
    readAll: func -> ArrayList<LispObject> {
        all := ArrayList<LispObject> new()
        while (hasNext?()) {
            x := read()
            if (x != null) {
                all add(x)
            }
        }
        return all
    }
    
    read: func -> LispObject {
        // Skip leading whitespace
        skipWhitespace()
        
        dispatch := reader peek()
        
        if (dispatch >= '0' && dispatch <= '9') {
            readNumber()
        } else if (dispatch == '-' && hasNext?()) {
            reader read() // Skip over - for now
            next := reader read()
            reader rewind(2) // Go back to -
            if (next >= '0' && next <= '9') {
                readNumber()
            } else {
                readSymbol()
            }
        } else match (dispatch) {
            case ')' => SyntaxException new("Mismatched parentheses") throw()
            case ':' => readKeyword()
            case ';' => // Comment
                reader skipLine()
                null
            case => readSymbol()
        }
    }   
    
    readSymbol: func -> LispSymbol {
        str := reader readUntil(WHITESPACE)
        return LispSymbol new(str)
    }
    
    readKeyword: func -> LispKeyword {
        reader read() // Skip leading :
        str := reader readUntil(WHITESPACE)
        return LispKeyword new(str)
    }
    
    readNumber: func -> LispNumber {
        str := reader readUntil(WHITESPACE)
        if (str contains?('.')) {
            f: Float
            c: Char // Hack to detect trailing garbage
            valid: Int = sscanf(str, "%f%c", f&, c&)
            if (valid == 1) {
                return LispNumber new(f)
            } else {
                SyntaxException new("Invalid float literal") throw()
            }
        } else {
            i: Int
            c: Char
            valid: Int = sscanf(str, "%i%c", i&, c&)
            if (valid == 1) {
                return LispNumber new(i)
            } else {
                SyntaxException new("Invalid integer literal") throw()
            }
        }
    }  
}
