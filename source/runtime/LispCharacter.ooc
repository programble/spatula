import LispObject

LispCharacter: class extends LispObject {
    value: Char
    
    init: func (=value)
    
    toString: func -> String {
        // TODO: Special cases
        "\\%c" format(value)
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}
