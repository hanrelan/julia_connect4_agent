include("agent.jl")

struct RandomAgent <: Agent
end

startRandomAgent() = RandomAgent()

function get_action(state::RandomAgent, _game_state, actions)
    index = rand(1:length(actions))
    action = actions[index]
    (state, action)
end

rewardAgent(state::RandomAgent, reward) = state

end_episode(state::RandomAgent) = state