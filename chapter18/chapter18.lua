---练习18.1 请编写一个迭代器fromto，使得如下循环与数值for循环等价:
---for i in fromto(n,m) do
---end
---你能否用无状态迭代器实现?

---练习18.2 向上一个练习的迭代器增加一个步长参数。

local function fromto(n,m,step)
    step = step or 1
    assert(type(step) == "number","invalid arg 'step'")
    assert(type(n) == "number","invalid arg  'n'")
    assert(type(m) == "number","invalid arg  'm'")
    n = n - step
    return function()
        n = n + step
        if n > m then return nil end
        return n
    end
end

local function test18_1_2()
    for i in fromto(1,5) do
        print(i)
    end
    for i in fromto(1,-1) do
        print(i)
    end
    for i in fromto(1,2.2,0.2) do
        print(i)
    end
    for i in fromto(1,2,"4") do
        print(i)
    end
    for i in fromto(1,{},{}) do
        print(i)
    end
end
--test18_1_2()



---练习18.3 请编写一个迭代器uniquewords,该迭代器返回指定文件中没有重复的所有单词。
---（提示:基于示例中allwords的代码，使用一个表来存储已经处理过的所有单词）
local function uniquewords(filename)
    assert(type(filename) == "string","not a file name")
    local wordcounter = {}
    local wordlist = {}
    for line in io.lines(filename) do
        for word in string.gmatch(line,"%w+") do
            wordcounter[word] = (wordcounter[word] or 0) + 1
        end
    end
    for word,count in pairs(wordcounter) do
        if count == 1 then
            wordlist[#wordlist + 1] = word
        end
    end
    local i = 0
    return function()
        i = i + 1
        return wordlist[i]
    end
end

local function test18_3()
    for word in uniquewords("word.txt") do
        print(word)
    end
end
--test18_3()



---练习18.4 请编写一个迭代器,该迭代器返回指定字符串的所有非空子串
--注意是（连续的）子串而不是子序列
local function substrings(str)
    local len = string.len(str)
    local i = 1
    local j = 0
    return function()
        if j >= len then
            i = i + 1; j = i
        else
            j = j + 1
        end
        if i <= len then return string.sub(str,i,j) end
    end
end

--for str in substrings("abcd") do
--    print(str)
--end

---练习18.5 请编写一个真正的迭代器，该迭代器遍历指定集合的所有子集
---(该迭代器可以使用同一个表来保存所有的结果。只需要在每次迭代时改变表的内容即可，不需要为每个子集创建一个新表)

local function allPowerSet(f,set)
    local t = {{}}
    f(t[1])
    for i = 1, #set do
        for j = 1, #t do
            local tmp = {table.unpack(t[j])}
            tmp[#tmp + 1] = set[i]
            t[#t+1] = tmp
            f(tmp)
        end
    end
end

local function printSubSet(subset)
    io.write("{")
    for i = 1,#subset do
        io.write(i == 1 and "" or ",",subset[i])
    end
    io.write("}\n")
end

allPowerSet(printSubSet,{1,2,3,4})