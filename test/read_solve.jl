using MAPFBenchmarks
using MultiAgentPathFinding
using Random
using Test

map_name = "Berlin_1_256.map"
scenario_name = "Berlin_1_256-even-1.scen"

scenario = MAPFBenchmarks.read_benchmark_scenario(scenario_name, map_name)
full_mapf = read_benchmark_mapf(map_name, scenario_name; flexible_departure=true)

mapf = select_agents(full_mapf, 100)
mapf.g

show_progress = true
sol_indep = independent_dijkstra(mapf; show_progress=show_progress);
sol_coop = repeated_cooperative_astar(mapf; show_progress=show_progress);
sol_os, stats_os = optimality_search(mapf; show_progress=show_progress);
sol_fs, stats_fs = feasibility_search(
    mapf; feasibility_timeout=10, show_progress=show_progress
);
sol_ds, stats_ds = double_search(mapf; feasibility_timeout=10, show_progress=show_progress);

!is_feasible(sol_indep, mapf)
is_feasible(sol_coop, mapf; verbose=true)
is_feasible(sol_os, mapf; verbose=true)
is_feasible(sol_fs, mapf; verbose=true)
is_feasible(sol_ds, mapf; verbose=true)

f_indep = flowtime(sol_indep, mapf)
f_coop = flowtime(sol_coop, mapf)
f_os = flowtime(sol_os, mapf)
f_fs = flowtime(sol_fs, mapf)
f_ds = flowtime(sol_ds, mapf)

@testset begin
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
