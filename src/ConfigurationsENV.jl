module ConfigurationsENV
using Continuables
using DataStructures: DefaultDict, OrderedDict
using Configurations: from_dict, is_option, to_dict

export from_env, to_env

function from_string(u::Union, str)
    if String <: u
        from_string(String, str)
    elseif Nothing <: u && str == ""
        nothing
    elseif u.a === Nothing
        from_string(u.b, str)
    else
        try
            from_string(u.a, str)
        catch e
            from_string(u.b, str)
        end
    end
end
from_string(::Type{String}, str) = string(str)
_defaulttype(::Type{<:Complex}) = Complex{Float64}
_defaulttype(::Type{<:Real}) = Float64
_defaulttype(::Type{<:Integer}) = Int
from_string(::Type{T}, str) where {T<:Number} = isconcretetype(T) ? parse(T, str) : parse(_defaulttype(T), str)
from_string(::Type{T}, str) where {T} = T(str)

@cont function nestedkeys_and_types(::Type{T}) where {T}
    for (name, type) in zip(fieldnames(T), fieldtypes(T))
        name = string(name)
        if is_option(type)
            # prefix needs to stay empty recursively
            foreach(nestedkeys_and_types(type)) do (keys, t)
                cont((name, keys...) => t)
            end
        else
            cont((name,) => type)
        end
    end
end

function RecursiveDict(args...)
    DefaultDict{String,Any,typeof(RecursiveDict)}(RecursiveDict, Dict{String,Any}(args...))
end

nestedget(dict, key1) = dict[key1]
nestedget(dict, key1, keys...) = nestedget(dict[key1], keys...)
nestedset!(dict, value, key1) = setindex!(dict, value, key1) 
nestedset!(dict, value, key1, keys...) = nestedset!(dict[key1], value, keys...)
function nestedmap(f, dict::AbstractDict)
    newdict = empty(dict)
    for (k, v) in pairs(dict)
        if isa(v, AbstractDict)
            newdict[k] = nestedmap(f, v)
        else    
            newdict[k] = f(v)
        end
    end
    newdict
end

function from_env(::Type{T}, ENV=ENV; prefix="", separator="__", return_dict=false) where {T}
    is_option(T) || error("not an option type")
    keys_to_name(keys) = prefix * join(map(uppercase, keys), separator)
    options_dict = RecursiveDict()
    for (keys, type) in collect(nestedkeys_and_types(T))
        name = keys_to_name(keys)
        if haskey(ENV, name)
            value = from_string(type, ENV[name])
            nestedset!(options_dict, value, keys...)
        end
    end
    return_dict ? options_dict : from_dict(T, options_dict)
end

function to_env(options; prefix="", separator="__")
    is_option(typeof(options)) || error("not an option type")
    keys_to_name(keys) = prefix * join(map(uppercase, keys), separator)
    options_dict = to_dict(options)
    return OrderedDict(
        keys_to_name(keys) => nestedget(options_dict, keys...)
        for (keys, type) in collect(nestedkeys_and_types(typeof(options)))
    )
end

end