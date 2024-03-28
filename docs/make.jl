using ConfigurationsEnv
using Documenter

DocMeta.setdocmeta!(ConfigurationsEnv, :DocTestSetup, :(using ConfigurationsEnv); recursive=true)

makedocs(;
    modules=[ConfigurationsEnv],
    authors="Stephan Sahm <stephan.sahm@jolin.io> and contributors",
    sitename="ConfigurationsEnv.jl",
    format=Documenter.HTML(;
        canonical="https://jolin-io.github.io/ConfigurationsEnv.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jolin-io/ConfigurationsEnv.jl",
    devbranch="main",
)
