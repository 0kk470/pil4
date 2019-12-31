---Exercise 27.1: Compile and run the simple stand-alone interpreter (Figure 27.1, “A bare-bones stand-alone
---Lua interpreter”).



---Exercise 27.2: Assume the stack is empty. What will be its contents after the following sequence of calls?
--lua_pushnumber(L, 3.5);
--lua_pushstring(L, "hello");
--lua_pushnil(L);
--lua_rotate(L, 1, -1);
--lua_pushvalue(L, -2);
--lua_remove(L, 1);
--lua_insert(L, -2);



---Exercise 27.3: Use the function stackDump (Figure 27.2, “Dumping the stack”) to check your answer
---to the previous exercise.


---Exercise 27.4: Write a library that allows a script to limit the total amount of memory used by its Lua state.
---It may offer a single function, setlimit, to set that limit.
---The library should set its own allocation function. This function, before calling the original allocator,
---checks the total memory in use and returns NULL if the requested memory exceeds the limit.
---(Hint: the library can use the user data of the allocation function to keep its state: the byte count, the current
---memory limit, etc.; remember to use the original user data when calling the original allocation function.)



--详见同目录 chapter27.cpp