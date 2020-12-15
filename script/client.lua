require "frame"

function show(msg, fcolor, bcolor, breaker)
    bcolor = bcolor or "black"
    fcolor = fcolor or "pink"
    cecho("<:"..bcolor.."><"..fcolor..">"..msg..(breaker or "\n"))
end
show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

mudlet = mudlet or {}
mudlet.supports = mudlet.supports or {}
regex = regex or {}

function regex.match(text, pattern)
    return rex.match(text, pattern)
end

function trigger_regex(name)
    local capture
    if triggers[name].options.Multi == true then
        capture = { regex.match(set.concat(get_lines(-triggers[name].multilines), "\n"), "("..triggers[name].pattern..")") }
    else
        capture = { regex.match(get_lines(-1)[1], "("..triggers[name].pattern..")") }
    end
    message("trace", name, "匹配 "..tostring(triggers[name].pattern), table.tostring(capture))
    if #capture == 0 then
        return false
    end
    capture[0] = capture[1]
    set.remove(capture, 1)
    global.regex = capture
    message("trace", "触发详情", name, table.tostring(triggers[name]))
    return true
end

function get_lines(from, to)
    if from == nil then
        from = -1
    end
    if to == nil then
        to = -1
    end
    if from > to then
        return nil
    end
    if #global.buffer+to < 0 then
        return nil
    end
    local lines = {}
    for i=math.max(1,#global.buffer+from+1),#global.buffer+to+1 do
        set.append(lines, global.buffer[i])
    end
    return lines
end

function get_matches(num)
    if num == nil then
        return global.regex
    end
    return global.regex[num]
end

function gag()
    return deleteLine()
end

function reset()
    if statics ~= nil and #statics > 0 then
        table.save(get_work_path().."log/statics."..statics.date, statics)
    end
    if automation.thread ~= nil then
        automation.thread = nil
        automation.jid = (var or {}).jid
        automation.config = config
        automation.repository = (carryon or {}).repository
    end
    automation.ui = ui
    table.save(get_work_path().."log/automation.tmp", automation)
    table.save(get_work_path().."log/global.tmp", (global.buffer or { "" }))
    resetProfile()
end

function window_size()
    local width,height = getMainWindowSize()
    return { width = width, height = height }
end

function window_wrap()
    return 100 --getWindowWrap()
end

function timer.add(name, seconds, send, group, options)
    if name == nil or name == "" then
        name = "timer_"..unique_id()
    end
    if group == "" then
        group = nil
    end
    if group ~= nil then
        timers.group[group] = timers.group[group] or {}
    end
    options = options or {}

    timers[name] = { send = send, group = group, seconds = seconds, options = options }
    if not options.OneShot then
        timers[name].id = tempTimer(seconds, send, true)
    else
        send = send.." timer.delete('"..name.."')"
        timers[name].id = tempTimer(seconds, send)
    end
    if group ~= nil then
        timers.group[group][name] = timers[name].id
    end
    if options.Enable == false then
        timer.disable(name)
    else
        timer.enable(name)
    end
    return name
end

function timer.delete(name)
    local rc = killTimer((timers[name] or {}).id or "")
    if timers[name] ~= nil and timers[name].group ~= nil then
        timers.group[timers[name].group][name] = nil
        if table.is_empty(timers.group[timers[name].group]) then
            timers.group[timers[name].group] = nil
        end
    end
    timers[name] = nil
    return rc
end

function timer.enable(name)
    return enableTimer((timers[name] or {}).id or name)
end

function timer.disable(name)
    return disableTimer((timers[name] or {}).id or name)
end

function timer.remain(name)
    return remainingTime(timers[name].id)
end

function timer.is_exist(name)
    if timers[name] == nil then
        return false
    else
        return true
    end
end

function timer.is_enable(name)
    if timer.is_exist(name) == false then
        return false
    end
    if isActive(timers[name].id, "timer") == 0 then
        return false
    else
        return true
    end
end

function timer.enable_group(group)
    local rc = true
    for k,_ in pairs(timers.group[group] or {}) do
        rc = rc and timer.enable(k)
    end
    return rc
end

function timer.disable_group(group)
    local rc = true
    for k,_ in pairs(timers.group[group] or {}) do
        rc = rc and timer.disable(k)
    end
    return rc
end

function timer.delete_group(group)
    local rc = true
    for k,_ in pairs(timers.group[group] or {}) do
        rc = rc and timer.delete(k)
    end
    return rc
end

function minimal_resources()
    setConsoleBufferSize(2000, 500)
end

function alias.add(name, pattern, send)
    if name == nil or name == "" then
        name = "alias_"..unique_id()
    end
    if aliases[name] ~= nil then
        alias.delete(name)
    end
    aliases[name] = tempAlias(pattern, send)
    return name
end

function alias.delete(name)
    local rc = killAlias(aliases[name])
    aliases[name] = nil
    return rc
end

function get_last_cmd()
    return command
end

function simulate(msg)
    return feedTriggers(msg.."\n")
end

function send_cmd(...)
    return send(...)
end

function print(parameter)
    if type(parameter) == "nil" then
        show(" 空字符："..tostring(parameter), "gray")
    elseif type(parameter) == "string" then
        if trigger.is_exist(parameter) == true then
            local switch,multi = {["true"] = "是", ["false"] = "否"},{["true"] = "多行", ["false"] = "单行"}
            show(" 触发："..tostring(parameter).."    属组："..tostring((triggers[parameter].group or "无")).."    优先级："..tostring(triggers[parameter].order), "gray")
            show(" 属性：  生效 - "..switch[tostring(triggers[parameter].options.Enable or false)].."， 一次性 - "..switch[tostring(triggers[parameter].options.OneShot or false)].."， 隐藏显示 - "..switch[tostring(triggers[parameter].options.Gag or false)], "gray")
            show(" 匹配模式："..multi[tostring(triggers[parameter].options.Multi or false)].."    匹配行数："..tostring(triggers[parameter].options.multilines or 1), "gray")
            show(" 匹配条件："..tostring(triggers[parameter].pattern), "gray")
            show(" 发送指令："..tostring(triggers[parameter].send), "gray")
            return
        end
        if timer.is_exist(parameter) == true then
            local switch = {["true"] = "是", ["false"] = "否"}
            show(" 计时器："..tostring(parameter).."    属组："..tostring((timers[parameter].group or "无")), "gray")
            show(" 属性：  生效 - "..switch[tostring(timers[parameter].options.Enable or false)].."， 一次性 - "..switch[tostring(timers[parameter].options.OneShot or false)], "gray")
            show(" 时长："..tostring(timer.remain(parameter)).." / "..tostring(timers[parameter].seconds).." 秒", "gray")
            show(" 发送指令："..tostring(timers[parameter].send), "gray")
            return
        end
        show(" 字符串："..tostring(parameter), "gray")
    elseif type(parameter) == "number" then
        show(" 数值："..tostring(parameter), "gray")
    elseif type(parameter) == "boolean" then
        show(" 布尔值："..tostring(parameter), "gray")
    elseif type(parameter) == "function" then
        show(" 函数："..tostring(parameter), "gray")
    elseif type(parameter) == "thread" then
        show(" 协程："..tostring(parameter).." ( "..tostring(coroutine.status(parameter).." )"), "gray")
    else
        show(" 表：", "gray")
        for _,v in ipairs(table.tojson(parameter)) do
            show(" "..v, "gray")
        end
    end
end

function flush_map()
    require "luasql.sqlite3"
    local env = assert(luasql.sqlite3():connect(get_script_path().."map.db"))
    local db = assert(env:execute("select name,desc,exits,zone,links,esc,npcs,items,tags from rooms"))
    local column = { "name", "desc", "exits", "zone", "links", "esc", "npcs", "items", "tags" }
    map = {}
    repeat
        row = db:fetch({})
        if row then
            local nrow = {}
            for k,v in pairs(row) do
                if column[k] == "exits" then
                    if v == "" then
                        v = {{}}
                    else
                        v = string.split(v, ",")
                        for i = 1, #v, 1 do
                            v[i] = string.toset(v[i])
                        end
                    end
                elseif column[k] == "links" then
                    v = string.totable(v)
                elseif column[k] == "npcs" or column[k] == "items" or column[k] == "tags" then
                    v = string.toset(v)
                elseif column[k] == "esc" then
                    v = tonumber(v)
                end
                nrow[column[k]] = v
            end
            set.append(map, nrow)
        end
    until row == nil
    env:close()
    table.save(get_script_path().."gps/map.lua", map)
    show("地图已更新", "orange")
end

show(" 已加载", "green")