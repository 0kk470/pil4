--Example Set
local Set = {}
local mt = nil

function Set.new(l)
    local newSet = {}
    mt = mt or {__add = Set.union ,
                __tostring = Set.tostring ,
                __sub = Set.difference,
                __len = Set.size,
                __metatable = "not your business"
    }
    setmetatable(newSet,mt)
    for _,v in ipairs(l) do newSet[v] = true end
    return newSet
end

function Set.union(a,b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection(a,b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

function Set.tostring(set)
    local l = {}
    for e in pairs(set) do
        l[#l + 1] = tostring(e)
    end
    return "{" .. table.concat(l,", ") .."}"
end

--local s1 = Set.new{1,2,3,4}
--local s2 = Set.new{2,4,6,7}
--local s3 = s1 + s2
--print(tostring(s3)) --输出{1,2,3,4,6,7}

---练习20.1 为集合定义一个__sub元方法用于返回集合的差集( a - b 表示 属于a并且不属于b的元素 的集合)
function Set.difference(a,b)
    assert(getmetatable(a) == mt,"attempt to 'sub' a set with a non-set value")
    assert(getmetatable(a) == mt,"attempt to 'sub' a set with a non-set value")
    local set = Set.new{}
    for k in pairs(a) do
        if not b[k] then
            set[k] = true
        end
    end
    return set
end
--local s4 = Set.new{1,2,3,4}
--local s5 = Set.new{2,3,6,7}
--local s6 = s4 - s5
--print(tostring(s6))


---练习20.2 为集合定义一个__len元方法,使得#s返回集合s的元素个数。
function Set.size(set)
    assert(type(set) == "table","invalid arg for 'set' ")
    local count = 0
    for k in pairs(set) do
        count = count + 1
    end
    return count
end
--local s7 = Set.new{"a","b",1,2,3,"c",{}}
--print(#s7)



---练习20.3 另一种实现只读表的方法是用一个函数作为__index元方法。
local key = {}
local mt = { -- create metatable
    __index = function (t,k) return t[key][k] end,
    __newindex = function (t, k, v)
        error("attempt to update a read-only table", 2)
    end
}

local function readOnly (t)
    local proxy = {[key] = t}
    setmetatable(proxy, mt)
    return proxy
end

--local days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday",
--                      "Thursday", "Friday", "Saturday"}
--print(days[2])
--days[2] = "Noday"



---练习20.4

local function fileAsArray(filename)
    assert(filename == "string","filename is not a 'string' ")
end