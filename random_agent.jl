include("agent.jl")

struct RandomAgent <: Agent
end

start_random_agent() = RandomAgent()

function get_action(state::RandomAgent, _game_state, actions)
    index = rand(1:length(actions))
    action = actions[index]
    action
end

function push_state!(::RandomAgent, game_state)
end

end_episode(state::RandomAgent, reward) = state