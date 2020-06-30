module RandomAgent

function start() 
    nothing
end

function get_action(state, _game_state, actions)
    index = rand(1:length(actions))
    action = actions[index]
    (state, action)
end

function give_reward(state, reward)
    state
end

export start, get_action
end