using Pkg
using TestEnv
Pkg.activate(dirname(@__DIR__))
TestEnv.activate()

using Base.Threads
using CSV
using Dates
using DataFrames
using MAPFBenchmarks
using MultiAgentPathFinding
using Random
using Test

data_dir = joinpath(@__DIR__, "..", "data")

function solve_with_stats(mapf::MAPF; params)
    indep_res = @timed independent_dijkstra(mapf; show_progress=params.show_progress)
    indep_solution = indep_res.value
    indep_feasible = is_feasible(indep_solution, mapf)
    indep_flowtime = flowtime(indep_solution, mapf)
    indep_stats = (
        indep_feasible=indep_feasible,
        indep_flowtime=indep_flowtime,
        indep_cpu=indep_res.time,
    )

    coop_res = @timed cooperative_astar(
        mapf; max_trials=params.coop_max_trials, show_progress=params.show_progress
    )
    coop_solution = coop_res.value
    coop_feasible = is_feasible(coop_solution, mapf)
    coop_flowtime = flowtime(coop_solution, mapf)
    coop_stats = (
        coop_feasible=coop_feasible, coop_flowtime=coop_flowtime, coop_cpu=coop_res.time
    )

    opt_res = @timed optimality_search(
        mapf;
        coop_max_trials=params.coop_max_trials,
        window=params.window,
        neighborhood_size=params.neighborhood_size,
        max_stagnation=params.optimality_max_stagnation,
        show_progress=params.show_progress,
    )
    opt_solution = opt_res.value
    opt_feasible = is_feasible(opt_solution, mapf)
    opt_flowtime = flowtime(opt_solution, mapf)
    opt_stats = (opt_feasible=opt_feasible, opt_flowtime=opt_flowtime, opt_cpu=opt_res.time)

    double_res = @timed double_search(
        mapf;
        window=params.window,
        neighborhood_size=params.neighborhood_size,
        conflict_price=params.conflict_price,
        conflict_price_increase=params.conflict_price_increase,
        feasibility_max_stagnation=params.feasibility_max_stagnation,
        optimality_max_stagnation=params.optimality_max_stagnation,
        show_progress=params.show_progress,
    )
    double_solution = double_res.value
    double_feasible = is_feasible(double_solution, mapf)
    double_flowtime = flowtime(double_solution, mapf)
    double_stats = (
        double_feasible=double_feasible,
        double_flowtime=double_flowtime,
        double_cpu=double_res.time,
    )

    stats = merge(indep_stats, coop_stats, opt_stats, double_stats)
    return stats
end

function do_the_stuff(; terrain_dir, scen_random_dir, S, all_A, stay_at_arrival, params)
    results_folder = joinpath(@__DIR__, "results")
    isdir(results_folder) || mkdir(results_folder)
    terrain_files = readdir(terrain_dir)
    T = length(terrain_files)

    for t in 1:T
        terrain_file = terrain_files[t]
        terrain_path = joinpath(terrain_dir, terrain_file)
        instance = replace(terrain_file, r".map$" => "")
        terrain = read_benchmark_terrain(terrain_path)
        empty_mapf = empty_benchmark_mapf(terrain; stay_at_arrival=stay_at_arrival)

        @threads for scen_id in 1:S
            csv_path = joinpath(results_folder, "$instance-random-$scen_id.csv")
            scenario_path = joinpath(scen_random_dir, "$instance-random-$scen_id.scen")
            scenario = read_benchmark_scenario(scenario_path, terrain_path)
            full_mapf = add_benchmark_agents(empty_mapf, scenario)

            scen_results = DataFrame()
            for i in eachindex(all_A)
                A = all_A[i]
                A <= length(scenario) || continue
                @info "Thread $(threadid()) - Instance $instance - Scenario $scen_id - A=$A"
                mapf = select_agents(full_mapf, A)
                metadata = (
                    date=now(),
                    instance=instance,
                    scen_type="random",
                    scen_id=scen_id,
                    A=A,
                    stay_at_arrival=stay_at_arrival,
                )
                stats = solve_with_stats(mapf; params=params)
                push!(scen_results, merge(metadata, stats, params))
            end
            CSV.write(csv_path, scen_results)
        end
    end
end

do_the_stuff(;
    terrain_dir=joinpath(data_dir, "mapf-map"),
    scen_random_dir=joinpath(data_dir, "mapf-scen-random", "scen-random"),
    S=25,
    all_A=[50],
    stay_at_arrival=true,
    params=(
        coop_max_trials=20,
        window=10,
        neighborhood_size=5,
        conflict_price=1.0,
        conflict_price_increase=2e-2,
        feasibility_max_stagnation=100,
        optimality_max_stagnation=100,
        show_progress=false,
    ),
)
