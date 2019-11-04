---练习23.1 编写一个测试程序来检测Lua是否真的实现了瞬表。
---（记得调用collectgarbage来强制进行一次垃圾收集循环）。
--- 如果可能的话，分别使用Lua5.1 5.2 5.3测试你的代码，看看有什么不同。
local function test23_1()
    local t = {}
    setmetatable(t,{__mode = "k",
                                __len = function (o)
                                          local count = 0
                                          for k,v in pairs(o) do count = count + 1 end
                                          return count
                                        end
                                })
    local a = {}
    t[a] = {x = a}
    print(#t)
    a = nil
    collectgarbage()
    print(#t)
end

--test23_1()



---练习23.2 考虑23.6节的第一个例子，该示例创建了一个带有析构器的表，该析构器再执行时只是输出一条消息。
---如果程序没有进行过垃圾收集就退出会发生什么?如果程序调用os.exit()呢?如果程序由于出错而退出呢？
local function test23_2()
    local o = {x = "hi"}
    setmetatable(o, {__gc = function (o) print(o.x) end})
	-- 1. collectgarbage("stop")  --析构器仍然会执行
	-- 2. error("an error")       --析构器函数会在报错之后执行
    -- 3. os.exit()               --析构器不会执行
end

--test23_2()



---练习23.3 假设要实现一个记忆表，该记忆表所对应函数的参数和返回值都是字符串。由于弱引用表不把字符串当作可回收对象，
---因此将这个记忆表标记为弱引用并不能使得其中的键值对能够被垃圾收集。在这种情况下，该如何实现记忆功能呢？

--用一张表映射字符串就可以了
local function test23_3()
    local mem = {}
    setmetatable(mem,{__mode = "kv"})
    local function getString(str)
        if mem[str] then
            print("memorized str")
            return mem[str].str
        end
        local value = { str = "this is key [" .. str .. "]'s value"}
        mem[str] = value
        print("create new str:" .. value.str)
        return value.str
    end
    print(getString("abc"))
    print(getString("abc"))
    collectgarbage()
    print(getString("abc"))
end

--test23_3()

--- 练习23.4 解释示例23.3中程序的输出。
local function figure23_3()
    local count = 0
    local mt = {__gc = function () count = count - 1 end}
    local a = {}
    --构建10000个带析构器的表
    for i = 1, 10000 do
        count = count + 1
        a[i] = setmetatable({},mt)
    end
    --第一次收集 基本没有垃圾可回收
    collectgarbage()
    --当前Lua程序占用的内存 count值为10000
    print(collectgarbage("count") * 1024, count)
    --将表引用置空
    a = nil
    --第一次回收垃圾。垃圾收集器会调用这10000个表的析构器 会回收部分内存 并将析构的对象标记为可回收
    collectgarbage()
    --当前Lua程序占用的内存会比上一个打印少  count值减少至0
    print(collectgarbage("count") * 1024, count)
    --第二次次回收垃圾。垃圾收集器将所有标记过的对象回收 析构器不会再触发 count值仍为0
    collectgarbage()
    --打印回收所有表后的内存占用  count值为0
    print(collectgarbage("count") * 1024, count)
end

--figure23_3()



--- 练习23.5 对于这个练习，你需要一个使用大量内存的Lua脚本。如果没有可以写一个这样的脚本（一个创建表的循环就行）。
--- ● 使用不同的payse和stepmul参数运行脚本。它们的值是如何影响脚本的性能和内存使用的?
--- 如果把pause值设为0会发生什么？把pause设成1000会发生什么?把stepmul设成0会发生什么？stepmul设成1000000会发生什么？
--- ● 调整你的脚本，使其能够完全控制垃圾收集器。脚本应该让垃圾收集器停止运行，然后时不时地完成垃圾收集的工作。
--- 你能够使用这种方式提高脚本的性能吗?
local function isWindows()
    return package.config:sub(1,1) == "\\"
end

local function sleep(n)
    if isWindows() then
        if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end
    else
        os.execute("sleep " .. tonumber(n))
    end
end

local function allocMemory()
    local a = {}
    for i = 1,100000 do
        a[i] = {}
    end
end

--setpause 在达到上一次垃圾收集器完成时内存的pause比例前，垃圾收集器会处于暂停状态 比如200表示达到上一次回收结束时内存的两倍(200%)才会进行一次新的垃圾收集
--setstepmul 每分配1kb内存 执行对应stepmul比例的垃圾回收处理
local function test23_5()
    print(collectgarbage("count") * 1024)
    --collectgarbage("setstepmul",100000)
    --collectgarbage("setpause",0)
    --collectgarbage("setpause",1000)
    --collectgarbage("setstepmul",1000000)
    while true do
        sleep(1)
        allocMemory()
        print(collectgarbage("count") * 1024)
    end
end

--test23_5()