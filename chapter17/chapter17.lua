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
geometry.plot( geometry.difference(square, geometry.rotate(square,45)), 100, 100)



---练习17.3 如果库搜索路径中包含固定的路径组成（即没有包含问号）会发生什么?这一行为有用吗?
package.path = package.path .. ";D:/pil4/chapter17/geometry.lua"
local testmod1 = require("D:/pil4/chapter17/geometry.lua")
local testmod2 = require("D:/pil4/chapter17/geometry.lua")
local mod1 = require("somethingNotExist1")
local mod1_copy = require("somethingNotExist1")
local mod2 = require("somethingNotExist2")
local mod3 = require("somethingNotExist3")
print("testmod1: ".. tostring(testmod1))
print("testmod2: ".. tostring(testmod2))
print("mod1: ".. tostring(mod1))
print("mod2 ".. tostring(mod2))
print("mod3 ".. tostring(mod3))
print("testmod1 == testmod2: ".. tostring(testmod1 == testmod2))
print("testmod1 == mod1: ".. tostring(testmod1 == mod1))
print("mod1 == mod1_copy: ".. tostring(mod1 == mod1_copy))
print("testmod1 == mod1: ".. tostring(testmod1 == mod1))

-- 如果在lua的搜索path中添加一项绝对路径的文件名，会导致require一个不存在的模块时，这个模块都会搜索到固定文件名的文件作为它导入的模块
-- 并且如果模块名不一样，缓存的table也不一样，就算加载了相同固定路径的module，在内存中也是两份独立的副本
-- 在极端情况下还是有用，相当于始终会有默认的模块被加载，可以用这套机制来拓展require函数
-- 详细可参见 https://www.lua.org/pil/8.1.html 最后一段说明


---练习17.4 编写一个同时搜索Lua文件和C标准库的搜索器。
---(提示:使用函数package.searchpath寻找正确的文件，然后试着依次使用函数loadfile和函数package.loadlib加载该文件)
local function searcher(name,path)
    assert(type(name) == "string","invalid name")
    assert(type(path) == "string","invalid path")
    local filename = package.searchpath(name,path)
    local err = ""
    if filename then
        print("loadfile")
        local f = loadfile(filename)
        if not f then
            print("loadlib")
            f = assert(package.loadlib(filename),filename .. " load failed")
        end
        return f
    else
        err = "\n\tno file '".. name .." can be loaded"
    end
    return nil,err
end
package.searchers[#package.searchers + 1] = searcher

