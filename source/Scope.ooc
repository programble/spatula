import structs/HashMap

Scope: class <V> {
    parent: This<V>
    map: HashMap<String, V>
    
    init: func (=parent) {
        map = HashMap<String, V> new()
    }
    
    get: func (key: String) -> V {
        if (map contains?(key)) {
            map get(key)
        } else {
            parent get(key)
        }
    }
    
    put: func (key: String, value: V) -> Bool {
        map put(key, value)
    }
    
    remove: func (key: String) -> Bool {
        map remove(key)
    }
    
    contains?: func (key: String) -> Bool {
        if (map contains?(key)) {
            true
        } else {
            parent contains?(key)
        }
    }
    
    merge: func (other: Scope<V>) {
        other map each(|k, v| put(k, v))
    }
}

Namespace: class <V> extends Scope<V> {
    list = HashMap<String, This> new() : static HashMap<String, This>

    init: func(name: String) {
        This list[name] = this
        super(null)
    }
    
    get: func (key: String) -> V {
        map get(key)
    }
    
    contains?: func (key: String) -> Bool {
        map contains?(key)
    }
}
