-- local lib = require "async-lib"

-- function run (code)
--     local co = coroutine.wrap(function ()
--         code()
--         lib.stop() -- finish event loop when done
--     end)
--     co() -- start coroutine
--     lib.runloop() -- start event loop
-- end

-- function putline (stream, line)
--     local co = coroutine.running() -- calling coroutine
--     local callback = (function () coroutine.resume(co) end)
--     lib.writeline(stream, line, callback)
--     coroutine.yield()
-- end

-- function getline (stream, line)
--     local co = coroutine.running() -- calling coroutine
--     local callback = (function (l) coroutine.resume(co, l) end)
--     lib.readline(stream, callback)
--     local line = coroutine.yield()
--     return line
-- end



---练习24.1 使用生产者驱动式设计重写24.2节中生产者-消费者的示例，其中消费者是协程，而生产者是主线程。

local function producer(consumer)
    while true do
        local x = io.read()
        coroutine.resume(consumer,x)
    end
end

local consumer = coroutine.create(function (x)
    print(x) --the first time into this func
    while true do
        local val = coroutine.yield()
        print("cosumer get(corutine): " .. val)
    end
end)

--producer(consumer)

---练习24.2 练习6.5要求编写一个函数来输出指定数组元素的所有组合。请使用协程把该函数修改为组合的生成器。
---该生成器的用法如下
--for c in combinations({"a","b","c"}, 2) do
--    printResult(c)
--end
local function combination_num(c)
    local cnt = 0
    for _,v in pairs(c) do
        if v then cnt = cnt + 1 end
    end
    return cnt
end

local function gen_combination(a, index, maxCnt, dic_isContain)
    if combination_num(dic_isContain) == maxCnt or index == #a + 1  then
        local res = {}
        res[#res + 1] = "{ "
        for k,v in pairs(dic_isContain) do
            if v then
                res[#res + 1] = a[k]
                res[#res + 1] = " "
            end
        end
        res[#res + 1] = "}"
        res[#res + 1] = "\n"
        local str = table.concat(res)
        print("ssssss" .. str)
        coroutine.yield(str)
    else
        dic_isContain[index] = true
        gen_combination(a, index + 1, maxCnt, dic_isContain)
        dic_isContain[index] = false
        gen_combination(a, index + 1, maxCnt, dic_isContain)
    end
end

function combinations(a, cnt)
    local co = coroutine.create(
        function() 
            gen_combination(a, 1, cnt, {}) 
        end
        )
    return function() 
        local c = coroutine.resume(co)
        return c;
    end
end

for c in combinations({"a","b","c"}, 2) do
   print(c)
end

---练习24.3 在示例24.5中，函数getline和putline每一次调用都会产生一个新的闭包。请使用记忆机制来避免这种资源浪费。

---练习24.4 请为基于协程的库（示例24.5）编写一个行迭代器，以便于使用for循环来读取一个文件

---练习24.5 你能否使用基于协程的库（示例24.5）来同时运行多个线程？要做哪些修改呢？

---练习24.6 用Lua实现一个transfer函数。如果你觉得唤醒-挂起和调用-返回类似，那么transfer就类似goto:它会挂起当前运行的协程，
---然后唤醒其他作为参数的协程（提示：使用某种调度机制来控制协程。这样的话，transfer会把控制权转交给调度器以通知下一个协程的运行，调度器就会唤醒下一个协程）