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

--local function ispali(n)
--    assert(isinteger(n))
--    local o = n
--    local a = {}
--    while n ~= 0 and n ~= 1 do
--        a[#a + 1] = math.modf()
--    end
--    print(tonumber(n,2))
--end
--print(tonumber("11",2))

--- 练习13.6 用lua实现一个bit数组。它应该支持下列操作
--- ● newBitArray(n) (创建一个有n个bit的数组)
--- ● setBit(a ,n ,v) (将boolean值 v 赋值给数组a的n位bit)
--- ● testBit(a ,n) (返回一个n位bit的boolean值v)
local function newBitArray(n)
   local array = {}
   for i = 1,n do array[i] = false end
   return array
end

local function setBit(a,n,v) 
   if a and a[n] then a[n] = v end
end

local function testBit(a,n) 
  return a and a[n]
end