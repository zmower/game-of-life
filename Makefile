terminal_life:	life.gpr life.ads life.adb terminal_life.adb
	gnatmake -Plife

clean:
	rm -f terminal_life
	rm -f *.o *.ali
