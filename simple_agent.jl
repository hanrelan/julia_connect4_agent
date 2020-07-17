include("agent.jl")

using Random

struct SimpleAgent <: Agent
end

startSimpleAgent() = SimpleAgent()

function get_value(game_state::Connect4.GameState)
    (game_state.status == Connect4.player1_win || game_state.status == Connect4.player2_win) ? 101 : rand(1:100)
end

function get_action(state::SimpleAgent, game_state, actions)
    value_of_action = (action) -> get_value(Connect4.act(game_state, action)[1])
    (_, index) = findmax(map(value_of_action, actions))
    actions[index]
end

rewardAgent(state::SimpleAgent, reward) = state

end_episode(state::SimpleAgent) = state