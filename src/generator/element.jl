function element(tag::String; children::Tuple=(), properties::Any=NamedTuple())::String
    if isnothing(tag)
        return join(children)
    end

    kids = join(children)
    props = join([string(k, "=", "\"" * v * "\"") for (k, v) in pairs(properties)], " ")
    
    if isempty(props)
        "<$(tag)>$kids</$(tag)>"
    else
        "<$(tag) $props>$kids</$(tag)>"
    end
end