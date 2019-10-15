--Example
local function serialize(o,indentation)
    indentation = indentation or 0
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q",o))
    elseif t == "table" then
        io.write("\n")
        local space = string.rep(" ",indentation + 2)
        local space2 = string.rep(" ",indentation + 4)
        if indentation > 0 then io.write(space) end
        io.write("{\n")
        for k,v in pairs(o) do
            io.write(space2,k," = ")
            serialize(v,indentation + 2)
            io.write(",\n")
        end
        if indentation > 0 then io.write(space,"}")
        else  io.write("}\n") end
    else
        error("cannot serialize a " .. type(o))
    end
end

local function basicSerialize(o)
    -- number or string
    return string.format("%q",o)
end

local function save(name,value,saved)
    saved = saved or {}
    io.write(name," = ")
    if type(value) == "number" or type(value) == "string" then
        io.write(basicSerialize(value),"\n")
    elseif type(value) == "table" then
        if saved[value] then
            io.write(saved[value],"\n")
        else
            saved[value] = name
            io.write("{}\n")
            for k,v in pairs(value) do
                k = basicSerialize(k)
                local fname = string.format("%s[%s]",name,k)
                save(fname,v,saved)
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end


local testTable = {
    a = 1,
    b = "str",
    c = {
        d = 1,
        e = true,
        f = {},
    }
}

io.input("data.txt","w")
io.output("data.txt")
serialize(testTable)