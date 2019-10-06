--- 练习12.1  请编写一个函数，该函数返回指定日期时间后一个月的日期时间(假定日期时间用数字形式表示)
local function getOneMonthLaterTime(iTime)
    local dateTime = os.date("*t",iTime)
    dateTime.month = dateTime.month + 1
    return os.time(dateTime)
end

print(os.date("%Y/%m/%d %H:%M:%S" ,getOneMonthLaterTime( os.time{year = 2019,month = 1,day = 31} ) ) )



--- 练习12.2 请编写一个函数，该函数返回指定日期是星期几(用整数表示,1表示星期天)
local function getWeekday(y,m,d)
    y = y or 1970
    m = m or 1
    d = d or 1
    return tonumber( os.date("%w", os.time({year = y,month = m,day = d}) ) ) + 1
end

print(getWeekday(2019,10,6))



--- 练习12.3 请编写一个函数，该函数的参数为一个date-time(使用数值表示)，返回当天中已经经过的秒数。
local function getElapsedSecond(iTime)
    local thisDay = os.date("*t",iTime)
    return thisDay.hour * 3600 + thisDay.min * 60 + thisDay.sec
end

print(getElapsedSecond(os.time()))



--- 练习12.4 请编写一个函数,该函数的参数为年，返回该年中第一个星期五是第几天
local function getFridayYearDay(year)
    local iTime = os.time{year = year , month = 1,day = 1}
    local dateTime = os.date("*t",iTime)
    while dateTime.wday ~= 6 do
        dateTime.day = dateTime.day + 1
        dateTime = os.date("*t",os.time(dateTime))
    end
    return dateTime.yday
end

print(getFridayYearDay(2018))



--- 练习12.5 请编写一个函数,该函数用于计算两个指定日期之间相差的天数
local function diffday(dateTime1,dateTime2)
    local iDiffTime = os.difftime(os.time(dateTime1),os.time(dateTime2) )
    return math.floor(iDiffTime / 86400)
end

print(diffday(  os.date("*t",os.time()) , {year = 1970,month = 1,day = 1} ))



--- 练习12.6 请编写一个函数,该函数用于计算两个指定日期之间相差的月份
local function diffmonth(dateTime1,dateTime2)
    return 12 * math.abs(dateTime1.year - dateTime2.year) + math.abs(dateTime1.month - dateTime2.month)
end

print(diffmonth(  os.date("*t",os.time()) , {year = 1970,month = 1,day = 1} ))


--- 练习12.7  向指定日期增加一个月再增加一天得到的结果，是否与先增加一天再增加一个月得到的结果一样?
-- 一样
local function test12_7()
    local dateTime1 = os.date("*t",os.time{year = 2019,month = 12,day = 31} )
    dateTime1.month = dateTime1.month + 1
    dateTime1.day = dateTime1.day + 1

    local dateTime2 = os.date("*t",os.time{year = 2019,month = 12,day = 31} )
    dateTime2.day = dateTime2.day + 1
    dateTime2.month = dateTime2.month + 1

    print(os.time(dateTime1) == os.time(dateTime2))

    local dateTime3 = os.date("*t",os.time{year = 2019,month = 2,day = 28} )
    dateTime3.month = dateTime3.month + 1
    dateTime3.day = dateTime3.day + 1

    local dateTime4 = os.date("*t",os.time{year = 2019,month = 2,day = 28} )
    dateTime4.day = dateTime4.day + 1
    dateTime4.month = dateTime4.month + 1

    print(os.time(dateTime3) == os.time(dateTime4))
end
test12_7()

--- 练习12.8 请编写一个函数,该函数用于输出操作系统的时区
local function getTimeZone()
    return os.date("%z")
end

print(getTimeZone())