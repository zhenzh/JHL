function statistics(mode, shift, classify)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ statistics ］参数：mode = "..tostring(mode)..", shift = "..tostring(shift)..", classify = "..tostring(classify))
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
    for i=time.toepoch(automation.statistics.date, "^(%d%d%d%d)(%d%d)(%d%d)(%d%d)$")-3600000,list.begin_time-3599999,-3600000 do
        if io.exists(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d%H")) then
            local history = table.load(get_work_path().."log/statistics."..time.todate(i, "%Y%m%d%H"))
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
    local format = "%2s%-8s%12s%-8s%12s%-12s%-16s%-10s"
    local font_color,back_color = "yellow","dimgray"
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
    show(string.format("%2s统计概览（%19s ~ %19s）%25s", "", time.todate(list.begin_time, "%Y-%m-%d %H:%M:%S"), time.todate(list.end_time, "%Y-%m-%d %H:%M:%S"), ""), "olivedrab", "ivory")
    show(string.format("%2s%-20s%-20s%-20s%-16s", "", "重置次数："..tostring(list.reset), "重连次数："..tostring(list.connect), "死亡次数："..tostring(list.death), "发呆次数："..tostring(list.idle)), "yellow", "black")
    show(string.format(format, "", "任务名", "获得经验", " / 效率", "获得潜能", " / 效率", "总用时（占比）", "完成数（成功率）"), "white", "dimgray")
    local lxmsg
    for _,v in ipairs(summary) do
        local ratio = string.format("%.2f", math.decimal(v.elapsed/(list.end_time-list.begin_time)*100, 2))
        local exp_rate,pot_rate,success_rate
        if v.elapsed == 0 then
            exp_rate,pot_rate = "-","-"
        else
            exp_rate = string.format("%.3f", math.decimal(v.exp*1000/v.elapsed, 3)).." 每秒"
            pot_rate = string.format("%.3f", math.decimal(v.pot*1000/v.elapsed, 3)).." 每秒"
        end
        if v.success + v.fail == 0 then
            success_rate = "-"
        else
            success_rate = string.format("%.2f", math.decimal(v.success/(v.success+v.fail)*100, 2))
        end
        if v.name == "龙象破障" then
            lxmsg = string.format(format, "", v.name, "-", " / -", "-", " / -", time.tohms(v.elapsed).."（"..ratio.."%）", tostring(v.fail).."（ - ）")
        else
            if back_color == "black" then
                back_color = "dimgray"
            else
                back_color = "black"
            end
            show(string.format(format, "", v.name, tostring(v.exp), " / "..exp_rate, tostring(v.pot), " / "..pot_rate, time.tohms(v.elapsed).."（"..ratio.."%）", tostring(v.success).."（"..success_rate.."%）"), font_color, back_color)
        end
    end
    if lxmsg ~= nil then
        if back_color == "black" then
            back_color = "dimgray"
        else
            back_color = "black"
        end
        show(lxmsg, font_color, back_color)
    end
    local total_ratio = string.format("%.2f", math.decimal(summary.total.elapsed/(list.end_time-list.begin_time)*100, 2))
    local total_exp_rate,total_pot_rate
    if summary.total.elapsed == 0 then
        total_exp_rate,total_pot_rate = "-","-"
    else
        total_exp_rate = string.format("%.2f", math.decimal(summary.total.exp*3600000/summary.total.elapsed, 2)).." 每小时"
        total_pot_rate = string.format("%.2f", math.decimal(summary.total.pot*3600000/summary.total.elapsed, 2)).." 每小时"
    end
    show(string.format(format, "", "总计", tostring(summary.total.exp), " / "..total_exp_rate, tostring(summary.total.pot), " / "..total_pot_rate, time.tohms(summary.total.elapsed).."（"..total_ratio.."%）", ""), "olivedrab", "ivory")
end

function statistics_list(list)
    local format = "%2s%-18s%-12s%-8s%12s%12s%8s%-8s"
    local font_color,back_color = "yellow","dimgray"
    local sum = { exp = 0, pot = 0, elapsed = 0 }
    show(string.format(format, "", "完成时间", "任务名", "任务结果", "获得经验", "获得潜能", "", "用时"), "white", "dimgray")
    for _,v in ipairs(list) do
        if v.name ~= "龙象破障" then
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

function statistics_append(job)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ statistics_append ］参数：job = "..tostring(job))
    if var.job.statistics ~= nil then
        var.job.statistics.exp = state.exp - (var.job.statistics.exp or state.exp)
        var.job.statistics.pot = state.pot - (var.job.statistics.pot or state.pot)
        var.job.statistics.end_time = time.epoch()
        var.job.statistics.elapsed = var.job.statistics.end_time - var.job.statistics.begin_time
        if automation.statistics.processing[job] == nil then
            if var.job.statistics.result == nil then
                automation.statistics.processing[job] = var.job.statistics
            else
                var.statistics = var.job.statistics
            end
        else
            automation.statistics.processing[job].exp = var.job.statistics.exp + automation.statistics.processing[job].exp
            automation.statistics.processing[job].pot = var.job.statistics.pot + automation.statistics.processing[job].pot
            automation.statistics.processing[job].end_time = var.job.statistics.end_time
            automation.statistics.processing[job].elapsed = var.job.statistics.elapsed + automation.statistics.processing[job].elapsed
            automation.statistics.processing[job].result = var.job.statistics.result
            if automation.statistics.processing[job].result ~= nil then
                var.statistics = automation.statistics.processing[job]
                automation.statistics.processing[job] = nil
            end
        end
        var.job.statistics = nil
    end
    statistics_archive()
end

function statistics_archive()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ statistics_archive ］")
    if var.statistics ~= nil then
        if time.toepoch(automation.statistics.date, "^(%d%d%d%d)(%d%d)(%d%d)(%d%d)$") + 3600000 <= var.statistics.end_time then
            local idle,death,reset,connect,processing = automation.statistics.idle,automation.statistics.death,automation.statistics.reset,automation.statistics.connect,automation.statistics.processing
            automation.statistics.idle = nil
            automation.statistics.death = nil
            automation.statistics.reset = nil
            automation.statistics.connect = nil
            automation.statistics.processing = nil
            table.save(get_work_path().."log/statistics."..automation.statistics.date, automation.statistics)
            automation.statistics = { date = time.date("%Y%m%d%H") }
            automation.statistics.idle,automation.statistics.death,automation.statistics.reset,automation.statistics.connect,automation.statistics.processing = idle,death,reset,connect,processing
        end
        set.append(automation.statistics, var.statistics)
        var.statistics = nil
    end
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")