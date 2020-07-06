import Base.show
include("connect4.jl")
include("agent.jl")
include("random_agent.jl")

import .Connect4

player1 = startRandomAgent()
player2 = startRandomAgent()

function run_episode(player1, player2)
    game_state = Connect4.start()
    current_player = player1
    other_player = player2
    while !Connect4.gameover(game_state)
        possible_actions = Connect4.get_actions(game_state)
        (current_player, action) = get_action(current_player, game_state, possible_actions)
        (game_state, (current_player_reward, other_player_reward)) = Connect4.act(game_state, action)
        current_player = rewardAgent(current_player, current_player_reward)
        other_player = rewardAgent(other_player, other_player_reward * -1)
        temp_player = other_player
        other_player = current_player
        current_player = temp_player
    end
    current_player = end_episode(current_player)
    other_player = end_episode(other_player)

    game_state
end


function run_simulation()
    player1_wins = 0
    player2_wins = 0
    ties = 0
    for i in 1:100000
        game_state = run_episode(player1, player2)
        if game_state.status == Connect4.player1_win
            player1_wins += 1
        elseif game_state.status == Connect4.player2_win
            player2_wins += 1
        elseif game_state.status == Connect4.tie
            ties += 1
        else
            throw("Unknown status at end of episode")
        end
    end
    println(player1_wins)
    println(player2_wins)
    println(ties)
end
run_simulation()