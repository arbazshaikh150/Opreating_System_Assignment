#!/bin/bash

# Generating the c file based on the (memory usage) and also displaying the output
# at the time of the execution

echo "#include <stdio.h>
#include <unistd.h>
int main(){	
" > new_size_test.c;

# pushing multiple lines inside the new_size_test.c file
read value;
a=0
while [ $a -lt $value ]
do
    echo '    printf("Hello From Technophile\n");' >> new_size_test.c;
    a=$((a+1));
done

echo "    sleep(100);
      return 0;
}" >> new_size_test.c;

# Compile the C file
gcc new_size_test.c -o technophile;

# Run the compiled program
./technophile;



