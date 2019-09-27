local N = 8
local count = 0
local function isplaceok(a,n,c)
    count = count + 1
    for i = 1,n - 1 do
        if a[i] == c or
           a[i] - i == c - n or
           a[i] + i == c + n then
            return false
        end
    end
    return true
end

local function printsolution(a)
    for i = 1, N do
        for j = 1, N do
            io.write(a[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
    print()
end

local function addqueen(a,n)
    if n > N then
        printsolution(a)
    else
        for c = 1,N do
            if isplaceok(a,n,c) then
                a[n] = c
                addqueen(a,n + 1)
            end
        end
    end
end

addqueen({},1)
local iCount1 = count

---练习2.1 修改八皇后问题的程序，使其在输出第一个解后即停止运行。
local function addqueen2(a,n)
    if n > N then
        printsolution(a)
        os.exit()
    else
        for c = 1,N do
            if isplaceok(a,n,c) then
                a[n] = c
                addqueen2(a,n + 1)
            end
        end
    end
end
--addqueen2({},1)


---练习2.2 解决八皇后问题的另一种方式是，先生成 1-8 之间的所有排列，然后依此遍历这些排列，检查每一个排列是否是问题的有效解。
---请使用这种方法编写程序，并对比新旧程序之间的性能差异(提示: 比较调用isplaceok 函数的次数)
local q = {}
local function slowEightQueen()
    count = 0
    for a = 1 , N do
        q[1] = a
        for b = 1,N do
            q[2] = b
            for c = 1,N do
                q[3] = c
                for d = 1,N do
                    q[4] = d
                    for e = 1,N do
                        q[5] = e
                        for f = 1,N do
                            q[6] = f
                            for g = 1,N do
                                q[7] = g
                                for h = 1,N do
                                    q[8] = h
                                    local isOk = false
                                    for row = 2,N do
                                        isOk  = isplaceok(q,row,q[row])
                                        if not isOk then
                                            break
                                        end
                                    end
                                    if isOk then
                                        printsolution(q)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

slowEightQueen()

local iCount2 = count
print("addqueen isplaceok Count:"..iCount1)
print("slowEightQueen isplaceok Count:"..iCount2)