module JLX
    include("generator/content.jl")
    include("generator/atom.jl")  
    include("generator/element.jl")

    include("compiler/transform.jl")
    include("macros.jl")

    export @include
end