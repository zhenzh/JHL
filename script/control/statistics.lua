function statistics(mode, shift, classify)
    local list = { end_time = time.epoch(), death = 0, idle = 0, connect = 0, reset = 0 }
    if type(shift) ~= "number" then
        show("统计时间不正确", "red")
        return false
    end
    list.begin_time = list.end_time - 3600000 * shift
    list = statistics_get_range(list)
    if mode == "summary" then
        return statistics_summary(list)
    elseif mode == "list" then
        return statistics_list(list)
    elseif mode == "classify" then
        return statistics_classify(list, classify)
    end
end

function statistics_get_range(list)
    for _,v in ipairs({"death", "idle", "connect", "reset"}) do
        for i=#automation.statistics[v],1,-1 do
            if automation.statistics[v][i] >= list.begin_time then
                list[v] = list[v] + 1
            else
                break
            end
        end
    end
    for i=#automation.statistics,1,-1 do
        if automation.statistics[i].end_time >= list.begin_time then
            set.insert(list, 1, automation.statistics[i])
        else
            return list
        end
    end
    for i=time.toepoch(automation.statistics.date, "^(%d%d%d%d)(%d%d)(%d%d)$")-86400000,list.begin_time-86399999,-86400000 do
        if io.exists(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d")) then
            local history = table.load(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d"))
            for j=#history,1,-1 do
                if history[j].end_time >= list.begin_time then
                    set.insert(list, 1, history[j])
                else
                    break
                end
            end
        end
    end
    return list
end

function statistics_summary(list)
    local summary = { total = {exp = 0, pot = 0, elapsed = 0} }
    for _,v in ipairs(config.jobs) do
        if config.jobs[v].enable == true then
            set.append(summary, { name = v, exp = 0, pot = 0, elapsed = 0, success = 0, fail = 0 })
            summary[v] = set.last(summary)
        end
    end
    for _,i in ipairs(list) do
        if summary[i.name] ~= nil then
            summary[i.name].exp = summary[i.name].exp + i.exp
            summary.total.exp = summary.total.exp + i.exp
            summary[i.name].pot = summary[i.name].pot + i.pot
            summary.total.pot = summary.total.pot + i.pot
            summary[i.name].elapsed = summary[i.name].elapsed + i.elapsed
            summary.total.elapsed = summary.total.elapsed + i.elapsed
            if i.result == "成功" then
                summary[i.name].success = summary[i.name].success + 1
            else
                summary[i.name].fail = summary[i.name].fail + 1
            end
        end
    end
    local margin = math.floor((window_wrap()-1)*0.02)
    show(string.format("%"..tostring(margin).."s统计概览（%19s ~ %19s）%"..tostring(window_wrap()-margin-53).."s", "", time.todate(list.begin_time, "%Y-%m-%d %H:%M:%S"), time.todate(list.end_time, "%Y-%m-%d %H:%M:%S"), ""), "olivedrab", "ivory")
    show(string.format("%"..tostring(margin).."s%-"..tostring(math.floor((window_wrap()-margin*2)/4)).."s%-"..tostring(math.floor((window_wrap()-margin*2)/4)).."s%-"..tostring(math.floor((window_wrap()-margin*2)/4)).."s%-"..tostring(math.floor((window_wrap()-margin*2)/4)).."s", "", "机器重置次数："..tostring(list.reset), "重连次数："..tostring(list.connect), "死亡次数："..tostring(list.death), "发呆次数："..tostring(list.idle)), "yellow", "black")
    local c1,c2,c3,c4,c5,c6 = math.floor((window_wrap()-1)*0.1),
                              math.floor((window_wrap()-1)*0.15),
                              math.floor((window_wrap()-1)*0.1),
                              math.floor((window_wrap()-1)*0.15),
                              math.floor((window_wrap()-1)*0.15),
                              math.floor((window_wrap()-1)*0.2)
    local c7 = window_wrap()-margin-c1-c2-c3-c4-c5-c6
    local format = "%"..tostring(margin).."s%-"..tostring(c1).."s%"..tostring(c2).."s%-"..tostring(c3).."s%"..tostring(c4).."s%-"..tostring(c5).."s%-"..tostring(c6).."s%-"..tostring(c7).."s"
    show(string.format(format, "", "任务名", "获得经验", "获取效率（每秒）", "获得潜能", "获取效率（每秒）", "总用时（占比）", "完成数（成功率）"), "white", "dimgray")
    local font_color,back_color = "yellow","dimgray"
    for _,v in ipairs(summary) do
        if back_color == "black" then
            back_color = "dimgray"
        else
            back_color = "black"
        end
        local ratio = string.format("%.2f", math.decimal(v.elapsed/(list.end_time-list.begin_time)*100, 2))
        local exp_rate,pot_rate,success_rate
        if v.elapsed == 0 then
            exp_rate = "-"
            pot_rate = "-"
        else
            exp_rate = string.format("%.3f", math.decimal(v.exp*1000/v.elapsed, 3))
            pot_rate = string.format("%.3f", math.decimal(v.pot*1000/v.elapsed, 3))
        end
        if v.success+v.fail == 0 then
            success_rate = "-"
        else
            success_rate = string.format("%.2f", math.decimal(v.success/(v.success+v.fail)*100, 2))
        end
        show(string.format(format, "", v.name, tostring(v.exp), " / "..exp_rate, tostring(v.pot), " / "..pot_rate, time.tohms(v.elapsed).."（"..ratio.."%）", tostring(v.success).."（"..success_rate.."%）"), font_color, back_color)
    end
    local total_ratio = string.format("%.2f", math.decimal(summary.total.elapsed/(list.end_time-list.begin_time)*100, 2))
    show(string.format(format, "", "总计", tostring(summary.total.exp), "", tostring(summary.total.pot), "", time.tohms(summary.total.elapsed).."（"..total_ratio.."%）", ""), "olivedrab", "ivory")
end

function statistics_list(list)
    local margin = math.floor((window_wrap()-1)*0.02)
    local c1,c2,c3,c4,c5,c6 = math.floor((window_wrap()-1)*0.23),
                              math.floor((window_wrap()-1)*0.15),
                              math.floor((window_wrap()-1)*0.1),
                              math.floor((window_wrap()-1)*0.15),
                              math.floor((window_wrap()-1)*0.15),
                              math.floor((window_wrap()-1)*0.1)
    local c7 = window_wrap()-margin-c1-c2-c3-c4-c5-c6
    local format = "%"..tostring(margin).."s%-"..tostring(c1).."s%-"..tostring(c2).."s%-"..tostring(c3).."s%"..tostring(c4).."s%"..tostring(c5).."s%"..tostring(c6).."s%-"..tostring(c7).."s"
    show(string.format(format, "", "完成时间", "任务名", "任务结果", "获得经验", "获得潜能", "", "用时"), "white", "dimgray")
    local font_color,back_color = "yellow","dimgray"
    local sum = { exp = 0, pot = 0, elapsed = 0 }
    for _,v in ipairs(list) do
        if back_color == "black" then
            back_color = "dimgray"
        else
            back_color = "black"
        end
        show(string.format(format, "", time.todate(v.end_time, "%Y/%m/%d %H:%M:%S"), v["name"], (v.result or "-"), tostring(v.exp), tostring(v.pot), "", time.tohms(v.elapsed)), font_color, back_color)
        sum.exp = sum.exp + v.exp
        sum.pot = sum.pot + v.pot
        sum.elapsed = sum.elapsed + v.elapsed
    end
    show(string.format(format, "", "", "总计", "-", tostring(sum.exp), tostring(sum.pot), "", time.tohms(sum.elapsed)), "olivedrab", "ivory")
end

function statistics_classify(list, classify)
    local sum = { exp = 0, pot = 0, elapsed = 0 }
    for _,v in ipairs(list) do
        if v.name == classify then
            sum.exp = sum.exp + v.exp
            sum.pot = sum.pot + v.pot
            sum.elapsed = sum.elapsed + v.elapsed
        end
    end
    return sum.exp,sum.pot,sum.elapsed
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")