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



---练习23.2
local function test23_2()
    local o = {x = "hi"}
    setmetatable(o, {__gc = function (o) print(o.x) end})
	-- 1. collectgarbage("stop")  --析构器仍然会执行
	-- 2. error("an error")       --析构器函数会在报错之后执行
    -- 3. os.exit()               --析构器不会执行
end

--test23_2()



---练习23.3

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

--- 练习23.4 解释示例23.3程序的输出。
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

figure23_3()



--- 练习23.5 