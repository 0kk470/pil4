--- Exercise 31.1: Modify the implementation of setarray so that it accepts only Boolean values.
local a = array.new(10)
a[4] = true
--a[4] = "true"  --not boolean


--- Exercise 31.2: We can see a Boolean array as a set of integers (the indices with true values in the array).
--- Add to the implementation of Boolean arrays functions to compute the union and intersection of two arrays.
--- These functions should receive two arrays and return a new one, without modifying its parameters.
local b = array.new(8)
b[4] = true
b[5] = true
b[8] = true

--- Exercise 31.3: Extend the previous exercise so that we can use addition to get the union of two arrays and
--- multiplication for the intersection.
print(a + b)
print(a * b)

--- Exercise 31.4: Modify the implementation of the __tostring metamethod so that it shows the full contents of the array in an appropriate way. Use the buffer facility (the section called “String Manipulation”)
--- to create the resulting string.



--- Exercise 31.5: Based on the example for Boolean arrays, implement a small C library for integer arrays.
--ignored