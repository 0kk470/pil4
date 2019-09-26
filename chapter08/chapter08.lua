---练习8.1 大多数C语法风格的编程语言都不支持elseif结构，为什么Lua比这些语言更需要这种结构?
--其他语言基本都有else if 和 switch 。
--个人认为Lua为了精简语法将else if 和 switch整合到一起形成了elseif。


---练习8.2 描述Lua语言中实现无条件循环的4种不同方法。你更喜欢哪一种?

--1
--while true do  print("loop1") end

--2
-- for i = 1,math.huge do
    -- print("loop2")
-- end

--3
-- ::loop::
-- print("loop3")
-- goto loop

--4
--repeat print("loop4") until false

---练习8.3 很多人认为,由于repeat-until很少使用，因此在像Lua语言这样的简单的语言种最好不要出现，你怎么看？
--略


---练习8.4 正如在6.4节中我们所见到的，尾调用就好像伪装过的goto语句。请使用这种方法重写8.2.5节的迷宫游戏。每个房间此时应该是个新函数，而每个goto语句都变成了一个尾调用。

--注:使用局部函数会有定义顺序的问题
function room1()
    local move = io.read()
    if move == "south" then return room3()
    elseif move == "east" then return room2()
    else
        print("invalid move")
        return room1()
    end
end

function room2()
    local move = io.read()
    if move == "south" then return room4()
    elseif move == "west" then return room1()
    else
        print("invalid move")
        return room2()
    end
end

function room3()
    local move = io.read()
    if move == "north" then return room1()
    elseif move == "east" then return room4()
    else
        print("invalid move")
        return room3()
    end
end

function room4()
    print("Congratulations, you won")
end

--room1()

---练习8.5 请解释一下为什么Lua语言会限制goto语句不能跳出一个函数?(提示:你该怎样正确跳出函数?)
--如果不加以限制
--一方面会破坏结构化设计风格，会导致代码晦涩难懂，降低可读性
--另一方面goto语句及其目标必须位于同一堆栈帧中. goto之前和之后的程序上下文需要相同,否则跳转到的代码将不会在其正确的堆栈帧中运行,并且其行为将是未定义的


---练习8.4 假设goto语句可以跳转出函数，请说明示例8.3中的程序将会如何执行
--例子8.3
function getlabel()
      return function() goto L1 end
    ::L1::
      return 0
end

function f(n)
    if n == 0 then return getlabel()
    else
        local res = f(n - 1)
        print(n)
        return res
    end
end

x = f(10)
x()

--答:就算不能跳出，这段goto代码调用也是不合法的
--   如果可以跳出x = f(10) = f(9) = f(8)  = f(7) = f(6) = f(5) = f(4) = f(3) = f(2) = f(1) = f(0) = 0 , x就不会是一个函数了,调用非法。
