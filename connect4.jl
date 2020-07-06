module Connect4

import Base.show 

@enum GameStatus player1_win player2_win tie undecided

Board = Array{UInt8,2}

struct GameState
    board::Board # 0 for empty, 1 for  player 1, 2 for player 2, columns (width) by rows (height)
    turn::UInt8 # 1 for player 1, 2 for player 2
    status::GameStatus
end

show(io::IO, ::MIME"text/plain", state::GameState) = show(io, state)

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
    if state.status == player1_win
        println(io, "Player 1 wins")
    elseif state.status == player2_win
        println(io, "Player 2 win")
    elseif state.status == tie
        println(io, "Tie")
    else
        state.turn == 1 ? println(io, "Player 1's turn") : println(io, "Player 2's turn")
    end
end

start() = GameState(zeros(UInt8, 7, 6), 1, undecided)

swap_turn(turn::UInt8) = turn == 1 ? 2 : 1

function act(state::GameState, column::UInt8)
    board = copy(state.board)
    (num_columns, num_rows) = size(board)
    updated = false
    empty_row_index = findfirst(board[column, :] .== 0)
    if empty_row_index === nothing
        error("Tried to place a piece in a filled column")
    end
    board[column, empty_row_index] = state.turn
    new_status = if did_win(board, state.turn)
        state.turn == 1 ? player1_win : player2_win
    elseif length(get_actions(board)) == 0
        tie
    else
        undecided
    end
    reward = (new_status == player1_win || new_status == player2_win) ? 1 : 0
    new_state = GameState(board, swap_turn(state.turn), new_status)
    (new_state, (reward, -1 * reward))
end

get_actions(state::GameState) = get_actions(state.board)

get_actions(board::Board) = convert(Array{UInt8}, findall(board[:,end] .== 0))

function check_connect(board::Board, player, dc, dr)
    (num_columns, num_rows) = size(board)
    start_column = dc >= 0 ? 1 : 4
    end_column = dc >= 0 ?  num_columns - dc * 3 : num_columns
    start_row = dr >= 0 ? 1 : 4
    end_row  = dr >= 0 ? num_rows - dr * 3 : num_rows
    for c in start_column:end_column, r in start_row:end_row
        if board[c, r] == player && board[c + dc, r + dr] == player && board[c + 2 * dc, r + 2 * dr] == player && board[c + 3 * dc, r + 3 * dr] == player
            return true
        end
    end
    return false
end

# Did the last player to play win
did_win(board, turn) =
    check_connect(board, turn, 1, 0) || 
    check_connect(board, turn, 0, 1) ||
    check_connect(board, turn, 1, 1) ||
    check_connect(board, turn, -1, 1)

gameover(state::GameState) = state.status != undecided

export start, get_actions, act, show, gameover

end