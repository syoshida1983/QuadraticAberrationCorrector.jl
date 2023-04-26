using QuadraticAberrationCorrector
using Documenter

DocMeta.setdocmeta!(QuadraticAberrationCorrector, :DocTestSetup, :(using QuadraticAberrationCorrector); recursive=true)

makedocs(;
    modules=[QuadraticAberrationCorrector],
    authors="Shuhei Yoshida <yshuhei@ele.kindai.ac.jp> and contributors",
    repo="https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/blob/{commit}{path}#{line}",
    sitename="QuadraticAberrationCorrector.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://syoshida1983.github.io/QuadraticAberrationCorrector.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/syoshida1983/QuadraticAberrationCorrector.jl",
    devbranch="master",
)
