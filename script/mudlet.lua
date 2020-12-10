require "frame"

function show(msg, fcolor, bcolor, breaker)
    bcolor = bcolor or "black"
    fcolor = fcolor or "blue"
    cecho("<:"..bcolor.."><"..fcolor..">"..msg..(breaker or "\n"))
end
show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

mudlet = mudlet or {}
mudlet.supports = mudlet.supports or {}
timer = timer or {}
timer_group = timer_group or { [""] = {} }
alias = alias or {}

regex = rex

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

function get_script_path()
    return string.gsub(getMudletHomeDir(), "/mudlet/profiles/.*", "/mudlet/script/")
end

function get_work_path()
    return getMudletHomeDir().."/"
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
    table.save(get_work_path().."log/automation.tmp", automation or {})
    table.save(get_work_path().."log/global.tmp", global.buffer or {})
    resetProfile()
end

function window_size()
    local width,height = getMainWindowSize()
    return {width = width, height = height}
end

function window_wrap()
    return 100 --getWindowWrap()
end

function add_timer(name, seconds, send, group, options)
    local timer_id,timer_activity
    if name == nil or name == "" then
        name = "timer_"..unique_id()
    end
    group = group or ""
    timer_group[group] = timer_group[group] or {}
    options = options or {}

    if not options.Enable then
        timer_activity = disable_timer
    else
        timer_activity = enable_timer
    end

    if not options.OneShot then
        timer_id = tempTimer(seconds, send, true)
    else
        send = send.." timer['"..name.."'] = nil"
        if group ~= "" then
            send = send..
                   " timer_group['"..group.."']['"..name.."'] = nil"..
                   " if table.is_empty(timer_group['"..group.."']) then "..
                       "timer_group['"..group.."'] = nil "..
                   "end"
        end
        timer_id = tempTimer(seconds, send)
    end
    timer_activity(timer_id)
    timer[name] = {timer_id, group}
    timer_group[group][name] = timer_id
    timer_group[""] = {}
    return timer_id
end

function del_timer(name)
    local rc = killTimer((timer[name] or {})[1] or "")
    if rc == true then
        timer_group[timer[name][2]][name] = nil
        if timer[name][2] ~= "" and table.is_empty(timer_group[timer[name][2]]) then
            timer_group[timer[name][2]] = nil
        end
        timer[name] = nil
    end
    return rc
end

function enable_timer(name)
    return enableTimer((timer[name] or {})[1] or name)
end

function disable_timer(name)
    return disableTimer((timer[name] or {})[1] or name)
end

function is_timer_exist(name)
    return timer[name] or false
end

function is_timer_enable(name)
    if is_timer_exist(name) == false then
        return false
    end
    if isActive(timer[name][1], "timer") == 0 then
        return false
    else
        return true
    end
end

function enable_timer_group(group)
    local rc = true
    for k,_ in pairs(timer_group[group] or {}) do
        rc = rc and enable_timer(k)
    end
    return rc
end

function disable_timer_group(group)
    local rc = true
    for k,_ in pairs(timer_group[group] or {}) do
        rc = rc and disable_timer(k)
    end
    return rc
end

function del_timer_group(group)
    local rc = true
    for k,_ in pairs(timer_group[group] or {}) do
        rc = rc and del_timer(k)
    end
    return rc
end

function minimal_resources()
    setConsoleBufferSize(2000, 500)
end

function add_alias(name, cmd, send)
    if name == nil or name == "" then
        name = "alias_"..unique_id()
    end
    if alias[name] ~= nil then
        del_alias(name)
    end
    alias[name] = tempAlias(cmd, send)
    return name
end

function del_alias(name)
    local rc = killAlias(alias[name])
    alias[name] = nil
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

function flush_map()
    require "luasql.sqlite3"
    local env = assert(luasql.sqlite3():connect(get_work_path().."../../script/map.db"))
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
    table.save(get_work_path().."../../script/gps/map.lua", map)
    show("地图已更新", "orange")
end

show(" 已加载", "green")