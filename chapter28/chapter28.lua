---Exercise 28.1: Write a C program that reads a Lua file defining a function f from numbers to numbers
---and plots that function. (You do not need to do anything fancy; the program can plot the results printing
---ASCII asterisks as we did in the section called “Compilation”(chapter 16.1).)
function f(x)
    print("enter function to be plotted (with variable 'x'):" .. x)
    local line = io.read()
    return line
end


---Exercise 28.2: Modify the function call_va (Figure 28.5, “A generic call function”) to handle Boolean
---values.
function checkboolean(isBool)
    if isBool == true or isBool == false then
        print(isBool)
    end
end


---Exercise 28.3: Let us suppose a program that needs to monitor several weather stations. Internally, it uses
---a four-byte string to represent each station, and there is a configuration file to map each string to the actual
---URL of the corresponding station. A Lua configuration file could do this mapping in several ways:
---• a bunch of global variables, one for each station;
---• a table mapping string codes to URLs;
---• a function mapping string codes to URLs.
---Discuss the pros and cons of each option, considering things like the total number of stations, the regularity
---of the URLs (e.g., there may be a formation rule from codes to URLs), the kind of users, etc.

--参见chapter28.cpp