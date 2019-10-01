--TODO


-- local s = "hello world"

-- local i , j = string.find(s,"hello")

-- print(string.sub(s,i,j))

-- local date = "today is 2019/10/1"

-- print(string.match(date,"%d+/%d+/%d+"))



-- print(string.gsub("i am a silly boy","a","p"))

-- string.find(str,"^d")          --检查字符串s是否以数字开头

-- string.find(str,"^[+-]?%d+$")  --检查字符串是否为一个没有多余前缀字符和后缀字符的整数

-- print(  string.gsub("a (enclosed (in) parenthese) line","%b()","")  )


local s =  "the anthem is the theme"
print( string.gsub(s,"%f[%w]the%f[%W]","one") )