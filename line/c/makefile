CC = gcc
CFLAGS = -g -Wall -O3 -I/usr/local/include -std=c17

default: demo

demo: area.o collinear.o fitcirc.o fitline.o main.o pt.o 
	$(CC) -L/usr/local/lib -lcmocka -lgsl -lgslcblas -lm area.o collinear.o fitcirc.o fitline.o main.o pt.o  -o demo

test: area.o collinear.o fitcirc.o fitline.o pt.o test_area.o test_collinear.o test_line.o test_main.o test_pt.o 
	$(CC) -L/usr/local/lib -lcmocka -lgsl -lgslcblas -lm area.o collinear.o fitcirc.o fitline.o pt.o test_area.o test_collinear.o test_line.o test_main.o test_pt.o  -o test


clean:
	$(RM) demo test *.o

area.o: area.c pt.h area.h
	$(CC) $(CFLAGS) -c area.c

collinear.o: collinear.c collinear.h pt.h area.h
	$(CC) $(CFLAGS) -c collinear.c

fitcirc.o: fitcirc.c fitcirc.h pt.h
	$(CC) $(CFLAGS) -c fitcirc.c

fitline.o: fitline.c fitline.h pt.h
	$(CC) $(CFLAGS) -c fitline.c

main.o: main.c fitline.h pt.h test_line.h
	$(CC) $(CFLAGS) -c main.c

pt.o: pt.c pt.h
	$(CC) $(CFLAGS) -c pt.c

test_area.o: test_area.c area.h pt.h
	$(CC) $(CFLAGS) -c test_area.c

test_collinear.o: test_collinear.c collinear.h pt.h
	$(CC) $(CFLAGS) -c test_collinear.c

test_line.o: test_line.c fitline.h pt.h
	$(CC) $(CFLAGS) -c test_line.c

test_main.o: test_main.c test_area.h test_collinear.h test_line.h \
 test_pt.h
	$(CC) $(CFLAGS) -c test_main.c

test_pt.o: test_pt.c pt.h
	$(CC) $(CFLAGS) -c test_pt.c

