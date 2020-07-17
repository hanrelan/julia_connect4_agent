abstract type Agent end

function start() end

function get_action(::Agent, game_state, actions) 
end

function rewardAgent(::Agent, reward) end

function end_episode(::Agent) end
