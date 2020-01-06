---另参见chapter28.cpp

---Exercise 28.1: Write a C program that reads a Lua file defining a function f from numbers to numbers
---and plots that function. (You do not need to do anything fancy; the program can plot the results printing
---ASCII asterisks as we did in the section called “Compilation”(chapter 16.1).)
function f(x)
    print("enter function to be plotted (with variable 'x':)" .. x)
    local line = io.read()
    return line
end


---Exercise 28.2: Modify the function call_va (Figure 28.5, “A generic call function”) to handle Boolean
---values.
function checkboolean(isBool)
    if isBool == true or isBool == false then
        print("c call lua checkboolean:" .. tostring(isBool))
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

-- config1
ws_1 = "https://weather.com/"
ws_2 = "http://www.nmc.cn/"
ws_3 = "http://data.cma.cn/"
--优点:配置简单快速 适合小数目气象站的配置
--缺点:拓展性很差，无法做额外的规则配置，而且在数量众多的情况下会产生大量的全局变量，降低了访问效率;且容易导致重名。

-- config2
ws_table = {
    ws_1 = "https://weather.com/",
    ws_2 = "http://www.nmc.cn/",
    ws_3 = "http://data.cma.cn/",
}
--优点:易于配置，有一定拓展性，并且可以通过表的特性来对配置进行一些修改（比如排序之类的）。可以制定一些特殊的映射规则。
--缺点:气象站数量众多的情况下会占用较大内存。

-- config3
function get_ws_url(ws_str)
    if ws_str == "ws_1" then
        return "https://weather.com/"
    elseif ws_str == "ws_2" then
        return "http://www.nmc.cn/"
    elseif ws_str == "ws_3" then
        return "http://data.cma.cn/"
    end
end

--优点:占用内存小
--缺点:存在字符串的比较开销 访问速度没有第1.2种效率高。