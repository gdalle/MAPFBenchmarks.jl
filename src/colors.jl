"""
    get_map_colors(map_matrix::Matrix{Char})
"""
function get_map_colors(map_matrix::Matrix{Char})
    height, width = size(map_matrix)
    map_colors = Matrix{RGB}(undef, height, width)
    for i in 1:height, j in 1:width
        c = map_matrix[i, j]
        if c == '.'  # empty => white
            x = colorant"white"
        elseif c == 'G'  # empty => white
            x = colorant"white"
        elseif c == 'S'  # shallow water => brown
            x = colorant"brown"
        elseif c == 'W'  # water => blue
            x = colorant"blue"
        elseif c == 'T'  # trees => green
            x = colorant"green"
        elseif c == '@'  # wall => black
            x = colorant"black"
        elseif c == 'O'  # wall => black
            x = colorant"black"
        elseif c == 'H'  # here => red
            x = colorant"red"
        else  # ? => black
            x = colorant"black"
        end
        map_colors[i, j] = x
    end
    return map_colors
end
