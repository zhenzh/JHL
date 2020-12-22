function statistics_list(time_shift)
    if time_shift == nil then
        time_shift = time.epoch() - 3600000
    elseif type(time_shift) == "number" then
        time_shift = time.epoch() - (3600000 * time_shift)
    else
        show("统计时间不正确", "red")
        return false
    end
    show(string.format("%"..tostring((window_wrap()-1)).."s", ""), "white", "gray")
    local c1,c2,c3,c4,c5,c6,c7,c8 = math.floor((window_wrap()-1)*0.02),
                                    math.floor((window_wrap()-1)*0.23),
                                    math.floor((window_wrap()-1)*0.15),
                                    math.floor((window_wrap()-1)*0.1),
                                    math.floor((window_wrap()-1)*0.15),
                                    math.floor((window_wrap()-1)*0.15),
                                    math.floor((window_wrap()-1)*0.1)
    c8 = window_wrap()-1-c1-c2-c3-c4-c5-c6-c7
    local format = "%"..tostring(c1).."s%-"..tostring(c2).."s%-"..tostring(c3).."s%-"..tostring(c4).."s%"..tostring(c5).."s%"..tostring(c6).."s%"..tostring(c7).."s%-"..tostring(c8).."s"
    show(string.format(format, "", "完成时间", "任务名", "结果", "获得经验", "获得潜能", "", "用时"), "white", "gray")
    local history,list = {},{}
    for i=#statistics,1,-1 do
        if statistics[i]["end"] >= time_shift then
            set.append(list, statistics[i])
        else
            return statistics_list_print(list, format)
        end
    end
    for i=time_shift,time.toepoch(statistics.date, "^(%d%d%d%d)(%d%d)(%d%d)$")+86399999,86400000 do
        if io.exists(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d")) then
            history = table.load(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d"))
        end
    end
    for i=#history,1,-1 do
        if history[i]["end"] >= time_shift then
            set.append(list, history[i])
        else
            break
        end
    end
    return statistics_list_print(list, format)
end

function statistics_list_print(list, format)
    local font_color = "yellow"
    local back_color = "gray"
    for _,v in ipairs(list) do
        if back_color == "black" then
            back_color = "gray"
        else
            back_color = "black"
        end
        show(string.format(format, "", time.todate(v["end"], "%Y/%m/%d %H:%M:%S"), v["name"], v["result"], tostring(v["exp"]), tostring(v["pot"]), "", time.todate(v["end"]-v["begin"], "%M:%S")), font_color, back_color)
    end
end

function statistics_classify()
end
