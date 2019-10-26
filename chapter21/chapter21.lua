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
--local stk2 = stack.new()
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
