#!/bin/bash
# Configure these:
cc="gcc"
cflags="-g -Wall -O3 -I/usr/local/include"
target="demo"

# Generate line of source files:
srcs=$(ls *.c | tr '\n' ' ')

# Generate line of object files:
objs=$(ls *.c | tr '\n' ' ' | sed -e 's/\.c/\.o/g')

# Generate makefile content:
# Define macros:
printf "CC = %s\n" "${cc}"
printf "CFLAGS = %s\n\n" "${cflags}"

# Define default build target:
printf "default: %s\n\n" "${target}"

# Define target and object file dependencies:
printf "%s: %s\n" "${target}" "${objs}"
printf '\t$(CC) -L/usr/local/lib -lgsl -lgslcblas -lm %s -o %s\n\n' "${objs}" "${target}" 

# Define target and dependencies for source files:
for f in $(ls *.c)
do
  echo "$(${cc} -MM ${f})"
  printf '\t$(CC) $(CFLAGS) -c %s\n' "${f}" 
  echo
done

# Define clean target:
printf "\nclean:\n"
printf '\t$(RM) %s *.o\n\n' "${target}"
