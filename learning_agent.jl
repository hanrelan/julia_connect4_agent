include("agent.jl")

using Flux

struct ModelTrainingInfo
    opt
    params
end

struct LearningAgent <: Agent
    model
    game_states
    model_train::ModelTrainingInfo
end

function train!(state::LearningAgent, reward)
    batch_size = length(state.game_states)
    batch_rewards = fill(reward, (1, batch_size))
    batch_states = create_batch(state.game_states)
    data = Flux.Data.DataLoader(batch_states, batch_rewards, batchsize=minimum([128, batch_size]))
    loss(x, y) = Flux.Losses.mse(state.model(x), y)
    Flux.train!(loss, state.model_train.params, data, state.model_train.opt)
end

function create_batch(states)
    flattened_states = map(game_state -> [reshape(game_state.board, 42); game_state.turn], states)
    batch_states = reduce(hcat, flattened_states)
end

function start_learning_agent() 
    model = Chain(Dense(43, 10, relu), Dense(10, 1, tanh))
    model_train = ModelTrainingInfo(ADAM(0.001, (0.9, 0.8)), Flux.params(model))
    LearningAgent(model, [], model_train)
end

function get_values(state::LearningAgent, states)
    batch_states = create_batch(states)
    state.model(batch_states)
end

function get_action(state::LearningAgent, game_state, actions)
    board = game_state.board
    next_states = map(action -> Connect4.act(game_state, action)[1], actions)
    values = get_values(state, next_states)
    (_, index) = findmax(values)
    if false
        println(game_state)
        println(values)
        println(index[2])
        println("--------")
    end
    actions[index[2]] 
end

function push_state!(state::LearningAgent, game_state)
    LearningAgent(state.model, push!(state.game_states, game_state), state.model_train)
end

function end_episode(state::LearningAgent, reward)
    if false
        println("Reward $reward")
    end
    train!(state, reward)
    LearningAgent(state.model, [], state.model_train)
end

# agent = start_learning_agent()
# game_state = Connect4.start()
# new_agent = push_state(agent, game_state)
# new_agent = push_state(agent, game_state)
# end_episode(new_agent, 10)