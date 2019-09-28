local function checkstring(str)
    if type(str) ~= "string" then
        str = tostring(str)
    end
    return str
end
---练习4.1 请问如何在Lua程序中以字符串的方式使用如下的XML片段?
local s1 = [=[
<![CDATA[
   Hello world
]]>
]=]
local s2 = "<![CDATA[\n   Hello world\n]]>"
print(s1)
print(s2)

---练习4.2 假设你需要以字符串的常量形式定义一组包含歧义的转义字符序列 你会使用哪种方式？
---请考虑诸如可读性、每行最大长度及字符串最大长度问题
local s3 = '\n \a \b \f \n \r \t \v \\ \" \' '

---练习4.3 请编写一个函数，使其实现在某个字符串的指定位置插入另一个字符串
function string.insert(s1, pos, s2)
    s1 = checkstring(s1)
    if not s2 then
        return s1
    end
    s2 = checkstring(s2)
    pos = pos or 1
    local len = string.len(s1)
    if pos <= 1 then
        return s2 .. s1
    elseif pos >= len + 1 then
        return s1 .. s2
    end
    local pre, suf = string.sub(s1, 1, pos - 1), string.sub(s1, pos, len)
    return pre .. s2 .. suf
end

print(string.insert("hello world", 1, "start: "))
print(string.insert("hello world", 7, "small "))

---练习4.4 请使用UTF-8字符串重写 insert("ação", 5, "!"))
function string.utf8insert(s1, pos, s2)
    s1 = checkstring(s1)
    if not s2 then
        return s1
    end
    s2 = checkstring(s2)
    pos = pos or 1
    local utf8len = utf8.len(s1)
    local len = string.len(s1)
    if pos <= 1 then
        return s2 .. s1
    elseif pos >= utf8len + 1 then
        return s1 .. s2
    end
    local m = utf8.offset(s1, pos)
    local pre, suf = string.sub(s1, 1, m - 1), string.sub(s1, m, len)
    return pre .. s2 .. suf
end

print(string.utf8insert("ação", 5, "!"))

---练习4.5 编写一个函数，该函数用于移除指定字符串中的一部分，移除的部分由起始位置和长度指定。
function string.remove(s1, pos, num)
    if not s1 then
        error("the argument#1 is nil!")
    end
    local len = string.len(s1)
    pos = pos or 1
    num = num or len
    if pos <= 1 then
        pos = 1
    elseif pos >= len + 1 then
        return s1
    end
    if num <= 0 then
        return s1
    end
    local m = math.min(pos + num, len)
    local pre, suf = string.sub(s1, 1, pos - 1), string.sub(s1, m, len)
    return pre .. suf
end

print(string.remove("hello world", 7, 4))
-- print(string.remove("hello world", -1, 4))
-- print(string.remove("hello world", 3, 4))

---练习4.6    使用UTF-8字符串重写 remove("ação", 2, 2)
function string.utf8remove(s1, pos, num)
    if not s1 then
        error("the argument#1 is nil!")
    end
    local utf8len = utf8.len(s1)
    local len = string.len(s1)
    pos = pos or 1
    num = num or utf8len
    if pos <= 1 then
        pos = 1
    elseif pos >= utf8len + 1 then
        return s1
    end
    if num <= 0 then
        return s1
    end
    local m1 = utf8.offset(s1, pos)
    local m2 = utf8.offset(s1, math.min(pos + num, utf8len + 1))
    local pre, suf = string.sub(s1, 1, m1 - 1), string.sub(s1, m2, len)
    return pre .. suf
end

print(string.utf8remove("ação", 2, 2))

---练习4.7 请编写一个函数判断指定的字符串是否为回文字符串
local function ispali(str)
    if not str then
        return false
    end
    str = checkstring(str)
    return str == string.reverse(str)
end

print(ispali("step on no pets"))
print(ispali("banana"))

---练习4.8 重写之前的练习，使得它们忽略空格和标点符号
local pattern = "[%p%s]"
local function ispali2(str)
    if not str then
        return false
    end
    str = checkstring(str)
    str = string.gsub(str, pattern, "")
    return str == string.reverse(str)
end
print(ispali2("ste p        ,,,on, no ,,,   pets"))
print(ispali2("st ep      on no   p  et s"))

---练习4.9 使用UTF-8字符串重写之前的练习
function string.utf8reverse(str)
    if not str then
        error("the argument#1 is nil!")
    end
    if str == "" then
        return str
    end
    local array = { utf8.codepoint(str, utf8.offset(str, 1), utf8.offset(str, -1)) }
    local rArray = {}
    local len = #array
    for i = len, 1, -1 do
        rArray[len - i + 1] = array[i]
    end
    return utf8.char(table.unpack(rArray))
end

local function ispali_utf8(str)
    if not str then
        return false
    end
    str = checkstring(str)
    str = string.gsub(str, pattern, "")
    return str == string.utf8reverse(str)
end

print(ispali_utf8("上海自来水来自海上"))
print(ispali_utf8("上海    自 来 水来   自海上"))
print(ispali_utf8("上海  ,,,  自?? 来 水来  ? 自海上"))

io.read()
	