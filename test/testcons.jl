@testset "check that all matrices can be processed by Chevie.jl" begin

  @testset for nam in GenericDecMats.generic_decomposition_matrices_names()

    # Construct the root system in question.
    pos = findfirst('d', nam)
    if startswith( nam, "2A")
      rnam = "psu"
      from = 3
      shift = x -> x + 1
    elseif startswith( nam, "2D")
      rnam = "pso-"
      from = 3
      shift = x -> 2*x
    elseif startswith( nam, "2E6")
      rnam = "2E6"
      shift = nothing
    elseif startswith( nam, "3D4")
      rnam = "3D4"
      shift = nothing
    elseif startswith( nam, "A")
      rnam = "sl"
      from = 2
      shift = x -> x + 1
    elseif startswith( nam, "B")
      rnam = "pso"
      from = 2
      shift = x -> 2*x + 1
    elseif startswith( nam, "D")
      rnam = "so"
      from = 2
      shift = x -> 2*x
    elseif startswith( nam, "E6")
      rnam = "E6"
      shift = nothing
    elseif startswith( nam, "E7")
      rnam = "E7"
      shift = nothing
    elseif startswith( nam, "F")
      rnam = "F4"
      shift = nothing
    elseif startswith( nam, "G")
      rnam = "G2"
      shift = nothing
    else
      error("no test defined for $nam")
    end

    d = parse(Int, nam[(pos+1):end])
    if shift isa Function
      n = parse(Int, nam[from:(pos-1)])
      R = Chevie.rootdatum(rnam, shift(n))
    else
      R = Chevie.rootdatum(rnam)
    end

    # The dimension of the matrix must fit.
    l1 = length(Chevie.charnames(Chevie.UnipotentCharacters(R), TeX = true))
    for context in keys(GenericDecMats._decomposition_matrix_from_list)
      obj = GenericDecMats.generic_decomposition_matrix(nam, context)
      l2 = length(obj.ordinary)
      if l1 != l2 && obj.is_complete == true
        error("$nam: ordinary has length $l2 (should be $l1)")
      end
    end

    # Let Chevie interpret the matrix.
    @test Chevie.generic_decomposition_matrix(R, d) != nothing
  end

end

