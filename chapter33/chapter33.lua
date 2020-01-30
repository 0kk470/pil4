--TODO
function Sleep(n)
    if n > 0 then os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL") end
end

local co = coroutine.wrap(function(x)
    coroutine.yield(1)
    print(x)
    coroutine.yield(2)
    print(x)
    coroutine.yield(3)
    print(x)
    print("coroutine end")
end)
print(1)
print(2)
lproc.start([[
print("c1 receive begin")
lproc.receive("c1")
print("c1 received ,receive c2")
lproc.receive("c2")
print("receive c2 end")
]])
lproc.start([[
print("send c1 begin")
lproc.send("c1")
print("send c1 end, start send c2")
Sleep(3)
lproc.send("c2")
print("c2 sended")
]])
print(3)
io.read()