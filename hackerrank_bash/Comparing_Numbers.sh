#!/bin/bash

# Read two integers from the user
echo "Enter the first integer (X): "
read x
echo "Enter the second integer (Y): "
read y

# Compare the two integers
if [[ $x -gt $y ]]; then
    echo "X is greater than Y"
elif [[ $x -lt $y ]]; then
    echo "X is less than Y"
else
    echo "X is equal to Y"
fi
