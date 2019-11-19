---Exercise 25.1: Adapt getvarvalue (Figure 25.1, “Getting the value of a variable”) to work with different coroutines (like the functions from the debug library).
function getvarvalue (co,name, level, isenv)
    if type(co) ~= "thread" then
        co = coroutine.running()
    end
    local value
    local found = false

    level = (level or 1) + 1

    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(co,level, i)
        if not n then break end
        if n == name then
            value = v
            found = true
        end
    end
    if found then return "local", value end

    -- try non-local variables
    local func = debug.getinfo(co,level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then return "upvalue", v end
    end

    if isenv then return "noenv" end -- avoid loop

    -- not found; get value from the environment
    local _, env = getvarvalue(co,"_ENV", level, true)
    if env then
        return "global", env[name]
    else -- no _ENV available
        return "noenv"
    end
end

function test25_1()
    local val1 = 1
    local co = coroutine.wrap(function ()
        local val2 = val1
        print(getvarvalue(nil,"val1",1))
        print(getvarvalue(nil,"val2",1))
    end)
    co()
    print(getvarvalue(nil,"val1",1))
    print(getvarvalue(nil,"val2",1))
end
--test25_1()

---Exercise 25.2: Write a function setvarvalue similar to getvarvalue (Figure 25.1, “Getting the value of a variable”).



---Exercise 25.3: Write a version of getvarvalue (Figure 25.1, “Getting the value of a variable”) that
---returns a table with all variables that are visible at the calling function. (The returned table should not
---include environmental variables; instead, it should inherit them from the original environment.)



---Exercise 25.4: Write an improved version of debug.debug that runs the given commands as if they
---were in the lexical scope of the calling function. (Hint: run the commands in an empty environment and
---use the __index metamethod attached to the function getvarvalue to do all accesses to variables.)



---Exercise 25.5: Improve the previous exercise to handle updates, too.



---Exercise 25.6: Implement some of the suggested improvements for the basic profiler that we developed
---in the section called “Profiles”.



---Exercise 25.7: Write a library for breakpoints. It should offer at least two functions:
    --setbreakpoint(function, line) --> returns handle
    --removebreakpoint(handle)
---We specify a breakpoint by a function and a line inside that function. When the program hits a breakpoint,
---the library should call debug.debug. (Hint: for a basic implementation, use a line hook that checks
---whether it is in a breakpoint; to improve performance, use a call hook to trace program execution and only
---turn on the line hook when the program is running the target function.)



---Exercise 25.8: One problem with the sandbox in Figure 25.6, “Using hooks to bar calls to unauthorized
---functions” is that sandboxed code cannot call its own functions. How can you correct this problem?