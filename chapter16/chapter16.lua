
--- 练习16.1
 local function loadwithprefix(prefix,code)
     local type_prefix = type(prefix)
     local type_code = type(code)
     assert(type_prefix == "string","invalid prefix:" .. type_prefix)
     assert(type_code == "string" or type_code == "function","invalid code type:" .. type_code)
     local func = nil
     if type(code) == "function" then
         func = code
     else
         local isLoad = false
         func = function()
             if isLoad then return nil end
             isLoad = true
             return code
         end
     end
     local isprefixload = false
     local loader = function()
         if isprefixload then return func() end
         isprefixload = true
         return prefix
     end
     return load(loader,"prefix loader","t")
 end

 local f1 = loadwithprefix("return ","1 + 1")
 print(f1())
 local count = 0
 local iter = function ()
     while count < 5 do
         count = count + 1
         return count
     end
 end
 local f2 = loadwithprefix("return ",iter)
 --print(f2())



--- 练习16.2
local function multiload(...)
    local args = {...}
    for i = 1,#args do
        assert(type(args[i]) == "string" or type(args[i]) == "function","invalid type for loader")
        if type(args[i]) == "string" then
            local code = args[i]
            local isLoad = false
            args[i] = function()
                if isLoad then return nil end
                isLoad = true
                return code
            end
        end
    end
    local idx = 1
    local loader = function()
        while args[idx] do
            local code = args[idx]()
            if not code then
                idx = idx + 1
            else
                return code
            end
        end
    end
    return load(loader,"prefix loader","t")
end
--local f3,err = multiload("local x = 1"," x = x + 100","print(x)")
--local f4,err = multiload("local x = 1"," x = x + 100",io.read())
--f3()
--f4()



--- 练习16.3
local function stringrep(s,n)
    local r = ""
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then r = r .. s end
            s = s .. s
            n = math.floor(n / 2)
        end
        r = r .. s
    end
end

local cmd1,cmd2 = "r = r .. s ","s = s..s "
local function stringrep_factory(n)
    local result = { "local args={...} " , " local r='' " , " local s = args[1] "}
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then result[#result + 1] = cmd1 end
            result[#result + 1] = cmd2
            n = math.floor(n / 2)
        end
        result[#result + 1] = cmd1
    end
    result[#result + 1] = "return r"
    return load(table.concat(result),"stringrep_n")
end

local function test16_3()
    local n = 1000000
    local stringrep_n = stringrep_factory(n)
    local startTime = os.clock()
    stringrep("a",n)
    print("stringrep cost:" .. os.clock() - startTime .. "s")

    startTime = os.clock()
    stringrep_n("a")
    print("stringrep_n cost:" .. os.clock() - startTime .. "s")
end

--local ff,err = stringrep_factory(5)
--print(ff("a"))
--test16_3()


--- 练习16.4
--似乎Lua的函数直接return返回值不是nil  但是在赋值 和 比较时会被调整成nil
--参见 stackoverflow.com/questions/39113323/how-do-i-find-an-f-that-makes-pcallpcall-f-return-false-in-lua
local function pcall_test()
    local f = function()
        return
    end
    local val = f()
    print(f())     -- no value
    print(val)     --nil
    print(nil) --nil
    print(f() == nil) --true
    local isOk = pcall(pcall,f()) -- false
    local isOk2 = pcall(pcall,(f()) ) -- true
    print(isOk)
    print(isOk2)
end
pcall_test()