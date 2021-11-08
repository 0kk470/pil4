local function isinteger(n)
    return math.type(n) == "integer"
end
--- 练习13.1 请编写一个函数，实现无符号整型数的取模运算

local function umod(a, b)
   if a < 0 then
      if b > 0 then
	     return ((a>>1)%b*2+(a&1)-b)%b
	  else
	     if math.ult(a,b) then 
		   return a 
		 else 
		   return b - a 
		 end
	  end
   else
	  if b > 0 then return a % b 
	  else return a end
   end
end

print(umod(3 << 62,10))
print(umod(3 << 62,100))
print(umod(3 << 62,1000))
print(umod(3 << 62,3 << 62))
print(umod(12345,3 << 62))

--- 练习13.2 请用不同的方式实现对Lua整形数值的二进制的位数计算
local function countdigit(n)
   assert(isinteger(n))
   local cnt = 0
   if n < 0 then
      n = -n
   end
   while n ~= 0 do
      cnt = cnt + 1
      n = n >> 1
   end
   return cnt
end

print("digit: " .. countdigit(0))
print("digit: " .. countdigit(-128))
print("digit: " .. countdigit(1))
print("digit: " .. countdigit(2))
print("digit: " .. countdigit(3))
print("digit: " .. countdigit(1025))

--- 练习13.3 如何判断一个给定的整数是2的幂次方?
local function checkpower2(n)
    assert(isinteger(n))
    return  n > 0 and n & (n - 1) == 0
end
for i = 1,2^5 do
   print(i,checkpower2(i))
end

--- 练习13.4 编写一个函数来计算一个指定整数的汉明权重（一个数的汉明权重是其二进制表示中的1的个数）
local function hammingweight(n)
    assert(isinteger(n))
    local iCount = 0
    while n ~= 0 do
        n = n & (n - 1)
        iCount = iCount + 1
    end
    return iCount
end
print(hammingweight(1))
print(hammingweight(3))
print(hammingweight(4))
print(hammingweight(math.tointeger(2^32)))

--- 练习13.5 编写一个函数来测试一个给定整数的二进制表示是否是一个回文数

local function ispali(n)
   assert(isinteger(n))
   local array = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
   if n < 0 then
      array[#array] = 1
   end
   n = math.abs(n);
   local index = 1
   while n ~= 0 do
      array[index] = math.fmod(n, 2)
      index = index + 1
      n = n // 2
   end
   local mid = #array // 2
   for i = 1, mid do
      if array[i] ~= array[#array - i + 1] then
         return false
      end
   end
   return true
end
print("isPali : " .. tostring(ispali(1)))
print("isPali : " .. tostring(ispali(2)))
print("isPali : " .. tostring(ispali(3)))
print("isPali : " .. tostring(ispali((1 << 1) + (1 << 30))))
print("isPali : " .. tostring(ispali(-1)))
print("isPali : " .. tostring(ispali(-8)))

--- 练习13.6 用lua实现一个bit数组。它应该支持下列操作
--- ● newBitArray(n) (创建一个有n个bit的数组)
--- ● setBit(a ,n ,v) (将boolean值 v 赋值给数组a的n位bit)
--- ● testBit(a ,n) (返回一个n位bit的boolean值v)
local function newBitArray(n)
   assert(math.type(n) == "integer", " 'n' is not an integer")
   assert(n >= 1, " 'n' shall not be smaller than 1")
   local array = {}
   for i = 1, n do array[i] = false end
   return array
end

local function setBit(a,n,v) 
   assert(a ~= nil, "array is null")
   assert(type(a) == "table", string.format("wrong param type:[%s], 'a' must be an array.", type(a)) )
   assert(math.type(n) == "integer", "n is not an integer")
   assert(#a >= n and n >= 1, "array index is out of range")
   assert(type(v) == "boolean", string.format("wrong param type:[%s], 'v' must be a boolean.", type(v)) )
   a[n] = v
end

local function testBit(a,n)
   assert(type(a) == "table", string.format("wrong param type:[%s], 'a' must be an array.", type(a)) )
   assert(math.type(n) == "integer", " 'n' is not an integer")
   assert(#a >= n and n >= 1, "array index is out of range")
   return a and a[n]
end

--newBitArray(-1)
--newBitArray(0)
--setBit("ss")
--setBit(nil, 1, 1)
--setBit({},"str",true)
--setBit(newBitArray(4),5,true)
--setBit(newBitArray(4), 4, "str")

local arrTest = newBitArray(3)

for i = 1, #arrTest do 
   setBit(arrTest,i,true) 
end

setBit(arrTest, 2, false)

for i = 1, #arrTest do 
   print(testBit(arrTest, i))
end