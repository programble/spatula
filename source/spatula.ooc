import structs/ArrayList

import Version
import runtime/LispObject
import Scope
import LispReader

main: func {
    "Spatula %s" printfln(Version toString())
    namespace := Namespace<LispObject> new("balls")
    while (true) {
        "=> " print()
        input := stdin readLine()
        if (input == "") {
            break
        }
        try {
            reader := LispReader new(input)
            exprs := reader readAll()
            for (expr in exprs) {
                expr evaluate(namespace) toString() println()
            }
        } catch (e: Exception) {
            e print()
        }
    }
}
