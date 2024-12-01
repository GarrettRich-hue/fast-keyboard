using JLD2
using Terming
using Crayons

function main()
    width = 5
    height = 6
    row = 3
    col = 2

    keyperm = jldopen("best-permutation-L5.jld2", "r")["bestPerm"]

    keyboard = ['a':'z'...][keyperm]
    ckeyboard(ind::Int)::Char = (1<=ind<=length(keyboard)) ? keyboard[ind] : ' '
    indrowcol(r::Int, c::Int) = (r-1)*width + c


    Terming.displaysize(height + 4+ 40, width+2+40)
    Terming.alt_screen(true)
    Terming.clear()
    Terming.raw!(true)
    event = nothing
    result = ""

    #print keyboard
    for (rowind, rowc) in enumerate(Iterators.partition(keyboard, width))
        Terming.cmove(1+rowind,2)
        Terming.print(join(rowc))
    end
    #print cursor
    Terming.cmove(row+1, col+1)
    # go into the loop
    while event != Terming.KeyPressedEvent(Terming.ESC)
        event = Terming.parse_sequence(Terming.read_stream())

        prow = row
        pcol = col
        plind = indrowcol(prow,pcol)
        newres = false
        if event in [Terming.KeyPressedEvent(Terming.UP), Terming.KeyPressedEvent('l')]
            row -= 1
        elseif event in [Terming.KeyPressedEvent(Terming.RIGHT), Terming.KeyPressedEvent(';')]
            col += 1
        elseif event in [Terming.KeyPressedEvent(Terming.DOWN), Terming.KeyPressedEvent('k')]
            row += 1
        elseif event in [Terming.KeyPressedEvent(Terming.LEFT), Terming.KeyPressedEvent('j')]
            col -= 1
        elseif event in [Terming.KeyPressedEvent(' ')]
            result = result * ckeyboard(plind)
            newres = true
        elseif event in [Terming. KeyPressedEvent('a')]
            result = result * ' '
            newres = true
        elseif event in [Terming.KeyPressedEvent('x')]
            result = result[1:end-1]
            newres = true
        end
        row = clamp(row, 1, height)
        col = clamp(col, 1, width)
        lind = indrowcol(row, col)
        if newres
            Terming.cmove(height + 3,2)
            Terming.print(result*' ')
            Terming.cmove(row+1, col+1)
        end
        if prow != row || pcol != col
            Terming.cmove(row+1, col+1)        
        end
        
   end
end
main()
