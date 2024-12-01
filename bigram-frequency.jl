using IterTools
using JLD2
function main()
    println("Enter text file from which to read and count bigrams: ")
    println("1. letters must be in lowercase ")
    println("2. Must contain only letters. It can't have newlines or whitespace characters")
    text_file = readline()
    text = String(read(text_file))
    bigramCount = zeros(Int64, (26, 26))
    for (a, b) in partition(text, 2, 1)
        bigramCount[Int(a)-Int('a')+1, Int(b)-Int('a')+1] += 1
    end
    bigramPercent = bigramCount ./ (length(text)-1)
    jldsave("bigram-percent.jld2"; bigramPercent)
end
main()
