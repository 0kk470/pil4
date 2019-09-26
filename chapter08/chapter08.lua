--TODO

--for i = 1,100 do
--    if i % 2 == 0 then
--        goto continue
--    end
--    print(i)
--    ::continue::
--end

::s1:: do
    local c = io.read(1)
    if c == '0' then goto s2
    elseif c == nil then print('ok');return
    else goto s1
    end
end

::s2:: do
    local c = io.read(1)
    if c == '0' then goto s1
    elseif c == nil then print 'not ok' ;return
    else goto s2
    end
end

goto s1