require "frame"

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

function show(msg, fcolor, bcolor)
    if msg == nil then
        return false
    end
    Echo("["..(color_map[fcolor] or "-")..":"..(color_map[bcolor] or "-")..":]"..tostring(msg).."[-:-:-]")
end
--show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

timer = timer or {}
timer_group = timer_group or { [""] = {} }
alias = alias or {}

regex = {}

function OnReceive(raw, text)
    global.output = true
    trigger_process(text)
    return global.output
end

function OnSend(cmd)
    local rc,msg = RegEx(cmd, "^/(.*)$")
    if rc == "1" then
        loadstring(tostring(msg))()
        return false
    end
end

function regex.match(message, pattern)
    return RegEx(message, "("..pattern..")")
end

function trigger_regex(name)
    local capture
    if triggers[name].options.Multi == true then
        capture = { RegEx(set.concat(get_lines(-triggers[name].multilines), "\n"), triggers[name].pattern) }
    else
        capture = { RegEx(get_lines(-1)[1], triggers[name].pattern) }
    end
    if capture[0] == "0" then
        return false
    end
    global.regex = { [0] = get_lines(-1)[1] }
    for _,v in ipairs(capture) do
        if v == "" then
            set.append(global.regex, false)
        else
            set.append(global.regex, v)
        end
    end
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
    global.output = "hide"
    return
end

-- function get_script_path()
--     return string.gsub(getMudletHomeDir(), "/mudlet/profiles/.*", "/mudlet/script/")
-- end

-- function get_work_path()
--     return getMudletHomeDir().."/"
-- end

-- function reset()
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
--     table.save(get_work_path().."log/automation.tmp", automation or {})
--     table.save(get_work_path().."log/global.tmp", global.buffer or {})
--     resetProfile()
-- end

-- function window_size()
--     local width,height = getMainWindowSize()
--     return {width = width, height = height}
-- end

-- function window_wrap()
--     return 100 --getWindowWrap()
-- end

-- function add_timer(name, seconds, send, group, options)
--     local timer_id,timer_activity
--     if name == nil or name == "" then
--         name = "timer_"..unique_id()
--     end
--     group = group or ""
--     timer_group[group] = timer_group[group] or {}
--     options = options or {}

--     if not options.Enable then
--         timer_activity = disable_timer
--     else
--         timer_activity = enable_timer
--     end

--     if not options.OneShot then
--         timer_id = tempTimer(seconds, send, true)
--     else
--         send = send.." timer['"..name.."'] = nil"
--         if group ~= "" then
--             send = send..
--                    " timer_group['"..group.."']['"..name.."'] = nil"..
--                    " if table.is_empty(timer_group['"..group.."']) then "..
--                        "timer_group['"..group.."'] = nil "..
--                    "end"
--         end
--         timer_id = tempTimer(seconds, send)
--     end
--     timer_activity(timer_id)
--     timer[name] = {timer_id, group}
--     timer_group[group][name] = timer_id
--     timer_group[""] = {}
--     return timer_id
-- end

-- function del_timer(name)
--     local rc = killTimer((timer[name] or {})[1] or "")
--     if rc == true then
--         timer_group[timer[name][2]][name] = nil
--         if timer[name][2] ~= "" and table.is_empty(timer_group[timer[name][2]]) then
--             timer_group[timer[name][2]] = nil
--         end
--         timer[name] = nil
--     end
--     return rc
-- end

-- function enable_timer(name)
--     return enableTimer((timer[name] or {})[1] or name)
-- end

-- function disable_timer(name)
--     return disableTimer((timer[name] or {})[1] or name)
-- end

-- function is_timer_exist(name)
--     return timer[name] or false
-- end

-- function is_timer_enable(name)
--     if is_timer_exist(name) == false then
--         return false
--     end
--     if isActive(timer[name][1], "timer") == 0 then
--         return false
--     else
--         return true
--     end
-- end

-- function enable_timer_group(group)
--     local rc = true
--     for k,_ in pairs(timer_group[group] or {}) do
--         rc = rc and enable_timer(k)
--     end
--     return rc
-- end

-- function disable_timer_group(group)
--     local rc = true
--     for k,_ in pairs(timer_group[group] or {}) do
--         rc = rc and disable_timer(k)
--     end
--     return rc
-- end

-- function del_timer_group(group)
--     local rc = true
--     for k,_ in pairs(timer_group[group] or {}) do
--         rc = rc and del_timer(k)
--     end
--     return rc
-- end

-- function minimal_resources()
--     setConsoleBufferSize(2000, 500)
-- end

-- function add_alias(name, cmd, send)
--     if name == nil or name == "" then
--         name = "alias_"..unique_id()
--     end
--     if alias[name] ~= nil then
--         del_alias(name)
--     end
--     alias[name] = tempAlias(cmd, send)
--     return name
-- end

-- function del_alias(name)
--     local rc = killAlias(alias[name])
--     alias[name] = nil
--     return rc
-- end

-- function get_last_cmd()
--     return command
-- end

-- function simulate(msg)
--     return feedTriggers(msg.."\n")
-- end

-- function send_cmd(...)
--     return send(...)
-- end

-- function flush_map()
--     require "luasql.sqlite3"
--     local env = assert(luasql.sqlite3():connect(get_work_path().."../../script/map.db"))
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
--     table.save(get_work_path().."../../script/gps/map.lua", map)
--     show("地图已更新", "orange")
-- end

-- show(" 已加载", "green")