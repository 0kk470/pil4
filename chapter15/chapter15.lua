--- 练习15.1 || 练习15.2 ||  练习15.3 || 练习15.4

local function isIdentifier(i)
   return string.match(i, "^[a-zA-Z_][a-zA-Z0-9_]*") == i
end

local function serialize(o,indentation)
    indentation = indentation or 0
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q",o))
    elseif t == "table" then
        io.write("\n")
        local space = string.rep(" ",indentation + 2)
        local space2 = string.rep(" ",indentation + 4)
        local saved = {}
        if indentation > 0 then io.write(space) end
        io.write("{\n")
        for i = 1,#o  do
            io.write(space2)
            serialize(o[i],indentation + 2)
            io.write(",\n")
            saved[i] = true
        end
        for k,v in pairs(o) do
            if not saved[k] then
                local key = isIdentifier(k) and k or string.format('[%q]',k)
                io.write(space2,key," = ")
                serialize(v,indentation + 2)
                io.write(",\n")
            end
        end
        if indentation > 0 then io.write(space,"}")
        else  io.write("}\n") end
    else
        error("cannot serialize a " .. type(o))
    end
end

local testTable = {
    a = 1,
    b = "str",
    c =
    {
        d = 1,
        e = true,
        f = {},
    },
    g = {1,2,3},
    "a",
    "b",
    "c",
    {7,8,9},
    ["#"] = "identifier",
}
--io.input("data.txt","w")
--io.output("data.txt")
--serialize(testTable)


local function basicSerialize(o)
    -- number or string
    return string.format("%q",o)
end

local function save(name,value,saved,indentation,isArray)
    indentation = indentation or 0
    saved = saved or {}
    local t = type(value)
    local space = string.rep(" ",indentation + 2)
    local space2 = string.rep(" ",indentation + 4)
    if not isArray then io.write(name," = ") end
    if t == "number" or t == "string"  or t == "boolean" or t == "nil" then
        io.write(basicSerialize(value),"\n")
    elseif t == "table" then
        if saved[value] then
            io.write(saved[value],"\n")
        else
            if #value > 0 then
                if indentation > 0 then io.write(space) end
                io.write("{\n")
            end
			local indexes = {}
            for i = 1,#value do
                if type(value[i]) ~= "table" then
                    io.write(space2)
                    io.write(basicSerialize(value[i]))
                else
                    local fname = string.format("%s[%s]",name,i)
                    save(fname,value[i],saved,indentation + 2,true)
                end
                io.write(",\n")
                indexes[i] = true
            end
            if #value > 0 then
                if indentation > 0 then io.write(space) end
                io.write("}\n")
            else
                io.write("{}\n")
            end
            saved[value] = name
            for k,v in pairs(value) do
                if not indexes[k] then
                    k = basicSerialize(k)
                    local fname = string.format("%s[%s]",name,k)
                    save(fname,v,saved,indentation + 2)
                    io.write("\n")
                end
            end
        end
    else
        error("cannot save a " .. t)
    end
end

local a = { 1,2,3, {"one","Two"} ,5, {4,b = 4,5,6} ,a = "ddd"}
local b = { k = a[4]}
local t = {}
save("a",a,t)
save("b",b,t)
print()