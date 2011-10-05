all: readline-test

readline-test: readline.sml readline-test.sml readline-test.mlb sml-readline.c
	mlton -default-ann 'allowFFI true' -link-opt -lreadline \
		readline-test.mlb sml-readline.c

clean:
	rm -f readline-test
