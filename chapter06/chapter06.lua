---练习6.1 请编写一个函数，该函数的参数为一个数组，打印出该数组所有的元素
local function printAllElement(t)
   if type(t) ~= "table" then
       return
   end
   print(table.unpack(t))
end
local test1 = {1,"a",2,3,5,"b"}
--printAllElement(test1)


---练习6.2 请编写一个函数，该函数的参数为可变数量的一组值，返回除第一个元素之外的其他所有值
local function returnWithoutFirst(first,...)
   return ...
end

--print(returnWithoutFirst(1,2,3,4,5))

---练习6.3 请编写一个函数，该函数的参数为可变数量的一组值，返回除最后元素之外的其他所有值
local function returnWithoutLast(...)
   local t = table.pack(...)
   table.remove(t)
   return table.unpack(t)
end

--print(returnWithoutLast(1,2,3,4,5))

---练习6.4 请编写一个函数，该函数用于打乱一个指定的数组。请保证所有的排列都是等概率的。

--Fisher Yates
local function shuffle(array)
    math.randomseed(os.time())
	for i = #array,2,-1 do
	   local j = math.random(1,i)
	   if i ~= j then
	   	   local temp = array[i]
	       array[i] = array[j]
	       array[j] = temp
	   end
	end
end

--local a = {1,2,3,4,5,6,7,8}
--shuffle(a)
--printAllElement(a)

---练习6.5 请编写一个函数，它传入一个数组并打印该数组中所有元素的组合。
---提示：可以使用组合的递推公式C(n,m) = C(n - 1,m - 1) + C(n - 1,m)。
---要计算从n个元素中选出m个组成的组合C(n,m)。可以先将第一个元素加到结果集中，然后计算其他元素的C(n - 1,m - 1)；
---然后从结果集中删掉第一个元素，再计算其他所有剩余元素的C(n - 1, m)。
---当n < m 时，组合不存在；当 m = 0 时，只有一种组合（一个元素都没有）
local result = {}
local function Combination(a,firstIndex,curLen,tarLen)
    if curLen > tarLen then
        return
    end
    local len = #a
    if curLen == tarLen then
        for i = 1,len do
            if result[i] then
                io.write(a[i]," ")
            end
        end
        io.write("\n")
        print()
        return
    end
    if firstIndex > len then
        return
    end
    result[firstIndex] = true
    Combination(a,firstIndex + 1 ,curLen + 1,tarLen)
    result[firstIndex] = false
    Combination(a,firstIndex + 1,curLen,tarLen )
end

local function printAllCombinations(a)
    for i = 1,#a do
        Combination(a,1,0,i)
    end
end

local a = {1,2,3,4,5}
printAllCombinations(a)
