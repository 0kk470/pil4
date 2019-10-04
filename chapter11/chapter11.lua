---练习11.1 当我们对一段文本执行统计单词出现频率的程序时，结果常常是一些注入冠词和介词之类的没有太多意义
---的短词汇。请改写该程序，使他忽略长度小于4个字母的单词

---练习11.2 重复上面的练习，除了按照长度忽略单词外，该程序还能从一个文本文件中读取要忽略的单词列表。


local ignore = {}
for line in io.lines("ignorewords.txt") do
    for word in string.gmatch(line,"%w+") do
        ignore[word] = true
    end
end

local counter = {}

for line in io.lines("content.txt") do
    for word in string.gmatch(line,"%w%w%w+") do
        if not ignore[word] then
            counter[word] = (counter[word] or 0) + 1
        end
    end
end

local words = {}

for w in pairs(counter) do
    words[#words + 1] = w
end

table.sort(words,function (w1,w2)
    return counter[w1] > counter[w2] or counter[w1] == counter[w2] and w1 < w2
end)

local n = math.min(tonumber(arg[1]) or math.huge,#words)

for i = 1, n do
    io.write(words[i] , "\t",counter[words[i]],"\n")
end