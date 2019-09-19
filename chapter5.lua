--练习5.3
sunday = "monday";monday = "sunday"
t = {sunday = "monday",[sunday] = monday} -- => t = { ["sunday"] = "monday" , ["monday"] = "sunday" }
print(t.sunday,t[sunday],t[t.sunday])     -- => print(t["sunday"],t["monday"],t["monday"])
--monday sunday sunday



---练习5.2
local a = {}
a.a = a
print(a)
print(a.a)
print(a.a.a)
print(a.a.a.a)
--一样 都是table的内存地址名

-- a.a.a.a = 3 --报错


---练习5.3
--TODO

---练习5.4
local function CaculatePolynomial(a,x)
   local result = 0
   x = x or 0
   if type(a) ~= "table" or #a <= 0 then
      return result
   end
   for i = 1,#a do
     result = result + a[i] * x^i
   end
   return result
end
print( CaculatePolynomial({1,2,3},2) )

---练习5.5
--TODO

---练习5.6
local function isValidSequence(a)
   if type(a) ~= "table" then
      return false
   end
   local count = 0
   local size = #a
   for k,v in pairs(a) do
       count = count + 1
   end
   return count == size
end

print(isValidSequence({1,2,3,4}))               --true
print(isValidSequence({1,nil,3,4}))             --false
print(isValidSequence({1,"a",3,4}))             --true
print(isValidSequence({1,2,3,nil}))             --true
print(isValidSequence({nil,2,3,4}))             --false
print(isValidSequence({nil,2, a = "b",nil}))    --false
print(isValidSequence("str"))                   --false
print(isValidSequence(nil))                     --false

--练习5.7
local function copyAllToEnd(source,des,pos)
    for i = 1,#source do
	   table.insert(des,pos,source[i])
	   pos = pos + 1
	end
end

local function test5_7()
    local source = {4,5,6}
    local des = {1,2,3,7,8,9}
    local result = ""
    copyAllToEnd( source,des,4)
    for i = 1,#des do 
       result = result .. des[i] .." "
    end
    print(result)
end
test5_7()

--练习5.8
function table.my_slowConcat(t)
   local result = ""
   for i = 1,#t do
      result = result .. t[i] --字符串重复赋值 效率奇低
   end
   return result
end

function table.my_fastConcat(t) --这个效率会高的多
   local result = {}
   local temp = nil
   for i = 1,#t do
      temp = { string.byte(tostring(t[i])) } 
      for j = 1,#temp do
	     result[#result + 1] = temp[j]
	  end
   end
   return string.char(table.unpack(result))
end

local function test5_8()
    local a = {}
    for i = 1,200000 do
       a[i] = "a"
    end
    local startTime = os.time()
    table.concat(a)
    print("table.concat cost Time :" .. os.time() - startTime .. "s")
    startTime = os.time()
    table.my_slowConcat(a)
    print("table.my_slowConcat cost Time :" .. os.time() - startTime .. "s")
    startTime = os.time()
    table.my_fastConcat(a)
    print("table.my_fastConcat cost Time :" .. os.time() - startTime .. "s")
end
test5_8()

io.read()