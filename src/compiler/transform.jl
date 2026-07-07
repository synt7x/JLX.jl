
function generate_children(children)
    Expr(:tuple, children...)
end

function generate_properties(properties)
    isempty(properties) && return :(NamedTuple())

    Expr(:tuple, properties...)
end

function generate_component(name, properties, children)
    kids = generate_children(children)

    if isempty(properties)
        return :(
            $name(
                children=$kids
            )
        )
    end

    return :(
        $name(
            $(properties...),
            children=$kids
        )
    )
end

function generate_tag(tag, properties, children)
    if isnothing(tag)
        return :(
            JLX.element(
                nothing,
                children=$(generate_children(children))
            )
        )
    end

    tag = String(tag)

    props = generate_properties(properties)
    kids = generate_children(children)

    return :(
        JLX.element(
            $tag,
            properties=$props,
            children=$kids
        )
    )
end

function generate_property(name, value)
    Expr(:(=), Symbol(name), value)
end

function generate_argument(name, value)
    Expr(:kw, Symbol(name), value)
end

function transform_jlx!(ex, args)
    properties = []
    children = []

    tag_or_component = args[1]
    is_component = tag_or_component isa Expr && tag_or_component.head == :jlx_component
    is_tag = tag_or_component isa Expr && tag_or_component.head == :jlx_tag

    for arg in args[2:end]
        if arg isa Expr && arg.head == :jlx_property
            if is_tag
                if length(arg.args) == 1
                    push!(properties,
                        generate_property(arg.args[1], true)
                    )
                else
                    push!(properties,
                        generate_property(arg.args[1], transform!(arg.args[2]))
                    )
                end
            elseif is_component
                if length(arg.args) == 1
                    push!(properties,
                        generate_argument(arg.args[1], true)
                    )
                else
                    push!(properties,
                        generate_argument(arg.args[1], transform!(arg.args[2]))
                    )
                end
            end
        else
            push!(children, transform!(arg))
        end
    end

    name = is_component ? tag_or_component.args[1] : is_tag ? String(tag_or_component.args[1]) : nothing

    if is_component
        return generate_component(name, properties, children)
    end

    return generate_tag(name, properties, children)
end

function transform!(ex)
    ex isa Expr || return ex
    
    if ex.head == :jlx
        return transform_jlx!(ex, ex.args)
    elseif ex.head == :jlx_atom
        for (i, arg) in enumerate(ex.args)
            ex.args[i] = transform!(arg)
        end

        return :(JLX.atom($(ex.args...)))
    elseif ex.head == :jlx_content
        for (i, arg) in enumerate(ex.args)
            ex.args[i] = transform!(arg)
        end

        return :(JLX.content($(ex.args...)))
    end
    
    return Expr(ex.head, transform!.(ex.args)...)
end