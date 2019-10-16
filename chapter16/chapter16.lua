
 local function f(x,y,z)
     return x + y + z
 end

 local function callback(str)
     print("callback:" .. tostring(str))
     return "i am a error"
 end

 local ret,result = xpcall(f,callback,2,2,nil)
 if ret then
     print(result)
 else
     print("error message:" .. tostring(result))
 end

local function foo(str)
    if type(str) ~= "string" then
        error("string expected",2)
    end
end

 local function test()
     foo({ a = "table"})
 end

 test()

