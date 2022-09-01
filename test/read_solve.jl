using Base.Threads
using Graphs
using GridGraphs
using MAPFBenchmarks
using MultiAgentPathFinding
using Random
using Test

data_dir = joinpath(@__DIR__, "..", "data")
map_dir = joinpath(data_dir, "mapf-map")
scen_random_dir = joinpath(data_dir, "mapf-scen-random", "scen-random")

instance = "Berlin_1_256"
scen_id = 3

map_path = joinpath(map_dir, "$instance.map")
scenario_path = joinpath(scen_random_dir, "$instance-random-$scen_id.scen")

map_matrix = read_benchmark_map(map_path)
scenario = read_benchmark_scenario(scenario_path, map_path)

active = active_cell.(map_matrix)
weights = ones(Bool, size(active))
grid = GridGraph{Int}(weights, active, GridGraphs.queen_directions, true)
g = SimpleDiGraph(grid)

cell_color.(map_matrix)

full_mapf = benchmark_mapf(map_matrix, scenario)
full_mapf.g

mapf = select_agents(full_mapf, 100)

show_progress = true
solution_indep = independent_dijkstra(mapf);
solution_coop = cooperative_astar(mapf);
solution_os = optimality_search(mapf; show_progress=show_progress);
solution_fs = feasibility_search(mapf; show_progress=show_progress);
solution_ds = double_search(mapf; show_progress=show_progress);

f_indep = flowtime(solution_indep, mapf)
f_coop = flowtime(solution_coop, mapf)
f_os = flowtime(solution_os, mapf)
f_fs = flowtime(solution_fs, mapf)
f_ds = flowtime(solution_ds, mapf)

@testset verbose = true "$instance-random-$scen_id" begin
    @test !is_feasible(solution_indep, mapf)
    @test is_feasible(solution_coop, mapf)
    @test is_feasible(solution_os, mapf)
    @test is_feasible(solution_fs, mapf)
    @test is_feasible(solution_ds, mapf)
    @test f_indep <= f_coop
    @test f_indep <= f_os
    @test f_indep <= f_fs
    @test f_indep <= f_ds
end
