using DataDeps
using MAPFBenchmarks
using Graphs
using MultiAgentPathFinding
using Documenter

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

datadep"mapf-map"
datadep"mapf-scen-even"
datadep"mapf-scen-random"

DocMeta.setdocmeta!(MAPFBenchmarks, :DocTestSetup, :(using MAPFBenchmarks); recursive=true)

makedocs(;
    modules=[MAPFBenchmarks],
    authors="Guillaume Dalle",
    sitename="MAPFBenchmarks.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        repolink="https://github.com/gdalle/MAPFBenchmarks.jl",
        canonical="https://gdalle.github.io/MAPFBenchmarks.jl",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/gdalle/MAPFBenchmarks.jl", devbranch="main")
