using JLD2
function rectangularD(width::Int)::Matrix{Int64}
    D = zeros(Int64, (26, 26))
    for i = 1:26
        for j = 1:26
            D[i,j] = abs((i-1)%width - (j-1)%width) + abs(div(i-1, width) - div(j-1, width))
        end
    end
    return D
end
function main()
    B = jldopen("bigram-percent.jld2", "r")["bigramPercent"]
    D = rectangularD(4)

    perm = [1:26...]

    totalDis(p) = sum(B[p, p] .* D)

    T = 100
    #good params: d = 1-10^-6, iters = 10^7
    #d = 1-10^-7, iters = 10^8
    d = 1-10^-7 
    iters = 10^8

    bestPerm = [1:length(perm)...]
    bDis = totalDis(perm)
    pDis = bDis
    for i = 1:iters
        #pertubate the permuation
        i, j = rand(1:length(perm)), rand(1:length(perm))
        perm[i], perm[j] = perm[j], perm[i]
        
        cDis = totalDis(perm)
        if cDis < bDis
            bestPerm .= perm
            bDis = cDis

            println("$bDis : $bestPerm")
        end
        if cDis < pDis
            pDis = cDis
        elseif rand() < exp(-(cDis - pDis)/(T))
            pDis = cDis
        else
            perm[i], perm[j] = perm[j], perm[i]
        end
        T *= d
    end
    jldsave("best-permutation-L.jld2"; bestPerm)
end
main()
