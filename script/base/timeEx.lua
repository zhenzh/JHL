--[[
========================
  扩展时间操作模块
========================
  time.epoch()                  获取当前的 epoch 秒数
  time.date(f)                  以格式 f 显示当前时间
  time.toepoch(s, p)            将字符串 s 根据正则 p 转换为 epoch 秒数
  time.totime(s, p)             将字符串 s 根据正则 p 转换为时间元表
  time.todate(e, f)             将 epoch 秒数 e 根据格式 f 转换为时间
  time.tohms(e, m)              将 epoch 秒数 e 以时分秒的单位显示，m 为 true 则显示微秒数

    f 格式： %b = 月份缩写
            %B = 月份全名
            %d = 日
            %H = 时（24小时制）
            %I = 时（12小时制，需要与 %p 一起使用）
            %p = 上下午
            %m = 2位数月（01 ~ 12）
            %M = 2位数分（00 ~ 59）
            %S = 2位数秒（00 ~ 59）
            %y = 2位数年（00 ~ 99，缺省 2000 ~ 2099）
            %Y = 4位数年
  
--]]

time = time or {}

function time.epoch()
    return os.time() * 1000
end

function time.date(f)
    if f == nil then
        return nil
    end
    return os.date(f)
end

function time.totime(s, p)
    local year,month,day,hour,min,sec = string.match(tostring(s), p)
    return {
        year = (tonumber(year or 1970)),
        month = (tonumber(month or 1)),
        day = (tonumber(day or 1)),
        hour = (tonumber(hour or 0)),
        min = (tonumber(min or 0)),
        sec = (tonumber(sec or 0))
    }
end

function time.toepoch(s, p)
    return os.time(time.totime(s, p))*1000
end

function time.todate(e, f)
    return os.date(f, e/1000)
end

function time.tohms(e, m)
    local t = os.date("!*t", e/1000)
    if m == nil then
        return string.format("%02d:%02d:%02d", (t.yday-1)*24+t.hour, t.min, t.sec)
    else
        return string.format("%02d:%02d:%02d.%03d", (t.yday-1)*24+t.hour, t.min, t.sec, e%1000)
    end
end