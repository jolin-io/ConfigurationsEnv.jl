# ConfigurationsENV

[![Build Status](https://github.com/jolin-io/ConfigurationsENV.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jolin-io/ConfigurationsENV.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jolin-io/ConfigurationsENV.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jolin-io/ConfigurationsENV.jl)

Ever wanted to read Configurations.jl from environment variables? Here you go 🙂

```julia
using Configurations
@option struct Opt1
    a::Bool
    b::Union{Nothing, Int} = nothing
end
@option struct Opt2
    a::Opt1
    b::String
end

env = Dict(
    "PREFIX_A_A" => "true",
    "PREFIX_A_B" => "",
    "PREFIX_B" => "hello world",
)

using ConfigurationsENV

config = from_env(Opt2, env, prefix="PREFIX_", separator="_")  
# Opt2(Opt1(true, nothing), "hello world")

to_env(config, prefix=">")  # separator defaults to "__", prefix to ""
# OrderedCollections.OrderedDict{String, Any} with 3 entries:
#   ">A__A" => true
#   ">A__B" => nothing
#   ">B"    => "hello world"
```

In case you just want to parse a subset of the options fields from environment variables, use `return_dict=true`.

```julia
env = Dict("PREFIX__A__A" => "true")

nested_dict = from_env(Opt2, env, prefix="PREFIX__", return_dict=true)
# DataStructures.DefaultDict{String, Any, typeof(ConfigurationsENV.RecursiveDict)} with 1 entry:
#   "a" => DefaultDict{String, Any, typeof(RecursiveDict)}("a"=>true)

from_dict(Opt2, merge(nested_dict, Dict("b" => "works")))
# Opt2(Opt1(true, nothing), "works")
```