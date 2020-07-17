include("agent.jl")

using Flux

struct LearningAgent <: Agent
    model
end

function startLearningAgent() 
    model = Chain(Dense(43, 10, relu), Dense(10, 1, tanh))
    LearningAgent(model)
end

function get_values(state::LearningAgent, states)
    flattened_states = map(game_state -> [reshape(game_state.board, 42); game_state.turn], states)
    batch_states = reduce(hcat, flattened_states)
    state.model(batch_states)
end

function get_action(state::LearningAgent, game_state, actions)
    board = game_state.board
    next_states = map(action -> Connect4.act(game_state, action)[1], actions)
    values = get_values(state, next_states)
    (_, index) = findmax(values[1])
    actions[index] # Need to take the second element since the first element is always 1
end

rewardAgent(state::LearningAgent, reward) = state

end_episode(state::LearningAgent) = state