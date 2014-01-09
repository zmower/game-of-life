PROGS=terminal_life test_life

all:	$(PROGS)

terminal_life:	life.gpr life.ads life.adb terminal_life.adb
	gnatmake -Plife

test_life:	life.ads life.adb test_life.adb
	gnatmake -Ptest_life

clean:
	rm -f $(PROGS)
	rm -f *.o *.ali
