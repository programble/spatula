import io/[Reader, StringReader]
import structs/ArrayList
import text/EscapeSequence

import ReaderExtensions

import runtime/[LispObject, LispSymbol, LispKeyword, LispNumber, LispCharacter, LispString]

SyntaxException: class extends Exception {
    init: func (=message)
}

EOFException: class extends SyntaxException {
    init: func (clazz: Class) {
        super("Unexpected EOF while reading %s" format(clazz name))
    }
}

LispReader: class {
    DELIMETER: static const String = " \t\r\n)"

    reader: Reader

    init: func (=reader)

    init: func ~string (str: String) {
        init(StringReader new(str))
    }

    hasNext?: func -> Bool {
        skipWhitespace() // This seems horrible to do in here
        reader hasNext?()
    }

    skipWhitespace: func {
        reader skipWhile(" \t\r\n")
    }

    readAll: func -> ArrayList<LispObject> {
        all := ArrayList<LispObject> new()
        while (hasNext?()) {
            all add(read())
        }
        all
    }

    read: func -> LispObject {
        if (!hasNext?()) return null

        dispatch := reader peek()

        if (dispatch >= '0' && dispatch <= '9') {
            readNumber()
        } else if (dispatch == '-' && hasNext?()) {
            reader read()
            next := reader read() // Get the character after the -
            reader rewind(2) // Then go back to the -
            if (next >= '0' && next <= '9') {
                readNumber()
            } else {
                readSymbol()
            }
        } else match (dispatch) {
            case ')' => SyntaxException new("Mismatched parentheses") throw()
            //case '(' => readList()
            case ':' => readKeyword()
            case '\\' => readCharacter()
            case '"' => readString()
            case ';' => // Comment
                reader skipLine()
                if (hasNext?()) {
                    read()
                } else {
                    null
                }
            case => readSymbol() // So lenient with symbols...
        }
    }

    readSymbol: func -> LispSymbol {
        s := reader readUntil(DELIMETER)
        LispSymbol new(s)
    }

    readKeyword: func -> LispKeyword {
        reader read() // Skip :
        s := reader readUntil(DELIMETER)
        LispKeyword new(s)
    }

    readNumber: func -> LispNumber {
        s := reader readUntil(DELIMETER)
        if (s contains?('.')) {
            f: Float
            c: Char // Dummy var
            valid := sscanf(s, "%f%c", f&, c&)
            if (valid == 1) {
                LispNumber new(f)
            } else {
                SyntaxException new("Invalid float literal: %s" format(s)) throw()
            }
        } else {
            i: Int
            c: Char
            valid := sscanf(s, "%i%c", i&, c&)
            if (valid == 1) {
                LispNumber new(i)
            } else {
                SyntaxException new("Invalid integer literal: %s" format(s)) throw()
            }
        }
    }

    readCharacter: func -> LispCharacter {
        reader read() // Skip \     
        if (!reader hasNext?()) {
            EOFException new(LispCharacter) throw()
        }
        LispCharacter new(reader read())
    }

    readString: func -> LispString {
        reader read() // Skip "
        if (!reader hasNext?()) {
            EOFException new(LispString) throw()
        }
        // TODO: Handle escaped quotes
        s := reader readUntil('"')
        // Verify string is closed
        reader rewind(1)
        if (reader read() != '"') {
            EOFException new(LispString) throw()
        }
        LispString new(EscapeSequence unescape(s))
    }
}
