---Exercise 15.1: Modify the code in Figure 15.2, “Serializing tables without cycles” so that it indents nested tables.
---(Hint: add an extra parameter to serialize with the indentation string.)

---Exercise 15.2: Modify the code of the previous exercise so that it uses the syntax ["key"]=value, as suggested in the section called “Saving tables without cycles”.

---Exercise 15.3: Modify the code of the previous exercise so that it uses the syntax ["key"]=value only when necessary
---(that is, when the key is a string but not a valid identifier).

---Exercise 15.4: Modify the code of the previous exercise so that it uses the constructor syntax for lists whenever possible. 
---For instance, it should serialize the table {14, 15, 19} as {14, 15, 19}, not as {[1] = 14, [2] = 15, [3] = 19}.
---(Hint: start by saving the values of the keys 1, 2, ..., as long as they are not nil. Take care not to save them again when traversing the rest of the table.)

local function isIdentifier(i)
    return string.match(i, "^[a-zA-Z_][a-zA-Z0-9_]*") == i
end

local function make_indentation(space_num)
    assert(math.type(space_num), "invalid type for 'space_num'")
    assert(space_num > 0, "'space_num' should be larger than 0")
    return string.rep(" ", space_num)
end

local function table_len(t)
    assert(type(t) == "table", "'t' must be a table")
    local cnt = 0
    for _,v in pairs(t) do cnt = cnt + 1 end
    return cnt
end

local function serialize(o,indentation)
    indentation = indentation or 0
    local _type = type(o)
    if _type == "number" or _type == "string" or _type == "boolean" or _type == "nil" then
        io.write(string.format("%q",o))
    elseif _type == "table" then
        local is_table_empty = table_len(o) == 0

        if not is_table_empty then 
            io.write("\n") 
        end
        if not is_table_empty and indentation > 0 then 
            io.write(make_indentation(indentation + 2)) 
        end

        io.write("{")

        if not is_table_empty then
            io.write("\n")
        end

        local arrayElements = {}
        for i = 1,#o  do
            io.write(make_indentation(indentation + 4))
            serialize(o[i],indentation + 2)
            io.write(",\n")
            arrayElements[i] = true
        end

        for k,v in pairs(o) do
            if not arrayElements[k] then
                local key = isIdentifier(k) and k or string.format('[%q]',k)
                io.write(make_indentation(indentation + 4),key," = ")
                serialize(v,indentation + 2)
                io.write(",\n")
            end
        end
        if not is_table_empty and indentation > 0 then 
            io.write(make_indentation(indentation + 2),"}")
        else  
            io.write("}") end
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
local f = io.output("data.txt")
serialize(testTable)
f:flush()


---Exercise 15.5: The approach of avoiding constructors when saving tables with cycles is too radical. It is
---possible to save the table in a more pleasant format using constructors for the simple case, and to use
---assignments later only to fix sharing and loops. Reimplement the function save (Figure 15.3, “Saving
---tables with cycles”) using this approach. Add to it all the goodies that you have implemented in the previous
---exercises (indentation, record syntax, and list syntax).

--TODO  incorrect code
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

--local a = { 1,2,3, {"one","Two"} ,5, {4,b = 4,5,6} ,a = "ddd"}
--local b = { k = a[4]}
--local t = {}
--save("a",a,t)
--save("b",b,t)
--print()