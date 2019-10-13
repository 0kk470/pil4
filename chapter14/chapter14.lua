---练习14.1: 请编写一个函数，该函数用于两个稀疏矩阵相加。
local function printMatrix(matrix)
    for i = 1,#matrix do
        print(table.concat(matrix[i]," "),"\n")
    end
end

local function addition(a,b)
    assert(type(a) == "table")
    assert(type(a) == "table")
    assert(#a == #b,"a and b are not the same dimension!")
    local c = {}
    for i = 1,#a do
        c[i] = {}
        for j,va in pairs(a[i]) do
            c[i][j] = va  + (b[i][j] or 0)
        end
        for k,vb in pairs(b[i]) do
            c[i][k] = vb  + (a[i][k] or 0)
        end
    end
    return c
end

local a = {{0,0,2},
           {0 ,0,3}}

local b = {{0,0,0},
           {-1,nil,-3}}
printMatrix(addition(a,b))



---练习14.2 改写示例14.2中队列的实现，使得当队列为空时两个索引都返回0
local queue = {}
function queue.new()
    return {first = 0,last = 0}
end

function queue.pushFirst(list,value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function queue.pushLast(list,value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function queue.popFirst(list)
    local first = list.first
    if first == list.last then return nil end
    local value = list[first]
    list[first] = nil
    list.first = first + 1
    if list.last == list.first then
        list.last = 0
        list.first = 0
    end
    return value
end

function queue.popLast(list)
    local last = list.last
    if last == list.first then return nil end
    local value = list[last]
    list[last] = nil
    list.last = last - 1
    if list.last == list.first then
        list.last = 0
        list.first = 0
    end
    return value
end



---练习14.3
---修改图所用的数据结构，使得图可以保存每条边的标签。该数据结构应该使用包括两个字段的对象来表示每一条边，即边的标签和边指向的节点。
---与邻接集合不同，每一个节点保存的是当从前结点出发的边的集合。
---修改函数readgraph，使得该函数从输入文件中按行读取，每行由两个节点名称外加边的标签组成（假设标签是一个数字）。
local function name2node(graph ,name)
    local node = graph[name]
    if not node then
        node = { name = name ,adj = {}}
        graph[name] = node
    end
    return node
end

local function readgraph(filename)
    local graph = {}
    for line in io.lines(filename) do
        local namefrom , nameto,distance = string.match(line,"(%S+)%s+(%S+)%s+(%d+)")
        local from = name2node(graph,namefrom)
        local to = name2node(graph,nameto)
        from.adj[to] = distance
    end
    return graph
end

local function findpath(curr,to,path,visited)
    path = path or {}
    visited = visited or {}
    if visited[curr] then return nil end
    visited[curr] = true
    path[#path + 1] = curr
    if curr == to then return path end

    for node in pairs(curr.adj) do
        local p = findpath(node,to,path,visited)
        if p then return p end
    end
    table.remove(path)
end

local function printpath(path)
    for i = 1,#path do print(path[i].name) end
end



---练习14.4 假设图使用上一个练习的表示方式，其中边的标签代表两个终端节点之间的距离。
---请编写一个函数，使用Dijkstra算法寻找两个指定节点之间的最短路径。

function table.size(t)
    local count = 0
    for k,v in pairs(t) do
        count = count + 1
    end
    return count
end

local function dijkstra(graph,startName,endName)
    local distance = {}
    local visited = {}
    local prev = {}
    for k,node in pairs(graph) do
        distance[node] = math.maxinteger
    end
    local startNode = name2node(graph,startName)
    local endNode = name2node(graph,endName)
    local curr = startNode
    distance[startNode] = 0
    while curr ~= endNode do
        for to,vdis in pairs(curr.adj) do
            if not visited[to] then
                if distance[to] > distance[curr] + vdis then
                    distance[to] = distance[curr] + vdis
                    prev[to] = curr
                end
            end
        end
        visited[curr] = true
        local nextNode = endNode
        for name,node in pairs(graph) do
            if not visited[node] then
                if not nextNode then
                    nextNode = node
                else
                    if distance[node] < distance[nextNode] then
                        nextNode = node
                    end
                end
            end
        end
        curr = nextNode
    end
    local traceback = {}
    curr = endNode
    while curr ~= startNode do
        traceback[#traceback + 1] = curr
        curr = prev[curr]
    end
    traceback[#traceback + 1] = startNode
    return traceback
end

local function printShortestPath(traceback)
    for i = #traceback,1,-1 do
        local cur = traceback[i]
        local next  = traceback[i - 1]
        if next then
            io.write(cur.name,"-[",cur.adj[next],"]-")
        else
            io.write(cur.name)
        end
    end
    print()
end

printShortestPath( dijkstra( readgraph("graph.txt"),"a","e" ) )