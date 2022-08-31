using Base.Threads
using MAPFBenchmarks
using MultiAgentPathFinding
using Random
using Test

data_dir = joinpath(@__DIR__, "..", "data")

instance = "Berlin_1_256"
scenario_type = "even"
scenario_id = 3

map_path = joinpath(data_dir, "mapf-map", "$instance.map")
scenario_path = joinpath(
    data_dir,
    "mapf-scen-$scenario_type",
    "scen-$scenario_type",
    "$instance-$scenario_type-$scenario_id.scen",
)

map_matrix = read_benchmark_map(map_path)
scenario = read_benchmark_scenario(scenario_path, map_path)

mapf = benchmark_mapf(map_matrix, scenario; nb_agents=100)
mapf.g

show_progress = false

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

@testset verbose = true "$instance - $scenario_type - $scenario_id" begin
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
