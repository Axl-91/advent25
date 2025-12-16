function parse_input(input_name)
    input_matrixes = Matrix{Int}[]
    matrix_rows = Vector{Int}[]
    dims = Vector{Int}[]
    values = Vector{Int}[]

    for line in eachline(input_name)
        line = strip(line)

        if (contains(line, 'x'))
            left, right = split(line, ":")

            dim = parse.(Int, split(left, "x"))
            value = parse.(Int, split(strip(right)))

            push!(dims, dim)
            push!(values, value)
        end

        if isempty(line) || endswith(line, ":")
            if !isempty(matrix_rows)
                M = reduce(vcat, transpose.(matrix_rows))
                push!(input_matrixes, M)
                empty!(matrix_rows)
            end
            continue
        end

        matrix_row = [c == '#' ? 1 : 0 for c in line]
        push!(matrix_rows, matrix_row)
    end

    return input_matrixes, dims, values
end

# Returns all different rotations of matrix
function rotations(A)
    rots = Matrix{Int}[]
    cur = A
    for _ in 1:4
        if all(B -> B != cur, rots)
            push!(rots, cur)
        end
        cur = rotr90(cur, -1)
    end
    return rots
end

# Check if the matrix A can be placed in the board
function can_place(board, A, x, y)
    x_max, y_max = size(A)
    for i in 1:x_max, j in 1:y_max
        if A[i, j] == 1 && board[x+i-1, y+j-1] == 1
            return false
        end
    end
    return true
end

function place!(board, A, x, y)
    x_max, y_max = size(A)
    for i in 1:x_max, j in 1:y_max
        if A[i, j] == 1
            board[x+i-1, y+j-1] = 1
        end
    end
end

function remove!(board, A, x, y)
    x_max, y_max = size(A)
    for i in 1:x_max, j in 1:y_max
        if A[i, j] == 1
            board[x+i-1, y+j-1] = 0
        end
    end
end

function can_place_in_board(board, pieces, idx)
    idx > length(pieces) && return true

    rows, cols = size(board)
    A, count = pieces[idx]
    rots = rotations(A)

    count == 0 && return can_place_in_board(board, pieces, idx + 1)

    for R in rots
        x_max, y_max = size(R)
        # Loop for every valid position
        # I can place the matrix on the board
        for x in 1:(rows-x_max+1), y in 1:(cols-y_max+1)
            if can_place(board, R, x, y)
                place!(board, R, x, y)
                pieces[idx] = (A, count - 1)

                can_place_in_board(board, pieces, idx) && return true

                pieces[idx] = (A, count)
                remove!(board, R, x, y)
            end
        end
    end

    return false
end

function part1(pieces, cols, rows)
    total_cells = rows * cols
    required = sum(sum(A) * n for (A, n) in pieces)

    # If pieces are bigger than the board returns false
    required > total_cells && return false

    board = zeros(Int, rows, cols)

    return can_place_in_board(board, pieces, 1)
end

function main()
    total = 0
    matrixes, matrix_dimensions, repeats = parse_input("input")

    for i in eachindex(matrix_dimensions)
        matrix_value_vector = []
        for j in eachindex(repeats[i])
            push!(matrix_value_vector, (matrixes[j], repeats[i][j]))
        end
        if part1(matrix_value_vector, matrix_dimensions[i][1], matrix_dimensions[i][2])
            total += 1
        end
    end

    println("Total: ", total)
end

main()
