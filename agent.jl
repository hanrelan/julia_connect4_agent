abstract type Agent end

function start() end

function get_action(::Agent, game_state, actions) 
end

function end_episode(::Agent, reward) end

function pushState(::Agent, game_state)
end
