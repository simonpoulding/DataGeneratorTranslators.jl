using DataGeneratorTranslators
using Base.Test

@testset "regex" begin

	@testset "generators" begin
		include("test_generators.jl")
	end

end