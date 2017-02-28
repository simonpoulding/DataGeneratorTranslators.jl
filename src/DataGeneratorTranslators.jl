module DataGeneratorTranslators

export regex_generator, type_generator, xsd_generator, bnf_generator

using ParserCombinator # BNF parsing
using LightXML # XSD parsing

include("parse.jl")
include("transform.jl")
include("build.jl")

# utility function to support direct inclusion of generator resulting from translation
function include_generator(genname::Symbol, translatefn::Function, translateargs...)
	genbuf = IOBuffer()
	translatefn(genbuf, genname, translateargs...)
	genstr = takebuf_string(genbuf)
	include_string(genstr)
	current_module().eval(genname)
end

include(joinpath("regex", "regex.jl"))
include(joinpath("type", "type.jl"))
include(joinpath("bnf", "bnf.jl"))
include(joinpath("xsd", "xsd.jl"))

end
