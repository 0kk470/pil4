---练习10.1
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

--use pattern
function string.split2(str, sep)
    local result = {}
    sep = sep or " "
    string.gsub(str, string.format("([^%s]+)", sep), function(c)
        result[#result + 1] = c
    end)
    return result
end

local function test10_1()
    local test = "123|||||456|780|"
    local a = string.split(test, "|")
    local b = string.split2(test, "|")
    for i = 1, #a do
        print(a[i])
    end
    print("----------------")
    for i = 1, #b do
        print(b[i])
    end
end
test10_1()