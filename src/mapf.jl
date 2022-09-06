function empty_benchmark_mapf(
    terrain::Matrix{Char};
    directions=GridGraphs.rook_directions_plus_center,
    diag_through_corner=false,
    stay_at_arrival=true,
)
    active = active_cell.(terrain)
    weights = Ones{Float64}(size(active))
    g = GridGraph{Int}(weights, active, directions, diag_through_corner)
    mapf = MAPF(
        g;
        departures=Int[],
        arrivals=Int[],
        departure_times=Int[],
        vertex_conflicts=MultiAgentPathFinding.LazyVertexConflicts(),
        edge_conflicts=MultiAgentPathFinding.LazySwappingConflicts(),
        stay_at_arrival=stay_at_arrival,
    )
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
    @assert length(unique(departures)) == length(departures)
    @assert length(unique(arrivals)) == length(arrivals)
    departure_times = fill(1, A)
    return replace_agents(mapf, departures, arrivals, departure_times)
end

function benchmark_mapf(terrain, scenario; kwargs...)
    empty_mapf = empty_benchmark_mapf(terrain; kwargs...)
    mapf = add_benchmark_agents(empty_mapf, scenario)
    return mapf
end
