require "tableEx"
require "set"
require "stringEx"
require "timeEx"
require "alias"
require "trigger"
require "alias"

local color_map = {
    aliceblue = "#f0f8ff",
    antiquewhite = "#faebd7",
    aqua = "#00ffff",
    cyan = "#00ffff",
    aquamarine = "#7fffd4",
    azure = "#f0ffff",
    beige = "#f5f5dc",
    bisque = "#ffe4c4",
    black = "#000000",
    blanchedalmond = "#ffebcd",
    blue = "#0000ff",
    blueviolet = "#8a2be2",
    brown = "#a52a2a",
    burlywood = "#deb887",
    cadetblue = "#5f9ea0",
    chartreuse = "#7fff00",
    chocolate = "#d2691e",
    coral = "#ff7f50",
    cornflowerblue = "#6495ed",
    cornsilk = "#fff8dc",
    crimson = "#dc143c",
    darkblue = "#00008b",
    darkcyan = "#008b8b",
    darkgoldenrod = "#b8860b",
    darkgray = "#a9a9a9",
    darkgreen = "#006400",
    darkkhaki = "#bdb76b",
    darkmagenta = "#8b008b",
    darkolivegreen = "#556b2f",
    darkorange = "#ff8c00",
    darkorchid = "#9932cc",
    darkred = "#8b0000",
    darksalmon = "#e9967a",
    darkseagreen = "#8fbc8f",
    darkslateblue = "#483d8b",
    darkslategray = "#2f4f4f",
    darkturquoise = "#00ced1",
    darkviolet = "#9400d3",
    deeppink = "#ff1493",
    deepskyblue = "#00bfff",
    dimgray = "#696969",
    dodgerblue = "#1e90ff",
    firebrick = "#b22222",
    floralwhite = "#fffaf0",
    forestgreen = "#228b22",
    fuchsia = "#ff00ff",
    magenta = "#ff00ff",
    gainsboro = "#dcdcdc",
    ghostwhite = "#f8f8ff",
    gold = "#ffd700",
    goldenrod = "#daa520",
    gray = "#808080",
    green = "#008000",
    greenyellow = "#adff2f",
    honeydew = "#f0fff0",
    hotpink = "#ff69b4",
    indianred = "#cd5c5c",
    indigo = "#4b0082",
    ivory = "#fffff0",
    khaki = "#f0e68c",
    lavender = "#e6e6fa",
    lavenderblush = "#fff0f5",
    lawngreen = "#7cfc00",
    lemonchiffon = "#fffacd",
    lightblue = "#add8e6",
    lightcoral = "#f08080",
    lightcyan = "#e0ffff",
    lightgoldenrodyellow = "#fafad2",
    lightgray = "#d3d3d3",
    lightgreen = "#90ee90",
    lightpink = "#ffb6c1",
    lightsalmon = "#ffa07a",
    lightseagreen = "#20b2aa",
    lightskyblue = "#87cefa",
    lightslategray = "#778899",
    lightsteelblue = "#b0c4de",
    lightyellow = "#ffffe0",
    lime = "#00ff00",
    limegreen = "#32cd32",
    linen = "#faf0e6",
    maroon = "#800000",
    mediumaquamarine = "#66cdaa",
    mediumblue = "#0000cd",
    mediumorchid = "#ba55d3",
    mediumpurple = "#9370db",
    mediumseagreen = "#3cb371",
    mediumslateblue = "#7b68ee",
    mediumspringgreen = "#00fa9a",
    mediumturquoise = "#48d1cc",
    mediumvioletred = "#c71585",
    midnightblue = "#191970",
    mintcream = "#f5fffa",
    mistyrose = "#ffe4e1",
    moccasin = "#ffe4b5",
    navajowhite = "#ffdead",
    navy = "#000080",
    oldlace = "#fdf5e6",
    olive = "#808000",
    olivedrab = "#6b8e23",
    orange = "#ffa500",
    orangered = "#ff4500",
    orchid = "#da70d6",
    palegoldenrod = "#eee8aa",
    palegreen = "#98fb98",
    paleturquoise = "#afeeee",
    palevioletred = "#db7093",
    papayawhip = "#ffefd5",
    peachpuff = "#ffdab9",
    peru = "#cd853f",
    pink = "#ffc0cb",
    plum = "#dda0dd",
    powderblue = "#b0e0e6",
    purple = "#800080",
    red = "#ff0000",
    rosybrown = "#bc8f8f",
    royalblue = "#4169e1",
    saddlebrown = "#8b4513",
    salmon = "#fa8072",
    sandybrown = "#f4a460",
    seagreen = "#2e8b57",
    seashell = "#fff5ee",
    sienna = "#a0522d",
    silver = "#c0c0c0",
    skyblue = "#87ceeb",
    slateblue = "#6a5acd",
    slategray = "#708090",
    snow = "#fffafa",
    springgreen = "#00ff7f",
    steelblue = "#4682b4",
    tan = "#d2b48c",
    teal = "#008080",
    thistle = "#d8bfd8",
    tomato = "#ff6347",
    turquoise = "#40e0d0",
    violet = "#ee82ee",
    wheat = "#f5deb3",
    white = "#ffffff",
    whitesmoke = "#f5f5f5",
    yellow = "#ffff00",
    yellowgreen = "#9acd32"
}

global.output = true
regex = {}

function regex.match(message, pattern)
    local msg = { RegEx(message, "("..pattern..")") }
    if msg[1] == "0" then
        return nil
    end
    local mch = { [0] = msg[2] }
    for i=3,#msg do
        if msg[i] == "" then
            set.append(mch, false)
        else
            set.append(mch, msg[i])
        end
    end
    return mch
end

function OnReceive(raw, text)
    global.output = true
    trigger_process(text)
    return global.output
end

function OnSend(cmd)
    local mch = regex.match(cmd, "^/\\s*(.*)\\s*$")
    if mch ~= nil then
        loadstring(mch[1])()
        return false
    end
    if alias_process(cmd) == true then
        return false
    end
    return send_cmd(cmd)
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
    global.output = "hide"
    return
end

function reset()
--     if statics ~= nil and #statics > 0 then
--         table.save(get_work_path().."log/statics."..statics.date, statics)
--     end
--     if automation.thread ~= nil then
--         automation.thread = nil
--         automation.jid = (var or {}).jid
--         automation.config = config
--         automation.repository = (carryon or {}).repository
--     end
--     automation.ui = ui
--     table.save(get_work_path().."log/automation.tmp", automation)
--     table.save(get_work_path().."log/global.tmp", (global.buffer or { "" }))
--    Send("reload-lua")
end

-- function window_size()
--     local width,height = getMainWindowSize()
--     return { width = width, height = height }
-- end

-- function window_wrap()
--     return 100 --getWindowWrap()
-- end

-- function timer.add(name, seconds, send, group, options)
--     if name == nil or name == "" then
--         name = "timer_"..unique_id()
--     end
--     if group == "" then
--         group = nil
--     end
--     if group ~= nil then
--         timers.group[group] = timers.group[group] or {}
--     end
--     options = options or {}

--     timers[name] = { send = send, group = group, seconds = seconds, options = options }
--     if not options.OneShot then
--         timers[name].id = tempTimer(seconds, send, true)
--     else
--         send = send.." timer.delete('"..name.."')"
--         timers[name].id = tempTimer(seconds, send)
--     end
--     if group ~= nil then
--         timers.group[group][name] = timers[name].id
--     end
--     if options.Enable == false then
--         timer.disable(name)
--     else
--         timer.enable(name)
--     end
--     return name
-- end

-- function timer.delete(name)
--     local rc = killTimer((timers[name] or {}).id or "")
--     if timers[name] ~= nil and timers[name].group ~= nil then
--         timers.group[timers[name].group][name] = nil
--         if table.is_empty(timers.group[timers[name].group]) then
--             timers.group[timers[name].group] = nil
--         end
--     end
--     timers[name] = nil
--     return rc
-- end

-- function timer.enable(name)
--     return enableTimer((timers[name] or {}).id or name)
-- end

-- function timer.disable(name)
--     return disableTimer((timers[name] or {}).id or name)
-- end

-- function timer.remain(name)
--     return remainingTime(timers[name].id)
-- end

-- function timer.is_exist(name)
--     if timers[name] == nil then
--         return false
--     else
--         return true
--     end
-- end

-- function timer.is_enable(name)
--     if timer.is_exist(name) == false then
--         return false
--     end
--     if isActive(timers[name].id, "timer") == 0 then
--         return false
--     else
--         return true
--     end
-- end

-- function timer.enable_group(group)
--     local rc = true
--     for k,_ in pairs(timers.group[group] or {}) do
--         rc = rc and timer.enable(k)
--     end
--     return rc
-- end

-- function timer.disable_group(group)
--     local rc = true
--     for k,_ in pairs(timers.group[group] or {}) do
--         rc = rc and timer.disable(k)
--     end
--     return rc
-- end

-- function timer.delete_group(group)
--     local rc = true
--     for k,_ in pairs(timers.group[group] or {}) do
--         rc = rc and timer.delete(k)
--     end
--     return rc
-- end

-- function minimal_resources()
--     setConsoleBufferSize(2000, 500)
-- end

-- function get_last_cmd()
--     return command
-- end

function simulate(msg)
    return Run(msg)
end

function send_cmd(cmd)
    local mch = regex.match(cmd, "^\\s*(.*?)\\s*;\\s*(#\\d+\\s+{.*?})\\s*;\\s*(.*)\\s*$")
    if mch ~= nil then
        for _,v in ipairs(mch) do
            if alias_process(v) == false then
                send_cmd(v)
            end
        end
        return false
    end
    for _,v in ipairs(string.split(cmd, ";")) do
        local send = v:trim()
        if alias_process(send) == false then
            Send(send)
        end
    end
    return false
end

function show(msg, fcolor, bcolor)
    if type(msg) == "table" then
        msg = table.tostring(msg)
    end
    Echo("["..(color_map[fcolor] or color_map["pink"])..":"..(color_map[bcolor] or "-")..":]"..tostring(msg).."[-:-:-]")
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

-- function flush_map()
--     require "luasql.sqlite3"
--     local env = assert(luasql.sqlite3():connect(get_script_path().."map.db"))
--     local db = assert(env:execute("select name,desc,exits,zone,links,esc,npcs,items,tags from rooms"))
--     local column = { "name", "desc", "exits", "zone", "links", "esc", "npcs", "items", "tags" }
--     map = {}
--     repeat
--         row = db:fetch({})
--         if row then
--             local nrow = {}
--             for k,v in pairs(row) do
--                 if column[k] == "exits" then
--                     if v == "" then
--                         v = {{}}
--                     else
--                         v = string.split(v, ",")
--                         for i = 1, #v, 1 do
--                             v[i] = string.toset(v[i])
--                         end
--                     end
--                 elseif column[k] == "links" then
--                     v = string.totable(v)
--                 elseif column[k] == "npcs" or column[k] == "items" or column[k] == "tags" then
--                     v = string.toset(v)
--                 elseif column[k] == "esc" then
--                     v = tonumber(v)
--                 end
--                 nrow[column[k]] = v
--             end
--             set.append(map, nrow)
--         end
--     until row == nil
--     env:close()
--     table.save(get_script_path().."gps/map.lua", map)
--     show("地图已更新", "orange")
-- end