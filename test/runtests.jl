using Aqua
using MAPFBenchmarks
using MultiAgentPathFinding
using Test

@testset verbose = true "MAPFBenchmarks.jl" begin
    @testset verbose = true "Code quality (Aqua)" begin
        Aqua.test_all(MultiAgentPathFinding; ambiguities=false)
    end
    @testset verbose = true "Read + solve" begin
        include("read_solve.jl")
    end
end
