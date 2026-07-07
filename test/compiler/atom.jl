@testset "Atom" begin
    @testset "Empty atom" begin
        ast = parse!("<p>{}</p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = (JLX.atom(),)
            )
        )
    end

    @testset "Atom property" begin
        ast = parse!("<p property={1 + 1}></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (property = JLX.atom(1 + 1),),
                children = ()
            )
        )
    end

    @testset "Atom children" begin
        ast = parse!("<p>{1 + 1}</p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = (JLX.atom(1 + 1),)
            )
        )
    end

    @testset "Atom property and children" begin
        ast = parse!("<p property={1 + 1}>{2 + 2}</p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (property = JLX.atom(1 + 1),),
                children = (JLX.atom(2 + 2),)
            )
        )
    end

    @testset "Nested atoms" begin
        ast = parse!("<p>{1 + 1}<h1>{2 + 2}</h1></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = (
                    JLX.atom(1 + 1),
                    JLX.element(
                        "h1",
                        properties = NamedTuple(),
                        children = (JLX.atom(2 + 2),)
                    )
                )
            )
        )
    end

    @testset "Nested atoms with properties" begin
        ast = parse!("<p property={1 + 1}>{2 + 2}<h1 property={3 + 3}>{4 + 4}</h1></p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (property = JLX.atom(1 + 1),),
                children = (
                    JLX.atom(2 + 2),
                    JLX.element(
                        "h1",
                        properties = (property = JLX.atom(3 + 3),),
                        children = (JLX.atom(4 + 4),)
                    )
                )
            )
        )
    end

    @testset "Neighboring atoms" begin
        ast = parse!("<p>{1 + 1}{2 + 2}</p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = (
                    JLX.atom(1 + 1),
                    JLX.atom(2 + 2)
                )
            )
        )
    end

    @testset "Neighboring atoms with properties" begin
        ast = parse!("<p property={1 + 1}>{2 + 2}{3 + 3}</p>", "atom.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (property = JLX.atom(1 + 1),),
                children = (
                    JLX.atom(2 + 2),
                    JLX.atom(3 + 3)
                )
            )
        )
    end
end