include("agent.jl")

using Random

struct SimpleAgent <: Agent
end

start_simple_agent() = SimpleAgent()

function find_winning_action(game_state, actions)
    for i in 1:length(actions)
        action = actions[i]
        new_state = Connect4.act(game_state, action)[1]
        if new_state.status == Connect4.player1_win || new_state.status == Connect4.player2_win
            return action
        end
    end
    return nothing
end

function get_action(state::SimpleAgent, game_state, actions)
    # First see if we have an easy win
    winning_action = find_winning_action(game_state, actions)
    if winning_action !== nothing
        return winning_action
    end
    
    # Check if the opponent has an easy win - if so, don't take that action
    shuffled_actions = shuffle(actions)
    for i in 1:length(shuffled_actions)
        my_action = shuffled_actions[i]
        new_state = Connect4.act(game_state, my_action)[1]
        their_actions = Connect4.get_actions(new_state) 
        their_winning_action = find_winning_action(new_state, their_actions)
        if their_winning_action === nothing
            # They don't have a winning action, this is an acceptable choice
            return my_action
        end
    end

    # Doesn't seem to matter what we do - pick a random action
    shuffled_actions[1]
end

function push_state!(::SimpleAgent, game_state)
end

end_episode(state::SimpleAgent, reward) = state