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
    elseif game_state.status == Connect4.tie
        (0, 0)
    else
        throw("Unknown status at end of episode")
    end
    player1 = end_episode(player1, player1_reward)
    player2 = end_episode(player2, player2_reward)

    (player1, player2, game_state)
end

function print_winrate(tag, player1, player2, player1_wins, player2_wins, ties)
    println(tag)
    println("------------")
    total = player1_wins + player2_wins + ties
    println("$(typeof(player1)) $player1_wins : $(round(player1_wins * 100 / total, digits=1))%")
    println("$(typeof(player2)) $player2_wins : $(round(player2_wins * 100 / total, digits=1))%")
    println("Ties: $ties")
    println("Total: $total")
    println("=====================\n")
end


function run_simulation(player1, player2)
    (player1_wins, player2_wins, ties) = (0, 0, 0)
    (player1_wins_last_n, player2_wins_last_n, ties_last_n) = (0, 0, 0)
    (player1_wins_first_n, player2_wins_first_n, ties_first_n) = (0, 0, 0)
    (player1_wins_running, player2_wins_running, ties_running) = (0, 0, 0)
    total = 2000
    n = 200
    last_n_start = total - n
    for i in 1:total
        if mod(i, 100) == 0
            print_winrate("Running count: $i", player1, player2, player1_wins_running, player2_wins_running, ties_running)
            (player1_wins_running, player2_wins_running, ties_running) = (0, 0, 0)
        end
        (player1, player2, game_state) = run_episode(player1, player2)
        if game_state.status == Connect4.player1_win
            if i > last_n_start
                player1_wins_last_n += 1
            elseif i <= n
                player1_wins_first_n += 1
            end
            player1_wins += 1
            player1_wins_running += 1
        elseif game_state.status == Connect4.player2_win
            if i > last_n_start
                player2_wins_last_n += 1
            elseif i <= n
                player2_wins_first_n += 1
            end
            player2_wins += 1
            player2_wins_running += 1
        elseif game_state.status == Connect4.tie
            if i > last_n_start
                ties_last_n += 1
            elseif i <= n
                ties_first_n += 1
            end
            ties += 1
            ties_running += 1
        else
            throw("Unknown status at end of episode")
        end
    end
    print_winrate("First $n", player1, player2, player1_wins_first_n, player2_wins_first_n, ties_first_n)
    print_winrate("Last $n", player1, player2, player1_wins_last_n, player2_wins_last_n, ties_last_n)
    print_winrate("Overall", player1, player2, player1_wins, player2_wins, ties)
    (player1, player2)
end
(player1, player2) = run_simulation(player1, player2)