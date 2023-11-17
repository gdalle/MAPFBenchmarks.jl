"""
    MAPFBenchmarks

Interface between the package MultiAgentPathFinding.jl (<https://github.com/gdalle/MultiAgentPathFinding.jl>) and Sturtevant's MAPF benchmarks (<https://movingai.com/benchmarks/mapf.html>).

The data files will be downloaded automatically when you run the core function [`read_benchmark_mapf`](@ref).
See <https://movingai.com/benchmarks/formats.html> for the description of their format.
"""
module MAPFBenchmarks

using Base: @kwdef
using Colors: @colorant_str
using DataDeps: DataDep, register, @datadep_str, unpack
using DocStringExtensions: TYPEDFIELDS
using FillArrays: Ones
using GridGraphs: GridGraph, coord_to_index, QUEEN_DIRECTIONS_PLUS_CENTER
using MultiAgentPathFinding: MAPF, LazyVertexConflicts, LazySwappingConflicts

export MAPFBenchmarkProblem
export benchmark_graph
export benchmark_mapf
export read_benchmark_mapf
export cell_color

"""
    MAPFBenchmarkProblem

Encode one agent of a MAPF scenario.

# Fields

$(TYPEDFIELDS)
"""
@kwdef struct MAPFBenchmarkProblem
    index::Int
    bucket::Int
    map_path::String
    width::Int
    height::Int
    start_i::Int
    start_j::Int
    goal_i::Int
    goal_j::Int
    optimal_length::Float64
end

active_cell(c::Char) = (c == '.') || (c == 'G') || (c == 'S')

"""
    benchmark_graph(
        map_matrix::Matrix{Char};
        directions=QUEEN_DIRECTIONS_PLUS_CENTER,
        nb_corners_for_diag=2,
        pythagoras_cost_for_diag=true,
    )

Create a grid graph from a map specified as a matrix of characters.

Returns a `GridGraphs.GridGraph`.
"""
function benchmark_graph(
    map_matrix::Matrix{Char};
    directions=QUEEN_DIRECTIONS_PLUS_CENTER,
    nb_corners_for_diag=2,
    pythagoras_cost_for_diag=true,
)
    vertex_weights = Ones{Float64}(size(map_matrix))
    vertex_activities = active_cell.(map_matrix)
    g = GridGraph(
        vertex_weights,
        vertex_activities,
        directions,
        nb_corners_for_diag,
        pythagoras_cost_for_diag,
    )
    return g
end

"""
    benchmark_mapf(
        g::GridGraph,
        scenario::Vector{MAPFBenchmarkProblem};
        flexible_departure=false
    )

Create a MAPF instance from a grid graph and a scenario (i.e. a set of agents).

Returns a `MultiAgentPathFinding.MAPF`.
"""
function benchmark_mapf(
    g::GridGraph, scenario::Vector{MAPFBenchmarkProblem}; flexible_departure=true
)
    A = length(scenario)
    departures = Vector{Int}(undef, A)
    arrivals = Vector{Int}(undef, A)
    for a in 1:A
        problem = scenario[a]
        is, js = problem.start_i, problem.start_j
        id, jd = problem.goal_i, problem.goal_j
        s = coord_to_index(g, is, js)
        d = coord_to_index(g, id, jd)
        departures[a] = s
        arrivals[a] = d
    end
    @assert length(unique(departures)) == length(departures)
    @assert length(unique(arrivals)) == length(arrivals)
    departure_times = fill(1, A)

    mapf = MAPF(
        g;
        departures,
        arrivals,
        departure_times,
        vertex_conflicts=LazyVertexConflicts(),
        edge_conflicts=LazySwappingConflicts(),
        flexible_departure,
    )

    return mapf
end

"""
    read_benchmark_map(map_name::AbstractString)

Read a map matrix from a text file.

Returns a `Matrix{Char}`.
"""
function read_benchmark_map(map_name::AbstractString)
    map_path = joinpath(datadep"mapf-map", map_name)
    lines = open(map_path, "r") do file
        readlines(file)
    end
    height_line = split(lines[2])
    height = parse(Int, height_line[2])
    width_line = split(lines[3])
    width = parse(Int, width_line[2])
    map_matrix = Matrix{Char}(undef, height, width)
    for i in 1:height
        line = lines[4 + i]
        for j in 1:width
            map_matrix[i, j] = line[j]
        end
    end
    return map_matrix
end

"""
    read_benchmark_scenario(scenario_name::AbstractString, map_name::AbstractString)

Read a scenario from a text file, and check that it corresponds to a given map.

Returns a `Vector{MAPFBenchmarkProblem}`.
"""
function read_benchmark_scenario(scenario_name::AbstractString, map_name::AbstractString)
    scenario_path = ""
    if occursin("random", scenario_name)
        scenario_path = joinpath(datadep"mapf-scen-random", "scen-random", scenario_name)
    elseif occursin("even", scenario_name)
        scenario_path = joinpath(datadep"mapf-scen-even", "scen-even", scenario_name)
    else
        error("Invalid scenario")
    end
    lines = open(scenario_path, "r") do file
        readlines(file)
    end
    scenario = MAPFBenchmarkProblem[]
    for (l, line) in enumerate(view(lines, 2:length(lines)))
        line_split = split(line, "\t")
        bucket = parse(Int, line_split[1]) + 1
        map_path = line_split[2]
        width = parse(Int, line_split[3])
        height = parse(Int, line_split[4])
        start_x = parse(Int, line_split[5])
        start_y = parse(Int, line_split[6])
        goal_x = parse(Int, line_split[7])
        goal_y = parse(Int, line_split[8])
        optimal_length = parse(Float64, line_split[9])
        @assert endswith(map_name, map_path)
        start_i = start_y + 1
        start_j = start_x + 1
        goal_i = goal_y + 1
        goal_j = goal_x + 1
        problem = MAPFBenchmarkProblem(;
            index=l,
            bucket=bucket,
            map_path=map_path,
            width=width,
            height=height,
            start_i=start_i,
            start_j=start_j,
            goal_i=goal_i,
            goal_j=goal_j,
            optimal_length=optimal_length,
        )
        push!(scenario, problem)
    end
    return scenario
end

"""
    read_benchmark_mapf(
        map_name::AbstractString,
        scenario_name::AbstractString;
        directions=QUEEN_DIRECTIONS_PLUS_CENTER,
        nb_corners_for_diag=2,
        pythagoras_cost_for_diag=true,
        flexible_departure=false,
    )

Create a MAPF instance by reading a map (`"something.map"`) and scenario (`"something.scen"`) from files.

Returns a `MultiAgentPathFinding.MAPF`.

# Example

```jldoctest
using Graphs, MAPFBenchmarks, MultiAgentPathFinding
mapf = read_benchmark_mapf("Berlin_1_256.map", "Berlin_1_256-random-1.scen")
nv(mapf.g), nb_agents(mapf)

# output

(65536, 1000)
```
"""
function read_benchmark_mapf(
    map_name::AbstractString,
    scenario_name::AbstractString;
    directions=QUEEN_DIRECTIONS_PLUS_CENTER,
    nb_corners_for_diag=2,
    pythagoras_cost_for_diag=true,
    flexible_departure=false,
)
    map_matrix = read_benchmark_map(map_name)
    scenario = read_benchmark_scenario(scenario_name, map_name)
    g = benchmark_graph(
        map_matrix; directions, nb_corners_for_diag, pythagoras_cost_for_diag
    )
    mapf = benchmark_mapf(g, scenario; flexible_departure)
    return mapf
end

"""
    cell_color(c::Char)

Give a color object corresponding to the type of cell.

To visualize a map in VSCode, just run `cell_color.(map_matrix)` in the REPL.
"""
function cell_color(c::Char)
    if c == '.'  # empty => white
        return colorant"white"
    elseif c == 'G'  # empty => white
        return colorant"white"
    elseif c == 'S'  # shallow water => brown
        return colorant"brown"
    elseif c == 'W'  # water => blue
        return colorant"blue"
    elseif c == 'T'  # trees => green
        return colorant"green"
    elseif c == '@'  # wall => black
        return colorant"black"
    elseif c == 'O'  # wall => black
        return colorant"black"
    elseif c == 'H'  # here => red
        return colorant"red"
    else  # ? => black
        return colorant"black"
    end
end

function __init__()
    register(
        DataDep(
            "mapf-map",
            """
            All maps from the Sturtevant MAPF benchmarks (73K)
            https://movingai.com/benchmarks/mapf/index.html
            """,
            "https://movingai.com/benchmarks/mapf/mapf-map.zip";
            post_fetch_method=unpack,
        ),
    )
    register(
        DataDep(
            "mapf-scen-random",
            """
            All random scenarios from the Sturtevant MAPF benchmarks (7.9M)
            https://movingai.com/benchmarks/mapf/index.html
            """,
            "https://movingai.com/benchmarks/mapf/mapf-scen-random.zip";
            post_fetch_method=unpack,
        ),
    )
    register(
        DataDep(
            "mapf-scen-even",
            """
            All even scenarios from the Sturtevant MAPF benchmarks (9.9M)
            https://movingai.com/benchmarks/mapf/index.html
            """,
            "https://movingai.com/benchmarks/mapf/mapf-scen-even.zip";
            post_fetch_method=unpack,
        ),
    )
    return nothing
end

end
