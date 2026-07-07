@testset "Component" begin
    @testset "Component with no properties or children" begin
        ast = parse!("<Component></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(children = ())
        )
    end

    @testset "Component with properties" begin
        ast = parse!("<Component property1={1 + 1} property2={2 + 2}></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                property1 = JLX.atom(1 + 1),
                property2 = JLX.atom(2 + 2),
                children = ()
            )
        )
    end

    @testset "Component with children" begin
        ast = parse!("<Component><div></div><span></span></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end

    @testset "Component with properties and children" begin
        ast = parse!("<Component property1={1 + 1} property2={2 + 2}><div></div><span></span></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                property1 = JLX.atom(1 + 1),
                property2 = JLX.atom(2 + 2),
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end

    @testset "Component with nested components" begin
        ast = parse!("<Component><NestedComponent></NestedComponent></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                children = (
                    NestedComponent(children = ()),
                )
            )
        )
    end

    @testset "Shorthand component with no properties or children" begin
        ast = parse!("<Component />", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(children = ())
        )
    end

    @testset "Shorthand component with properties" begin
        ast = parse!("<Component property1={1 + 1} property2={2 + 2} />", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                property1 = JLX.atom(1 + 1),
                property2 = JLX.atom(2 + 2),
                children = ()
            )
        )
    end

    @testset "Shorthand component with children" begin
        ast = parse!("<Component><div></div><span></span></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end

    @testset "Shorthand component with properties and children" begin
        ast = parse!("<Component property1={1 + 1} property2={2 + 2}><div></div><span></span></Component>", "component.jl").args[2]

        @test transform!(ast) == :(
            Component(
                property1 = JLX.atom(1 + 1),
                property2 = JLX.atom(2 + 2),
                children = (
                    JLX.element("div", properties = NamedTuple(), children = ()),
                    JLX.element("span", properties = NamedTuple(), children = ())
                )
            )
        )
    end
end