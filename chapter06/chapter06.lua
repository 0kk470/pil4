---练习6.1 请编写一个函数，该函数的参数为一个数组，打印出该数组所有的元素
local function printAllElement(t)
   if type(t) ~= "table" then
       return
   end
   print(table.unpack(t))
end
local test1 = {1,"a",2,3,5,"b"}
printAllElement(test1)


---练习6.2 请编写一个函数，该函数的参数为可变数量的一组值，返回除第一个元素之外的其他所有值
local function returnWithoutFirst(first,...)
   return ...
end

print(returnWithoutFirst(1,2,3,4,5))

---练习6.3 请编写一个函数，该函数的参数为可变数量的一组值，返回除最后元素之外的其他所有值
local function returnWithoutLast(...)
   local t = table.pack(...)
   table.remove(t)
   return table.unpack(t)
end

print(returnWithoutLast(1,2,3,4,5))

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

local a = {1,2,3,4,5,6,7,8}
shuffle(a)
printAllElement(a)

io.read()
