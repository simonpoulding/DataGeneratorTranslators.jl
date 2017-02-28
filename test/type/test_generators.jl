using DataGenerators

function try_generating_for_type(t::Type, supplementalts::Vector{DataType} = Vector{DataType}(); tries::Int = 100, showdatum::Bool=false, showerror::Bool=false)

	println("type $(t):")

	g = type_generator(:TypeGen, t, supplementalts)

	gi = g()

	print("  generating $(tries) data")
	if showdatum
		println()
	end

	for i in 1:100

		x = try 
			choose(gi)
		catch exc
			if isa(exc, DataGenerators.TypeGenerationException)
				if showerror
					warn("$(exc)")
				else
					print("!")
				end
				continue
			else
				rethrow(exc)
			end
		end

		if showdatum
			println("Type $(typeof(x)); Value: $(x)")
		else
			print(".")
		end

		@test DataGenerators.isa_tuple_adjust(x, t)

	end
	println()

	println()
	
end


@testset "smoke tests" begin
	
	sd = false
	se = false

	try_generating_for_type(Int16, showdatum=sd, showerror=se)

	try_generating_for_type(Union{Int8, UInt16}, showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{Int32, String}, showdatum=sd, showerror=se)

	try_generating_for_type(Signed, showdatum=sd, showerror=se)
	
end

@testset "regression tests" begin

	sd = false
	se = false

	try_generating_for_type(Signed, showdatum=sd, showerror=se)

	try_generating_for_type(Any, DataType[Number], showdatum=sd, showerror=se)

	try_generating_for_type(Union{Int8, UInt16}, showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{Int32, String}, showdatum=sd, showerror=se)

	try_generating_for_type(Type{Unsigned}, DataType[Number], showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{TypeVar(:S, Signed, false), TypeVar(:S, Signed, false)}, showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{TypeVar(:S, Signed, true), TypeVar(:T, Signed, true)}, showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{TypeVar(:S, Signed, true), TypeVar(:S, Signed, true)}, showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{TypeVar(:S, Signed, true), Type{TypeVar(:S, Signed, true)}}, showdatum=sd, showerror=se)

	try_generating_for_type(Tuple{TypeVar(:S, Signed, false), Type{TypeVar(:T, Signed, false)}}, showdatum=sd, showerror=se)

end

@testset "dogfood tests" begin

	typeg = type_generator(:TypeGen, Type, DataType[Number;])

	typegi = typeg()

	for i in 1:10

		t = nothing
		while t == nothing
			try
				t = choose(typegi)
				if t == Union{}
					warn("skipping type returned from type generator as it is Union{}")
					t = nothing
					continue
				end
			catch exc
				if isa(exc, DataGenerators.TypeGenerationException)
					warn("skipping type returned from type generator owing to: $(exc)")
					continue
				else
					rethrow(exc)
				end
			end
		end

		try_generating_for_type(t, convert(Vector{DataType},DataGenerators.GENERATOR_SUPPORTED_CHOOSE_TYPES), showdatum=false, showerror=false)

	end

end

@testset "edge tests" begin

	sd = false
	se = false

	try_generating_for_type(Tuple, DataType[Int64, String], showdatum=sd, showerror=se)

	try_generating_for_type(DataType, DataType[Number], showdatum=sd, showerror=se)

	try_generating_for_type(Union, DataType[Number], showdatum=sd, showerror=se)

	try_generating_for_type(Type{TypeVar(:T, Integer)}, showdatum=sd, showerror=se)

	try_generating_for_type(Type{TypeVar(:T, Signed)}, DataType[Number], showdatum=sd, showerror=se)

	try_generating_for_type(Type{Any}, DataType[Number], showdatum=sd, showerror=se)

	try_generating_for_type(Type, DataType[Number], showdatum=sd, showerror=se)

end

