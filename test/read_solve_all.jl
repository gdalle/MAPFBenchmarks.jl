using Base.Threads
using MAPFBenchmarks
using MultiAgentPathFinding
using ProgressMeter
using Random
using Test

data_dir = joinpath(@__DIR__, "..", "data")
map_dir = joinpath(data_dir, "mapf-map")
scen_random_dir = joinpath(data_dir, "mapf-scen-random", "scen-random")

for map_file in readdir(map_dir)
    instance = replace(map_file, r".map$" => "")
    map_path = joinpath(map_dir, map_file)
    @showprogress "Instance $instance" for scen_id in 1:25
        scen_random_path = joinpath(scen_random_dir, "$instance-random-$scen_id.scen")
        mapf_random = read_benchmark_mapf(map_path, scen_random_path; nb_agents=1000)
    end
end
