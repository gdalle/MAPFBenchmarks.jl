```@meta
CurrentModule = MAPFBenchmarks
```

# MAPFBenchmarks.jl

This package is an interface between the algorithms from [`MultiAgentPathFinding.jl`](https://github.com/gdalle/MultiAgentPathFinding.jl) and the grid instances from Sturtevant's MAPF benchmark[^1].

[^1]: [*Benchmarks for Grid-Based Pathfinding*](https://ieeexplore.ieee.org/document/6194296), Sturtevant (2012)

## Downloading instances

We provide a function `download_benchmark_mapf` that can be used to download instances one at a time.
However, if you want to work on several instances, it will be more efficient to download them beforehand. To do that:

1. Clone the `MAPFBenchmarks.jl` repository
2. Go to <https://movingai.com/benchmarks/grids.html>
3. Download and extract the zip files for both maps and benchmark problems into a folder of your choosing, for instance `MAPFBenchmarks.jl/data`

The file format is described [here](https://webdocs.cs.ualberta.ca/~nathanst/papers/benchmarks.pdf).

!!! warning "Warning"
    Please keep the following limitations in mind:
    1. We don't support [weighted maps](https://movingai.com/benchmarks/weighted/index.html) yet.
    2. As of right now, the cost of a diagonal move in our implementation is ``1`` instead of ``\sqrt{2}``.
