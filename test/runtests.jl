using Aqua
using MAPFBenchmarks
using MultiAgentPathFinding
using Test

@testset verbose = true "MAPFBenchmarks.jl" begin
    @testset "Code quality (Aqua)" begin
        Aqua.test_all(MultiAgentPathFinding; ambiguities=false, deps_compat=false)  # TODO: deps compat
    end
    @testset "Read + solve" begin
        include("read_solve.jl")
    end
end
