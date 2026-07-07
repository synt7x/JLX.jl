@testset "Tag" begin
    @testset "Tag with no properties or children" begin
        ast = parse!("<p></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = ()
            )
        )
    end

    @testset "Tag with properties" begin
        ast = parse!("<p property1={1 + 1} property2={2 + 2}></p>", "tag.jl").args[2]

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

    @testset "Tag with children" begin
        ast = parse!("<p><div></div><span></span></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end

    @testset "Tag with properties and children" begin
        ast = parse!("<p property1={1 + 1} property2={2 + 2}><div></div><span></span></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                    property2 = JLX.atom(2 + 2)
                ),
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end

    @testset "Tag with nested tags" begin
        ast = parse!("<p><div><span></span></div></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = NamedTuple(),
                children = (
                    JLX.element(
                        "div",
                        properties = NamedTuple(),
                        children = (
                            JLX.element("span", properties = NamedTuple(), children = ()),
                        )
                    ),
                )
            )
        )
    end

    @testset "Tag with nested tags and properties" begin
        ast = parse!("<p property1={1 + 1}><div property2={2 + 2}><span></span></div></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                ),
                children = (
                    JLX.element(
                        "div",
                        properties = (
                            property2 = JLX.atom(2 + 2),
                        ),
                        children = (
                            JLX.element("span", properties = NamedTuple(), children = ()),
                        )
                    ),
                )
            )
        )
    end

    @testset "Tag with nested tags, properties, and children" begin
        ast = parse!("<p property1={1 + 1}><div property2={2 + 2}><span>{3 + 3}</span></div></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                ),
                children = (
                    JLX.element(
                        "div",
                        properties = (
                            property2 = JLX.atom(2 + 2),
                        ),
                        children = (
                            JLX.element(
                                "span",
                                properties = NamedTuple(),
                                children = (JLX.atom(3 + 3),)
                            ),
                        )
                    ),
                )
            )
        )
    end

    @testset "Tag with nested tags, properties, children, and atoms" begin
        ast = parse!("<p property1={1 + 1}><div property2={2 + 2}><span>{3 + 3}</span>{4 + 4}</div></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                ),
                children = (
                    JLX.element(
                        "div",
                        properties = (
                            property2 = JLX.atom(2 + 2),
                        ),
                        children = (
                            JLX.element(
                                "span",
                                properties = NamedTuple(),
                                children = (JLX.atom(3 + 3),)
                            ),
                            JLX.atom(4 + 4)
                        )
                    ),
                )
            )
        )
    end

    @testset "Tag with nested tags, properties, children, atoms, and fragments" begin
        ast = parse!("<p property1={1 + 1}><div property2={2 + 2}><span>{3 + 3}</span>{4 + 4}<></></div></p>", "tag.jl").args[2]

        @test transform!(ast) == :(
            JLX.element(
                "p",
                properties = (
                    property1 = JLX.atom(1 + 1),
                ),
                children = (
                    JLX.element(
                        "div",
                        properties = (
                            property2 = JLX.atom(2 + 2),
                        ),
                        children = (
                            JLX.element(
                                "span",
                                properties = NamedTuple(),
                                children = (JLX.atom(3 + 3),)
                            ),
                            JLX.atom(4 + 4),
                            JLX.element(nothing, children = ())
                        )
                    ),
                )
            )
        )
    end
end