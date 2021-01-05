function statistics(...)
    local mode,shift = ...
    local duration
    if select("#", ...) == 1 then
        if type(select(1, ...)) ~= "number" then
            show("统计时间不正确", "red")
            return false
        end
        mode = "-s"
        shift = select(1, ...)
    elseif select("#", ...) == 0 then
        mode = "-s"
        shift = 1
    end
    if type(shift) == "number" then
        duration = 3600000 * shift
        shift = time.epoch() - duration
    else
        show("统计时间不正确", "red")
        return false
    end

    local func,format
    if mode == "-l" then
        local c1,c2,c3,c4,c5,c6,c7,c8 = math.floor((window_wrap()-1)*0.02),
                                        math.floor((window_wrap()-1)*0.23),
                                        math.floor((window_wrap()-1)*0.15),
                                        math.floor((window_wrap()-1)*0.1),
                                        math.floor((window_wrap()-1)*0.15),
                                        math.floor((window_wrap()-1)*0.15),
                                        math.floor((window_wrap()-1)*0.1)
        c8 = window_wrap()-1-c1-c2-c3-c4-c5-c6-c7
        format = "%"..tostring(c1).."s%-"..tostring(c2).."s%-"..tostring(c3).."s%-"..tostring(c4).."s%"..tostring(c5).."s%"..tostring(c6).."s%"..tostring(c7).."s%-"..tostring(c8).."s"
        show(string.format(format, "", "完成时间", "任务名", "结果", "获得经验", "获得潜能", "", "用时"), "white", "dimgray")
        func = statistics_list
    else
        local c1,c2,c3,c4,c5,c6,c7,c8 = math.floor((window_wrap()-1)*0.02),
                                        math.floor((window_wrap()-1)*0.3),
                                        math.floor((window_wrap()-1)*0.15),
                                        math.floor((window_wrap()-1)*0.1),
                                        math.floor((window_wrap()-1)*0.15),
                                        math.floor((window_wrap()-1)*0.1),
                                        math.floor((window_wrap()-1)*0.1)
        c8 = window_wrap()-1-c1-c2-c3-c4-c5-c6-c7
        format = "%"..tostring(c1).."s%-"..tostring(c2).."s%"..tostring(c3).."s%3s%-"..tostring(c4).."s%"..tostring(c5).."s%3s%-"..tostring(c6).."s%-"..tostring(c7).."s%-"..tostring(c8).."s"
        show(string.format(format, "", "任务名（时占比）", "获得经验", " / ", "时效率", "获得潜能", " / ", "时效率", "总用时", "成功率"), "white", "dimgray")
        func = statistics_summary
    end

    local list = { duration = duration }
    for i=#automation.statistics,1,-1 do
        if automation.statistics[i]["end"] >= shift then
            set.insert(list, 1, automation.statistics[i])
        else
            return func(list, format)
        end
    end
    for i=time.toepoch(automation.statistics.date, "^(%d%d%d%d)(%d%d)(%d%d)$")-86400000,shift-86399999,-86400000 do
        if io.exists(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d")) then
            local history = table.load(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d"))
            for j=#history,1,-1 do
                if history[j]["end"] >= shift then
                    set.insert(list, 1, history[j])
                else
                    break
                end
            end
        end
    end
    return func(list, format)
end

function statistics_summary(list, format)
    local summary = {}
    for _,v in ipairs(config.jobs) do
        if config.jobs[v].enable == true then
            set.append(summary, { name = v, exp = 0, pot = 0, elapsed = 0, success = 0, fail = 0 })
            summary[v] = set.last(summary)
        end
    end
    for _,i in ipairs(list) do
        if summary[i.name] ~= nil then
            summary[i.name].exp = summary[i.name].exp + i.exp
            summary[i.name].pot = summary[i.name].pot + i.pot
            summary[i.name].elapsed = summary[i.name].elapsed + i.elapsed
            if i.result == "成功" then
                summary[i.name].success = summary[i.name].success + 1
            else
                summary[i.name].fail = summary[i.name].fail + 1
            end
        end
    end
    local font_color,back_color = "yellow","dimgray"
    for _,v in ipairs(summary) do
        if back_color == "black" then
            back_color = "dimgray"
        else
            back_color = "black"
        end
        local ratio = string.format("%.2f", math.decimal(v.elapsed/list.duration*100, 2))
        local exp_rate,pot_rate,success_rate
        if v.elapsed == 0 then
            exp_rate = "-"
            pot_rate = "-"
        else
            exp_rate = string.format("%.2f", math.decimal(v.exp*3600000/v.elapsed*100, 2))
            pot_rate = string.format("%.2f", math.decimal(v.pot*3600000/v.elapsed*100, 2))
        end
        if v.success+v.fail == 0 then
            success_rate = "-"
        else
            success_rate = string.format("%.2f", math.decimal(v.success/(v.success+v.fail)*100, 2))
        end
        show(string.format(format, "", v.name.."（"..ratio.."%）", tostring(v.exp), " / ", exp_rate, tostring(v.pot), " / ", pot_rate, time.todate(v.elapsed, "%H:%M:%S"), success_rate), font_color, back_color)
    end
end

function statistics_list(list, format)
    local font_color,back_color = "yellow","dimgray"
    for _,v in ipairs(list) do
        if back_color == "black" then
            back_color = "dimgray"
        else
            back_color = "black"
        end
        show(string.format(format, "", time.todate(v["end"], "%Y/%m/%d %H:%M:%S"), v["name"], (v["result"] or "-"), tostring(v["exp"]), tostring(v["pot"]), "", time.todate(v["elapsed"], "%M:%S")), font_color, back_color)
    end
end
