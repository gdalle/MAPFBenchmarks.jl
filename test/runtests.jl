using Aqua
using Documenter
using JuliaFormatter
using MAPFBenchmarks
using MultiAgentPathFinding
using Test

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

@testset verbose = true "MAPFBenchmarks.jl" begin
    @testset "Code quality (Aqua)" begin
        Aqua.test_all(MultiAgentPathFinding; ambiguities=false, deps_compat=false)  # TODO: deps compat
    end
    @testset "Code formatting (JuliaFormatter)" begin
        @test JuliaFormatter.format(MultiAgentPathFinding; overwrite=false)
    end
    @testset "Doctestst" begin
        Documenter.doctest(MultiAgentPathFinding)
    end
    @testset "Read + solve" begin
        include("read_solve.jl")
    end
end
