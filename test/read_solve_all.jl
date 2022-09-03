using Base.Threads
using CSV
using Dates
using DataFrames
using MAPFBenchmarks
using MultiAgentPathFinding
using ProgressMeter
using Random
using Test

data_dir = joinpath(@__DIR__, "..", "data")

function solve_with_stats(mapf::MAPF; params, show_progress=false)
    indep_res = @timed independent_dijkstra(mapf; show_progress=show_progress)
    indep_solution = indep_res.value
    indep_feasible = is_feasible(indep_solution, mapf)
    indep_flowtime = flowtime(indep_solution, mapf)

    coop_res = @timed cooperative_astar(mapf; show_progress=show_progress)
    coop_solution = coop_res.value
    coop_feasible = is_feasible(coop_solution, mapf)
    coop_flowtime = flowtime(coop_solution, mapf)

    double_res = @timed double_search(mapf; params..., show_progress=show_progress)
    double_solution = double_res.value
    double_feasible = is_feasible(double_solution, mapf)
    double_flowtime = flowtime(double_solution, mapf)

    stats = (
        indep_cpu=indep_res.time,
        indep_flowtime=indep_flowtime,
        indep_feasible=indep_feasible,
        coop_cpu=coop_res.time,
        coop_flowtime=coop_flowtime,
        coop_gap=(coop_flowtime - indep_flowtime) / indep_flowtime,
        coop_feasible=coop_feasible,
        double_cpu=double_res.time,
        double_flowtime=double_flowtime,
        double_gap=(double_flowtime - indep_flowtime) / indep_flowtime,
        double_feasible=double_feasible,
        params...,
    )
    return stats
end

function do_the_stuff(;
    terrain_dir,
    scen_random_dir,
    S,
    all_A,
    stay_at_arrival,
    params,
    show_progress,
)
    terrains = readdir(terrain_dir)
    T = length(terrains)
    for t in 1:T
        terrain_file = terrains[t]
        instance = replace(terrain_file, r".map$" => "")
        terrain_path = joinpath(terrain_dir, terrain_file)
        terrain = read_benchmark_terrain(terrain_path)
        empty_mapf = empty_benchmark_mapf(terrain; stay_at_arrival=stay_at_arrival)
        if !isdir(joinpath(@__DIR__, "results", instance))
            mkdir(joinpath(@__DIR__, "results", instance))
        end
        @threads for scen_id in 1:S
            scenario_path = joinpath(scen_random_dir, "$instance-random-$scen_id.scen")
            scenario = read_benchmark_scenario(scenario_path, terrain_path)
            length(scenario) >= maximum(all_A) || continue
            full_mapf = add_benchmark_agents(empty_mapf, scenario)
            scen_results = DataFrame()
            for i in eachindex(all_A)
                A = all_A[i]
                @info "Thread $(threadid()) - Instance $instance - Scenario $scen_id - A=$A"
                mapf = select_agents(full_mapf, A)
                stats = solve_with_stats(mapf; params=params, show_progress=show_progress)
                res = (
                    date=now(),
                    instance=instance,
                    scen_type="random",
                    scen_id=scen_id,
                    A=A,
                    stay_at_arrival=stay_at_arrival,
                    stats...,
                )
                push!(scen_results, res)
            end
            CSV.write(
                joinpath(@__DIR__, "results", instance, "$instance-random-$scen_id.csv"),
                scen_results,
            )
        end
    end
end

do_the_stuff(;
    terrain_dir=joinpath(data_dir, "mapf-map"),
    scen_random_dir=joinpath(data_dir, "mapf-scen-random", "scen-random"),
    S=25,
    all_A=10:10:10,
    stay_at_arrival=false,
    params=(
        neighborhood_size=10,
        conflict_price=1e-1,
        conflict_price_increase=1e-2,
        feasibility_max_steps_without_improvement=100,
        optimality_max_steps_without_improvement=100,
    ),
    show_progress=false,
)
