---9.4 Example
local function disk(cx,cy,r)
   return function(x , y)
      return ( x - cx) ^ 2 + (y - cy) ^ 2 <= r ^ 2
   end
end

local function rect(left,right,bottom,up)
   return function(x,y)
      return left <= x and x <= right and bottom <= y and y <= up
   end
end

local function union(r1,r2)
   return function(x , y)
       return r1(x,y) or r2(x,y)
   end
end

local function intersection(r1,r2)
   return function(x , y)
      return r1(x,y) and r2(x,y)
   end
end

local function difference(r1,r2)
   return function(x , y)
      return r1(x,y) and not r2(x,y)
   end
end

local function translate(r,dx,dy)
   return function(x , y)
      return r(x - dx,y - dy)
   end
end

local function plot(r,N ,M)
   io.write("P1\n",M ," ",N,"\n")
   for i = 1 , N do
      local y = ( N - i * 2) / N
      for j = 1, M do
         local x = (j * 2 - M) / M
         io.write(r(x,y) and "1" or "0")
      end
      io.write("\n")
   end
end

--local c1 = disk(0 ,0,1)
--plot(difference(c1,translate(c1,0.3,0)) , 100 ,100) --500 is too long for windows console

---练习9.1 请编写一个函数integral ,该函数以一个函数 f 为参数并返回其积分的近似值。
local function integral(f , x1,x2,delta)
   delta = delta or 1e-4
   local result = 0
   for v = x1,x2,delta do
      result = result + f(v) * delta
   end
   return result
end

local function f1(x)
   return -x + 1
end

--[[
   |
   | ·
   |    ·
   |       ·
   |__________·_______   y = -x + 1
]]
print(integral(f1,0,1))

---练习9.2 请问如下的代码段将输出怎样的结果?
local function F(x)
   return {
      set = function(y) x = y end,
      get = function() return x end
   }
end

local o1 = F(10)
local o2 = F(20)
print(o1.get(),o2.get())
o2.set(100)
o1.set(300)
print(o1.get(),o2.get())

---练习9.3
---练习5.3要求我们编写一个以多项式 a 以及值 x 为参数，返回结果为对应多项式值的函数。
---请编写该函数的柯里化版本，该版本的函数应该以一个多项式为参数并返回另一个函数。
local function newpoly(a)
   return function(x)
      local result = 0
      for i = 1,#a do
         result = result + a[i] * x ^ (i - 1)
      end
      return result
   end
end

local func = newpoly({3,0,1})
print(func(0))
print(func(5))
print(func(10))

---练习9.4 使用几何区域系统的例子，绘制一个北半球所能看到的娥眉月。
local c2 = disk(0 ,0,1)
plot(difference(c2,translate(c2,-0.3,0)) , 100 ,100)


---练习9.5 在几何区域系统的例子中，增加一个函数来将指定的区域旋转指定的角度。
local function rotate(r,angle)
   return function(x , y)
      local rad = math.rad(angle)
      return r(x * math.cos(rad) - y * math.sin(rad),x * math.sin(rad) + y * math.cos(rad))
   end
end
local square = rect(-1,1,-1,1)
plot( difference( square,rotate(square,45) ),100,100)