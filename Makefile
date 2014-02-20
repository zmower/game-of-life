PROGS=terminal_life test_life tash_life

all:	$(PROGS)

terminal_life:	life.gpr life_g.ads life_g.adb terminal_life.adb
	gnatmake -Plife

tash_life:	life_g.ads life_g.adb tash_life.adb
	gnatmake -Ptash_life

test_life:	test_life.gpr life_g.ads life_g.adb test_life.adb
	gnatmake -Ptest_life

clean:
	rm -f $(PROGS)
	rm -f *.o *.ali
