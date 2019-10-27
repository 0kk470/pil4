---练习21.1 实现一个类Stack，该类具有push、pop、top、isempty

local stack = {}
stack.__index = stack

function stack:new(o)
    o = o or {}
    setmetatable(o,self)
    o.list = {}
    return o
end

function stack:isempty()
    return #self.list == 0
end

function stack:push(v)
    assert(v,"push data is nil")
    self.list[#self.list + 1] = v
end

function stack:top()
    if self:isempty() then error("cannot get top,stack is empty") end
    return self.list[#self.list]
end

function stack:pop()
    if self:isempty() then error("pop error,stack is empty") end
    local v =  self.list[#self.list]
    table.remove(self.list)
    return v
end

--local stk = stack:new()
--local stk2 = stack:new()
--stk:push(1)
--stk:push(2)
--stk:push(3)
--print(stk:top())
--print(stk:pop())
--print(stk:top())
--print(stk:isempty())
--print(stk2:isempty())

---练习21.2 实现类Stack的子类StackQueue。除了继承的方法外，还给这个子类增加一个方法insertbottom。
---该方法在栈的底部插入一个元素（这个方法使得我们可以把这个类的实例当作队列）
local StackQueue = stack:new()
StackQueue.__index = StackQueue
function StackQueue:insertbottom(v)
    assert(v,"insert value is nil")
    table.insert(self.list,1,v)
end
--local stkqueue = StackQueue:new()
--stkqueue:push(1)
--stkqueue:insertbottom(2)
--stkqueue:insertbottom(3)
--print(stkqueue:pop())
--print(stkqueue:pop())
--print(stkqueue:pop())



---练习21.3 使用对偶表示重新实现类Stack
local DualStack = {}
local stackContainer = {}
DualStack.__index = DualStack

function DualStack:new(o)
    o = o or {}
    setmetatable(o,self)
    stackContainer[o] = {}
    return o
end

function DualStack:isempty()
    return #stackContainer[self] == 0
end

function DualStack:push(v)
    assert(v,"push data is nil")
    table.insert(stackContainer[self],v)
end

function DualStack:top()
    if self:isempty() then error("cannot get top,stack is empty") end
    return stackContainer[self][#stackContainer[self]]
end

function DualStack:pop()
    if self:isempty() then error("pop error,stack is empty") end
    local v =  stackContainer[self][#stackContainer[self]]
    table.remove(stackContainer[self])
    return v
end
--local stk3 = DualStack:new()
--local stk4 = DualStack:new()
--stk3:push(1)
--stk3:push(2)
--stk3:push(3)
--print(stk3:top())
--print(stk3:pop())
--print(stk3:top())
--print(stk3:isempty())
--print(stk4:isempty())

---练习21.4 对偶表示的一种变形是使用代理表示对象(20.4.4节)。每一个对象由一个空的代理表表示。
---一个内部的表把代理映射到保存对象状态的表。这个内部表不能从外部访问，但是方法可以使用内部表来把self变量转换为要操作的表。
---请使用这种方式实现银行账户的示例，然后讨论这种方式的优点和缺点。

--优点 很好的将数据进行了封装 避免从外部直接访问修改
--缺点 由于返回的是proxy空表，因此调试的适合不方便获取类的内部信。 此外由于内部代理表的存在，对象使用过后无法被垃圾回收。

do
    local Account = {}
    local proxies = {}
    local mt = {
        __index = function(t,k)
            local objstate = proxies[t]
            if objstate then
                return objstate[k]
            end
        end
    }
    function Account:withdraw(v)
        self.balance = self.balance - v
    end

    function Account:deposit(v)
        self.balance = self.balance + v
    end

    function Account:getBalance()
        return self.balance
    end

    function Account:new(o)
        o = o or {balance = 0}
        self.__index = self
        setmetatable(o,self)
        return o
    end

    function account_proxy()
        local obj = Account:new()
        local proxy = {}
        proxies[proxy] = obj
        setmetatable(proxy,mt)
        return proxy
    end
end
--local account1 = account_proxy()
--local account2 = account_proxy()
--print(account1:getBalance())
--account1:withdraw(2)
--print(account1:getBalance())
--account1:deposit(10)
--print(account1:getBalance())
--print("--------------------")
--print(account2:getBalance())
--account2:withdraw(5)
--print(account2:getBalance())
--account2:deposit(6)
--print(account2:getBalance())