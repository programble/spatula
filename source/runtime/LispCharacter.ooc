import LispObject

LispCharacter: class extends LispObject {
    value: Char
    
    init: func (=value)
    
    inspect: func -> String {
        // TODO: Special cases
        "\\%c" format(value)
    }
    
    toString: func -> String {
        "%c" format(value)
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}
