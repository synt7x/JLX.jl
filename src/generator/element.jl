function element(tag::String="div"; children::Tuple=(), properties::Any=NamedTuple())::String
    kids = join(children)
    props = join([string(k, "=", "\"" * v * "\"") for (k, v) in pairs(properties)], " ")
    if isempty(props)
        "<$(tag)>$kids</$(tag)>"
    else
        "<$(tag) $props>$kids</$(tag)>"
    end
end