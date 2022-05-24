using MAPFBenchmarks
using Documenter

DocMeta.setdocmeta!(MAPFBenchmarks, :DocTestSetup, :(using MAPFBenchmarks); recursive=true)

makedocs(;
    modules=[MAPFBenchmarks],
    authors="Guillaume Dalle <22795598+gdalle@users.noreply.github.com> and contributors",
    repo="https://github.com/gdalle/MAPFBenchmarks.jl/blob/{commit}{path}#{line}",
    sitename="MAPFBenchmarks.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://gdalle.github.io/MAPFBenchmarks.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/gdalle/MAPFBenchmarks.jl",
    devbranch="main",
)
