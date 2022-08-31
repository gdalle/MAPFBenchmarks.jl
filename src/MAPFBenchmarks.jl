module MAPFBenchmarks

using Base.Threads
using Colors
using FillArrays
using Graphs
using GridGraphs
using MultiAgentPathFinding
using HTTP
using ZipFile

include("read.jl")
include("colors.jl")

export MAPFBenchmarkProblem
export read_benchmark_map, read_benchmark_scenario
export benchmark_mapf, read_benchmark_mapf
export get_map_colors

end
