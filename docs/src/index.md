```@meta
CurrentModule = MAPFBenchmarks
```

# MAPFBenchmarks.jl

This package is an interface between the algorithms from [`MultiAgentPathFinding.jl`](https://github.com/gdalle/MultiAgentPathFinding.jl) and the grid instances from Sturtevant's MAPF benchmark[^1].

[^1]: [*Benchmarks for Grid-Based Pathfinding*](https://ieeexplore.ieee.org/document/6194296), Sturtevant (2012)

To work on these instances:

1. Clone the `MAPFBenchmarks.jl` repository
2. Go to <https://movingai.com/benchmarks/grids.html>
3. Download and extract the zip files for maps and scenarios into a folder of your choosing, for instance `MAPFBenchmarks.jl/data`.

The file format is described [here](https://webdocs.cs.ualberta.ca/~nathanst/papers/benchmarks.pdf).
