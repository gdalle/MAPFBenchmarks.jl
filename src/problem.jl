"""
    MAPFBenchmarkProblem

# Fields
- `index::Int`
- `bucket::Int`
- `map::String`
- `width::Int`
- `height::Int`
- `start_i::Int`
- `start_j::Int`
- `goal_i::Int`
- `goal_j::Int`
- `optimal_length::Float64`
"""
Base.@kwdef struct MAPFBenchmarkProblem
    index::Int
    bucket::Int
    map::String
    width::Int
    height::Int
    start_i::Int
    start_j::Int
    goal_i::Int
    goal_j::Int
    optimal_length::Float64
end
