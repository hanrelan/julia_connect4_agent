import Base.show
include("connect4.jl")
include("agent.jl")
include("random_agent.jl")
include("simple_agent.jl")
include("learning_agent.jl")

import .Connect4

player1 = start_learning_agent()
player2 = start_simple_agent()

function run_episode(player1, player2)
    game_state = Connect4.start()
    current_player = player1
    other_player = player2
    while !Connect4.gameover(game_state)
        possible_actions = Connect4.get_actions(game_state)
        action = get_action(current_player, game_state, possible_actions)
        (game_state, (current_player_reward, other_player_reward)) = Connect4.act(game_state, action)
        push_state!(current_player, game_state)
        (current_player, other_player) = (other_player, current_player)
    end
    (player1_reward, player2_reward) = if game_state.status == Connect4.player1_win
        (1, -1)
    elseif game_state.status == Connect4.player2_win
        (-1, 1)
    elseif game_state.status == tie
        (0, 0)
    else
        throw("Unknown status at end of episode")
    end
    player1 = end_episode(player1, player1_reward)
    player2 = end_episode(player2, player2_reward)

    game_state
end


function run_simulation()
    player1_wins = 0
    player2_wins = 0
    ties = 0
    player1_wins_last_1000 = 0
    player2_wins_last_1000 = 0
    ties_last_1000 = 0
    for i in 1:1000
        if mod(i, 100) == 0
            println(i)
        end
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
    println("$(typeof(player1)) $player1_wins")
    println("$(typeof(player2)) $player2_wins")
    println(ties)
    println("$(typeof(player1)) $player1_wins_last_1000")
    println("$(typeof(player2)) $player2_wins_last_1000")
    println(ties_last_1000)
end
run_simulation()