import Base.show 
struct GameState
    board::Array{UInt8,2} # 0 for empty, 1 for black, 2 for red, columns (width) by rows (height)
    turn::UInt8 # 1 for black, 2 for red
end

function show(io::IO, ::MIME"text/plain", state::GameState)
    board = state.board
    (num_columns, num_rows) = size(board)
    for row = num_rows:-1:1
        for column = 1:num_columns
            print(io, board[column, row])
            print(io, " ")
        end
        print(io, "\n")
    end
    state.turn == 1 ? println(io, "Black's turn") : println(io, "Red's turn")
end

start() = GameState(zeros(UInt8, 7, 6), 1)

function act(state::GameState, column::UInt8)
    board = copy(state.board)
    (num_columns, num_rows) = size(board)
    updated = false
    for row = 1:num_rows
        if board[column, row] == 0
            board[column, row] = state.turn
            updated = true
            break
        end
    end
    if !updated
        error("Tried to place a piece in a filled column")
    end
    GameState(board, state.turn == 1 ? 2 : 1)
end

state = start()
state = act(state, UInt8(1))

