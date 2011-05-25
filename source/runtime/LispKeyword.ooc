import LispObject

LispKeyword: class extends LispObject {
    value: String
    
    init: func (=value)
    
    inspect: func -> String {
        ":%s" format(value)
    }
    
    toString: func -> String {
        value
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}
