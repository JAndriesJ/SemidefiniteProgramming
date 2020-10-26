# Juno Activate Enviornment in folder of the project
# using Pkg
if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end
using SemidefiniteProgramming
using Test


@testset "sparsesymmetricmatrix.jl" begin
    SSM = SparseSymmetricMatrix(Float64)
    @test typeof(SSM) == SparseSymmetricMatrix{Float64}
    for i in 1:10
        for j in 1:10
            setindex!(SSM, rand(1)[1], i, j)
        end
    end
    # show(SSM.entries)
    @test size(SSM) == 10
    SSM10 = *(10.0,SSM)
    SSM_copy = copy(SSM)

    @test ==(SSM_copy, SSM) == true
    @test ==(SSM10, *(1.0,SSM)) == false
    @test isapprox(SSM10, *(10.0,SSM)) == true

    delete!(SSM,1,1)
    @test SSM[1,1] == 0
end


@testset "sparsesymmetricmatrix.jl" begin
    SSBM = SparseSymmetricBlockMatrix(Float64)
    @test typeof(SSBM) == SparseSymmetricBlockMatrix{Float64}
    @test  typeof(blocks(SSBM)) == Dict{Any,SparseSymmetricMatrix{Float64}}
    for b in 1:2
        for i in 1:3
            for j in i:3
                setindex!(SSBM, rand(1)[1], b,i, j)
            end
        end
    end
    @test getindex(SSBM,1,1,1) == SSBM.blocks[1][1,1]
    SSBM_copy = copy(SSBM) # What is the point of this copy.
    SSBM_alt = SSBM
    SSBM10 = *(10.0, SSBM)
    # show(SSBM10)
    @test ==(SSBM_copy, SSBM_alt) == true
    @test isapprox(SSBM_copy, *(0.0000001,SSBM_alt)) == false
end

@testset "sparsesdp.jl" begin
    SSDP = SparseSDP(Float64)
    @test ismaximizationproblem(SSDP)
    @test setmaximizationproblem!(SSDP, true)
    @test !normalized(SSDP)

    SSBM = SparseSymmetricBlockMatrix(Float64)
    for b in 1:2
        for i in 1:3
            for j in i:3
                setindex!(SSBM, rand(1)[1], b,i, j)
            end
        end
    end
    setobj!(SSDP,SSBM)
    obj(SSDP)
    obj(SSDP,1)
    obj(SSDP,2)
    freeobj(SSDP)
    setcon!(SSDP,1, 1, 1, 1, 2.3)
    cons(SSDP)

    getcon(SSDP,1)
    setrhs!(SSDP, 1, rand(1)[1])
    rhs(SSDP,1)
    rhsdense(SSDP)
    ncons(SSDP)
end
    ## Errors
    # setfreecon!(SSDP, 1, 1, 1.1)
    # freecons(SSDP)
    # blocksizes(SSDP)
    # SSDP_copy = copy(SSDP)

@testset "normalization.jl" begin
    sanitycheck()
    # IndexMap()
    # newindex!,
    # normalize
end




#
#
#
# @testset "SemidefiniteProgramming.jl" begin
#     # Write your tests here.
#     sdp = SparseSDP(maximize=true)
#
#     setobj!(sdp, 1, 1, 1, 1.0)
#     setobj!(sdp, 2, 1, 1, 2.0)
#     setobj!(sdp, 3, 1, 1, 3.0)
#     setobj!(sdp, 3, 2, 2, 4.0)
#
#     setrhs!(sdp, 1, 10.0)
#     setcon!(sdp, 1, 1, 1, 1, 1.0)
#     setcon!(sdp, 1, 2, 1, 1, 1.0)
#
#     setrhs!(sdp, 2, 20.0)
#     setcon!(sdp, 2, 2, 1, 1, 1.0)
#     setcon!(sdp, 2, 3, 1, 1, 5.0)
#     setcon!(sdp, 2, 3, 1, 2, 2.0)
#     setcon!(sdp, 2, 3, 2, 1, 2.0)
#     setcon!(sdp, 2, 3, 2, 2, 6.0)
#
#     println(obj(solve(sdp, CSDP())))
# end
