--[[
========================
  通用函数模块
========================
  verbose(level)                    调试打印，根据传入的打印级别( level )打印当前正在调用的函数信息。level 支持：none, info, trace
  run_i()                           在游戏中执行命令 i 并等待完成相应的屏幕输出
  run_hp()                          在游戏中执行命令 hp 并等待完成相应的屏幕输出
  run_score()                       在游戏中执行命令 score 并等待完成相应的屏幕输出
  run_skills()                      在游戏中执行命令 skills 并等待完成相应的屏幕输出
  run_enable()                      在游戏中执行命令 enable 并等待完成相应的屏幕输出
  run_prepare()                     在游戏中执行命令 prepare 并等待完成相应的屏幕输出
  run_set()                         在游戏中执行命令 set 并等待完成相应的屏幕输出
  run_list()                        在游戏中执行命令 list 并等待完成相应的屏幕输出
  jia_min()                         将角色当前的 jiali, jiajin 设为最小值
  jia_max()                         将角色当前的 jiali, jiajin 设为最大值
  obj_analysis(obj)                 解析对象字符串，得到对应的数量、中文名、英文ID
  compare_carryon(before, after)    对比两组
  chs2num(s)                        中文数字转换为阿拉伯数字
  timec2n(hour, quater)             干支时间转换为二十四小时制
  is_own(item)                      判断是否持有指定物品
  is_fighting()                     判断是否正在战斗
--]]
require "items"

show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

function verbose(level)
    global.debug.level = global.debug[level] or 0
    if global.debug.level == 2 then
        disable_trigger("hide_set_value")
        disable_trigger("hide_ga")
    else
        enable_trigger("hide_set_value")
        enable_trigger("hide_ga")
    end
    if level == "none" then
        show("调试输出已关闭", "orange")
    else
        show("当前调试输出级别："..level, "orange")
    end
end

function run_i()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_i ］")
    if wait_line("i", 30, nil, 10, "^你\\(你\\)身上携带物品的别称如下\\(右方\\)：$|^目前你身上没有任何东西。$") == false then
        return -1
    else
        if wait_line(nil, 30, {Gag=true}, 11, "^> $") == false then
            return -1
        else
            return 0
        end
    end
end

function run_hp()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_hp ］")
    if wait_line("hp", 30, nil, 10, "^\\s+饮水：\\s+\\d+/\\s+\\d+\\s+经验：\\s+[-\\d]+$") == false then
        return -1
    else
        if wait_line(nil, 30, {Gag=true}, 11, "^> $") == false then
            return -1
        else
            return 0
        end
    end
end

function run_score()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_score ］")
    if wait_line("score", 30, {Gag=true}, 11, "^└[─]+ Brotherhood ─┘$", "^> $") == false then
        return -1
    else
        return 0
    end
end

function run_skills()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_skills ］")
    if wait_line("skills", 30, {Gag=true}, 11, "^你目前所学过的技能：（共\\S+项技能）[　]+$", "^> $") == false then
        return -1
    else
        return 0
    end
end

function run_enable()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_enable ］")
    if wait_line("enable", 30, {Gag=true}, 11, "^以下是你目前使用中的特殊技能。$", "^> $") == false then
        return -1
    else
        return 0
    end
end

function run_prepare()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_prepare ］")
    if wait_line("prepare", 30, nil, 10, "^以下是你目前组合中的特殊拳术技能。$|^你现在没有组合任何特殊拳术技能。$") == false then
        return -1
    else
        if wait_line(nil, 30, {Gag=true}, 11, "^> $") == false then
            return -1
        else
            return 0
        end
    end
end

function run_set()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_set ］")
    if wait_line("set", 30, {Gag=true}, 11, "^你目前设定的环境变量有：$", "^> $") == false then
        return -1
    else
        return 0
    end
end

function run_list()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ run_list ］")
    if wait_line("list", 30, {Gag=true}, 11, "^你保存的物品如下:$", "^> $") == false then
        return -1
    else
        return 0
    end
end

function jia_min()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ jia_min ］")
    local action = {}
    if state.power > 0 then
        set.append(action, "jiali none")
        state.power = 0
    end
    if state.energy > 1 then
        set.append(action, "jiajin 1")
        state.energy = 1
    end
    run(set.concat(action, ";"))
end

function jia_max()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ jia_max ］")
    local action = {}
    if state.power == 0 then
        set.append(action, "jiali max")
    end
    if state.energy == 1 then
        set.append(action, "jiajin max")
    end
    run(set.concat(action, ";"))
end

function obj_analysis(obj)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ obj_analysis ］参数：obj = "..tostring(obj))
    local count,name,id
    local unit = {"两", "文", "件", "顶", "柄", "盆", "把", "捆", "杯", "根", "条", "块", "串", "封", "个", "杆", "对", "包", "副", "位", "名", "团",
                  "本", "部", "钱", "面", "锭", "只", "瓶", "盘", "粒", "碟", "碗", "棵", "颗", "枚", "支", "张", "朵", "双", "册", "页", "辆"}
    for _,v in ipairs(unit) do
        _,_,count,name,id = string.find(obj, "%s*(%S+)"..v.."(%S+)%(([ %w]+)%)")
        if name then
            count = chs2num(count)
            if name == "布袋" then count = 1 end
            if count > 0 then
                return count,name..":"..string.lower(id),name,string.lower(id)
            end
        end
    end
    _,_,name,id = string.find(obj, "%s*(%S+)%(([ %w]+)%)")
    return 1,name..":"..string.lower(id),name,string.lower(id)
end

function compare_carryon(before, after)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ compare_carryon ］参数：before = "..table.tostring(before)..", after = "..table.tostring(after))
    local delta = {}
    for k,v in pairs(after) do
        if before[k] == nil then
            delta[k] = delta[k] or 0
            delta[k] = delta[k] + v.count
        else
            if before[k].count < v.count then
                delta[k] = v.count - before[k].count
            end
        end
    end
    return delta
end

function chs2num(s)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ chs2num ］参数：s = "..tostring(s))
    if type(s) ~= "string" or s == "" then
        return 0
    else
        local c = 1
        if string.match(s, "负") then
            s = string.gsub(s, "负", "")
            c = -1
        end

        s = string.gsub(s, "零", "*0+")
        s = string.gsub(s, "十", "*10+")
        s = string.gsub(s, "百", "*100+")
        s = string.gsub(s, "千", "*1000+")
        s = string.gsub(s, "万", "+0)*10000+(0+")
        s = string.gsub(s, "亿", "+0)*100000000+(0+")
        s = string.gsub(s, "一", "1")
        s = string.gsub(s, "二", "2")
        s = string.gsub(s, "三", "3")
        s = string.gsub(s, "四", "4")
        s = string.gsub(s, "五", "5")
        s = string.gsub(s, "六", "6")
        s = string.gsub(s, "七", "7")
        s = string.gsub(s, "八", "8")
        s = string.gsub(s, "九", "9")
        s = string.gsub(s, " ", "")
        s = string.gsub(s, "？", "")
        s = string.gsub(s, "　", "")
        s = "(0+"..s.."+0)"
        s = string.gsub(s, "++", "+")
        s = string.gsub(s, "+%*", "+")

        if string.match(s, '^[%d%+%-%*%/%(%)]+$') then
            s = "return "..s
            local m = loadstring(s)
            s = m()
            m = nil
            return s*c
        end
        return 0
    end
end

function chs2time(s)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ chs2time ］参数：s = "..tostring(s))
    local t = {year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0}
    local m = {["年"] = "year", ["月"] = "month", ["天"] = "day", ["小时"] = "hour", ["分钟"] = "minute", ["秒"] = "second"}
    s = string.gsub(s, "又", "")
    s = string.gsub(s, "个", "")
    for _,v in ipairs({"年", "月", "天", "小时", "分钟", "秒"}) do
        local _,e,n = string.find(s, "(%S+)"..v)
        s = string.sub(s, (e or 0) + 1)
        t[m[v]] = chs2num(n) or 0
    end
    t.day = 1970 + t.day
    return t
end

function timec2n(hour, quater)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ timec2n ］参数：hour = "..tostring(hour)..", quater = "..tostring(quater))
    local ctime_table = {
        ["子"] = 0,
        ["丑"] = 2,
        ["寅"] = 4,
        ["卯"] = 6,
        ["辰"] = 8,
        ["巳"] = 10,
        ["午"] = 12,
        ["未"] = 14,
        ["申"] = 16,
        ["酉"] = 18,
        ["戌"] = 20,
        ["亥"] = 22,
        ["正"] = 0.0,
        ["一刻"] = 0.5,
        ["二刻"] = 1.0,
        ["三刻"] = 1.5
    }
    local num = ctime_table[hour] + ctime_table[quater]
    return num
end

function is_own(item)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ is_own ］参数：item = "..tostring(item))
    if carryon.inventory[item] ~= nil then
        return true
    else
        for k,v in pairs(carryon.container) do
            if v[item] ~= nil then
                return k
            end
        end
        return false
    end
end

function is_fighting() -- 0: no fight   1: fight
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ is_fighting ］")
    add_trigger("fighting_hide_ga", "", nil, {Enable=true, StopEval=true, Gag=true}, 1, "^> $")
    repeat
        local l = wait_line("yun lifeheal", 30, {Gag=false}, 10, "^战斗中无法运功疗伤！$|"..
                                                                 "^你要用真气为谁疗伤？$|"..
                                                                 "^你要替谁治疗伤口？$|"..
                                                                 "^\\( 你上一个动作还没有完成，不能施用内功。\\)$")
        if l == false then
            return -1
        elseif l[0] == "你要用真气为谁疗伤？" or l[0] == "你要替谁治疗伤口？" then
            del_trigger("fighting_hide_ga")
            if wait_line(nil, 30, {Gag=true}, 10, "^> $") == false then
                return -1
            else
                return 0
            end
        elseif l[0] == "战斗中无法运功疗伤！" then
            del_trigger("fighting_hide_ga")
            if wait_line(nil, 30, {Gag=true}, 10, "^> $") == false then
                return -1
            else
                return 1
            end
        else
            wait(0.1)
        end
    until false
end
--function keep_pots(pots)
--    local l,w
--    if tonumber(GetVariable("pot")) + tonumber(GetVariable("pot_saved")) >= pots then
--        if tonumber(GetVariable("pot")) == pots then
--            return true
--        else
--            if GetVariable("room_id") ~= "2399" then
--                flyto(2399)
--                l,_ = wait.regexp("^[>\\s]*你目前还没有任何为 移动(?:完成|失败) 的变量设定。$", 180)
--                if no_response(l) or string.find(l, "移动失败") then
--                    return false
--                end
--            end
--            if tonumber(GetVariable("pot")) > pots then
--                if tonumber(GetVariable("pot_saved")) >= tonumber(GetVariable("exp")) then
--                    Execute("qu "..GetVariable("pot_saved"))
--                    l,w = wait.regexp("^[>\\s]*你取出了(\\d+)点潜能。$", 30)
--                    if no_response(l) then return nil end
--                    SetVariable("pot", tonumber(GetVariable("pot")) + tonumber(w[1]))
--                    SetVariable("pot_saved", 0)
--                    Execute("cun "..tostring(tonumber(GetVariable("pot")) - pots))
--                    l,w = wait.regexp("^[>\\s]*你存储了(\\d+)点潜能。$", 30)
--                    if no_response(l) then return nil end
--                    SetVariable("pot", pots)
--                    SetVariable("pot_saved", w[1])
--                else
--                    Execute("cun "..tostring(tonumber(GetVariable("pot")) - pots))
--                    l,w = wait.regexp("^[>\\s]*你存储了(\\d+)点潜能。$", 30)
--                    if no_response(l) then return nil end
--                    SetVariable("pot", pots)
--                    SetVariable("pot_saved", tonumber(GetVariable("pot_saved")) + tonumber(w[1]))
--                end
--            else
--                Execute("qu "..tostring(pots - tonumber(GetVariable("pot"))))
--                l,w = wait.regexp("^[>\\s]*你取出了(\\d+)点潜能。$", 30)
--                if no_response(l) then return nil end
--                SetVariable("pot", pots)
--                SetVariable("pot_saved", tonumber(GetVariable("pot_saved")) - tonumber(w[1]))
--            end
--            return true
--        end
--    else
--        return false
--    end
--end
--


--function get_range(rooms, range)
--    if type(rooms) ~= "table" then
--        rooms = string.split(rooms, "|")
--    end
--
--    if type(range) ~= "number" then
--        range = tonumber(range) or 0
--    end
--
--    local rid_list = {}
--    for _,v in ipairs(rooms) do
--        rid_list[v] = range
--    end
--
--    for _,v in ipairs(rooms) do
--        message("#"..debug.getinfo(1).currentline.." [get_range] 将被用于查询的房间号："..table.tostring(rid_list))
--        if rid_list[v] > 0 then
--            if rid_list[v] == range then
--                range = range - 1
--            end
--            message("#"..debug.getinfo(1).currentline.." [get_range] 查询房间号为 "..v.." 的相邻房间")
--            for i,j in pairs(map[v].links) do
--                if rid_list[i] == nil then
--                    message("#"..debug.getinfo(1).currentline.." [get_range] 房间 "..i.." 在范围内")
--                    local exit
--                    if type(j) == "table" then
--                        for _,m in ipairs(j) do
--                            if string.find(m, ";") then
--                                exit = string.split(m, ";")
--                                exit = exit[#exit]
--                            else
--                                exit = m
--                            end
--                            if is_dir(exit) or exit == "look" then
--                                rid_list[i] = range
--                                set.append(rooms, i)
--                                message("#"..debug.getinfo(1).currentline.." [get_range] 当前已知范围内的房间号："..table.tostring(rooms))
--                                break
--                            end
--                        end
--                    else
--                        if string.find(j, ";") then
--                            exit = string.split(j, ";")
--                            exit = exit[#exit]
--                        else
--                            exit = j
--                        end
--                        if is_dir(exit) or exit == "look" then
--                            rid_list[i] = range
--                            set.append(rooms, i)
--                            message("#"..debug.getinfo(1).currentline.." [get_range] 当前已知范围内的房间号："..table.tostring(rooms))
--                        end
--                    end
--                end
--            end
--        else
--            break
--        end
--    end
--    return rooms
--end
--
--function clean_spirit(spirit)
--    if spirit == nil then
--        spirit = 0
--    end
--
--    if type(spirit) ~= "number" then
--        return false
--    end
--
--    if spirit < dbg0 then
--        return false
--    end
--
--    --待追加如果wuji，先散工
--    send_cmd("score")
--    repeat
--        if math.abs(tonumber(GetVariable("spirit"))) <= spirit then
--            if GetVariable("room_id") == "1790" then
--                wait_nobusy()
--            end
--            return true
--        end
--        if GetVariable("room_id") ~= "1790" then
--            flyto(1790)
--            l,_ = wait.regexp("^[>\\s]*你目前还没有任何为 移动(?:完成|失败) 的变量设定。$", 180)
--            if no_response(l) or string.find(l, "移动失败") then
--                message("#"..debug.getinfo(1).currentline.." [clean_spirit] 放弃降神")
--                return false
--            end
--        end
--
--        if math.abs(tonumber(GetVariable("spirit"))) < 40 then
--            if math.abs(tonumber(GetVariable("spirit"))) - 10 > spirit then
--                for i = 1,10 do
--                Execute("mianbi")
--                end
--                flood = flood + 10
--            else
--                Execute("mianbi")
--                flood = flood + 1
--            end
--        elseif math.abs(tonumber(GetVariable("spirit"))) * math.pow(0.95, 10) >= spirit then
--            for i = 1,10 do
--                Execute("mianbi")
--            end
--            flood = flood + 10
--        else
--            Execute("mianbi")
--            flood = flood + 1
--        end
--        send_cmd("score")
--        if flood > 30 then
--            wait.time(1)
--            flood = 0
--        end
--    until false
--end

show(" 已加载", "green")