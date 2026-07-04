function atom(node)
    if node isa Vector
        return join(atom.(node))
    elseif node isa Tuple
        return join(atom.(node))
    end

    return node
end