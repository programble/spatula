import LispObject
import ../Scope

LispNumber: class extends LispObject {
    new: static func ~int (value: Int) -> LispInt {
        LispInt new(value)
    }
    
    new: static func ~float (value: Float) -> LispFloat {
        LispFloat new(value)
    }
    
    new: static func ~fraction (numerator: Int, denominator: Int) -> LispFraction {
        LispFraction new(numerator, denominator)
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

LispFraction: class extends LispNumber {
    numerator: Int
    denominator: Int
    
    init: func (=numerator, =denominator)
    
    toString: func -> String {
        "%d/%d" format(numerator, denominator)
    }
    
    equals?: func (other: LispObject) -> Bool {
        // TODO: Compare reduced ratios
        false
    }
    
    evaluate: func (scope: Scope<LispObject>) -> LispObject {
        // TODO: Reduce fraction
        this
    }
}
