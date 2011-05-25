import structs/ArrayList

import exceptions
import ../Scope

LispObject: abstract class {
    inspect: func -> String {
        "#<%s:%p>" format(this class name, this)
    }
    
    toString: func -> String {
        this inspect()
    }
    
    equals?: func (other: LispObject) -> Bool {
        other class == this class
    }
    
    evaluate: func (scope: Scope<LispObject>) -> LispObject {
        this
    }
    
    call: func (args: ArrayList<LispObject>, scope: Scope<LispObject>) -> LispObject {
        NotCallableException new(this class) throw()
    }
}

operator == (a, b: LispObject) -> Bool {
    a equals?(b)
}

operator != (a, b: LispObject) -> Bool {
    !a equals?(b)
}
