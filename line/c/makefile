CC = gcc
CFLAGS = -g -Wall -O3 -I/usr/local/include

default: demo

demo: example.o 
	$(CC) -L/usr/local/lib -lgsl -lgslcblas -lm example.o  -o demo

example.o: example.c
	$(CC) $(CFLAGS) -c example.c


clean:
	$(RM) demo *.o

