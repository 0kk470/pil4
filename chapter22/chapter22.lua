---练习22.1 本章开始时定义的函数getfield，由于可以接收像math?sun或string!!!gsub这样的字段而不够严谨。
---请将其重写，使得该函数只能支持 . 作为名称分隔符。
t = {x = {y = 10}}
function getfield(f)
    local v = _G
    for w in string.gmatch(f,"([%a_][%w_]*)%.") do
        if type(v[w]) ~= "table" then
            error("invalid field " .. w)
        else
            print(w)
            v = v[w]
        end
    end
    local last = string.match(f, "%.?([%a_][%w_]*)$")
    if last then
        v = v[last]
    end
    return v
end

 print(getfield("t.x.y"))
 print(getfield("t???x???y"))


---练习22.2 请详细解释下列程序做了什么，以及输出的结果是什么
--声明一个foo局部变量
local foo

--do end 构造了一个沙盒环境
do
    --将_ENV指向的全局环境表赋值给一个临时变量_ENV
    local _ENV = _ENV
    --foo赋值一个函数用来打印_ENV.X 此时_ENV指向的就是全局表
    function foo() print(X) end
end

--将_ENV.X值设为13
X = 13
--将当前作用域的_ENV全局表引用阻断掉
_ENV = nil
--调用foo 因为foo处于另一个沙盒环境 所以能访问到_ENV.X 并打印13
foo()
--当前作用域的_ENV为nil 所以对这个X的访问会出错 _ENV报nil访问错误
X = 0


---练习22.3 请详细解释下列程序做了什么，以及输出的结果是什么
--将print的引用保存下来 避免构造沙盒环境时访问不到函数print
local print = print

--定义一个传入沙盒环境表的全局函数并打印 a + _ENV.b的值
function foo2(_ENV,a)
    print(a + b)
end

--构造一个全局变量b = 14的函数调用环境 输出 26
foo2({b = 14},12)
--构造一个全局变量b = 10的函数调用环境 输出 11
foo2({b = 10},1)