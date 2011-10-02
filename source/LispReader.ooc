import io/[Reader, StringReader]
import structs/ArrayList
import text/EscapeSequence

import ReaderExtensions

import runtime/[LispObject, LispSymbol, LispKeyword, LispNumber, LispCharacter, LispString]

// Reader Exceptions
SyntaxException: class extends Exception {
    init: func (=message)
}

EOFException: class extends SyntaxException {
    init: func (clazz: Class) {
        message = "Unexpected EOF while reading %s" format(clazz name)
    }
}

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
        reader skipWhile(" \t\r\n")
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
        skipWhitespace() // Skip leading whitespace
        if (!hasNext?()) {
            return null
        }
        
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
            case '\\' => readCharacter()
            case '"' => readString()
            case ';' => // Comment
                reader skipLine()
                null
            case => readSymbol()
        }
    }   
    
    readSymbol: func -> LispSymbol {
        str := reader readUntil(" \t\r\n)")
        return LispSymbol new(str)
    }
    
    readKeyword: func -> LispKeyword {
        reader read() // Skip leading :
        str := reader readUntil(" \t\r\n)")
        return LispKeyword new(str)
    }
    
    readNumber: func -> LispNumber {
        str := reader readUntil(" \t\r\n)")
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
    
    readCharacter: func -> LispCharacter {
        reader read() // Skip over \ 
        if (!reader hasNext?()) {
            EOFException new(LispCharacter) throw()
        }
        return LispCharacter new(reader read())
    }
    
    readString: func -> LispString {
        reader read() // Skip leading "
        if (!reader hasNext?()) {
            EOFException new(LispString) throw()
        }
        str := reader readUntil('"')
        // Verify the string has a closing "
        reader rewind(1)
        if (reader read() != '"') {
            EOFException new(LispString) throw()
        }
        return LispString new(EscapeSequence unescape(str))
    }
}
