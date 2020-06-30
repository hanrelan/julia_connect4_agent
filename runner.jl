import Base.show
include("connect4.jl")
include("random_agent.jl")

Agent1 = RandomAgent
Agent2 = RandomAgent

import .Connect4
import .Agent1
import .Agent2


player1 = Agent1.start()
player2 = Agent2.start()

function run_episode(player1, player2)
    game_state = Connect4.start()
    current_player = player1
    current_agent = Agent1
    other_player = player2
    other_agent = Agent2
    while !game_state.gameover
        possible_actions = Connect4.get_actions(game_state)
        if length(possible_actions) == 0
            println(game_state)
        end
        (current_player, action) = current_agent.get_action(current_player, game_state, possible_actions)
        (game_state, reward) = Connect4.act(game_state, action)
        current_player = current_agent.give_reward(current_player, reward)
        other_player = other_agent.give_reward(other_player, reward * -1)
        (temp_player, temp_agent) = (other_player, other_agent)
        (other_player, other_agent) = (current_player, current_agent)
        (current_player, current_agent) = (temp_player, temp_agent)
    end
    current_player = current_agent.end_episode(current_player)
    other_player = other_agent.end_episode(other_player)

    # println(game_state)
    game_state
end


function run_simulation()
    total_count1 = 0
    total_count2 = 0
    for i in 1:100000
        game_state = run_episode(player1, player2)
        if game_state.turn == 1
            total_count2 = total_count2 + 1
        else
            total_count1 = total_count1 + 1
        end
    end
    println(total_count1)
    println(total_count2)
end
run_simulation()