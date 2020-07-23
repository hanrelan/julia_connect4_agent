include("agent.jl")

struct RandomAgent <: Agent
end

startRandomAgent() = RandomAgent()

function get_action(state::RandomAgent, _game_state, actions)
    index = rand(1:length(actions))
    action = actions[index]
    action
end

function pushState(::RandomAgent, game_state)
end

end_episode(state::RandomAgent, reward) = state