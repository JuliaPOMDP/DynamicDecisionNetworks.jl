using Documenter, DynamicDecisionNetworks

makedocs(;
    modules=[DynamicDecisionNetworks],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/zsunberg/DynamicDecisionNetworks.jl/blob/{commit}{path}#L{line}",
    sitename="DynamicDecisionNetworks.jl",
    authors="Zachary Sunberg <sunbergzach@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/zsunberg/DynamicDecisionNetworks.jl",
)
