module SemidefiniteProgramming

import
    Base.print,
    Base.show,
    Base.getindex,
    Base.setindex!,
    Base.size,
    Base.copy,
    Base.(*),
    Base.delete!,
    Base.(==),
    Base.isapprox
    # Base.start,# This is deprciated
    # Base.next, # This is deprciated and is now called Base.nextind but not the same
    # Base.done, # This is deprciated


# export
    # SparseSDP,
    # ismaximizationproblem,
    # setmaximizationproblem!,
    # setobj!,
    # obj,
    # setrhs!,
    # rhs,
    # setcon!,
    # cons,
    # ncons,
    # blocksizes,
    #
    # writesdpasparse,
    # readsdpasparse,
    #
    # SparseSDPSolution,
    # dualobj,
    # primalmatrix,
    # dualvector,
    # dualmatrix,
    #
    # SDPSolver,
    # SDPA,
    # SDPAQD,
    # SDPAGMP,
    # CSDP,
    # solve


export
 # sparsesymmetricmatrix.jl
    sanityCheck,
    SparseSymmetricMatrix,
    setindex!,
    getindex,
    size,
    *,
    delete!,
    ==,
    isapprox, # This one still gives errors.
# sparsesymmetricblockmatrix.jl
    SparseSymmetricBlockMatrix,
    blocks,
    setindex!,
    getindex,
    copy,
    *,
    show,
    ==,
    isapprox,
# sparsesdp.jl
    SparseSDP,
    ismaximizationproblem,
    setmaximizationproblem!,
    normalized,
    copy,
    setobj!,
    obj,
    freeobj,
    setcon!,
    setfreecon!,
    cons,
    getcon,
    setrhs!,
    rhs,
    rhsdense,
    ncons,
    blocksizes
# normalization.jl
    sanitycheck
    # IndexMap,
    # newindex!
    # normalize


include("sparsesymmetricmatrix.jl")
include("sparsesymmetricblockmatrix.jl")
include("sparsesdp.jl")
include("normalization.jl")
# include("sdpasparse.jl")
# include("solvers.jl")
# include("sdpsolution.jl")

end
