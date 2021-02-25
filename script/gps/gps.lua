require "template"
require "dir"
require "locate"
require "events"

local map_events = {
    ["yell chuan;enter"] = navigation,                  ["yell chuan"] = navigation,
    ["yell boat;enter"] = yell_boat,                    ["knock lou;enter"] = knock_lou,
    ["look boat;jump boat"] = jump_boat,                ["tui boat;jump boat"] = jump_boat,
    ["west53"] = quanzhou_gate,                         ["east52"] = quanzhou_gate,
    ["zha stone;climb down"] = huashan_cliff,           ["bang tree;climb"] = huashan_cliff,
    ["go1826"] = xiyu_desert,                           ["go1327"] = xiyu_desert,
    ["east3036"] = walk_ice,                            ["west3036"] = walk_ice,
    ["go1984"] = xueshan,                               ["zou tiesuo"] = tiesuo,
    ["westup1494"] = heifeng,                           ["eastup1494"] = heifeng,
    ["time"] = peach_grove,                             ["north1759"] = peach_grove,
    ["yell boat"] = murong,   ["qu murong"] = murong,   ["qu matou"] = murong,
    ["qu mantuo"] = murong,   ["qu xiaozhu"] = murong,  ["tan qin"] = murong,
    ["sand1090"] = quicksand, ["sand2980"] = quicksand, ["sand3004"] = quicksand,
    ["jump valley"] = busy,   ["climb up889"] = busy,   ["jump wall"] = busy,
    ["climb cliff"] = fall,   ["northup1069"] = fall,   ["southdown1068"] = fall, ["southup413"] = fall,

    ["out1048"] = leave_transport, ["out1049"] = leave_transport, ["out1507"] = leave_transport,
    ["out1526"] = leave_transport, ["out1528"] = leave_transport, ["out1508"] = leave_transport,
    ["out2048"] = leave_transport, ["out2049"] = leave_transport, ["out2074"] = leave_transport,
    ["out2647"] = leave_transport, ["out2794"] = leave_transport, ["out1365"] = leave_transport,
    ["out1554"] = leave_transport, ["out1091"] = leave_transport, ["out1460"] = leave_transport,
    ["out2782"] = leave_transport, ["out2783"] = leave_transport, ["out1531"] = leave_transport,
    ["out1708"] = leave_transport, ["out2750"] = leave_transport, ["out2751"] = leave_transport,

    ["kill nv lang;northdown"] = kill_npc,  ["kill jiading;westup"] = kill_npc,     ["kill yideng shiwei;north"] = kill_npc,
    ["kill shuo bude;up"] = kill_npc,       ["kill jiaozhong;north"] = kill_npc,    ["kill wugen daoren;northup"] = kill_npc,
    ["kill jian zhanglao;east"] = kill_npc, ["kill xiao lan;east"] = kill_npc,      ["kill zhang zhiguang;westup"] = kill_npc,
    ["kill wang furen;up"] = kill_npc,      ["kill lao denuo;south"] = kill_npc,    ["kill xu ming;kill xu tong;eastup"] = kill_npc,
    ["kill yue lingshan;west"] = kill_npc,  ["kill xihua zi;south"] = kill_npc,     ["kill ning zhongze;west"] = kill_npc,
    ["kill zhang songxi;west"] = kill_npc,  ["kill du dajin;enter"] = kill_npc,     ["kill huangshan nuzi;west"] = kill_npc,
    ["kill lu dayou;south"] = kill_npc,     ["kill lao denuo;west"] = kill_npc,     ["kill gao genming;northup"] = kill_npc,
    ["kill xiao wei;south"] = kill_npc,     ["kill caihua zi;enter"] = kill_npc,    ["kill wu shi;open door;west"] = kill_npc,
    ["kill jielv seng;north"] = kill_npc,   ["kill shou wei;north"] = kill_npc,     ["kill qiu shanfeng;enter"] = kill_npc,
    ["kill xiao lan;west"] = kill_npc,      ["kill binu;westup"] = kill_npc,        ["kill huangshan nuzi;east"] = kill_npc,
    ["kill shi sao;north"] = kill_npc,      ["kill ge lunbu;north"] = kill_npc,     ["kill shihou zi;northdown"] = kill_npc,
    ["kill shihou zi;west"] = kill_npc,     ["kill fan yiweng;north"] = kill_npc,   ["kill zhang songxi;south"] = kill_npc,
    ["kill shi daizi;west"] = kill_npc,     ["kill gongsun zhi;north"] = kill_npc,  ["kill menggu junguan;southeast"] = kill_npc,
    ["kill ning zhongze;east"] = kill_npc,  ["kill zhang songxi;east"] = kill_npc,  ["kill changle bangzhong;east"] = kill_npc,
    ["kill ya huan;east"] = kill_npc,       ["kill jia ding;east"] = kill_npc,      ["kill qingguan biqiu;open door;north"] = kill_npc,
    ["kill gongye qian;enter"] = kill_npc,  ["kill liang fa;east"] = kill_npc,      ["kill huikong zunzhe;northup"] = kill_npc,
    ["kill hu laoye;east"] = kill_npc,      ["kill wu shi;north"] = kill_npc,       ["kill qingle biqiu;north"] = kill_npc,
    ["kill yin jin;north"] = kill_npc,      ["kill tan chuduan;up"] = kill_npc,     ["kill ning zhongze;south"] = kill_npc,
    ["kill situ heng;north"] = kill_npc,    ["kill zhuang han;enter"] = kill_npc,   ["kill wei shi;open door;west"] = kill_npc,
    ["kill jing xin;south"] = kill_npc,     ["kill ouyang feng;open door;down"] = kill_npc,

    ["out1274"] = navigation, ["out1758"] = navigation, ["out3123"] = navigation, ["out3105"] = navigation,
    ["out1546"] = navigation, ["out1760"] = navigation, ["out2208"] = navigation,

    ["hit guan bing;north"] = hit_npc,   ["hit yideng shiwei;west"] = hit_npc,           ["hit yideng shiwei;south"] = hit_npc,
    ["hit ya yi;south"] = hit_npc,       ["hit ping si;north"] = hit_npc,                ["hit yideng shiwei;east"] = hit_npc,
    ["hit song bing;north"] = hit_npc,   ["hit xiao er;up"] = hit_npc,                   ["hit wu jiang;hit guan bing;northeast"] = hit_npc,
    ["hit ling tuisi;west"] = hit_npc,   ["hit ming ku;hit ming nan;enter"] = hit_npc,   ["hit wu jiang;hit guan bing;north"] = hit_npc,
    ["hit fu sigui;south"] = hit_npc,    ["hit wu jiang;hit guan bing;south"] = hit_npc,

    ["knock gate;north"] = open_door, ["move shi;enter"] = open_door,   ["dive cave;enter"] = open_door,     ["open door;down"] = open_door,
    ["open door;east"] = open_door,   ["open door;enter"] = open_door,  ["open door;north"] = open_door,     ["open door;northeast"] = open_door,
    ["open door;south"] = open_door,  ["open door;up"] = open_door,     ["open door;southwest"] = open_door, ["open door;west"] = open_door,
    ["open east;east"] = open_door,   ["open gate;south"] = open_door,  ["open west;west"] = open_door,      ["push dashi;enter"] = open_door,
    ["kneel"] = open_door,            ["push men;south"] = open_door,   ["knock lou"] = open_door,           ["push dashi;northdown"] = open_door,
    ["say 天堂有路你不走呀;down"] = open_door,

    ["climb up2935"] = quanzhen_cliff,    ["climb up3003"] = quanzhen_cliff,    ["climb up1422"] = quanzhen_cliff,
    ["climb down3003"] = quanzhen_cliff,  ["climb down2935"] = quanzhen_cliff,  ["climb down1404"] = quanzhen_cliff,
    ["climb down3244"] = quanzhen_cliff,  ["climb up3244"] = quanzhen_cliff,

    ["east2248"] = beijing_gate,   ["east2251"] = beijing_gate,   ["east2254"] = beijing_gate,   ["east2257"] = beijing_gate,
    ["south2260"] = beijing_gate,  ["south2263"] = beijing_gate,  ["south2266"] = beijing_gate,  ["west2269"] = beijing_gate,
    ["west2272"] = beijing_gate,   ["west2275"] = beijing_gate,   ["west2278"] = beijing_gate,   ["northwest2281"]  = beijing_gate,
    ["west2304"] = beijing_gate,   ["west2324"] = beijing_gate,   ["north2323"] = beijing_gate,  ["north2314"] = beijing_gate,
    ["east2313"] = beijing_gate,   ["east2294"] = beijing_gate,   ["north2324"] = beijing_gate,  ["southeast2294"] = beijing_gate,
    ["west2290"] = beijing_gate,   ["west2306"] = beijing_gate,   ["east2331"]  = beijing_gate,  ["east2336"] = beijing_gate,
    ["south2403"] = beijing_gate,  ["north2284"] = beijing_gate,

    ["northeast387"]  = emei_99guai,  ["eastdown388"] = emei_99guai,   ["westup387"] = emei_99guai,
    ["northeast389"] = emei_99guai,   ["southwest388"] = emei_99guai,  ["eastdown390"] = emei_99guai,
    ["westup389"] = emei_99guai,      ["southwest390"] = emei_99guai,  ["down388"] = emei_99guai,
    ["down389"] = emei_99guai,

    ["south3010"] = nanjiang_desert,      ["northwest3006"] = nanjiang_desert,   ["northeast1328"] = nanjiang_desert,
    ["southwest3007"] = nanjiang_desert,  ["northeast1979"] = nanjiang_desert,   ["southeast3008"] = nanjiang_desert,
    ["northeast3009"] = nanjiang_desert,   ["southwest1979"] = nanjiang_desert,

    ["east790"] = kitchen,  ["south1738"] = kitchen,  ["north2685"] = kitchen,  ["north681"] = kitchen,
    ["west430"] = kitchen,  ["west1107"] = kitchen,   ["open door;north760"] = kitchen,

    ["go1299"] = dynamic_exit,  ["go1301"] = dynamic_exit,  ["go1302"] = dynamic_exit,  ["go1530"] = dynamic_exit,
    ["go1432"] = dynamic_exit,  ["go1433"] = dynamic_exit,  ["go1434"] = dynamic_exit,

    ["up325"] = hotel,    ["up957"] = hotel,    ["up1258"] = hotel,
    ["up1391"] = hotel,   ["up1614"] = hotel,   ["up20"] = hotel,
    ["up2143"] = hotel,   ["up2318"] = hotel,   ["up3017"] = hotel,
}

local maze = {
    2970,2971,2792,2793,2974,
    3065,3066,3067,3068,3069,3070,3071,3074,
    3011,3012,1827,2988,2989,2990,
    2998,2999,3000,3001,
    2992,2993,2994,2995,2996,2997,3002,3016
}

function get_path(src, dst)
    local trace = {}
    trace[dst] = {cost = 10000}
    trace[src] = {step = "", cost = 0}
    local analyzing = {src}
    while #analyzing > 0 do
        local nxt = {}
        for _,i in ipairs(analyzing) do
            if trace[i].cost < trace[dst].cost - 1 then
                for k,v in pairs(map[i].links) do
                    local cost = (trace[i].cost or 0) + (map_attr.cost[k..tostring(v)] or map_attr.cost[k] or 1)
                    if trace[v] == nil then
                        trace[v] = {step = k, cost = cost, last = i}
                        set.append(nxt, v)
                    elseif cost < trace[v].cost then
                        trace[v] = {step = k, cost = cost, last = i}
                        set.append(nxt, v)
                    end
                end
            end
        end
        analyzing = nxt
    end
    local path,crt,nxt = {},dst,nil
    while crt ~= nil do
        path[crt] = trace[crt]
        path[crt].next = nxt
        nxt = crt
        crt = trace[crt].last
    end
    return path
end

function get_multipath(src, dst)
    local trace,cost = {},{}
    for _,v in ipairs(dst) do
        trace[v] = {cost = 10000}
        cost[v] = 10000
    end
    cost[src] = nil
    trace[src] = {step = "", cost = 0}
    local analyzing = {src}
    while #analyzing > 0 do
        local nxt = {}
        for _,i in ipairs(analyzing) do
            if trace[i].cost < set.max(table.values(cost)) - 1 then
                for k,v in pairs(map[i].links) do
                    local curent_cost = (trace[i].cost or 0) + (map_attr.cost[k..tostring(v)] or map_attr.cost[k] or 1)
                    if trace[v] == nil then
                        trace[v] = {step = k, cost = curent_cost, last = i}
                        if cost[v] ~= nil then
                            cost[v] = curent_cost
                        end
                        set.append(nxt, v)
                    elseif curent_cost < trace[v].cost then
                        trace[v] = {step = k, cost = curent_cost, last = i}
                        if cost[v] ~= nil then
                            cost[v] = curent_cost
                        end
                        set.append(nxt, v)
                    end
                end
            end
        end
        analyzing = nxt
    end
    local path = var.goto.multipath or {}
    local crt,nxt
    for k,_ in pairs(cost) do
        if trace[k].cost >= 10000 then
            cost[k] = nil
            trace[k] = nil
            set.delete(dst, k)
        elseif path[k] == nil or path[k][src] == nil then
            crt = k
            local temp = {}
            while crt ~= nil do
                if path[crt] == nil or path[crt][src] == nil then
                    if path[crt] == nil and cost[crt] ~= nil then
                        path[crt] = {}
                    end
                    for i,j in pairs(path) do
                        if j[src] == nil then
                            temp[i] = temp[i] or {}
                            temp[i][crt] = trace[crt]
                            if i ~= crt then
                                temp[i][crt].next = nxt
                                if cost[crt] ~= nil then
                                    path[i][crt] = table.deepcopy(temp[i])
                                elseif crt == src then
                                    path[i][crt] = table.deepcopy(temp[i])
                                end
                            end
                        end
                    end
                    nxt = crt
                    crt = trace[crt].last
                else
                    for i,_ in pairs(temp) do
                        if cost[i] ~= nil then
                            for j,_ in pairs(path[crt][src]) do
                                if cost[j] ~= nil then
                                    path[i][j] = table.union((path[i][j] or {}), (path[crt][j] or {[crt] = trace[crt]}))
                                    path[i][j][crt].next = nxt
                                    path[i][j] = table.union(path[i][j], temp[i])
                                elseif j == src then
                                    path[i][j] = table.union(path[crt][j], temp[i])
                                    path[i][j][crt].next = nxt
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end
    return path
end

function gonext(mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ gonext ］参数："..tostring(mode))
    if var.goto == nil then
        show("未知目的地", "red")
        return -1
    else
        var.goto.index = var.goto.index + 1
        if var.goto.index > #var.goto.room_ids then
            show(tostring(#var.goto.room_ids).." 个目的地已全部访问", "white")
            var.goto = nil
            return 1
        else
            if mode == "walk" then
                map_adjust("门派接引", "禁用", "过河", "渡船", "丐帮密道", "禁用")
            else
                map_adjust("门派接引", "启用", "过河", "大圣", "丐帮密道", "启用")
            end
            var.goto.thread = coroutine.running()
            var.goto.next = true
            trigger.add(nil, "faint()", "goto", {Enable=true}, 19, "^你的眼前一黑，接著什么也不知道了....$")
            trigger.add(nil, "tired()", "goto", {Enable=true}, 19, "^你已经精疲力尽，动弹不得。$")
            trigger.add(nil, "hinder()", "goto", {Enable=true}, 19, "^你的动作还没有完成，不能移动。$")
            trigger.add(nil, "terminate()", "goto", {Enable=true}, 19, "^鬼门关 - |^一道闪电从天降下，直朝你劈去……结果没打中！$")
            trigger.add(nil, "lost()", "goto", {Enable=true, StopEval=true}, 21, "^这个方向没有出路。$|^什么\\?$")
            trigger.add("goto_hide_ga", "", "goto", {Enable=true, Gag=true}, 1, "^> $")
            return goto_return(goto_move())
        end
    end
end

function goto(dst, mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ goto ］参数：dst = "..tostring(dst)..", mode = "..tostring(mode))
    var.goto = var.goto or {}
    var.goto.multipath = nil
    if mode == "walk" then
        map_adjust("门派接引", "禁用", "过河", "渡船", "丐帮密道", "禁用")
    else
        map_adjust("门派接引", "启用", "过河", "大圣", "丐帮密道", "启用")
    end
    if var.goto.thread == nil then
        var.goto.room_ids = parse(dst)
        var.goto.index = 1
        var.goto.thread = coroutine.running()
        trigger.add(nil, "faint()", "goto", {Enable=true}, 19, "^你的眼前一黑，接著什么也不知道了....$")
        trigger.add(nil, "tired()", "goto", {Enable=true}, 19, "^你已经精疲力尽，动弹不得。$")
        trigger.add(nil, "hinder()", "goto", {Enable=true}, 19, "^你的动作还没有完成，不能移动。$")
        trigger.add(nil, "terminate()", "goto", {Enable=true}, 19, "^鬼门关 - |^一道闪电从天降下，直朝你劈去……结果没打中！$")
        trigger.add(nil, "lost()", "goto", {Enable=true, StopEval=true}, 21, "^这个方向没有出路。$|^什么\\?$")
        trigger.add("goto_hide_ga", "", "goto", {Enable=true, Gag=true}, 1, "^> $")
        return goto_return(goto_move())
    else
        local interrupt = var.goto.pause
        var.goto.pause = function()
            var.goto.pause = nil
            var.goto.room_ids = parse(dst)
            var.goto.room_id = nil
            var.goto.index = 1
            var.goto.report = nil
            if var.goto.event ~= nil then
                var.goto.event = false
            end
            return 0
        end
        if interrupt == true then
            run("set 移动暂停")
        end
        return 1
    end
end

function goto_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ goto_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.goto == nil then
        return rc,msg
    end
    trigger.delete_group("goto")
    if rc < 0 then
        if #var.goto.room_ids == 0 then
            show("未知目的地", "orange")
        end
        show("移动失败", "red")
        var.goto = nil
    else
        var.goto.thread = nil
        var.goto.report = nil
        var.goto.room_id = nil
        if get_lines(-1)[1] ~= "> " then
            if wait_line(nil, 30, nil, 20, "^> $") == false then
                return -1
            end
        end
        show("移动成功", "green")
    end
    return rc,msg
end

function goto_relocate()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ goto_relocate ］")
    if #set.inter(env.current.id, {3003, 3244}) > 0 then
        env.current.id = { 3244 }
        return
    end
    if #set.inter(env.current.id, {1827, 2988, 2989, 2990}) > 0 then
        if map[var.goto.room_ids[var.goto.index]].zone == "西域白驼山" then
            var.goto.adjust = 1826
        else
            var.goto.adjust = 1327
        end
        env.current.id = { 2990 }
        local rc = xiyu_desert()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            env.current.id = {}
            return goto_move()
        else
            return
        end
    end
    local rc = one_step()
    if rc == 0 then
        return goto_move()
    elseif rc == 1 then
        if #env.current.exits == 0 then
            return -1
        end
        if state.nl >= 20 then
            return goto_relocate()
        end
        if dazuo() ~= 0 then
            return -1
        else
            if state.qx <= profile.dazuo then
                if yun_recover() ~= 0 then
                    return -1
                end
            else
                if yun_refresh() ~= 0 then
                    return -1
                end
                if state.jl > state.jl_max / 10 then
                    return goto_relocate()
                end
            end
        end
    else
        return -1
    end
    return goto_relocate()
end

function goto_move()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ goto_move ］")
    local rc
    while var.goto.pause ~= nil do
        if var.goto.pause() ~= 0 then
            return -1
        end
    end
    if #var.goto.room_ids == 0 then
        return -1
    end
    if env.current.name == "" then
        if wait_line("look", 30, nil, 20, "^\\S+\\s+- ", "^> $") == false then
            return -1
        end
    end
    if set.has({"大船", "小船", "小舟", "江船", "渡船"}, env.current.name) == true then
        if type(env.current.exits) == "string" then
            if env.current.exits == "" then
                env.current.exits = {}
            else
                env.current.exits = string.split(env.current.exits, "、")
            end
        end
        if #env.current.exits == 0 then
            rc = leave_transport()
            if rc < 0 then
                return -1
            elseif rc == 1 then
                return goto_move()
            end
        else
            if wait_line("out", 30, nil, 20, "^\\S+\\s+- ", "^> $") == false then
                return -1
            end
        end
    end
    rc = locate()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        rc = goto_relocate()
        if rc ~= nil then
            return rc
        end
        var.goto.adjust = nil
    end
    -- local room_id    全路径规划方案
    -- if false and #var.goto.room_ids > 1 then
    --     if var.goto.multipath == nil then
    --         var.goto.multipath = get_multipath(env.current.id[1], var.goto.room_ids)
    --         for _,v in ipairs(var.goto.room_ids) do
    --             get_multipath(v, var.goto.room_ids)
    --         end
    --         local all_cost = {}
    --         for _,v in ipairs(set.permute(var.goto.room_ids)) do
    --             set.append(all_cost, 0)
    --             for i = 1, #v, 1 do
    --                 local from,to = v[i-1] or env.current.id[1],v[i]
    --                 local sub_cost = (var.goto.multipath[to] or {})[from] or {}
    --                 sub_cost = ((sub_cost[to] or {}).cost or 0) - ((sub_cost[from] or {}).cost or 0)
    --                 all_cost[#all_cost] = set.last(all_cost) + sub_cost
    --                 if set.last(all_cost) >= (all_cost[#all_cost-1] or 10000) then
    --                     all_cost[#all_cost] = all_cost[#all_cost-1]
    --                     break
    --                 end
    --             end
    --             if all_cost[#all_cost] < (all_cost[#all_cost-1] or 10000) then
    --                 var.goto.room_ids = v
    --             end
    --         end
    --         room_id = var.goto.room_ids[var.goto.index]
    --         var.goto.path = var.goto.multipath[room_id][env.current.id[1]]
    --     else
    --         room_id = var.goto.room_ids[var.goto.index]
    --         if var.goto.next == true then
    --             var.goto.next = nil
    --             var.goto.path = var.goto.multipath[room_id][env.current.id[1]] or get_path(env.current.id[1], room_id)
    --         else
    --             var.goto.path = get_path(env.current.id[1], room_id)
    --         end
    --     end
    -- else
    --     room_id = var.goto.room_ids[var.goto.index]
    --     var.goto.path = get_path(env.current.id[1], room_id)
    -- end
    var.goto.room_id = var.goto.room_ids[var.goto.index]
    var.goto.path = get_path(env.current.id[1], var.goto.room_id)
    if var.goto.report == nil then
        show("准备前往："..tostring(var.goto.room_id).."（"..tostring(var.goto.index).." / "..tostring(#var.goto.room_ids).."）", "white")
        var.goto.report = true
    end
    if var.goto.path[var.goto.room_id].cost >= 10000 then
        return -1
    end
    return goto_exec(env.current.id[1])
end

function goto_exec(current_id)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ goto_exec ］")
    if current_id == nil or var.goto.path[current_id] == nil then
        return goto_move()
    end
    local next_id = var.goto.path[current_id].next
    local pause_msg,flood = "移动完成",global.flood
    local path,path_overflow = {},{}
    local overflow_id,event
    while next_id ~= nil do
        event = map_events[var.goto.path[next_id].step..tostring(next_id)] or
                map_events[var.goto.path[next_id].step]
        if event ~= nil then
            pause_msg = "地图事件"
            break
        end
        if flood > config.flood then
            if #path_overflow == 0 and (var.goto.path[next_id].last == 3039 or
               set.has(maze, next_id) == true and set.has(maze, var.goto.path[next_id].last) == true) then
                set.append(path, var.goto.path[next_id].step)
                current_id = next_id
                overflow_id = current_id
            else
                set.append(path_overflow, var.goto.path[next_id].step)
                overflow_id = next_id
                if flood > config.flood + 10 then
                    path_overflow = {}
                    pause_msg = "稍事休息"
                    break
                end
            end
        else
            set.append(path, var.goto.path[next_id].step)
            current_id = next_id
            overflow_id = current_id
        end
        flood = flood + string.count(var.goto.path[next_id].step, ";") + 1
        next_id = var.goto.path[next_id].next
    end
    if #path_overflow > 0 then
        set.extend(path, path_overflow)
        current_id = overflow_id
    end
    run(set.concat(path, ";"))
    local l = wait_line("set "..pause_msg,
                        30, {StopEval=true}, 20,
                        "^你目前还没有任何为 ((?:移动完成|稍事休息|地图事件)) 的变量设定。$")
    if l == false then
        return -1
    end
    while var.goto.pause ~= nil do
        if var.goto.pause() ~= 0 then
            return -1
        else
            return goto_move()
        end
    end
    if l[1] == "移动完成" then
        trigger.disable("goto_hide_ga")
        if locate() < 0 then
            return -1
        end
        if env.current.name == map[var.goto.room_id].name and 
           set.has(env.current.id, var.goto.room_id) == true then
            env.current.id = { var.goto.room_id }
            if var.goto.event ~= nil then
                trigger.enable("goto_hide_ga")
            end
            return 0
        else
            trigger.enable("goto_hide_ga")
            return goto_move()
        end
    elseif l[1] == "稍事休息" then
        env.current.id = get_room_id_by_name(env.current.name)
        if #env.current.id > 1 then
            if type(env.current.desc) == "table" and #env.current.desc > 0 then
                env.current.desc = set.concat(env.current.desc)
                env.current.id = get_room_id_by_desc(env.current.desc, env.current.id)
            end
            if #env.current.id > 1 then
                if type(env.current.exits) == "string" then
                    if env.current.exits == "" then
                        env.current.exits = {}
                    else
                        env.current.exits = string.split(env.current.exits, "[和 、]+")
                    end
                end
                env.current.id = get_room_id_by_exits(env.current.exits, env.current.id)
            end
        end
        if env.current.name == map[current_id].name and set.has(env.current.id, current_id) == true then
            env.current.id = { current_id }
        else
            return goto_move()
        end
        var.goto.pause = true
        l = wait_line(nil,
                      1, {StopEval=true}, 20,
                      "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                      "^你的眼前一黑，接著什么也不知道了....$|"..
                      "^鬼门关 - $|"..
                      "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if l == false then
            global.flood = 0
        else
            return goto_move()
        end
    else
        env.current.id = { current_id }
        local rc = event()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return goto_move()
        end
        current_id = env.current.id[1]
        while var.goto.pause ~= nil do
            if var.goto.pause() ~= 0 then
                return -1
            else
                return goto_move()
            end
        end
    end
    return goto_exec(current_id)
end

function parse(dst)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ parse ］参数：dst = "..tostring(dst))
    if type(dst) == "table" then
        return dst
    elseif type(dst) == "number" or string.find(dst, "^%d+$") then
        return {tonumber(dst)}
    else
        local parse_result
        parse_result = get_room_id_by_name(dst)
        if #parse_result == 0 then
            for _,v in ipairs(table.keys(map_attr.zone)) do
                if string.match(dst, "^"..v) then
                    local name = string.gsub(dst, v, "", 1)
                    local zone = map_attr.zone[v]
                    if name == "外土路" then
                        zone = "华山"
                        name = "村外土路"
                    end
                    parse_result = get_room_id_by_name(name)
                    if #parse_result > 1 then
                        parse_result = get_room_id_by_zones({zone}, parse_result)
                    end
                    break
                end
            end
            if #parse_result == 0 then
                parse_result = get_room_id_by_npc(dst)
                if #parse_result == 0 then
                    parse_result = get_room_id_by_tag(dst)
                    if #parse_result == 0 then
                        parse_result = get_room_id_by_item(dst)
                    end
                end
            end
        end
        return parse_result
    end
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
