
---练习16.1
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
 print(f2())

local function multiload(...)

end