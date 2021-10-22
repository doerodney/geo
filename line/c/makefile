CC = gcc
CFLAGS = -g -Wall -O3 -I/usr/local/include

default: demo

demo: fitcirc.o main.o pt.o 
	$(CC) -L/usr/local/lib -lcmocka -lgsl -lgslcblas -lm fitcirc.o main.o pt.o  -o demo

test: fitcirc.o pt.o test_foo.o 
	$(CC) -L/usr/local/lib -lcmocka -lgsl -lgslcblas -lm fitcirc.o pt.o test_foo.o  -o test


clean:
	$(RM) demo test *.o

fitcirc.o: fitcirc.c pt.h
	$(CC) $(CFLAGS) -c fitcirc.c

main.o: main.c fitcirc.h pt.h
	$(CC) $(CFLAGS) -c main.c

pt.o: pt.c pt.h
	$(CC) $(CFLAGS) -c pt.c

