local iChapterNum = 33
local tChapterName =
{
	"Getting Started",
	"Interlude: The Eight-Queen Puzzle",
	"Numbers",
	"Strings",
	"Tables",
	"Functions",
	"The External World",
	"Filling Some Gaps",
	"Closures",
	"Pattern Matching",
	"Interlude: Most Frequent Words",
	"Date and Time",
	"Bits and Bytes",
	"Data Structures",
	"Data Files and Serialization (FIXME)",
	"Compilation, Execution, and Errors",
	"Modules and Packages",
	"Iterators and the Generic for",
	"Interlude: Markov Chain Algorithm",
	"Metatables and Metamethods",
	"Object-Oriented Programming",
	"The Environment",
	"Garbage",
	"Coroutines (TODO)",
	"Reflection (TODO)",
	"Interlude: Multithreading with Coroutines (TODO)",
	"An Overview of the C API",
	"Extending Your Application",
	"Calling C from Lua",
	"Techniques for Writing C Functions",
	"User-Defined Types in C",
	"Managing Resources",
	"Threads and States",
}
local function file_exists(name)
    local f = io.open(name, "r")
    if f then
        io.close(f)
        return true
    end
    return false
end

local function createLua(filename)
    os.execute("mkdir " .. filename)
    local path = string.format("%s/%s.lua", filename, filename)
    if file_exists(path) then
        print("Existed file")
        return
    end
    local file = io.output(path)
    if file then
        print("success")
        file:write("--TODO")
        file:close()
    end
end

for i = 1, iChapterNum do
    createLua(string.format("chapter%02d", i))
end

local function updateReadMe()
    local f = io.open("README.md", 'w')
    local fmtText = "+ [Chapter%02d : %s](https://github.com/0kk470/Lua-4th/blob/master/chapter%02d/chapter%02d.lua)"
	local fmtText_capi = "+ [Chapter%02d : %s](https://github.com/0kk470/Lua-4th/blob/master/chapter%02d)"
    if f then
        print("update readme " .. tostring(f))
        f:write("# Lua-4th\n\nLua程序设计第四版习题答案(Pil4 Exercise Solutions) ", "\n", "\n")
        f:write("## Part I. Basics", "\n")
        for i = 1, iChapterNum do
            f:write(string.format(i >= 27 and fmtText_capi or fmtText, i,tChapterName[i], i, i), "\n", "\n")
            if i == 8 then
                f:write("## Part II. Real Programming", "\n")
            elseif i == 17 then
                f:write("## Part III. Lua-isms", "\n")
            elseif i == 26 then
                f:write("## Part IV. C API", "\n")
            end
        end
		f:write("### Others","\n")
		f:write("+ [compile lua via visual studio](https://github.com/0kk470/lua-on-visual-studio)")
        f:flush()
        return true
    end
    return false
end
updateReadMe()
os.exit()