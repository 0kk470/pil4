---练习6.1
local function printAllElement(t)
   if type(t) ~= "table" then
       return
   end
   print(table.unpack(t))
end
local test1 = {1,"a",2,3,5,"b"}
printAllElement(test1)


---练习6.2
local function returnWithoutFirst(...)
   return select(2,...)
end

print(returnWithoutFirst(1,2,3,4,5))

---练习6.3
local function returnWithoutLast(...)
   local t = table.pack(...)
   table.remove(t)
   return table.unpack(t)
end

print(returnWithoutLast(1,2,3,4,5))

---练习6.4

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
