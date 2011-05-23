import LispObject

LispKeyword: class extends LispObject {
    value: String
    
    init: func (=value)
    
    toString: func -> String {
        ":%s" format(value)
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}
