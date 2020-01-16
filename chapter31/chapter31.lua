--- Exercise 31.1: Modify the implementation of setarray so that it accepts only Boolean values.
local a = array.new(10)
print(a)
a[4] = true
print(a[4])
print(#a)
--array.set(a, 1, 20) --not boolean


--- Exercise 31.2: We can see a Boolean array as a set of integers (the indices with true values in the array).
--- Add to the implementation of Boolean arrays functions to compute the union and intersection of two arrays.
--- These functions should receive two arrays and return a new one, without modifying its parameters.



--- Exercise 31.3: Extend the previous exercise so that we can use addition to get the union of two arrays and
--- multiplication for the intersection.



--- Exercise 31.4: Modify the implementation of the __tostring metamethod so that it shows the full contents of the array in an appropriate way. Use the buffer facility (the section called “String Manipulation”)
--- to create the resulting string.



--- Exercise 31.5: Based on the example for Boolean arrays, implement a small C library for integer arrays.