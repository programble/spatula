NotCallableException: class extends Exception {
    init: func (type: Class) {
        message = "%s is not callable" format(type name)
    }
}

UndefinedException: class extends Exception {
    init: func (symbol: String) {
        message = "'%s' is not defined" format(name)
    }
}
