"""
    initialise()
Initialise function for the ABM.
This function will return the ABM.
Arguments necessary for declaring the space will need to be passed manually.
"""

function initialise(step_function;
    n_sheep = 100,
    n_wolves = 50,
    dims = (20, 20),
    regrowth_time = 30,
    Δenergy_sheep = 4,
    Δenergy_wolf = 20,
    sheep_reproduce = 0.04,
    wolf_reproduce = 0.05,
    seed = 23182,
)
    space = GridSpace(dims, periodic = false)
    properties = Dict(
        :step_function => step_function,
        :fully_grown => falses(dims),
        :coundown => zeros(Int, dims),
        :regrowth_time => regrowth_time
        )
    rng = Random.MersenneTwister(seed)
    
    model = ABM(
        SheepWolf, space;
        properties, rng
    )

    id = 0
    for n in 1:n_sheep
        id += 1
        energy = rand(1:(Δenergy_sheep*2)) - 1
        sheep = Sheep(id, (0, 0), Physiological(energy, sheep_reproduce, Δenergy_sheep))
        add_agent_single!(sheep, model)
    end
    for n in 1:n_wolves
        id += 1
        energy = rand(1:(Δenergy_wolf*2)) - 1
        wolf = Wolf(id, (0, 0), Physiological(energy, wolf_reproduce, Δenergy_wolf))
        add_agent_single!(wolf, model)
    end

    for p in positions(model)
        fully_grown = rand(model.rng, Bool)
        countdown = fully_grown ? regrowth_time : rand(model.rng, 1:regrowth_time) - 1
        model.coundown[p...] = countdown
        model.fully_grown[p...] = fully_grown
    end

    return model

end

#TODO reorder agent actions in expected execution order if required.
#TODO insert keyword arguments if required
model = initialise([walk, eat, die, reproduce])
