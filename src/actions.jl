"""
walk(agent, model)
The Sheep or the Wolf moves one space randomly
"""
function walk(agent, model)
    walk!(agent, rand, model)
    agent.Physiological.energy -= 1
end

"""
eat(agent, model)
Forward to type specific eat function
"""
function eat(agent, model)
    if agent.Identity.type == :sheep
        sheep_eat!(agent, model)
    else
        wolf_eat!(agent, model)
    end
end

"""
sheep_eat!(agent, model)
Sheep will eat the patch of grass and gain Δenergy.
The grasspatch will loose its fully_grown status.
"""
function sheep_eat!(agent, model)
    if mode.fully_grown[agent.pos...]
        sheep.Physiological.energy += sheep.Physiological.Δenergy
        model.fully_grown[agent.pos...] = false
    end
end

"""
wolf_eat!(agent, model)
If the wolf shares the position with sheep
it will eat one of them at random.
That sheep dies.
Wolf gains Δenergy.
"""
function wolf_eat!(agent, model)
    agents_in_pos = collect(agents_in_position(agent.pos, model))
    dinner = filter!(x -> x.Identity.type == :sheep, agents_in_pos)
    if !isempty(dinner)
        sheep = rand(model.rng, dinner)
        kill_agent!(sheep, model)
        agent.Physiological.energy += agent.Physiological.Δenergy
    end
end

"""
die(agent, model)
The Sheep or the Wolf dies.
"""
function die(agent, model)
    if (agent.Physiological.energy < 0)
        kill_agent!(agent, model)
    end
end

""" 
reproduce(agent, model)
Make an exact copy of the parent.
Both offspring and parent will have 50% of original energy.
"""
function reproduce(agent, model)
    if rand(model.rng) <= agent.Physiological.reproduction_prob
        agent.Physiological.energy /= 2
        id = nextid(model)
        offspring = SheepWolf(
            id,
            agent.pos,
            agent.Identity,
            agent.Physiological,
        )
        add_agent_pos!(offspring, model)
    end
end

"""
grass_step!(model)
Handles grass growth if grass is not full_grown
As given in https://juliadynamics.github.io/Agents.jl/v4.3/examples/predator_prey_fast/
"""
function grass_step!(model)
    @inbounds for p in positions(model)
        if !(model.fully_grown[p...])
            if model.countdown[p...] ≤ 0
                model.fully_grown[p...] = true
                model.countdown[p...] = model.regrowth_time
            else
                model.countdown[p...] -= 1
            end
        end
    end
end
