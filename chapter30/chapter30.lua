---Exercise 30.1: Implement a filter function in C. It should receive a list and a predicate and return a new
---list with all elements from the given list that satisfy the predicate:
--- t = filter({1, 3, 20, -4, 5}, function (x) return x < 5 end) -- t = {1, 3, -4}
---(A predicate is just a function that tests some condition, returning a Boolean.)
t1 = mylib.filter({1, 3, 20, -4, 5}, function(x) return x < 5 end )
print("len:" .. #t1)
print(t1[1], t1[2], t1[3])

t2 = mylib.filter({"a","b",1,{},134.7,true}, function(x) return type(x) == 'string' end)
print("len:" .. #t2)
print(t2[1], t2[2])


---Exercise 30.2: Modify the function l_split (from Figure 30.2, “Splitting a string”) so that it can work
---with strings containing zeros. (Among other changes, it should use memchr instead of strchr.)



---Exercise 30.3: Reimplement the function transliterate (Exercise 10.3) in C.



---Exercise 30.4: Implement a library with a modification of transliterate so that the transliteration
---table is not given as an argument, but instead is kept by the library. Your library should offer the following
---functions:
--- lib.settrans (table) -- set the transliteration table
--- lib.gettrans () -- get the transliteration table
--- lib.transliterate(s) -- transliterate 's' according to the current table
---Use the registry to keep the transliteration table.



---Exercise 30.5: Repeat the previous exercise using an upvalue to keep the transliteration table.



---Exercise 30.6: Do you think it is a good design to keep the transliteration table as part of the state of the
---library, instead of being a parameter to transliterate?