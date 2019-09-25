local iChapterNum = 33

local function file_exists(name)
   local f = io.open(name,"r")
   if f then
      io.close(f)
	  return true
   end
   return false
end

local function createLua(filename)
   os.execute("mkdir " .. filename)
   local path = string.format("%s/%s.lua",filename,filename)
   if file_exists(path) then
      print("Existed file")
      return
   end
   local file = io.output(path)
   if file then
      print("success")
      file:write("--TODO")
   end
end

for i = 1,iChapterNum do
   createLua(string.format("chapter%02d",i))
end


local function updateReadMe()
   local f = io.open("README.md","w")
   local fmtText = "[chapter%02d](https://github.com/0kk470/Lua-4th/blob/master/chapter%02d/chapter%02d.lua)"
   if f then
      f:write("# Lua-4th\n\nLua程序设计第四版习题答案","\n","\n")
      for i = 1,iChapterNum do
         f:write(string.format(fmtText,i,i,i),"\n","\n")
      end
	  return true
   end
   return false
end
updateReadMe()