---  练习10.1 请编写一个函数split,该函数接受两个参数，第一个参数是字符串，第二个参数是分隔符模式，函数的返回值是分隔符分割后的原始字符串中每一部分的序列。
---你编写的函数是如何处理空字符串的呢?
---use find and sub
function string.split(str, sep)
    local result = {}
    if not str or str == "" then
        return result
    end
    if sep == "" then
        result[#result + 1] = str
        return result
    end
    sep = sep or " "
    local start, length = 1, #str
    while start <= length do
        local i, j = string.find(str, sep, start)
        if not i or not j then
            if start <= length then
                result[#result + 1] = string.sub(str, start, length)
            end
            break
        end
        result[#result + 1] = string.sub(str, start, i - 1)
        start = j + 1
    end
    return result
end

--use pattern  (deal with empty string)
function string.split2(str, sep)
    local result = {}
    sep = sep or " "
    string.gsub(str, string.format("([^%s]+)", sep), function(c)
        result[#result + 1] = c
    end)
    return result
end

local function test10_1()
    local test1 = "a whole new World"
    local a = string.split(test1, " ")
    local b = string.split2(test1, " ")
    for i = 1, #a do
        print(a[i])
    end
    print("----------------")
    for i = 1, #b do
        print(b[i])
    end
    print("==================")
    local test2 = "a|whole|new|||||World"
    a = string.split(test2, "|")
    b = string.split2(test2, "|")
    for i = 1, #a do
        print(a[i])
    end
    print("----------------")
    for i = 1, #b do
        print(b[i])
    end
end
-- test10_1()



---  练习10.2 模式'%D'和'^%d'是等价的，那么模式'[^%d%u]'和'[%D%U]'呢?
-- 后者不等价
local str = "A"
print(string.match(str, "[^%d%u]")) --非数字并且非大写字母
print(string.match(str, "[%D%U]"))  --非数字或者非大写字母 其实就是所有字符


---  练习10.3 请编写一个函数transliterate，该函数接受两个参数，第1个参数是字符串，第二个参数是一个表。
---函数 transliterate 根据第二个参数 表 使用一个字符替换字符串中的字符。如果表中将a映射为b ，那么该函数将所有 a 替换为 b 。
---如果表中将 a 映射为 false，那么该函数则把结果中的所有a移除
local function transliterate(str, t)
    if not str or not t then
        error("Invalid argument")
    end
    for k, v in pairs(t) do
        str = string.gsub(str, k, function(key)
            if v == false then
                return ""
            end
            return v
        end)
    end
    return str
end

local t = { the = false,best = "good"}
print(transliterate("Lua isthe a best language in thisthe world",t))


---  练习10.4 在10.3节的最后，我们定义了一个trim函数。由于该函数使用了回溯，所以对于某些字符串来说该函数的时间复杂度是O(n^2)。
---  ●构造一个可能会导致函数trim耗费O(n^2)时间复杂度的字符串。
---  ●重写这个函数使得其时间复杂度为O(n)。

local function trim(s)
    s = string.gsub(s,"^%s*(.-)%s*$","%1")
    return s
end

print(trim(" ss sb bb "))
