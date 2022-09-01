module MAPFBenchmarks

using Base.Threads
using Colors
using FillArrays
using Graphs
using GridGraphs
using MultiAgentPathFinding

include("cells.jl")
include("problem.jl")
include("mapf.jl")
include("read.jl")

export cell_color, active_cell
export MAPFBenchmarkProblem
export benchmark_mapf
export read_benchmark_map, read_benchmark_scenario, read_benchmark_mapf

end
