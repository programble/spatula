import LispObject
import ../Scope

LispNumber: class extends LispObject {
    new: static func ~int (value: Int) -> LispInt {
        LispInt new(value)
    }
    
    new: static func ~float (value: Float) -> LispFloat {
        LispFloat new(value)
    }
}

LispInt: class extends LispNumber {
    value: Int
    
    init: func (=value)
    
    toString: func -> String {
        value toString()
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}

LispFloat: class extends LispNumber {
    value: Float
    
    init: func (=value)
    
    toString: func -> String {
        value toString()
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
}
