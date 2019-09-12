local s1 = 
[=[ 
<![CDATA[
   Hello world
]]>
]=]
local s2 = "<![CDATA[\n   Hello world\n]]>"
print(s1)
print(s2)

function string.insert(s1,pos,s2)
    if not s1 then
        error("the argument#1 is nil!")
    end
    if not s2 then
        return s1
    end
	pos = pos or 1
	local len = string.len(s1)
	if pos <= 1 then
	   return s2..s1
	elseif pos >= len + 1 then
	   return s1..s2
	end
    local pre,suf = string.sub(s1,1,pos - 1),string.sub(s1,pos,len)
    return pre..s2..suf
end

function string.utf8insert(s1,pos,s2)
    if not s1 then
        error("the argument#1 is nil!")
    end
    if not s2 then
        return s1
    end
	pos = pos or 1
	local utf8len = utf8.len(s1)
	local len = string.len(s1)
	if pos <= 1 then
	   return s2..s1
	elseif pos >= utf8len + 1 then
	   return s1..s2
	end
	local m = utf8.offset(s1,pos)
    local pre,suf = string.sub(s1,1,m - 1),string.sub(s1,m,len)
    return pre..s2..suf
end


print(string.insert("hello world",1,"start: "))
print(string.insert("hello world",7,"small "))

	local s1 = "dadadad我程序"
	local s2 = "abcg"
	local s3 = "我程序"
	local test1 = "是一个"
	local test2 = "def"
	local test3 = "ddd哈哈"
	-- print(  string.utf8insert(s1,9,test1) )
	-- print(  string.utf8insert(s1,9,test2) )
	-- print(  string.utf8insert(s1,9,test3) )
	-- print(  string.utf8insert(s2,4,test1) )
	-- print(  string.utf8insert(s2,4,test2) )
	-- print(  string.utf8insert(s3,4,test3) )
	-- print(  string.utf8insert(s3,1,test1) )
	-- print(  string.utf8insert(s3,2,test2) )
	-- print(  string.utf8insert(s3,3,test3) )

	
function string.utf8remove(s1,pos,num)
    if not s1 then
        error("the argument#1 is nil!")
    end
    local utf8len = utf8.len(s1)
    local len = string.len(s1)
    pos = pos or 1
    num = num or utf8len
    if pos <= 1 then
        pos = 1
    elseif pos >= utf8len + 1 then
        return s1
    end
	if num <= 0 then
	    return s1
	end
    local m1 =  utf8.offset(s1,pos)
    local m2 =  utf8.offset(s1, math.min(pos + num,utf8len + 1) )
    local pre,suf = string.sub(s1,1 ,m1 - 1) ,  string.sub(s1, m2 , len)
    return pre..suf
end	

	print(  string.utf8remove(s1,2,6) )
	print(  string.utf8remove(s1) )
	print(  string.utf8remove(s2) )
	print(  string.utf8remove(s3,1) )
	print(  string.utf8remove(s3,-1,2) )
	print(  string.utf8remove(s1,4,1) )
	print(  string.utf8remove(s1,2,6) )
	print(  string.utf8remove(s1,2,-1) )
	