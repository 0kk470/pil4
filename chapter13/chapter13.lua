--- 练习13.1 请编写一个函数，实现无符号整形的模运算

--- 练习13.2 请用不同的方式实现对Lua整形数值的二进制的位数计算

--- 练习13.3 你怎么检测一个给定的整数是2的幂次方
local function check2(n)
    return n ~ 0 == n
end
print(check2(1))
print(check2(2))
print(check2(3))
print(check2(4))
print(check2(5))


--- 练习13.4 编写一个函数来计算一个给定整数的汉明权值（一个数字的汉明权值是它的二进制表示下的1的个数）
local function hammingweight(n)
    local iCount = 0
    while n ~= 0 do
        n = n & (n - 1)
        iCount = iCount + 1
    end
    return iCount
end
print(hammingweight(1))
print(hammingweight(2))
print(hammingweight(4))
print(hammingweight(7))


--- 练习13.5 编写一个函数来测试一个给定整数的二进制表示是否是一个回文数

--- 练习13.6 用lua实现一个bit数组。它应该支持下列操作
--- ● newBitArray(n) (创建一个有n个bit的数组)
--- ● setBit(a ,n ,v) (将boolean值 v 赋值给数组a的n位bit)
--- ● testBit(a ,n ,v) (返回一个n位bit的boolean值v)