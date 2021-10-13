CC = gcc
CFLAGS = -g -Wall -O3 -I/usr/local/include

default: demo

demo: fitcirc.o main.o 
	$(CC) -L/usr/local/lib -lgsl -lgslcblas -lm fitcirc.o main.o  -o demo

fitcirc.o: fitcirc.c pt.h
	$(CC) $(CFLAGS) -c fitcirc.c

main.o: main.c fitcirc.h pt.h
	$(CC) $(CFLAGS) -c main.c


clean:
	$(RM) demo *.o

