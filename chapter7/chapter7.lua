---练习7.1 请编写一个程序，该程序读取一个文本文件然后将每行的内容按照字母表顺序排序后重写该文件。
---如果调用时不带参数，则从标准输入读取并向标准输出写入；
---如果调用时传入一个文件名作为参数，则从该文件中读取并向标准输出写入；
---如果调用时传入两个文件名作为参数，则从第一个文件读取并将结果写入第二个文件中
local function SortAndWrite(file1,file2)
   if file1 then
      local str1 = io.input(file1)
   end
end

function createDir(dirname)
   os.execute("mkdir " .. dirname)
end

createDir("chapter7_test")