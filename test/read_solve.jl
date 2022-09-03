using Base.Threads
using Graphs
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

full_mapf = benchmark_mapf(terrain, scenario, stay_at_arrival=false)

mapf = select_agents(full_mapf, 100)
mapf.g

show_progress = true
sol_indep = independent_dijkstra(mapf; show_progress=show_progress);
sol_coop = cooperative_astar(mapf; show_progress=show_progress);
sol_os = optimality_search(mapf; show_progress=show_progress);
sol_fs = feasibility_search(mapf; show_progress=show_progress);
sol_ds = double_search(mapf; show_progress=show_progress);

!is_feasible(sol_indep, mapf)
is_feasible(sol_coop, mapf)
is_feasible(sol_os, mapf)
is_feasible(sol_fs, mapf)
is_feasible(sol_ds, mapf)

f_indep = flowtime(sol_indep, mapf)
f_coop = flowtime(sol_coop, mapf)
f_os = flowtime(sol_os, mapf)
f_fs = flowtime(sol_fs, mapf)
f_ds = flowtime(sol_ds, mapf)

@testset verbose = true "$instance-random-$scen_id" begin
    @test all(
        scenario[a].optimal_length ≈ path_weight(sol_indep[a], mapf) for
        a in 1:nb_agents(mapf)
    )
    @test !is_feasible(sol_indep, mapf)
    @test is_feasible(sol_coop, mapf)
    @test is_feasible(sol_os, mapf)
    @test is_feasible(sol_fs, mapf)
    @test is_feasible(sol_ds, mapf)
    @test f_indep <= f_coop
    @test f_indep <= f_os
    @test f_indep <= f_fs
    @test f_indep <= f_ds
end
