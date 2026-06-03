# turn the list of integers and vectors into the decomposition matrix
# in the Oscar context
function _decomposition_matrix_from_list_Oscar(list::Vector, indets::Vector{String}, m::Int, n::Int)
    if length(indets) > 0
      R, vars = Oscar.polynomial_ring(Oscar.ZZ, indets)
    else
      R, vars = (Oscar.ZZ, Oscar.ZZRingElem[])
    end

    # Construct the decomposition matrix.
    for i in 1:length(list)
      if isa(list[i], Vector)
        cfs = list[i][2:2:end]
        exp = Vector{Int64}[]
        for j in 1:2:(length(list[i])-1)
          monexp = zeros(Int64, length(vars))
          for k in 1:2:(length(list[i][j])-1)
            monexp[list[i][j][k]] = list[i][j][k+1]
          end
          push!(exp, monexp)
        end
        list[i] = R(cfs, exp)
      end
    end

    return vars, Oscar.matrix(R, m, n, list)
end

_decomposition_matrix_from_list[:Oscar] = _decomposition_matrix_from_list_Oscar

_labelled_matrix_formatted = Oscar.labelled_matrix_formatted

function zero_repl_string(obj)
   str = string(obj)
   return (str == "0" ? "." : str)
end

# GAPDoc is available, we can use it to turn the BibTeX references
# into text format references, which can be formatted at runtime.

function load_references()
  file = joinpath(@__DIR__, "..", "doc", "References.bib.xml")
  prs = Oscar.GAP.Globals.ParseBibXMLextFiles(Oscar.GAP.GapObj(file))::Oscar.GAP.GapObj
  txt = Oscar.GAP.GapObj("Text")::Oscar.GAP.GapObj
  for e in prs.entries
    r = Oscar.GAP.Globals.RecBibXMLEntry(e, txt, prs.strings)::Oscar.GAP.GapObj
    gdm_references[Oscar.GAP.gap_to_julia(r.Label)] = e
  end
end
load_references()

function formatted_reference(label::AbstractString)
  txt = Oscar.GAP.GapObj("Text")
  Globals = Oscar.GAP.Globals
  r = gdm_references[label]::Oscar.GAP.GapObj
  origin = Globals.StringBibXMLEntry(r, txt)
  return string(Globals.Encode(Globals.Unicode(origin)::Oscar.GAP.GapObj, Globals.GAPInfo.TermEncoding::Oscar.GAP.GapObj)::Oscar.GAP.GapObj)
end
