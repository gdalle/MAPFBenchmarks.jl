var documenterSearchIndex = {"docs":
[{"location":"api/#API-reference","page":"API reference","title":"API reference","text":"","category":"section"},{"location":"api/#Docstrings","page":"API reference","title":"Docstrings","text":"","category":"section"},{"location":"api/","page":"API reference","title":"API reference","text":"Modules = [MAPFBenchmarks]","category":"page"},{"location":"api/#MAPFBenchmarks.BenchmarkMAPF","page":"API reference","title":"MAPFBenchmarks.BenchmarkMAPF","text":"BenchmarkMAPF = MAPF{SparseGridGraph{Int64,Float64}}\n\nConcrete subtype of MultiAgentPathFinding.MAPF designed for the benchmark instances of Sturtevant.\n\n\n\n\n\n","category":"type"},{"location":"api/#MAPFBenchmarks.BenchmarkProblem","page":"API reference","title":"MAPFBenchmarks.BenchmarkProblem","text":"BenchmarkProblem\n\nFields\n\nindex::Int\nbucket::Int\nmap::String\nwidth::Int\nheight::Int\nstart_i::Int\nstart_j::Int\ngoal_i::Int\ngoal_j::Int\noptimal_length::Float64\n\n\n\n\n\n","category":"type"},{"location":"api/#MAPFBenchmarks.benchmark_mapf-Tuple{AbstractString, AbstractString}","page":"API reference","title":"MAPFBenchmarks.benchmark_mapf","text":"benchmark_mapf(map_path, scenario_path[; buckets])\n\n\n\n\n\n","category":"method"},{"location":"api/#MAPFBenchmarks.display_benchmark_map-Tuple{Matrix{Char}}","page":"API reference","title":"MAPFBenchmarks.display_benchmark_map","text":"display_benchmark_mapf(map_matrix::Matrix{Char})\n\n\n\n\n\n","category":"method"},{"location":"api/#MAPFBenchmarks.download_benchmark_mapf-Tuple{Any, Any}","page":"API reference","title":"MAPFBenchmarks.download_benchmark_mapf","text":"download_benchmark_mapf(series, instance[; buckets])\n\nDownload a map and scenario from https://movingai.com/benchmarks/.\n\nArguments\n\nseries: the family of maps (eg. \"street\")\ninstance: the map id (eg. \"Berlin_0_256\")\nbuckets: the set of buckets to consider in the scenario (eg. 1:10)\n\n\n\n\n\n","category":"method"},{"location":"api/#MAPFBenchmarks.read_benchmark_map-Tuple{AbstractString}","page":"API reference","title":"MAPFBenchmarks.read_benchmark_map","text":"read_benchmark_map(map_path)\n\n\n\n\n\n","category":"method"},{"location":"api/#MAPFBenchmarks.read_benchmark_scenario-Tuple{AbstractString, AbstractString}","page":"API reference","title":"MAPFBenchmarks.read_benchmark_scenario","text":"read_benchmark_scenario(scenario_path, map_path)\n\n\n\n\n\n","category":"method"},{"location":"api/#Index","page":"API reference","title":"Index","text":"","category":"section"},{"location":"api/","page":"API reference","title":"API reference","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = MAPFBenchmarks","category":"page"},{"location":"#MAPFBenchmarks.jl","page":"Home","title":"MAPFBenchmarks.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is an interface between the algorithms from MultiAgentPathFinding.jl and the grid instances from Sturtevant's MAPF benchmark[1].","category":"page"},{"location":"","page":"Home","title":"Home","text":"[1]: Benchmarks for Grid-Based Pathfinding, Sturtevant (2012)","category":"page"},{"location":"#Downloading-instances","page":"Home","title":"Downloading instances","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"We provide a function download_benchmark_mapf that can be used to download instances one at a time. However, if you want to work on several instances, it will be more efficient to download them beforehand. To do that:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Clone the MAPFBenchmarks.jl repository\nGo to https://movingai.com/benchmarks/grids.html\nDownload and extract the zip files for both maps and benchmark problems into a folder of your choosing, for instance MAPFBenchmarks.jl/data","category":"page"},{"location":"","page":"Home","title":"Home","text":"The file format is described here.","category":"page"},{"location":"","page":"Home","title":"Home","text":"warning: Warning\nPlease keep the following limitations in mind:We don't support weighted maps yet.\nAs of right now, the cost of a diagonal move in our implementation is 1 instead of sqrt2.","category":"page"}]
}
