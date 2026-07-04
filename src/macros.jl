using JLXSyntax

macro include(path)
    path isa String || error("@include requires a literal string")

    caller = dirname(String(__source__.file))
    fullpath = normpath(joinpath(caller, path))

    if !isfile(fullpath)
        throw(ArgumentError("File not found: $fullpath"))
    end

    if endswith(fullpath, ".jlx")
        contents = read(fullpath, String)
        return esc(transform!(parse!(contents, fullpath)))
    else
        return :(Base.include($__module__, $fullpath))
    end
end