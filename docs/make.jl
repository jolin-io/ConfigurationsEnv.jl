using ConfigurationsENV
using Documenter

DocMeta.setdocmeta!(ConfigurationsENV, :DocTestSetup, :(using ConfigurationsENV); recursive=true)

makedocs(;
    modules=[ConfigurationsENV],
    authors="Stephan Sahm <stephan.sahm@jolin.io> and contributors",
    sitename="ConfigurationsENV.jl",
    format=Documenter.HTML(;
        canonical="https://jolin-io.github.io/ConfigurationsENV.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jolin-io/ConfigurationsENV.jl",
    devbranch="main",
)
