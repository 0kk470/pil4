local function new()
    return {first = 0,last = 0}
end

local function pushFirst(list,value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

local function pushLast(list,value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

local function popFirst(list)
    local first = list.first
    if first == list.last then return nil end
    local value = list[first]
    list[first] = nil
    list.first = first + 1
    if list.last == list.first then
        list.last = 0
        list.first = 0
    end
    return value
end

local function popLast(list)
    local last = list.last
    if last == list.first then return nil end
    local value = list[last]
    list[last] = nil
    list.last = last - 1
    if list.last == list.first then
        list.last = 0
        list.first = 0
    end
    return value
end

return {
    new = new,
    pushFirst = pushFirst,
    pushLast = pushLast,
    popFirst = popFirst,
    popLast = popLast,
}