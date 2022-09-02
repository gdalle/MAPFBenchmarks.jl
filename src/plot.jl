function plot_benchmark_path(terrain::Matrix{Char}, mapf::MAPF, timed_path::TimedPath)
    h, w = GridGraphs.height(mapf.g), GridGraphs.width(mapf.g)
    coords = [GridGraphs.index_to_coord(mapf.g, v) for v in timed_path.path]
    img = cell_color.(terrain)
    f = Figure()
    ax = Axis(f[1, 1]; aspect=DataAspect())
    image!(ax, rotr90(img); interpolate=false)
    is = first.(coords) .- 0.5
    js = last.(coords) .- 0.5
    xs = js
    ys = h .- is
    Makie.scatter!(ax, xs, ys)
    return f
end
