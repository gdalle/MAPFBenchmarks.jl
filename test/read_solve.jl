using Base.Threads
using Graphs
using GridGraphs
using MAPFBenchmarks
using MultiAgentPathFinding
using Random
using Test

data_dir = joinpath(@__DIR__, "..", "data")
terrain_dir = joinpath(data_dir, "mapf-map")
scen_random_dir = joinpath(data_dir, "mapf-scen-random", "scen-random")

instance = "Boston_0_256"
scen_id = 3

terrain_path = joinpath(terrain_dir, "$instance.map")
scenario_path = joinpath(scen_random_dir, "$instance-random-$scen_id.scen")

terrain = read_benchmark_terrain(terrain_path);
scenario = read_benchmark_scenario(scenario_path, terrain_path);

full_mapf = benchmark_mapf(terrain, scenario)

mapf = select_agents(full_mapf, 100)
mapf.g

show_progress = true
solution_indep = independent_dijkstra(mapf; show_progress=show_progress);
solution_coop = cooperative_astar(mapf; show_progress=show_progress);
solution_os = optimality_search(mapf; show_progress=show_progress);
solution_fs = feasibility_search(mapf; show_progress=show_progress);
solution_ds = double_search(mapf; show_progress=show_progress);

!is_feasible(solution_indep, mapf)
is_feasible(solution_coop, mapf)
is_feasible(solution_os, mapf)
is_feasible(solution_fs, mapf)
is_feasible(solution_ds, mapf)

f_indep = flowtime(solution_indep, mapf)
f_coop = flowtime(solution_coop, mapf)
f_os = flowtime(solution_os, mapf)
f_fs = flowtime(solution_fs, mapf)
f_ds = flowtime(solution_ds, mapf)

@testset verbose = true "$instance-random-$scen_id" begin
    @test all(
        scenario[a].optimal_length ≈ path_weight(solution_indep[a], mapf) for
        a in 1:nb_agents(mapf)
    )
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
