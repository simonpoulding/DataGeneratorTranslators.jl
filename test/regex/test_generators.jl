using DataGenerators

regex_generator(:SCWildcardGen, ".")

@testset "choose(String) using regex containing wilcard" begin

	gn = SCWildcardGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^.$", td)
	    @mcheck_values_vary td
	end

end

regex_generator(:SCQuantifiersGen, "a?b+c*d{4}e{5,6}f{7,}g{8,8}")

@testset "choose(String) using regex containing quantifiers" begin

	gn = SCQuantifiersGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^a?b+c*d{4}e{5,6}f{7,}g{8,8}$", td)
	    @mcheck_values_include count(x->x=='a',td) [0,1]
	    @mcheck_values_include count(x->x=='b',td) [1,2,3]
	    @mcheck_values_include count(x->x=='c',td) [0,1,2]
	    @mcheck_values_include count(x->x=='d',td) [4,]
	    @mcheck_values_include count(x->x=='e',td) [5,6]
	    @mcheck_values_include count(x->x=='f',td) [7,8,9]
	    @mcheck_values_are count(x->x=='g',td) [8]
	end

end


regex_generator(:SCAlternationGen, "foo|bar|baz")

@testset "choose(String) using regex containing alternation" begin

	gn = SCAlternationGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^foo|bar|baz$", td)
	    @mcheck_values_are td ["foo","bar","baz"]
	end

end



regex_generator(:SCBracketsGen, "a[uvw][x-z0-3]b")

@testset "choose(String) using regex containing bracket" begin

	gn = SCBracketsGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^a[uvw][x-z0-3]b$", td)
	    @mcheck_values_are td[2] ['u','v','w']
	    @mcheck_values_are td[3] ['x','y','z','0','1','2','3']
	end

end


regex_generator(:SCParenthesesGen, "a(bc|de)")

@testset "choose(String) using regex containing parentheses" begin

	gn = SCParenthesesGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^a(bc+|de+)$", td)
	    @mcheck_values_are td[2] ['b','d']
	    @mcheck_values_are td[3] ['c','e']
	end

end

regex_generator(:SCClassesGen, "\\s\\S\\d\\D\\w\\W")

@testset "choose(String) using regex containing classes" begin

	gn = SCClassesGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^\s\S\d\D\w\W$", td)
	    @mcheck_values_vary td
	end

end

regex_generator(:SCEscapesGen, "\\.\\[\\]\\|\\?\\+\\*\\\\")

@testset "choose(String) using regex that escapes metacharacters" begin

	gn = SCEscapesGen()

	@testset "emits different ASCII strings that match regex" begin
	    td = choose(gn)
	    @test typeof(td) == String
	    @test ismatch(r"^\.\[\]\|\?\+\*\\$", td)
	end

end
