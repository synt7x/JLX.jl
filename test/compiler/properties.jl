@testset "Properties" begin
    @testset "Empty properties" begin
        ast = parse!("<p></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = ()
            )
        )
    end

    @testset "Properties with atoms" begin
        ast = parse!("<p property1={1 + 1} property2={2 + 2}></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                    property2 = JLX.atom(2 + 2)
                ),
                children = ()
            )
        )
    end

    @testset "Properties without quotes" begin
        ast = parse!("<p property1=hello property2=world></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = "hello",
                    property2 = "world"
                ),
                children = ()
            )
        )
    end

    @testset "Properties with quotes" begin
        ast = parse!("<p property1=\"hello\" property2=\"world\"></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = "hello",
                    property2 = "world"
                ),
                children = ()
            )
        )
    end
    
    @testset "Properties with no value" begin
        ast = parse!("<p property1 property2></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = true,
                    property2 = true
                ),
                children = ()
            )
        )
    end

    @testset "Properties in shorthand" begin
        ast = parse!("<p property1 property2 />", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = true,
                    property2 = true
                ),
                children = ()
            )
        )
    end

    @testset "Quoted properties in shorthand" begin
        ast = parse!("<p property1=\"hello\" property2=\"world\" />", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = "hello",
                    property2 = "world"
                ),
                children = ()
            )
        )
    end

    @testset "Atom properties in shorthand" begin
        ast = parse!("<p property1={1 + 1} property2={2 + 2} />", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                    property2 = JLX.atom(2 + 2)
                ),
                children = ()
            )
        )
    end
end