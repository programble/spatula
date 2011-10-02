import io/Reader

extend Reader {
    readWhile: func (chars: String) -> String {
        sb := Buffer new(1024)
        while (hasNext?()) {
            c := read()
            if (!chars contains?(c) || (!hasNext?() && c == 8)) break
            sb append(c)
        }
        return sb toString()
    }

    skipWhile: func ~chars (chars: String) {
        while (hasNext?()) {
            c := read()
            if (!chars contains?(c)) {
                rewind(1)
                break
            }
        }
    }

    readUntil: func ~chars (chars: String) -> String {
        sb := Buffer new(1024)
        while (hasNext?()) {
            c := read()
            if (chars contains?(c) || (!hasNext?() && c == 8)) {
                rewind(1)
                break
            }
            sb append(c)
        }
        return sb toString()
    }
}
