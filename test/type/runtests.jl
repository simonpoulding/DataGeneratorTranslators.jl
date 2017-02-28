using DataGeneratorTranslators
using Base.Test

@testset "type" begin

	@testset "generators" begin
		include("test_generators.jl")
	end

end