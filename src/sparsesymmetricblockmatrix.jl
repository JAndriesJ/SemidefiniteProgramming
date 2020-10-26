mutable struct SparseSymmetricBlockMatrix{T<:Number}
    blocks::Dict{Any,SparseSymmetricMatrix{T}}
end

SparseSymmetricBlockMatrix(T::Type) = SparseSymmetricBlockMatrix(Dict{Any,SparseSymmetricMatrix{T}}())

SparseSymmetricBlockMatrix() = SparseSymmetricBlockMatrix(Float64)

blocks(m::SparseSymmetricBlockMatrix) = m.blocks

function setindex!(bm::SparseSymmetricBlockMatrix{Float64}, v::Float64, bi, i, j)
    if haskey(blocks(bm), bi)
        blocks(bm)[bi][i, j] = v
    else
        m = SparseSymmetricMatrix(Float64)
        m[i, j] = v
        blocks(bm)[bi] = m
    end
end

function setindex!(bm::SparseSymmetricBlockMatrix{Float64}, m::SparseSymmetricMatrix{Float64}, bi)
    blocks(bm)[bi] = m
end

function getindex(bm::SparseSymmetricBlockMatrix{Float64}, bi, i, j)
    get(blocks(bm), bi, SparseSymmetricMatrix(Float64))[i, j]
end

getindex(bm::SparseSymmetricBlockMatrix{Float64}, bi) = get(blocks(bm), bi, SparseSymmetricMatrix(Float64))

# start(m::SparseSymmetricBlockMatrix) = start(blocks(m))
# next(m::SparseSymmetricBlockMatrix, state) = next(blocks(m), state)
# done(m::SparseSymmetricBlockMatrix, state) = done(blocks(m), state)

copy(m::SparseSymmetricBlockMatrix) = SparseSymmetricBlockMatrix(copy(blocks(m)))

function *(x::Float64, m::SparseSymmetricBlockMatrix{Float64})
    p = SparseSymmetricBlockMatrix(Float64)
    for k in keys(blocks(m))
        p[k] = x * m[k]
    end
    p
end

function show(io::IO, m::SparseSymmetricBlockMatrix{Float64})
    println(io, typeof(m))
    for (blockindex, matrix) in blocks(m)
        for ((i, j), v) in matrix.entries
            println(io, "$blockindex\t$i\t$j\t$v")
        end
    end
end

==(A::SparseSymmetricBlockMatrix, B::SparseSymmetricBlockMatrix) = blocks(A) == blocks(B)

function isapprox(A::SparseSymmetricBlockMatrix, B::SparseSymmetricBlockMatrix)
    nb_blocks = length(blocks(A))
    if nb_blocks != length(blocks(B))
        return false
    end

    for b in 1:nb_blocks
        for ((i,j),val) in A.blocks[b].entries
            if !isapprox(val, B.blocks[b].entries[i,j])
                return false
            end
        end
    end
    true
end
