# Lua代码规范
撰写人员|时间|用途
-|:-|:-
kk47|2019-10-29|规范代码，提高开发效率，减少踩坑


## 命名
*  #### 类和文件命名

驼峰式命名，类和文件命名最好一致，单词首字母大写,按照[模块]+[功能]+[基础类型] （Race+Shop+UI = RaceShopUI）

类似如下代码不应出现，一个类名至少要一眼看过去就能了解它的基本功能

```Lua
 
 local MainView = class("MainView", require("UI/GameUI/Base/UIBase"))     --不好的命名
 
 local RaceShopUI = class("RaceShopUI", require("UI/GameUI/Base/UIBase")) --正确的命名
```

*  #### 函数命名 
   * Lua库扩展函数：全部使用小写，不用下划线。如对string的扩展。
   
   ```Lua
 
    function string.insert(s1,i,s2) 
       --body
    end
 
   ```
   * 类成员函数：驼峰式命名 ，大写，且 命名 阐明功能。如
   
   ```Lua
 
    function RaceShopUI:OnBuyBtnClick() 
       --body
    end
 
   ```
    * 局部函数：一般为辅助用的内联函数，小写，命名阐明功能，单词间用__下划线分割。如
   
   ```Lua
    local function is_money_enough(iMoney) 
       --body
    end
    
    function RaceShopUI:OnBuyBtnClick() 
       if is_money_enough(val) then
          --do something
       end
    end
 
   ```
    * 全局函数或工具类函数：一般为通用的逻辑，单词首字母大写，命名阐明功能。如
   
   ```Lua
    function IsNewPlayer() 
    
    end
    
    function DoSomething() 
    
    end
   ```
*  #### 变量命名 
   * 变量命名应尽量表达清楚类型。
   ```Lua
      local is_xxx   --布尔值 比如is_on
      local ixxx     --整数   比如iMaxCount
      local fxxx     --浮点数 比如fDamage
      local xxx_dic  --字典   比如item_dic
      local xxx_list --列表或数组   比如friend_list
      local uixxx    --无符号整型 比如uiType
      local dwxxx    --无符号整型 比如dwTaskID
      local acxxx    --字符数组或者字符串 比如acName
      local str_xxx  --字符串 比如str_name
      local byte_xxx --字节类型
      local co_xxx   --协程
      
      --自定义类型以此类推
   ```
   * 成员变量命名：小写，单词之间用“_”或者大写字母分隔，不可外部访问的私有变量前需要加下划线__。比如
   ```Lua
      function PlayerBag:Init()
         self.__item_dic = {}
	 self.__dwPlayerID = 0
         self.__is_full = false
         self.__callback = nil
      end
   ```
   * 局部变量命名：首字母小写，单词之间用“_”或者大写字母分隔。比如
   ```Lua
      function PlayerBag:GetItemCount(dwItemID)
         local iCount = 0
         local item_data = self.__item_dic and self.__item_dic[dwItemID]
         if item_data then iCount = item_data.iPileCount end
         return iCount
      end
   ```
    * 参数名命名：同局部变量。
    * Unity的组件命名。在名字末尾标识组件类型，提高可读性：
   ```Lua
        
	--滑动列表（ScrollRect）：xxx_scrollrect
	--按钮（Button）：xxx_btn
	--文字（Text）：xxx_txt
	--图片（Image）：xxx_img
	--输入框（InputField）：xxx_input
	--开关（Toggle）：xxx_tgl
	--滑动条组件（Slider）：xxx_slider
	--后续以此类推
   ```

## 2.代码优化
*  #### 多利用局部变量缓存来提高访问速度
   * 在类文件中缓存频繁使用的全局函数。
   ```Lua
      --类文件开始
      local format = string.format
      local floor = math.floorS
      
      --某个成员函数
      function TimeUtil:GetGameStopwatch()
         local iTime = floor(self.__timeSinceStartUp)
         local hour = floor(iTime / 3600)
         local min = floor( (iTime % 3600) / 60 )
         local sec = floor( (iTime % 3600) % 60 )
         return format("%02d:%02d:%02d",hour,min,sec)
      end
   ```
   * 使用局部变量缓存来减小嵌套表访问的开销。比如
   ```Lua
      local playerData = roomlist[1].playerlist[1]
      self.name_txt.text = playerData.acName
      self.score_txt.text = playerData.iScore
      self.icon_img.sprite = getSpriteByName(playerData.kIcon)
   ```
   * 复用局部变量来进行遍历，减小在循环内重复创建的开销。
   ```Lua
      local kCommonInfo = nil
      for k,v in pairs(friend_list) do
         kCommonInfo = v.Data.kCommonInfo
	 --domething
      end
   ```
   * Unity需要频繁访问的对象在Lua这边可以缓存
   ```Lua
      local GameObject = CS.UnityEngine.GameObject
      local go = GameObject("new GameObject")
      go:SetActive(true)
   ```
*  #### 使用table
   * 数组型table
      * 初始化使用列表进行初始化效率更高。
      ```Lua
         local a = {1,2,3}
      ```
      * 尽量减少ipairs泛型迭代器的使用，使用传统for循环。
      ```Lua
         local a = {1,2,3}
         for i = 1,#a do
	 
         end
      ```
       * 末尾插入元素可以用下列代码替代table.insert，效率会好一点。
      ```Lua
         local a = {1,2,3}
         a[#a + 1] = 4
      ```
   * 字典型table
      * 不同类型的变量之间，可以使用;进行分割增强可读性。
      ```Lua
         local tbl = {x=10, y=45; "one", "two", "three"; 1,2,3}
      ```
      * 使用pairs遍历时,key或者value如果没有用到,用_命名来忽略它。
      ```Lua
         for _,vData in pairs(friend_list) do
	    --do something to vData
         end
      ```
      * table.insert、table.pack、table.remove、#符号等不适用于字典型table
      * 避免在循环中使用全局变量
      
*  #### 使用string
   * 字符串是不可修改的常量，任何对字符串的操作都会构造一个新的字符串。
   * 常用的字符串常量用局部变量缓存
   * 字符串的连接
      * 数量少的情况下直接使用 *..* 操作符
      * 很多个情况下使用string.format
      * 大量字符串连接的情况下使用数组table进行连接
      ```Lua
         table.concat(strlist)
      ```
   * 长字符串的表示方法
   ```Lua
   
   --1.使用[[ ]] 括号
   --中间可以加任意数量等号进行匹配 比如‘[=[’ 会和 ‘]=]’匹配
   local b = [===[ 
      <html>
       <head>
         <title>An HTML Page</title>
       </head>
       <body>
         <a href="http://www.lua.org">Lua</a>
       </body>
      </html>
   ]===]
   
   --2.使用\z表示 
   local longstr = "long string long string long string \z
                  long string long string long string long string \z
                  long string long string long string long string long string long string \z
                  long string long string "
   ```
   * Lua5.3支持了utf8字符串操作,使用参见[chapter4](https://github.com/0kk470/pil4/blob/master/chapter04/chapter04.lua)
   
   

*  #### 函数
      * Class.func()和Class:func()调用区别。
      前者类似静态调用后者类似成员函数调用，以下情况两者等价
      
      ```Lua
         local str = "a string"
         local len1 = string.len(str)
         --等价于
         local len2 = str:len()
         
         function string.len(self) 
            print(#self)
         end
         --等价于
         function string:len()
            print(#self)
         end
	 
	 --如果使用了继承，调用基类注意不要使用:。 因为:符号是把调用者作为第一个参数
	 local RaceShopUI = class("RaceShopUI", require("UI/GameUI/Base/BaseWindow"))
	 
	 function RaceShopUI:Show()
             self.super:Show()     --错误的基类函数调用 实际上是self.super.Show(self.super)
             self.super.Show(self) --正确的调用
	 end
      ```
      * 函数尾调用。Lua函数如果return的是一个纯函数调用，那么这种递归不会有栈开销。
      
         (注意必须是纯函数调用，包含函数调用的表达式不是尾调用)
      ```Lua
         local function tailcall(count)
            if count <= 0 then return 0 end
            return tailcall(count - 1)
         end
         tailcall(10000000)
      ```
      * 多参数。一般一个函数的参数不要超过5个，如果参数实在太多考虑使用...可变参数或者把参数放在table中
      ```Lua
        local function add1(...)
            local sum = 0
            for i = 1,select("#",...) do
               sum = sum + select(i,...)
            end
            return sum
        end
	 
        local function add2(tbl)
            local sum = 0
            for i = 1,#tbl do sum = sum + tbl[i] end
            return sum
        end
      ```
      * 函数调用语法糖。如果函数参数只有一个字符串或者是只有一个表构造器，那么可以忽略()括号。
      ```Lua
         print"a message"
	 
         ShowMessageBox{ Type = MESSAGEBOX_COMMON , Message = string.format(Txt_Format3,acName,iNum) }
      ```
      * 函数参数尽量进行非空和类型检测，善用断言。
      ```Lua
        function getSomeData(uiID)
           if not uiID then return end
           -- use uiID to get Data
	end
	
	function loadwithprefix(prefix,code)
           local type_prefix = type(prefix)
           local type_code = type(code)
           assert(type_prefix == "string","invalid prefix:" .. type_prefix)
           assert(type_code == "string" or type_code == "function","invalid code type:" .. type_code)
           local func = nil
           if type(code) == "function" then
               func = code
           else
               local isLoad = false
               func = function()
                   if isLoad then return nil end
                   isLoad = true
                   return code
               end
           end
           local isprefixload = false
           local loader = function()
               if isprefixload then return func() end
               isprefixload = true
               return prefix
           end
           return load(loader,"prefix loader","t")
        end
      ```
## 3.代码格式
*  缩进对齐。IDEA + EmmyLua可以使用自带的格式整理命令:Ctrl + ALT + L
*  body只有一行简单逻辑的控制语句 可以一行写完。比如
```Lua
   if isSuccess then DoSomething() end
   
   for k,v in pairs(tbl) do print(v) end
```

*  符号和变量之间尽量保持一个空格

```Lua
   local v = 1
   func(v1 ,v2 , v3)
```

## 4.其他补充
TODO
