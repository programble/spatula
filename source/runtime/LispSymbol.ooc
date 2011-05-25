import LispObject
import ../Scope
import exceptions

LispSymbol: class extends LispObject {
    value: String
    
    init: func (=value)
    
    inspect: func -> String {
        value
    }
    
    equals?: func (other: LispObject) -> Bool {
        super(other) && this value == other as This value
    }
    
    evaluate: func (scope: Scope<LispObject>) -> LispObject {
        if (scope contains?(value)) {
            scope[value]
        } else {
            UndefinedException new(value) throw()
        }
    }
}
