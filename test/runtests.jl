using DataGeneratorTranslators
using Base.Test


#
# temporarily stub out BaseTestAuto features
#
macro mcheck_values_include(params...)
  quote warn("Skipping mcheck_values_include") end
end
macro mcheck_values_are(params...)
  quote warn("Skipping mcheck_values_are") end
end
macro mcheck_values_vary(params...)
  quote warn("Skipping mcheck_values_are") end
end
macro mcheck_that_sometimes(params...)
  quote warn("Skipping mcheck_that_sometimes") end
end
#


@testset "DataGeneratorTranslators" begin
	include(joinpath("regex", "runtests.jl"))
	include(joinpath("type", "runtests.jl"))
end