mutable struct SparseSDP{T<:Number}
    obj::SparseSymmetricBlockMatrix{T}
    cons::Dict{Any,SparseSymmetricBlockMatrix{T}}
    rhs::Dict{Any,T}
    maximize::Bool
    normalized::Bool
    freecons::Dict{Any}{Dict{Any}{T}}
    freeobj::Dict{Any}{T}
end

SparseSDP(T::Type; maximize=true, normalized=false) = SparseSDP(SparseSymmetricBlockMatrix(T),
                                                                Dict{Any,SparseSymmetricBlockMatrix{T}}(),
                                                                Dict{Any,T}(),
                                                                maximize,
                                                                normalized,
                                                                Dict{Any}{Dict{Any}{T}}(),
                                                                Dict{Any}{T}())

SparseSDP(; maximize=true, normalized=false) = SparseSDP(Float64, maximize=maximize, normalized=normalized)

ismaximizationproblem(sdp::SparseSDP) = sdp.maximize

setmaximizationproblem!(sdp::SparseSDP, maximize::Bool) = sdp.maximize = maximize

normalized(sdp::SparseSDP) = sdp.normalized

copy(sdp::SparseSDP) = SparseSDP(copy(obj(sdp)), copy(cons(sdp)), copy(rhs(sdp)), sdp.maximize)

setobj!(sdp::SparseSDP{Float64}, c::SparseSymmetricBlockMatrix{Float64}) = obj(sdp) = obj

function setobj!(sdp::SparseSDP{Float64}, bi, m::SparseSymmetricMatrix{Float64})
    obj(sdp)[bi] = m
end

function setobj!(sdp::SparseSDP{Float64}, bi, i, j, v::Float64)
    obj(sdp)[bi, i, j] = v
end

function setobj!(sdp::SparseSDP{Float64}, bi, m::Matrix{Float64})
    n = size(m)[1]
    for j = 1:n
        for i = 1:j
            if m[i, j] != zero(T)
                setobj!(sdp, bi, i, j, m[i, j])
            end
        end
    end
end

obj(sdp::SparseSDP) = sdp.obj

obj(sdp::SparseSDP, bi) = sdp.obj[bi]

freecons(sdp::SparseSDP) = sdp.freecons

freeobj(sdp::SparseSDP) = sdp.freeobj

function setcon!(sdp::SparseSDP{Float64}, ri, bi, i, j, v::Float64)
    if !isapprox(v, 0.0)
        if haskey(cons(sdp), ri)
            cons(sdp)[ri][bi, i, j] = v
        else
            a = SparseSymmetricBlockMatrix(Float64)
            a[bi, i, j] = v
            cons(sdp)[ri] = a
        end
    end
end

function setcon!(sdp::SparseSDP{Float64}, ri, bi, m::AbstractMatrix{Float64})
    for i = 1:size(m, 1)
        for j = 1:size(m, 2)
            if m[i, j] != zero(Float64)
                setcon!(sdp, ri, bi, i, j, m[i, j])
            end
        end
    end
end

function setfreecon!(sdp::SparseSDP{Float64}, ri, ci, v::Float64)
    if !isapprox(v, 0.0)
        if haskey(D(sdp), ri)
            freecon(sdp)[ri][ci] = Float64
        else
            freecon(sdp)[ri] = Dict{Any,Float64}(ci => v)
        end
    end
end

setfreeobj!(sdp::SparseSDP{Float64}, ri, v::Float64) = freeobj(sdp)[ri] = v

cons(sdp::SparseSDP) = sdp.cons

getcon(sdp::SparseSDP, ri) = sdp.cons[ri]

setrhs!(sdp::SparseSDP{Float64}, ri, v::Float64) = sdp.rhs[ri] = v

rhs(sdp::SparseSDP) = sdp.rhs

rhs(sdp::SparseSDP, ri) = sdp.rhs[ri]

function rhsdense(sdp::SparseSDP{Float64})
    l = zeros(Float64, ncons(sdp))
    for (ri, v) in rhs(sdp)
        l[ri] = v
    end
    l
end

function ncons(sdp::SparseSDP)
    v = 0
    for ri in keys(cons(sdp))
        if ri > v
            v = ri
        end
    end
    for ri in keys(rhs(sdp))
        if ri > v
            v = ri
        end
    end
    v
end

function blocksizes(sdp::SparseSDP)
    blockdict = Dict{Any,Set}()
    for (bi, block) in obj(sdp)
        indices = get(blockdict, bi, Set())
        union!(indices, block.indices)
        blockdict[bi] = indices
    end
    for a in values(cons(sdp))
        for (bi, block) in a
            indices = get(blockdict, bi, Set())
            union!(indices, block.indices)
            blockdict[bi] = indices
        end
    end
    blocksizedict = Dict{Any,Int}()
    for (bi, entries) in blockdict
        blocksizedict[bi] = length(entries)
    end
    blocksizedict
end
