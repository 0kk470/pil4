---练习17.1 将双端队列的实现（示例14.2）重写为恰当的模块
 local queue = require("queue")
 local q = queue.new()
 queue.pushFirst(q,1)
 queue.pushFirst(q,2)
 queue.pushFirst(q,3)
 print(queue.popFirst(q))
 print(queue.popFirst(q))


---练习17.2 将几何区域系统的实现（示例9.4）重写为恰当的模块
local geometry = require("geometry")
local square = geometry.rect(-1,1,-1,1)
geometry.plot( geometry.difference( square,geometry.rotate(square,45) ),100,100)



---练习17.3 如果库搜索路径中包含固定的路径组成（即没有包含问号）会发生什么?这一行为有用吗?
package.path = package.path .. ";D:/LuaTest/chapter16/chapter16.lua"  --换成你自己电脑上的绝对路径
local chapter16 = require("chapter16")
if chapter16 then print("chapter16 require success") end
-- 有用 Lua会在搜索其他路径失败的情况下根据固定路径搜索对应的文件



---练习17.4 编写一个同时搜索Lua文件和C标准库的搜索器。
---(提示:使用函数package.searchpath寻找正确的文件，然后试着依次使用函数loadfile和函数package.loadlib加载该文件)
local function searcher(name,path)
    assert(type(name) == "string","invalid name")
    assert(type(path) == "string","invalid path")
    local filename = package.searchpath(name,path)
    local err = ""
    if filename then
        print("loadfile")
        local f = assert(loadfile(filename),filename .. " loadfile failed")
        if not f then
            print("loadlib")
            f = assert(package.loadlib(filename),filename .. " loadlib failed")
        end
        return f
    else
        err = "\n\tno file '".. name .." can be loaded"
    end
    return nil,err
end
package.searchers[#package.searchers + 1] = searcher

