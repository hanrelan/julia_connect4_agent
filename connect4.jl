module Connect4

import Base.show 
struct GameState
    board::Array{UInt8,2} # 0 for empty, 1 for  player 1, 2 for player 2, columns (width) by rows (height)
    turn::UInt8 # 1 for black, 2 for red
    gameover::Bool
end

function show(io::IO, ::MIME"text/plain", state::GameState)
    show(io, state)
end

function show(io::IO, state::GameState)
    board = state.board
    (num_columns, num_rows) = size(board)
    for row = num_rows:-1:1
        for column = 1:num_columns
            print(io, board[column, row])
            print(io, " ")
        end
        print(io, "\n")
    end
    if state.gameover
        state.turn == 1 ? println(io, "Player 2 wins") : println("Player 1 wins")
    else
        state.turn == 1 ? println(io, "Player 1's turn") : println(io, "Player 2's turn")
    end
end

start() = GameState(zeros(UInt8, 7, 6), 1, false)

function swap_turn(turn::UInt8)
    turn == 1 ? 2 : 1
end

function act(state::GameState, column::UInt8)
    board = copy(state.board)
    (num_columns, num_rows) = size(board)
    updated = false
    empty_row_index = findfirst(board[column, :] .== 0)
    if empty_row_index === nothing
        error("Tried to place a piece in a filled column")
    end
    board[column, empty_row_index] = state.turn
    new_state = GameState(board, swap_turn(state.turn), false)
    reward = get_reward(new_state) 
    gameover = reward > 0 || length(get_actions(new_state)) == 0
    (GameState(new_state.board, new_state.turn, gameover), reward)
end

function get_actions(state::GameState)
    convert(Array{UInt8}, findall(state.board[:,end] .== 0))
end

function check_connect(board, player, dc, dr)
    (num_columns, num_rows) = size(board)
    start_column = dc >= 0 ? 1 : 4
    end_column = dc >= 0 ?  num_columns - dc * 3 : num_columns
    start_row = dr >= 0 ? 1 : 4
    end_row  = dr >= 0 ? num_rows - dr * 3 : num_rows
    for c in start_column:end_column
        for r in start_row:end_row
            if board[c, r] == player && board[c + dc, r + dr] == player && board[c + 2 * dc, r + 2 * dr] == player && board[c + 3 * dc, r + 3 * dr] == player
                return true
            end
        end
    end
    return false
end

# Did the last player to play win
function did_win(state::GameState) 
    last_to_play = swap_turn(state.turn)
    check_connect(state.board, last_to_play, 1, 0) || 
    check_connect(state.board, last_to_play, 0, 1) ||
    check_connect(state.board, last_to_play, 1, 1) ||
    check_connect(state.board, last_to_play, -1, 1)
end

# The reward for the last player to play
function get_reward(state)
    did_win(state) ? 1 : 0
end


state = start()
state = act(state, UInt8(3))

export start, did_win, get_reward, get_actions, act, show

end