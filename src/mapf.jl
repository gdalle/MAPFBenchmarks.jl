function empty_benchmark_mapf(terrain::Matrix{Char})
    active = active_cell.(terrain)
    weights = Ones{Float64}(size(active))
    g = GridGraph{Int}(weights, active, GridGraphs.all_directions, true)
    departures, arrivals = Int[], Int[]
    mapf = MAPF(g, departures, arrivals)
    return mapf
end

function add_benchmark_agents(mapf::MAPF, scenario::Vector{MAPFBenchmarkProblem})
    A = length(scenario)
    departures = Vector{Int}(undef, A)
    arrivals = Vector{Int}(undef, A)
    for a in 1:A
        problem = scenario[a]
        is, js = problem.start_i, problem.start_j
        id, jd = problem.goal_i, problem.goal_j
        s = GridGraphs.coord_to_index(mapf.g, is, js)
        d = GridGraphs.coord_to_index(mapf.g, id, jd)
        departures[a] = s
        arrivals[a] = d
    end
    departure_times = fill(1, A)
    return replace_agents(mapf, departures, arrivals, departure_times)
end

function benchmark_mapf(terrain, scenario)
    empty_mapf = empty_benchmark_mapf(terrain)
    mapf = add_benchmark_agents(empty_mapf, scenario)
    return mapf
end
