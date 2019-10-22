print("please Input N (size for the sequence of previous words):")
local N = tonumber(io.read())
while math.type(N) ~= "integer" do
    print("Invalid type, ReInput N:")
    N = tonumber(io.read())
end

function allwords ()
    local line = io.read() -- current line
    local pos = 1 -- current position in the line
    return function()
        -- iterator function
        while line and line ~= "" do
            -- repeat while there are lines
            local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
            if w then
                -- found a word?
                pos = e -- update next position
                return w -- return the word
            else
                line = io.read() -- word not found; try next line
                pos = 1 -- restart from first position
            end
        end
        return nil -- no more lines: end of traversal
    end
end

function prefix (words)
    return table.concat(words," ")
end

local statetab = {}

function insert (prefix, value)
    local list = statetab[prefix]
    if list == nil then
        statetab[prefix] = { value }
    else
        list[#list + 1] = value
    end
end

local MAXGEN = 200
local NOWORD = "\n"

-- build table
local wordTable = {}
for i = 1,N do
    wordTable[N] = NOWORD
end
print("\nPlease Input the words:")
for nextword in allwords() do
    insert(prefix(wordTable), nextword)
    for i = 1,#wordTable do
        wordTable[i] = wordTable[i + 1]
    end
    wordTable[N] = nextword
end
insert(prefix(wordTable), NOWORD)

-- generate text
for i = 1,N do
    wordTable[N] = NOWORD
end
for i = 1, MAXGEN do
    local list = statetab[prefix(wordTable)]
    -- choose a random item from list
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then
        return
    end
    io.write(nextword, " ")
    for i = 1,#wordTable do
        wordTable[i] = wordTable[i + 1]
    end
     wordTable[N] = nextword
end