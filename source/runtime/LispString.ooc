import text/EscapeSequence

import LispObject

LispString: class extends LispObject {
    value: String
    
    init: func (=value)
    
    inspect: func -> String {
        "\"%s\"" format(EscapeSequence escape(value))
    }
    
    toString: func -> String {
        value
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}
