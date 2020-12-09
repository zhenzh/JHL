show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

link_dir = {
    ["tang coffin"]                                                                               = false,
    ["west;west;west;west;west;west;west;west;west;west"]                                         = false,
    ["search"]                                                                                    = false,
    ["jump 牛心石"]                                                                               = false,
    ["kneel"]                                                                                     = false,
    ["time"]                                                                                      = false,
    ["climb up"]                                                                                  = false,
    ["climb down"]                                                                                = false,
    ["jump fubing"]                                                                               = false,
    ["jump bingshan"]                                                                             = false,
    ["look"]                                                                                      = false,
    ["look 1434"]                                                                                 = false,
    ["look 1432"]                                                                                 = false,
    ["look 1302"]                                                                                 = false,
    ["look 1299"]                                                                                 = false,
    ["north;north;north"]                                                                         = false,
    ["bang song;climb down"]                                                                      = false,
    ["jump back"]                                                                                 = false,
    ["bang tree;climb"]                                                                           = false,
    ["dlyidengsite-slw"]                                                                          = false,
    ["move gang"]                                                                                 = false,
    ["climb"]                                                                                     = false,
    ["play qin"]                                                                                  = false,
    ["walk"]                                                                                      = false,
    ["pa shang"]                                                                                  = false,
    ["look boat;jump boat"]                                                                       = false,
    ["out;out;out;out;out;out;out;out;out;out;out"]                                               = false,
    ["climb wall"]                                                                                = false,
    ["back"]                                                                                      = false,
    ["front"]                                                                                     = false,
    ["jump island"]                                                                               = false,
    ["fly bank"]                                                                                  = false,
    ["jump window"]                                                                               = false,
    ["enter 第四株"]                                                                              = false,
    ["kneel cave;enter;use fire;kneel grave;out;west"]                                            = false,
    ["enter dong"]                                                                                = false,
    ["pa xia"]                                                                                    = false,
    ["jump wall"]                                                                                 = false,
    ["qu murong"]                                                                                 = false,
    ["south;south;south;south;south;south"]                                                       = false,
    ["north;north;north;north;north;north"]                                                       = false,
    ["climb cliff"]                                                                               = false,
    ["look 崖;jump qiaobi"]                                                                       = false,
    ["tui boat;jump boat"]                                                                        = false,
    ["south;south;south"]                                                                         = false,
    ["south;south;south;south;south"]                                                             = false,
    ["ask gate keeper about 矿区"]                                                                = false,
    ["push left;push left;push left;push right;push right;push right;push front;enter"]           = false,
    ["jump up"]                                                                                   = false,
    ["qu matou"]                                                                                  = false,
    ["qu xiaozhu"]                                                                                = false,
    ["tan qin"]                                                                                   = false,
    ["zou tiesuo"]                                                                                = false,
    ["east;east;east;east;east;east;east;east;east;east"]                                         = false,
    ["west;west;west;west;west;west;west;west;west;west;west"]                                    = false,
    ["southwest;southeast;north;south;west;east;west;east;east;south;west;north;northwest;north"] = false,
    ["east;east;east;east;east;east;east;east;east;east;east"]                                    = false,
    ["follow hudie"]                                                                              = false,
    ["fly ting"]                                                                                  = false,
    ["chop shuzhi"]                                                                               = false,
    ["press 谦"]                                                                                  = false,
    ["get eluan shi;jump tan"]                                                                    = false,
    ["pa up"]                                                                                     = false,
    ["swim down"]                                                                                 = false,
    ["jump valley"]                                                                               = false,
    ["tie stone;climb down"]                                                                      = false,
    ["jump 雪坑"]                                                                                 = false,
    ["drop eluan shi;swim up"]                                                                    = false,
    ["drop eluan shi;swim light"]                                                                 = false,
    ["look skeleton;"]                                                                            = false,
    ["swim up"]                                                                                   = false,
    ["kill nv lang;northdown"]                                                                    = "northdown",
    ["kill jiading;westup"]                                                                       = "westup",
    ["zhuan ball;down"]                                                                           = "down",
    ["move stone;enter"]                                                                          = "enter",
    ["open door;north"]                                                                           = "north",
    ["kill lao denuo;west"]                                                                       = "west",
    ["kill lao denuo;south"]                                                                      = "south",
    ["kill shuo bude;up"]                                                                         = "up",
    ["kill jiaozhong;north"]                                                                      = "north",
    ["hit yideng shiwei;west"]                                                                    = "west",
    ["hit yideng shiwei;south"]                                                                   = "south",
    ["hit yideng shiwei;east"]                                                                    = "east",
    ["kill wugen daoren;northup"]                                                                 = "northup",
    ["kill jing xin;south"]                                                                       = "south",
    ["greet hu;east"]                                                                             = "east",
    ["open gate;south"]                                                                           = "south",
    ["knock lou;enter"]                                                                           = "enter",
    ["ask sha gu about 玩;agree;enter"]                                                           = "enter",
    ["give 5 silver to xiao er;up"]                                                               = "up",
    ["kill shou wei;north"]                                                                       = "north",
    ["kill jian zhanglao;east"]                                                                   = "east",
    ["kill xiao lan;east"]                                                                        = "east",
    ["kill xiao lan;west"]                                                                        = "west",
    ["hit ping si;north"]                                                                         = "north",
    ["kill wang furen;up"]                                                                        = "up",
    ["yell boat;enter"]                                                                           = "enter",
    ["open door;south"]                                                                           = "south",
    ["kill yue lingshan;west"]                                                                    = "west",
    ["open door;enter"]                                                                           = "enter",
    ["open east;east"]                                                                            = "east",
    ["kill xihua zi;south"]                                                                       = "south",
    ["kill zhang songxi;east"]                                                                    = "east",
    ["kill zhang songxi;south"]                                                                   = "south",
    ["kill zhang songxi;west"]                                                                    = "west",
    ["tui wall;down"]                                                                             = "down",
    ["hit fu sigui;south"]                                                                        = "south",
    ["kill du dajin;enter"]                                                                       = "enter",
    ["kill binu;westup"]                                                                          = "westup",
    ["push dashi;enter"]                                                                          = "enter",
    ["kill lu dayou;south"]                                                                       = "south",
    ["push dashi;northdown"]                                                                      = "northdown",
    ["move jiashan;enter"]                                                                        = "enter",
    ["kill shi sao;north"]                                                                        = "north",
    ["push men;south"]                                                                            = "south",
    ["open door;up"]                                                                              = "up",
    ["kill xiao wei;south"]                                                                       = "south",
    ["ask jiang baisheng about 上山;northup"]                                                     = "northup",
    ["say 青衫磊落险峰行;northeast"]                                                                = "northeast",
    ["kill caihua zi;enter"]                                                                      = "enter",
    ["strike wall;out"]                                                                           = "out",
    ["kill yideng shiwei;north"]                                                                  = "north",
    ["give 10 silver to yu zu;south"]                                                             = "south",
    ["kill jielv seng;north"]                                                                     = "north",
    ["yell chuan;enter"]                                                                          = "enter",
    ["yell chuan"]                                                                                = "enter",
    ["zhuan ball;up"]                                                                             = "up",
    ["open door;west"]                                                                            = "west",
    ["kill gongsun zhi;north"]                                                                    = "north",
    ["kill fan yiweng;north"]                                                                     = "north",
    ["open door;east"]                                                                            = "east",
    ["kill qiu shanfeng;enter"]                                                                   = "enter",
    ["open west;west"]                                                                            = "west",
    ["kill zhang zhiguang;westup"]                                                                = "westup",
    ["hit song bing;north"]                                                                       = "north",
    ["kill huangshan nuzi;west"]                                                                  = "west",
    ["kill zhuang han;enter"]                                                                     = "enter",
    ["kill hu laoye;east"]                                                                        = "east",
    ["an stone;down"]                                                                             = "down",
    ["open door;down"]                                                                            = "down",
    ["kill huangshan nuzi;east"]                                                                  = "east",
    ["kill ge lunbu;north"]                                                                       = "north",
    ["kill shi daizi;west"]                                                                       = "west",
    ["hit ya yi;south"]                                                                           = "south",
    ["hit ming ku;hit ming nan;enter"]                                                            = "enter",
    ["kill shihou zi;west"]                                                                       = "west",
    ["kill shihou zi;northdown"]                                                                  = "northdown",
    ["kill gao genming;northup"]                                                                  = "northup",
    ["kill yin jin;north"]                                                                        = "north",
    ["kill ouyang feng;open door;down"]                                                           = "down",
    ["kill qingguan biqiu;open door;north"]                                                       = "north",
    ["kill ning zhongze;south"]                                                                   = "south",
    ["kill ning zhongze;east"]                                                                    = "east",
    ["kill ning zhongze;west"]                                                                    = "west",
    ["kill ya huan;east"]                                                                         = "east",
    ["kill jia ding;east"]                                                                        = "east",
    ["kill gongye qian;enter"]                                                                    = "enter",
    ["dive cave;enter"]                                                                           = "enter",
    ["mianbi;strike wall;enter"]                                                                  = "enter",
    ["kill liang fa;east"]                                                                        = "east",
    ["say 天堂有路你不走呀;down"]                                                                    = "down",
    ["kill wu shi;open door;west"]                                                                = "west",
    ["kill guan bing;north"]                                                                      = "north",
    ["kill wei shi;open door;west"]                                                               = "west",
    ["kill huikong zunzhe;northup"]                                                               = "northup",
    ["kill changle bangzhong;east"]                                                               = "east",
    ["hit ling tuisi;west"]                                                                       = "west",
    ["kill menggu junguan;southeast"]                                                             = "southeast",
    ["kill tan chuduan;up"]                                                                       = "up",
    ["kill qingle biqiu;north"]                                                                   = "north",
    ["kill wu shi;north"]                                                                         = "north",
    ["kill xuming;kill xutong;eastup"]                                                            = "eastup",
    ["knock gate;north"]                                                                          = "north",
    ["open door;southwest"]                                                                       = "southwest",
    ["hit wu jiang;hit guan bing;north"]                                                          = "north",
    ["open door;northeast"]                                                                       = "northeast",
    ["hit wu jiang;hit guan bing;south"]                                                          = "south",
    ["wield jian;strike wall;out"]                                                                = "out",
    ["use fire;left"]                                                                             = "left",
    ["kill situ heng;north"]                                                                      = "north",
    ["move shi;enter"]                                                                            = "enter",
    ["hit wu jiang;hit guan bing;northeast"]                                                      = "northeast",
    ["hit guan bing;north"]                                                                       = "north",
    ["out1048"] = "out",
    ["out1526"] = "out",
    ["out2048"] = "out",
    ["out2647"] = "out",
    ["out1554"] = "out",
    ["out1708"] = "out",
    ["out2782"] = "out",
    ["out1049"] = "out",
    ["out1528"] = "out",
    ["out2049"] = "out",
    ["out2794"] = "out",
    ["out1091"] = "out",
    ["out2750"] = "out",
    ["out2783"] = "out",
    ["out1507"] = "out",
    ["out1508"] = "out",
    ["out2074"] = "out",
    ["out1365"] = "out",
    ["out1460"] = "out",
    ["out1531"] = "out",
    ["out2751"] = "out",
    ["out1274"] = "out",
    ["out1758"] = "out",
    ["out3123"] = "out",
    ["out1760"] = "out",
    ["out2208"] = "out",
    ["out1546"] = "out",
    ["out3105"] = "out",
}

function locate(ids)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ locate ］")
    if #env.current.id == 1 then
        return locate_return(0)
    end
    if env.current.name == "" then
        if wait_line("look", 30, nil, 10, "^\\S+\\s+- ", "^> $") == false then
            return locate_return(-1)
        end
        env.current.id = ids or env.current.id
    end
    if env.current.name == "" then
        return locate_return(-1)
    end
    if env.current.name == "海船" then
        local rc = locate_navigation()
        if rc ~= nil then
            return locate_return(rc)
        end
    end
    if #env.current.id > 0 then
        env.current.id = get_room_id_by_name(env.current.name, env.current.id)
    else
        env.current.id = get_room_id_by_name(env.current.name)
    end
    if #env.current.id > 1 then
        if type(env.current.exits) == "string" then
            if env.current.exits == "" then
                env.current.exits = {}
            else
                env.current.exits = string.split(string.gsub(env.current.exits, " 和 ", "、"), "、")
            end
        end
        env.current.id = get_room_id_by_exits(env.current.exits, env.current.id)
    end
    if #env.current.id > 1 and #env.current.zone > 0 then
        env.current.id = get_room_id_by_zones(env.current.zone, env.current.id)
    end
    if #env.current.id > 1 then
        if type(env.current.desc) == "table" then
            if #env.current.desc > 0 then
                env.current.desc = set.concat(env.current.desc)
            else
                env.current.name = ""
                return locate(env.current.id)
            end
        end
        env.current.id = get_room_id_by_desc(env.current.desc, env.current.id)
    end
    if #env.current.id > 1 then
        for _,v in ipairs(env.current.exits) do
            local rc = look_dir(v)
            if rc == 1 then
                env.current.name = ""
                return locate(env.current.id)
            else
                if rc == 0 then
                    rc = locate_nextto()
                end
                if rc < 0 then
                    env.current.id = {}
                    break
                end
                env.current.id = get_room_id_by_roomsto(env.nextto.id, v, env.current.id)
                if #env.current.id <= 1 then
                    break
                end
            end
        end
    end
    if #env.current.id == 0 then
        return locate_return(-1)
    end
    if #env.current.id == 1 then
        return locate()
    end
    return locate_return(1)
end

function locate_return(rc)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ locate_return ］参数：rc = "..tostring(rc))
    if rc == 0 then
        env.current.zone = {map[env.current.id[1]].zone}
        if (var.goto or {}).thread == nil then
            show("定位成功", "green")
            show("当前位置："..(env.current.zone[1] or '海上').." "..env.current.name.."（ID "..tostring(env.current.id[1]).."）", "white")
        end
    elseif rc == 1 then
        env.current.zone = {}
        for _,v in ipairs(env.current.id) do
            env.current.zone = set.union(env.current.zone, {map[v].zone})
        end
        if (var.goto or {}).thread == nil then
            show("定位成功", "green")
            show("当前位置："..set.concat(env.current.zone, "|").." "..env.current.name.."（ID "..set.concat(env.current.id, "|").."）", "white")
        end
    else
        env.current = {id = {}, name = "", desc = {}, exits = "", zone = {}, objs = {}}
        env.room = env.current
        show("定位失败", "red")
    end
    return rc
end

local locate_port = {
    ["舟山"] = 3032,
    ["塘沽口"] = 3033,
    ["安海港"] = 3034,
    ["永宁港"] = 3035
}

function locate_navigation()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ locate_navigation ］")
    local l = wait_line("locate", 30, nil, nil, "^你现在在((?:舟山|塘沽口|永宁港|安海港))\\S*。$|^船还没开呢。$")
    if l == false then
        return -1
    else
        if l[0] == "船还没开呢。" then
            env.current.id = { 3032, 3033, 3034, 3035 }
            env.current.desc = "这是一艘很普通的渔船，几名渔夫摆弄着帆篷，篙桨，绳索，和船尾木舵。"
            env.current.exits = { "out" }
            return
        else
            env.current.id = { locate_port[l[1]] }
            env.current.exits = {}
            env.current.zone = {}
        end
        return 0
    end
end

function locate_nextto()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ locate_nextto ］")
    if env.nextto.name ~= "" then
        env.nextto.id = get_room_id_by_name(env.nextto.name)
        if #env.nextto.id > 1 then
            env.nextto.desc = set.concat(env.nextto.desc)
            env.nextto.id = get_room_id_by_desc(env.nextto.desc, env.nextto.id)
            if #env.nextto.id > 1 then
                if env.nextto.exits == "" then
                    env.nextto.exits = {}
                else
                    env.nextto.exits = string.split(string.gsub(env.nextto.exits, " 和 ", "、"), "、")
                end
                if #env.nextto.exits > 0 then
                    env.nextto.id = get_room_id_by_exits(env.nextto.exits, env.nextto.id)
                end
            end
        end
    end
    if #env.nextto.id == 0 then
        env.nextto = {id = {}, name = "", desc = {}, exits = "", zone = {}, objs = {}}
        show("定位相邻房间失败", "orange")
        return -1
    elseif #env.nextto.id == 1 then
        env.nextto.zone = {map[env.nextto.id[1]].zone}
        return 0
    else
        env.nextto.zone = {}
        for _,v in ipairs(env.nextto.id) do
            env.nextto.zone = set.union(env.nextto.zone, {map[v].zone})
        end
        return 1
    end
end

function get_room_id_by_name(name, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_name ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,i in ipairs(rooms) do
        if map[i].name == name then
           set.append(room_ids, i)
        end
    end
    return room_ids
end

function get_room_id_by_desc(desc, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_desc ］")
    local room_ids = {}
    for _,v in ipairs(rooms) do
        if map[v].desc == desc then
            set.append(room_ids, v)
        end
    end
    return room_ids
end

function get_room_id_by_zones(zones, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_zones ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,v in ipairs(rooms) do
        if map[v].zone ~= nil then
            if set.has(zones, map[v].zone) == true then
                set.append(room_ids, v)
            end
        end
    end
    return room_ids
end

function get_room_id_by_exits(exits, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_exits ］")
    local room_ids = {}
    for _,v in ipairs(rooms) do
        for _,i in ipairs(map[v].exits) do
            if set.equal(i, exits) then
                set.append(room_ids, v)
                break
            end
        end
    end
    return room_ids
end

function get_room_id_by_npc(npc, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_npc ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,v in ipairs(rooms) do
        if map[v].npcs ~= nil then
            if set.has(map[v].npcs, npc) == true then
                set.append(room_ids, v)
            end
        end
    end
    return room_ids
end

function get_room_id_by_item(item, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_item ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,v in ipairs(rooms) do
        if map[v].items ~= nil then
            if set.has(map[v].items, item) == true then
                set.append(room_ids, v)
            end
        end
    end
    return room_ids
end

function get_room_id_by_tag(tag, rooms, mode)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_tag ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,v in ipairs(rooms) do
        if map[v].tags ~= nil then
            if mode == "exclude" then
                if set.has(map[v].tags, tag) == false then
                    set.append(room_ids, v)
                end
            else
                if set.has(map[v].tags, tag) == true then
                    set.append(room_ids, v)
                end
            end
        elseif mode == "exclude" then
            set.append(room_ids, v)
        end
    end
    return room_ids
end

function get_room_id_by_roomsfrom(roomsfrom, dir, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_roomsfrom ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,v in ipairs(roomsfrom) do
        for i,j in pairs(map[v].links) do
            if set.has(rooms, j) == true then
                i = link_dir[i] or i
                if i ~= false then
                    if dir == nil then
                        set.append(room_ids, j)
                    elseif dir == i then
                        set.append(room_ids, j)
                        break
                    end
                end
            end
        end
    end
    return set.inter(rooms, room_ids)
end

function get_room_id_by_roomsto(roomsto, dir, rooms)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_room_id_by_roomsto ］")
    local room_ids = {}
    if rooms == nil then
        rooms = table.index(map)
    end
    for _,v in ipairs(rooms) do
        for i,j in pairs(map[v].links) do
            if set.has(roomsto, j) == true then
                i = link_dir[i] or i
                if i ~= false then
                    if dir == nil or dir == i then
                        set.append(room_ids, v)
                        break
                    end
                end
            end
        end
    end
    return room_ids
end

-- function scan_room(rooms, start)
--     local l
--     scan = true
--     if type(rooms) == "string" then
--         rooms = string.totable(rooms)
--     elseif type(rooms) ~= "table" then
--         scan = nil
--         return false
--     end

--     if #rooms == 0 then
--         return true
--     end

--     local room_string = table.concat(rooms, "|")
--     if string.find(room_string, "^[0-9]+[|0-9]*$") then
--         SetVariable("room_id_dst", room_string)
--     else
--         scan = nil
--         return false
--     end

--     if start == nil then start = 1 end
--     SetVariable("room_id_dstpos", start - 1)
--     while tonumber(GetVariable("room_id_dstpos")) < #rooms do
--         flynext()
--         l,_ = wait.regexp("^[>\\s]*你目前还没有任何为 移动(?:完成|失败) 的变量设定。$", 180)
--         if no_response(l) or string.find(l, "移动失败") then
--             ColourNote("orange", "", "目的地无法到达，略过 "..rooms[tonumber(GetVariable("room_id_dstpos"))])
--         end
--         if path == "nomove" or room_compare > 0 then
--             EnableTrigger("get_room_name", false)
--             EnableTrigger("get_room_exits", false)
--             Execute("look;set 搜索完成")
--             wait.regexp("^[>\\s]*你目前还没有任何为 搜索完成 的变量设定。$", 30)
--             EnableTrigger("get_room_name", true)
--             EnableTrigger("get_room_exits", true)
--             if set.equal(room_update, string.split(GetVariable("room_id"), "|")) == true then
--                 room_update = nil
--             end
--             Execute("set 更新定位")
--             wait.regexp("^[>\\s]*你目前还没有任何为 更新定位 的变量设定。$", 30)
--             flood = flood + 3
--         end
--         if scan == false then
--             scan = nil
--             return true
--         end
--         if flood > 40 then
--             wait.time(1)
--             flood = 0
--         end
--     end
--     scan = nil
--     return true
-- end

show(" 已加载", "green")