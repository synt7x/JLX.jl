function content(args...)::String
    out = IOBuffer()

    for (i, a) in enumerate(args)
        s = string(a)

        if i > 1
            if !(startswith(s, r"[.,;:!?]"))
                print(out, " ")
            end
        end

        print(out, s)
    end

    return String(take!(out))
end