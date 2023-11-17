module MAPFBenchmarksMakieExt

using Colors
using GridGraphs: GridGraph, height, width, index_to_coord
using Makie
using MAPFBenchmarks
using MultiAgentPathFinding: MAPF, TimedPath

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

function plot_benchmark_path(
    map_matrix::Matrix{Char}, mapf::MAPF{W,G}, timed_path=nothing
) where {W,G<:GridGraph}
    h, w = height(mapf.g), width(mapf.g)
    img = cell_color.(map_matrix)
    f = Figure()
    ax = Axis(f[1, 1]; aspect=DataAspect())
    image!(ax, rotr90(img); interpolate=false)
    if !isnothing(timed_path)
        coords = [index_to_coord(mapf.g, v) for v in timed_path.path]
        is = first.(coords) .- 0.5
        js = last.(coords) .- 0.5
        xs = js
        ys = h .- is
        Makie.scatter!(ax, xs, ys)
    end
    return f
end

end
