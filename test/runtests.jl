using Test

using JLX
using JLXSyntax

@testset "JLX" begin
    @testset "Compiler" begin
        include("compiler/atom.jl")
        include("compiler/component.jl")
        include("compiler/fragment.jl")
        include("compiler/properties.jl")
        include("compiler/tag.jl")
    end
end