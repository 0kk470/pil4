--TODO
local Account = { balance = 12}

function Account:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function Account:deposit(v)
    self.balance = self.balance + v
end

function Account:withdraw(v)
    if v - self.balance >= self:getLimit() then
        error"insufficient funds"
    end
    self.balance = self.balance - v
    print("balance: " .. self.balance)
end

local SpecialAccount = Account:new()
local s = SpecialAccount:new{limit = 1000}
function SpecialAccount:getLimit()
    return self.limit or 0
end

print(s:getLimit())
s:withdraw(2)

local function createclass(...)
    local c = {}
    local parents = {...}
    setmetatable(c,{__index = function (t,k)
        for i = 1,#parents do
            if parents[i][k] then t[k] = parents[i][k] return parents[i][k] end
        end
    end} )
    c.__index = c
    c.new = function(o)
        o = o or {}
        setmetatable(o,c)
        return o
    end
    return c
end

local function newAccount(initialBalance)
    local self = {balance = initialBalance}
    local withdraw = function(v) self.balance = self.balance - v end
    local deposit = function(v) self.balance = self.balance + v end
    local getBalance = function() return self.balance end
    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance,
    }
end

function newObject(value)
    return function(action,v)
        if action == "get" then return value
        elseif action == "set" then value = v
        else error("invalid action")
        end
    end
end

local d = newObject(0)
print(d("get")) --0
d("set",10)
print(d("get")) --10

local balance = {}

function Account:withdraw(v)
    balance[self] = balance[self] - v
end


function Account:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o,self)
    balance[o] = 0
    return o
end
