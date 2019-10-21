--TODO
---练习18.1
---练习18.2
local function fromto(n,m,step)
    step = step or 1
    assert(type(step) == "number","invalid arg 'step'")
    assert(type(n) == "number","invalid arg  'n'")
    assert(type(m) == "number","invalid arg  'm'")
    n = n - step
    return function()
        n = n + step
        if n > m then return nil end
        return n
    end
end
--for i in fromto(1,5,2) do
--    print(i)
--end
--for i in fromto(1,-1) do
--    print(i)
--end
--for i in fromto(1,2.2,0.2) do
--    print(i)
--end
--for i in fromto(1,2,"4") do
--    print(i)
--end
--for i in fromto(1,3,{}) do
--    print(i)
--end