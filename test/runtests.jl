using ConfigurationsENV
using Test
using Configurations: @option, from_dict


# CAUTION, certain variables names are buggy https://github.com/Roger-luo/Configurations.jl/issues/101

@option struct MyConfig1
    key_a::Bool
    key_b::Int
    key_c::Union{Nothing, Int} = nothing
    key_d::Union{Nothing, String} = nothing
    key_e::String
end

@option struct MyConfig2
    key_a::MyConfig1
    key_b::String
end

@testset "ConfigurationsENV.jl" begin    
    d = Dict(
        "key_a" => Dict(
            "key_a" => true,
            "key_b" => 3,
            "key_c" => 1,
            "key_d" => "let's see",
            "key_e" => "hello",
        ),
        "key_b" => "world",
    )
    
    option = from_dict(MyConfig2, d)
    env = ConfigurationsENV.to_env(option, prefix="JOLIN_", separator="_")
    env = Dict(k => string(v) for (k, v) in pairs(env))

    option2 = ConfigurationsENV.from_env(MyConfig2, env, prefix="JOLIN_", separator="_")
    @test option == option2

    d2 = ConfigurationsENV.from_env(MyConfig2, env, prefix="JOLIN_", separator="_", return_dict=true)
    @test d == d2
end
