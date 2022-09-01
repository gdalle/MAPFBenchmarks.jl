
function benchmark_mapf(map_matrix::Matrix{Char}, scenario::Vector{MAPFBenchmarkProblem})
    # Create graph
    active = active_cell.(map_matrix)
    weights = Ones{Float64}(size(active))
    g = GridGraph{Int}(weights, active, GridGraphs.queen_directions, true)
    # Add sources and destinations
    sources, destinations = Int[], Int[]
    for a in 1:length(scenario)
        problem = scenario[a]
        is, js = problem.start_i, problem.start_j
        id, jd = problem.goal_i, problem.goal_j
        s = GridGraphs.coord_to_index(g, is, js)
        d = GridGraphs.coord_to_index(g, id, jd)
        @assert GridGraphs.active_vertex(g, s)
        @assert GridGraphs.active_vertex(g, d)
        push!(sources, s)
        push!(destinations, d)
    end
    # Create MAPF
    mapf = MAPF(g, sources, destinations)
    return mapf
end
