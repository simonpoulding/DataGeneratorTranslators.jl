type TypeGenerationException <: Exception
	func::Symbol
	msg::AbstractString
	caught::Union{Exception, Void}
	function TypeGenerationException(func::Symbol, msg::AbstractString, caught::Union{Exception, Void}=nothing)
		new(func, msg, caught)
	end
end

# non-abstract types that the generator can build special rules for generating values
# is the same as DataGenerators.GENERATOR_SUPPORTED_CHOOSE_TYPES, but redefined here to avoid circular module dependencies
const DATAGENERATORS_SUPPORTED_TYPES = Type[Bool; Int8; Int16; Int32; Int64; UInt8; UInt16; UInt32; UInt64; Float16; Float32; Float64; String;]
# non-abstract types that the type translator can handle directly, either via Data Generator or itself
const DIRECTLY_SUPPORTED_TYPES = Type[DATAGENERATORS_SUPPORTED_TYPES; Tuple; DataType; Union;]


include("type_utilities.jl")
include("type_parse.jl")
include("type_transform.jl")
include("type_build.jl")
include("type_generator_utilities.jl")

function type_rules(t::Type, supporteddts::Vector{DataType}=Vector{DataType}(), rulenameprefix="")
	ast = parse_type(t, supporteddts)
	transform_type_ast(ast)
	transform_ast(ast) # this standard transform (which analysis reachability) isn't really needed for a type, but included for consistency with other translators
	build_type_rules(ast, rulenameprefix)
end

function type_generator(io::IO, genname::Symbol, t::Type, supporteddts::Vector{DataType}=Vector{DataType}())
	rules = type_rules(t, supporteddts)
	description = "an instance of type $(t)"
	output_generator(io, genname, description, rules)
end

type_generator(genname::Symbol, t::Type, supporteddts::Vector{DataType}=Vector{DataType}()) = include_generator(genname, type_generator, t, supporteddts)