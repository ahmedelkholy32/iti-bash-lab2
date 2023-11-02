#!/bin/bash
### This script calculate sin(x) using POW and Factorial
### Where cos(x) = 1-x^2/2!+x^4/4!-x^6/6!.... 1000, x in redian, x(radian)= X(degree) * pi/180
### This scrept accept 1 parameter (x)

### Exit codes:
#       0: successful
#       1: not enough parameters
#       2: many parameters
#       3: invalid value       

# check if user insert required parameters
[ ${#} -lt 1 ] && echo "Must determine the value of x" && exit 1
[ ${#} -gt 1 ] && echo "Expect 1 parameter only" && exit 2

# check if the value of x is integer
x=${1}
[ $(echo ${x} | grep -c "^[0-9]\+$") -ne 1 ] && echo The value of x must be positive intgeer && exit 3

# write function to calculate POW / Factorial
function pow_fact {
    local y=${1}
    # cal pow
    local pow=1
    for i in $(seq 1 ${y})
        do
            # pow=$[ pow * x ]
            pow=$(echo ${pow}*${x} | bc -l)
        done
    # cal factorial
    local fact=1
    for i in $(seq 1 ${y})
        do
            fact=$[ fact * i ]
        done
    echo $(echo ${pow}/${fact} | bc -l)
}

# convert x value from degree to redian
p=3.14159265359
x=$(echo ${x}*${p}/180 | bc -l)
# make loop for even sequnce
result=1
sign='-'
for i in $(seq 2 2 10)
    do
        # call pow_fact to return power(x)/factorial for i
        out=$(pow_fact ${i})
        if [ ${sign} == '-' ]
            then
                result=$(echo ${result}-${out} | bc -l)
                sign='+'
            else 
                result=$(echo ${result}+${out} | bc -l)
                sign='-'
        fi
    done
echo $(echo ${result} | bc -l)
exit 0
