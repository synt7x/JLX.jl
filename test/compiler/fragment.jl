@testset "Fragment" begin
    @testset "Empty fragment" begin
        ast = parse!("<></>", "fragment.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(nothing, children = ())
        )
    end

    @testset "Fragment with children" begin
        ast = parse!("<><div></div><span></span></>", "fragment.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                nothing,
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end
end