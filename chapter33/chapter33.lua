---Exercise 33.1: As we saw, if a function calls lua_yield (the version with no continuation), control
---returns to the function that called it when the thread resumes. What values does the calling function receive
---as results from that call?



---Exercise 33.2: Modify the lproc library so that it can send and receive other primitive types such as
---Booleans and numbers without converting them to strings. (Hint: you only have to modify the function
---movevalues.)



---Exercise 33.3: Modify the lproc library so that it can send and receive tables. (Hint: you can traverse
---the original table building a copy in the receiving state.)



---Exercise 33.4: Implement in the lproc library a non-blocking send operation

local co = coroutine.wrap(function(x)
    coroutine.yield(1)
    print(x)
    coroutine.yield(2)
    print(x)
    coroutine.yield(3)
    print(x)
    print("coroutine end")
end)
print(1)
print(2)
lproc.start([[
print("c1 send begin")
lproc.send("c1")
print("c1 sended ,receive c2")
lproc.receive("c2")
print("receive c2 end")
]])
lproc.start([[
print("c1 receive begin")
lproc.receive("c1")
print("c1 received ,send c2")
lproc.send("c2")
print("send c2 end")
]])
print(3)