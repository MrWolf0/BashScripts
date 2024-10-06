#!/bin/bash

# Read two integers from the user
echo "Enter the first integer: "
read a
echo "Enter the second integer: "
read b

# Perform calculations
sum=$((a + b))
diff=$((a - b))
mul=$((a * b))

# Check if the second integer is not zero before performing division
if [[ $b -ne 0 ]]; then
    quo=$((a / b))
else
    quo="undefined (division by zero)"
fi

# Display the results
echo "Sum: $sum"
echo "Difference: $diff"
echo "Product: $mul"
echo "Quotient: $quo"
