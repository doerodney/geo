#!/bin/bash
# Configure these:
cc="gcc"
cflags="-g -Wall -O3 -I/usr/local/include"
libs="$(pkg-config --libs cmocka gsl)"
target="demo"
test_target="test"

# Generate line of non-test*.c source files:
# srcs=$(ls *.c | grep -vE "^test" | tr '\n' ' ')

# Generate line of project (non-test) object files:
projobjs=$(ls *.c | grep -vE "^test" | tr '\n' ' ' | sed -e 's/\.c/\.o/g')

# Generate line of test object files (test plus non-test excluding main.c):
testobjs=$(ls *.c | grep -vE "^main.c" | tr '\n' ' ' | sed -e 's/\.c/\.o/g')

# Generate makefile content:
# Define macros:
printf "CC = %s\n" "${cc}"
printf "CFLAGS = %s\n\n" "${cflags}"

# Define default build target:
printf "default: %s\n\n" "${target}"

# Define target and object file dependencies:
printf "%s: %s\n" "${target}" "${projobjs}"
printf '\t$(CC) -L/usr/local/lib %s %s -o %s\n\n' "${libs}" "${projobjs}" "${target}" 

# Define test target:
printf "%s: %s\n" "${test_target}" "${testobjs}"
printf '\t$(CC) -L/usr/local/lib %s %s -o %s\n\n' "${libs}" "${testobjs}" "${test_target}" 

# Define clean target:
printf "\nclean:\n"
printf '\t$(RM) %s %s *.o\n\n' "${target}" "${test_target}"

# Define target and dependencies for source files:
for f in $(ls *.c)
do
  echo "$(${cc} -MM ${f})"
  printf '\t$(CC) $(CFLAGS) -c %s\n' "${f}" 
  echo
done