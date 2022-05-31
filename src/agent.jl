"""
    Physiological <:ParamLayer
The Physiological layer for SheepWolf.
"""
mutable struct Physiological <: ParamLayer
    #TODO enter parameters for the Physiological Layer
    energy::Float64
    reproduction_prob::Float64
    Δenergy::Float64
end

"""
    Identity <:ParamLayer
The Identity layer for SheepWolf.
"""
mutable struct Identity <: ParamLayer
    #TODO enter parameters for the Identity Layer
    type::Symbol # :sheep or :wolf
end


"""
    SheepWolf <:AbstractAgent
A SheepWolf in a GridSpace.
The agents by default possess the following layers:
    - Physiological
    - Identity
Spatial functions are handled by the respective space of Agents.jl
"""

mutable struct SheepWolf <:AbstractAgent
    id::Int
    #TODO customise 'pos' as necessary
    pos::Dims{2}
    Physiological::Physiological
    Identity::Identity
end

"""
    Helper functions for Wolf and sheep
"""
Sheep(id, pos, phys) = SheepWolf(id, pos, phys, Identity(:sheep))
Wolf(id, pos, phys) = SheepWolf(id, pos, phys, Identity(:wolf))