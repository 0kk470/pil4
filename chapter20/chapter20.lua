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



---练习20.3 另一种实现只读表的方法是用一个函数作为__index元方法。这种方式使得访问的开销更大，但是创建只读表的开销更小。
---(因为所有的只读表能够共享一个元表)请使用这种方式重写函数readOnly
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



---练习20.4 代理表可以表示除表以外的其他类型的对象。请编写一个函数fileAsArray,该函数以一个文件名为参数，返回值会对应文件的代理。
---当执行 t = fileAsArray("myfile")后,返回t[i]返回指定文件的第i个字节，而对t[i]的赋值更新第i个字节。

---练习20.5 扩展之前的例子，使得我们能够使用pairs(t)遍历文件中的所有字节,并使用#t来获得文件的大小。

local function getfileSize(proxy)
    local filebytes = rawget(proxy,"filebytes")
    return filebytes and #filebytes or 0
end

local function getfileByte(proxy,i)
    assert(math.type(i) == "integer","i is not an integer")
    local filebytes = rawget(proxy,"filebytes")
    return filebytes and filebytes[i]
end

local function setfileByte(proxy,i,v)
    assert(math.type(i) == "integer","i is not an integer")
    local filebytes = assert(rawget(proxy,"filebytes"),"file bytes is nil")
    assert(i <= #filebytes and i > 0,"i is too large or too small for file size,value:" .. i)
    if  filebytes[i] == v then return end
    filebytes[i] = v
    local str = string.char(table.unpack(filebytes))
    local filename = assert(rawget(proxy,"filename"),"file name is nil")
    local f = assert(io.open(filename,"w"),"file does not exists")
    f:write(str)
end

local function filepairs(proxy)
    local i = 0
    local filebytes = assert(rawget(proxy,"filebytes"),"file bytes is nil")
    return function ()
        i = i + 1
        if i <= #filebytes then
           return i,filebytes[i]
        end
    end
end

local function fileAsArray(filename)
    assert(type(filename) == "string","filename is not a 'string' ")
    local f = assert(io.open(filename,"r"),"file does not exists")
    local proxy = { filename = filename,filebytes = {string.byte(f:read("a"),1,-1)}}
    local mt = {
        __len = getfileSize,
        __index = getfileByte,
        __newindex = setfileByte,
        __pairs = filepairs
    }
    setmetatable(proxy,mt)
    return proxy
end

--local t = fileAsArray("data.txt")
--print("__index")
--print(string.char(t[1]))
--print(string.char(t[2]))
--print(string.char(t[3]))
--print("__len")
--print(#t)
--print("__newindex")
--t[1] = string.byte("a")
--t[26] = string.byte("Z")
--print("__pairs")
--for i,v in pairs(t) do
--    print(i,string.char(v))
--end