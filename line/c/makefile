CC = gcc
CFLAGS = -g -Wall -O3 -I/usr/local/include

default: demo

demo: fitcirc.o main.o pt.o 
	$(CC) -L/usr/local/lib -lcmocka -lgsl -lgslcblas -lm fitcirc.o main.o pt.o  -o demo

test: fitcirc.o pt.o test_main.o test_pt.o 
	$(CC) -L/usr/local/lib -lcmocka -lgsl -lgslcblas -lm fitcirc.o pt.o test_main.o test_pt.o  -o test


clean:
	$(RM) demo test *.o

fitcirc.o: fitcirc.c pt.h
	$(CC) $(CFLAGS) -c fitcirc.c

main.o: main.c fitcirc.h pt.h
	$(CC) $(CFLAGS) -c main.c

pt.o: pt.c pt.h
	$(CC) $(CFLAGS) -c pt.c

test_main.o: test_main.c
	$(CC) $(CFLAGS) -c test_main.c

test_pt.o: test_pt.c pt.h
	$(CC) $(CFLAGS) -c test_pt.c

