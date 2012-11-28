all: readline-test

readline-test: readline.sml readline-test.sml readline-test.mlb sml-readline.c
	mlton -link-opt -lreadline \
		readline-test.mlb sml-readline.c

clean:
	rm -f readline-test
