--[[
========================
  扩展时间操作模块
========================
  time.epoch()                  获取当前的 epoch 时间
  time.totime(s,f)              将字符串 s 根据格式 f 转换为时间元表
  time.totime(s,f)              将字符串 s 根据格式 f 转换为 epoch 时间
                                f 格式：%b = 月份缩写
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
  time.date(F)                  以格式 F 显示当前时间
                                F 格式：h               时（0 ~ 23 或 1 ~ 12 上/下午）
                                        hh              2位数时（00 ~ 23 或 01 ~ 12 上/下午）
                                        H               时（0 ~ 23）
                                        HH              2位数时（00 ~ 23）
                                        m               分（0 ~ 59）
                                        mm              2位数分（00 ~ 59）
                                        s               秒（0 ~ 59）
                                        ss              2位数秒（00 ~ 59）
                                        z               毫秒（0 ~ 999）
                                        zzz             3位数毫秒（000 ~ 999）
                                        AP 或 A         使用 AM/PM 区别上/下午
                                        ap 或 a         使用 am/pm 区别上/下午
                                        
                                        d               日（1 ~ 31）
                                        dd              2位数日（01 ~ 31）
                                        ddd             星期缩写（如 Mon ~ Sun）
                                        dddd            星期全名（如 Monday ~ Sunday）
                                        M               月（1 ~ 12）
                                        MM              2位数月（01 ~ 12）
                                        MMM             月份缩写（如 Jan ~ Dec）
                                        MMMM            月份全名（如 January ~ December）
                                        yy              2位数年（00 ~ 99）
                                        yyyy            4位数年
--]]

time = time or {}

function time.epoch()
    return getEpoch() * 1000
end

function time.totime(s, f)
    return datetime:parse(s, f)
end

function time.toepoch(s, f)
    return datetime:parse(s, f, true) * 1000
end

function time.date(F)
    return getTime(true, F)
end