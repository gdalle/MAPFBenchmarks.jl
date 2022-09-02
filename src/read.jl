"""
    read_benchmark_terrain(terrain_path)
"""
function read_benchmark_terrain(terrain_path::AbstractString)
    lines = open(terrain_path, "r") do file
        readlines(file)
    end
    height_line = split(lines[2])
    height = parse(Int, height_line[2])
    width_line = split(lines[3])
    width = parse(Int, width_line[2])
    terrain = Matrix{Char}(undef, height, width)
    for i in 1:height
        line = lines[4 + i]
        for j in 1:width
            terrain[i, j] = line[j]
        end
    end
    return terrain
end

"""
    read_benchmark_scenario(scenario_path, terrain_path)
"""
function read_benchmark_scenario(
    scenario_path::AbstractString, terrain_path::AbstractString
)
    lines = open(scenario_path, "r") do file
        readlines(file)
    end
    scenario = MAPFBenchmarkProblem[]
    for (l, line) in enumerate(view(lines, 2:length(lines)))
        line_split = split(line, "\t")
        bucket = parse(Int, line_split[1]) + 1
        map = line_split[2]
        width = parse(Int, line_split[3])
        height = parse(Int, line_split[4])
        start_x = parse(Int, line_split[5])
        start_y = parse(Int, line_split[6])
        goal_x = parse(Int, line_split[7])
        goal_y = parse(Int, line_split[8])
        optimal_length = parse(Float64, line_split[9])
        @assert endswith(terrain_path, map)
        start_i = start_y + 1
        start_j = start_x + 1
        goal_i = goal_y + 1
        goal_j = goal_x + 1
        problem = MAPFBenchmarkProblem(;
            index=l,
            bucket=bucket,
            map=map,
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

function read_benchmark_mapf(terrain_path::AbstractString, scenario_path::AbstractString)
    terrain = read_benchmark_terrain(terrain_path)
    scenario = read_benchmark_scenario(scenario_path, terrain_path)
    return benchmark_mapf(terrain, scenario)
end
