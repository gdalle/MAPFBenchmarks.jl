module MAPFBenchmarks

using Base.Threads
using Colors
using FillArrays
using Graphs
using GridGraphs
using MultiAgentPathFinding
using Requires

include("cells.jl")
include("problem.jl")
include("mapf.jl")
include("read.jl")

export cell_color, active_cell
export MAPFBenchmarkProblem
export empty_benchmark_mapf, add_benchmark_agents, benchmark_mapf
export read_benchmark_terrain, read_benchmark_scenario, read_benchmark_mapf

function __init__()
    @require GLMakie = "e9467ef8-e4e7-5192-8a1a-b1aee30e663a" begin
        using .GLMakie
        include("plot.jl")
    end
end

end
