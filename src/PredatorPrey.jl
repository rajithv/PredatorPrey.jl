"""
This model is an adaptation of https://juliadynamics.github.io/Agents.jl/v4.3/examples/predator_prey_fast/
to AgentsX.jl framework. The original works with pure Agents.jl.
"""
module PredatorPrey

using Agents
using AgentsX
using Random
using InteractiveDynamics
using CairoMakie

include("agent.jl")
include("actions.jl")
include("model.jl")

offset(a) = a.Identity.type == :sheep ? (-0.7, -0.5) : (-0.3, -0.5)
ashape(a) = a.Identity.type == :sheep ? :circle : :utriangle
acolor(a) = a.Identity.type == :sheep ? RGBAf0(1.0, 1.0, 1.0, 0.8) : RGBAf0(0.2, 0.2, 0.2, 0.8)

grasscolor(model) = model.countdown ./ model.regrowth_time

heatkwargs = (colormap = [:brown, :green], colorrange = (0, 1))

plotkwargs = (
    ac = acolor,
    as = 15,
    am = ashape,
    offset = offset,
    heatarray = grasscolor,
    heatkwargs = heatkwargs
)

using PredatorPrey
fig, _ = abmplot(model; plotkwargs...)
fig

end
