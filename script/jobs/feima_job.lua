local job_target = {
    ["西域李姑娘"]       = {1331, 1333, 1335, 1334, 1336, 1332, 1337},
    ["「老把头」赫尔苏"]  = {1474, 1473, 1476, 1477, 1478, 1472, 1480, 1479, 1483, 1475},
    ["黑木崖鲍长老"]     = {2743, 2745, 2746, 2748, 2749, 2750, 2747, 2744},
    ["西夏叶二娘"]       = {1581, 1582, 1583, 1584, 1590, 1585, 1586, 1587, 1591},
    ["嵩山左冷禅"]       = {2463, 2474, 2475, 2476, 2478, 2477, 2987, 2472},
    ["少室山知客僧"]     = {1627, 1698, 1649, 1648, 1652, 1653, 1654, 1655, 1657, 1647, 1646, 1640, 1639, 1638, 1697, 1694, 1650, 1658, 1659, 1663, 1615, 1616, 1695, 1696, 1628, 1626, 1625, 1624, 1623, 1622, 1621, 1620, 1619, 1618, 1617, 1637, 1636, 1635, 1634, 1633, 1632, 1631, 1630, 1629, 1651},
    ["星宿丁老怪"]       = {1435, 1443, 1436, 1442, 1441, 1440, 1437, 2595, 2597, 2596, 2598, 1444, 1445},
    ["姑苏慕容风波恶"]   = {1092, 1091, 2046, 2047, 2048, 1276},
    ["襄阳耶律齐"]       = {2607, 2691, 2692, 2693, 2694, 2695, 2696, 2697, 2690, 2608},
    ["泉州马五德"]       = {31, 32, 33, 34, 35, 42, 41, 36, 40, 38, 39, 37, 44, 43},
    ["大理段王爷"]       = {188, 190, 191, 193, 194, 192, 189},
    ["大雪山灵智上人"]   = {425, 430, 429, 428, 433, 437, 438, 434, 435, 436, 431, 439, 442, 426},
    ["杭州欧匠师"]       = {1199, 1198, 1255, 1197, 1256, 1196, 1257, 1192, 1259, 1193, 1189, 1185, 1247},
    ["华山矮老者"]       = {868, 869, 870, 871, 872, 893, 897},
    ["昆仑山韦蝙王"]     = {559, 563, 564, 584, 565, 567, 583, 566, 568, 569, 570, 571, 572, 580, 581, 582, 573, 574, 577},
    ["峨嵋山贝锦仪"]     = {361, 362, 363, 380, 381, 364, 365, 366, 379},
    ["归云庄陆冠英"]     = {1092, 1091, 2046, 2047, 2048, 1276, 1270, 1268, 1271},
    ["武当山宋大侠"]     = {661, 683, 662, 663, 664, 665, 679, 680, 681, 682, 666, 671, 672, 673, 674},
    ["全真马真人"]       = {790, 789, 788, 792, 793, 796, 794, 795, 782, 787, 788, 797},
    ["灵鹫宫余婆婆"]     = {1449, 1450, 1457, 1451, 1452, 1456, 1453, 1454},
}

local job_enemys = {"打手", "抢匪", "流寇", "山贼", "轩辕虹", "铁手", "土匪", "土匪头", "风刃", "俺懒", "发浪", "贼头", "天使涟涟", "强盗头", "盗贼",
                    "我想有个家", "我是霍岩", "铜", "草寇", "路霸", "地痞", "没名字", "烧开水国王", "神域丶西来", "盗匪", "无赖", "山大王", "外星新人",
                    "小虾", "恶人", "恶霸", "独行盗", "山贼头", "臭蛤蟆", "乡下的旌旌亮", "毛贼", "流氓", "豆腐青菜", "冷风", "悟觉", "老村长的渡皮", "是犯嘀咕"}

local phase = {
    ["任务获取"] = 1,
    ["任务执行"] = 2,
    ["任务结算"] = 3,
    ["任务放弃"] = 4,
}

function enable_feima_job()
    trigger.delete_group("feima_job")
    trigger.delete_group("feima_job_active")
    trigger.add("feima_job_addenemy", "feima_job_addenemy()", "feima_job", {Enable=false}, 100, "^(\\S+)脚下一个不稳，跌在地上昏了过去。$")
    trigger.add("feima_job_enemy", "feima_job_enemy()", "feima_job", {Enable=false}, 100, "^(\\S+)叫道：点子扎手，扯呼！$")
    trigger.add("feima_job_complete", "feima_job_complete()", "feima_job_active", {Enable=false}, 100, "^你累了个半死，终于把镖运到了地头。$")
    trigger.add("feima_job_count_addenemy", "feima_job_count_addenemy()", "feima_job_active", {Enable=false}, 100, "^(\\S+)(?:喝道：「你，我们的帐还没算完，看招！」|一眼瞥见你，「哼」的一声冲了过来！|喝道：「你，看招！」|和你仇人相见份外眼红，立刻打了起来！|一见到你，愣了一愣，大叫：「我宰了你！」|和你一碰面，二话不说就打了起来！|对著你大喝：「可恶，又是你！」)")
    trigger.add("feima_job_count_enemy", "feima_job_count_enemy()", "feima_job_active", {Enable=false, Multi=true}, 100, "^(?:劫匪大声说道：“此山是我开，此树是我栽，要想过此路，留下买路财。牙嘣半个不字，管杀不管埋。|劫匪喊道：点子爪子硬！赶紧来帮忙！)\\n看起来(\\S+)想杀死你！$")
end

function disable_feima_job()
    trigger.delete_group("feima_job")
    trigger.delete_group("feima_job_active")
end

function feima_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job ］")
    automation.idle = false
    var.job = var.job or { name = "飞马镖局" }
    var.job.statistics = var.job.statistics or { name = "飞马镖局" }
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    var.job.enemy_name = var.job.enemy_name or ("(?:"..set.concat(job_enemys, "|")..")")
    var.job.enemy = {count = 0}
    var.job.addenemy = {count = 0}
    trigger.enable_group("feima_job_active")
    if (config.jobs["飞马镖局"].phase or 0) <= phase["任务获取"] then
        local rc = feima_job_p1()
        if rc ~= nil then
            return feima_job_return(rc)
        end
    end
    if config.jobs["飞马镖局"].phase == phase["任务执行"] then
        return feima_job_return(feima_job_p2())
    end
    if config.jobs["飞马镖局"].phase == phase["任务结算"] then
        local rc = feima_job_return(feima_job_p3())
        if rc ~= nil then
            return feima_job_return(rc)
        end
    end
    if config.jobs["飞马镖局"].phase == phase["任务放弃"] then
        return feima_job_return(feima_job_p4())
    end
    return feima_job_return(feima_job())
end

function feima_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_return ］参数："..tostring(rc))
    if var.job == nil then
        return rc
    end
    trigger.disable_group("feima_job")
    trigger.disable_group("feima_job_active")
    config.jobs["飞马镖局"].biaoche = nil
    config.jobs["飞马镖局"].npc = nil
    config.jobs["飞马镖局"].dest = nil
    config.jobs["飞马镖局"].recover = nil
    config.jobs["飞马镖局"].path = nil
    statistics_append("飞马镖局")
    if var.job.weapon_ori ~= nil then
        var.job.weapon_ori[1] = var.job.weapon[1]
        var.job.weapon_ori[2] = var.job.weapon[2]
    end
    var.job = nil
    return rc
end

function feima_job_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_p1 ］")
    local rc = feima_job_goto_maxingkong()
    if rc ~= nil then
        return rc
    end
    return feima_job_aquire()
end

function feima_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_p2 ］")
    local rc,msg = feima_job_goto_biaoche()
    if rc ~= nil then
        return rc
    end
    rc = feima_job_check_biaoche()
    if rc ~= nil then
        return rc
    end
    map_adjust("门派接引", "禁用", "过河", "渡船", "丐帮密道", "禁用")
    if calibration["南阳城"][1] == "开放" then
        map_attr.cost["north2401"] = 10000
    end
    config.jobs["飞马镖局"].path = get_path(config.jobs["飞马镖局"].biaoche, config.jobs["飞马镖局"].dest[1])
    if calibration["南阳城"][1] == "开放" then
        map_attr.cost["north2401"] = nil
    end
    if config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].dest[1]].cost == 10000 then
        config.jobs["飞马镖局"].phase = phase["任务放弃"]
        return feima_job_p4()
    end
    var.job.thread_suspend = true
    if var.job.thread == nil then
        var.job.thread_suspend = false
        coroutine.wrap(function() feima_job_start_sub_thread() end)()
    end
    if coroutine.status(var.job.thread) == "dead" then
        var.job.thread = nil
        var.job.thread_suspend = false
        coroutine.wrap(function() feima_job_start_sub_thread() end)()
    end
    if var.job.thread_suspend == true then
        var.job.thread_suspend = false
        coroutine.resume(var.job.thread)
    end
    rc = feima_job_ganche()
    if rc ~= nil then
        return rc
    end
    if #config.jobs["飞马镖局"].dest > 1 then
        if var.job.thread_suspend == false then
            if automation.skill ~= nil then
                run("set 中断事件")
            elseif var.yun_heal ~= nil then
                run("set 中断事件")
            end
        end
        local dest = set.copy(config.jobs["飞马镖局"].dest)
        set.reverse(dest)
        feima_job_wait_sub_thread_break()
        rc,msg = search("^\\s+「店铺伙计」"..config.jobs["飞马镖局"].npc, dest)
        if rc == 0 then
            config.jobs["飞马镖局"].dest = table.keys(msg)
            return feima_job_p2()
        else
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return feima_job_p4()
        end
    end
    timer.delete("feima_job_biaoche")
    return feima_job_arrive()
end

function feima_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_p3 ］")
    local rc = feima_job_goto_maxingkong()
    if rc == nil then
        return feima_job_settle()
    end
    if rc >= 0 then
        if recover(config.job_nl) ~= 0 then
            return -1
        end
    end
    return rc
end

function feima_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_p4 ］")
    if var.job ~= nil then
        if var.job.thread_suspend == false and automation.skill ~= nil then
            run("set 中断事件")
        end
        if var.job.thread ~= nil then
            while var.job.thread_suspend == false do
                wait(0.1)
            end
            var.job.thread_suspend = false
            coroutine.resume(var.job.thread)
        end
    end
    local rc = feima_job_goto_maxingkong()
    if rc == nil then
        rc = feima_job_abandon_job()
    end
    if rc >= 0 then
        if recover(config.job_nl) ~= 0 then
            return -1
        end
    end
    return rc
end

function feima_job_wait_sub_thread_break()
    while var.job.thread_suspend == false do
        if var.job.thread == nil then
            var.job.thread_suspend = true
            break
        else
            if coroutine.status(var.job.thread) == "dead" then
                var.job.thread_suspend = true
                var.job.thread = nil
                break
            end
        end
        wait(0.1)
    end
    var.job.bevent = nil
    return
end

function feima_job_goto_maxingkong()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_goto_maxingkong ］")
    if env.current.id[1] ~= 2921 then
        var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
        local rc = goto(2921)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function feima_job_aquire()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_aquire ］")
    local l = wait_line("ask ma xingkong about 押镖",
                        30, nil, nil,
                        "^你向马行空打听有关「押镖」的消息。$|"..
                        "^这里没有 \\S+ 这个人$|"..
                        "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif l[0] == "你向马行空打听有关「押镖」的消息。" then
        l = wait_line(nil,
                      30, nil, nil,
                      "^马行空说道：这位\\S+不是正在护镖么，请先完成手上的工作再来。$|"..
                      "^马行空点了点头。$|"..
                      "^马行空说道：最近镖局生意惨淡，生意不好做呀。$|"..
                      "^但是很显然的，马行空现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif l[0] == "马行空点了点头。" then
            config.jobs["飞马镖局"].phase = phase["任务执行"]
            config.jobs["飞马镖局"].biaoche = 2921
        elseif l[0] == "但是很显然的，马行空现在的状况没有办法给你任何答覆。" then
            return 1
        else
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return feima_job_p4()
        end
    else
        return 1
    end
    return
end

function feima_job_goto_biaoche()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_goto_biaoche ］")
    if config.jobs["飞马镖局"].biaoche == nil then
        config.jobs["飞马镖局"].phase = phase["任务放弃"]
        return feima_job_p4()
    else
        if env.current.id[1] ~= config.jobs["飞马镖局"].biaoche then
            local rc = goto(config.jobs["飞马镖局"].biaoche)
            if rc ~= 0 then
                config.jobs["飞马镖局"].phase = phase["任务放弃"]
                return feima_job_p4()
            end
        end
    end
    return
end

function feima_job_check_biaoche()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_check_biaoche ］")
    if config.jobs["飞马镖局"].dest == nil then
        local l = wait_line("check",
                            30, nil, nil,
                            "^这是送给(\\S+)的镖货，接货人是\\S+附近的(\\S+)。$|"..
                            "^你要打听谁的消息？$|"..
                            "^只有乞丐才能打探别人的技能！$|"..
                            "明教天鹰教神通")
        if l == false then
            return -1
        elseif l[1] ~= false then
            config.jobs["飞马镖局"].dest = job_target[l[1]]
            config.jobs["飞马镖局"].npc = l[2]
        else
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return feima_job_p4()
        end
    end
    return
end

function feima_job_ganche()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_ganche ］")
    if config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].biaoche].next == nil then
        return
    end
    local dir = feima_job_get_dir()
    if dir == nil then
        var.job.bevent = true
        feima_job_wait_sub_thread_break()
        local rc = one_step()
        if rc ~= 0 then
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return feima_job_p4()
        end
        return feima_job()
    elseif dir == "yell boat;enter" then
        run("yell boat")
    end
    while var.job.move == false do
        if var.job.enemy.count > 0 or 
           var.job.addenemy.count > 0 or
           config.jobs["飞马镖局"].phase > phase["任务执行"] then
            return feima_job_post_ganche()
        end
        wait(0.1)
    end
    local l = wait_line("gan che to "..dir,
                        30, nil, nil,
                        "^你驱赶镖车向\\S+驶去。$|"..
                        "慢点赶，镖车还没跟上来呢。$|"..
                        "^什么\\?$|"..
                        "^没有这个方向。$|"..
                        "劫匪一声奸笑：“想跑，门都没有，把货给老子留下吧。”$")
    if l == false then
        return -1
    elseif string.match(l[0], "慢点赶，镖车还没跟上来呢。") then
        wait(0.1)
        return feima_job_ganche()
    elseif l[0] == "什么?" then
        config.jobs["飞马镖局"].phase = phase["任务放弃"]
        return feima_job_p4()
    elseif l[0] == "没有这个方向。" then
        if env.current.id[1] == 1432 or 
           env.current.id[1] == 1433 or 
           env.current.id[1] == 1434 then
            local current_id = env.current.id[1]
            if wait_line("look", 30, nil, nil, "^\\S+ - $", "^>\\s+$") == false then
                return -1
            end
            env.current.id = { current_id }
        end 
        local rc = locate()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return feima_job_p4()
        end
        config.jobs["飞马镖局"].biaoche = env.current.id[1]
    elseif l[0] == "劫匪一声奸笑：“想跑，门都没有，把货给老子留下吧。”" then
        var.job.enemy.count = 1
        trigger.enable("feima_job_enemy")
        if var.yun_bidu ~= nil then
            if var.wait_no_busy ~= nil then
                var.wait_no_busy.stop = true
            end
            if var.wait_no_fight ~= nil then
                var.wait_no_fight.stop = true
            end
        end
    else
        automation.idle = false
        var.job.move = false
        var.job.enemy = {count = 0}
        var.job.addenemy = {count = 0}
        timer.add("feima_job_biaoche", 3, "feima_job_biaoche()", "feima_job", {Enable=true, OneShot=true})
        if wait_line(nil, 30, nil, nil, "^\\S+ - ", "^> $") == false then
            return -1
        else
            env.current.id = {config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].biaoche].next}
            config.jobs["飞马镖局"].biaoche = env.current.id[1]
            if var.job.enemy.count > 0 or var.job.addenemy.count > 0 then
                if var.job.thread_suspend == false then 
                    if var.yun_bidu ~= nil then
                        if var.wait_no_busy ~= nil then
                            var.wait_no_busy.stop = true
                        end
                        if var.wait_no_fight ~= nil then
                            var.wait_no_fight.stop = true
                        end
                    end
                    if var.yun_heal or 
                       var.yun_forceheal or 
                       var.dazuo or 
                       automation.skill ~= nil then
                        run("set 中断事件")
                    end
                end
            end
        end
    end
    local rc = feima_job_post_ganche()
    if rc ~= nil then
        return rc
    end
    return feima_job_ganche()
end

function feima_job_get_dir()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_get_dir ］")
    local dir = config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].biaoche].next].step
    local l
    if dir == "yell boat;enter" then
        l = wait_line("yell boat",
                      30, nil, nil,
                      "^只听得(?:江|湖)面上隐隐传来：“别急嘛，这儿正忙着呐……”$|"..
                      "^一叶扁舟缓缓地驶了过来，(?:艄公|船夫)将一块踏脚板搭上堤岸，以便乘客$|"..
                      "^岸边一只(?:渡船|小舟)上的(?:老艄公|船夫)说道：正等着你呢，上来吧。$")
        if l == false then
            return -1
        elseif string.match(l[0], "别急嘛") then
            wait(1)
            return feima_job_get_dir()
        end
    elseif string.match(dir, "knock gate") or 
           string.match(dir, "open ") then
        l = wait_line(string.split(dir, ";")[1],
                      30, nil, nil,
                      "^(?:大|木)门已经是开着(?:的|)了。$|"..
                      "^你将木门打开。$|"..
                      "^和尚开门$")
        if l == false then
            return -1
        end
    else
        if set.has({"大船", "小船", "江船", "渡船", "小舟"}, env.current.name) then
            l = wait_line(nil,
                          180, nil, nil,
                          "^艄公说“到啦，上岸吧”，随即把一块踏脚板搭上堤岸。$")
            if l == false then
                return -1
            end
        elseif dir == "go1433" then
            if type(env.current.exits) == "string" then
                env.current.exits = string.split(env.current.exits, " 和 ")
            end
            dir = set.copy(env.current.exits)
            set.delete(dir, "eastdown")
            dir = dir[1]
        elseif dir == "go1432" then
            if type(env.current.exits) == "string" then
                env.current.exits = string.split(env.current.exits, " 和 ")
            end
            dir = set.copy(env.current.exits)
            local rc = look_dir(dir[1])
            if rc < 0 then
                return -1
            elseif rc == 1 then
                if wait_line("look", 30, nil, nil, "^干沟 - $", "^> $") == false then
                    return -1
                end
                dir = feima_job_get_dir()
            else
                if env.nextto.name == "干沟" then
                    dir = dir[1]
                else
                    dir = dir[2]
                end
            end
        end
    end
    return regular_dir(dir)
end

function feima_job_post_ganche()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_post_ganche ］")
    local rc
    if config.jobs["飞马镖局"].phase == phase["任务结算"] then
        if var.job.enemy.count > 0 or var.job.addenemy.count > 0 then
            var.job.bevent = true
            feima_job_wait_sub_thread_break()
            run("halt")
            rc = one_step()
            if rc < 0 then
                return -1
            elseif rc == 0 then
                var.job.enemy.count = 0
                var.job.addenemy.count = 0
            end
        end
        return feima_job_arrive()
    end
    rc = feima_job_kill_enemy()
    if rc ~= nil then
        return rc
    end
    if coroutine.status(var.job.thread) == "dead" then
        var.job.thread = nil
        var.job.thread_suspend = false
        coroutine.wrap(function() feima_job_start_sub_thread() end)()
    end
    if var.job.thread_suspend == true then
        var.job.thread_suspend = false
        coroutine.resume(var.job.thread)
    end
    return
end

function feima_job_kill_enemy()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_kill_enemy ］")
    if var.job.enemy.count > 0 or var.job.addenemy.count > 0 then
        if prepare_skills() < 0 then
            return -1
        end
        local rc = fight()
        if rc < 0 then
            return -1
        elseif rc == 1 then --最后一步已交接还在战斗
            return feima_job_post_ganche()
        elseif rc == 2 then
            run("halt")
            rc = one_step()
            if rc ~= 0 then
                return -1
            else
                if recover(profile.power * 10) ~= 0 then
                    return -1
                end
            end
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return feima_job_p4()
        end
        trigger.disable("feima_job_enemy")
--        if is_fighting() == 1 then
--            show("dbg fighting")
--            if var.job.addenemy.count <= 0 then
--                var.job.enemy.count = 1
--            end
--            if var.job.enemy.count > 0 then
--                return feima_job_kill_enemy()
--            end
--        end
    end
    return
end

function feima_job_arrive()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_arrive ］")
    jia_min()
    timer.add("feima_job_wait_timeout", 10, "config.jobs['飞马镖局'].phase = "..tostring(phase["任务放弃"]), "feima_job", {Enable=true, OneShot=true})
    while config.jobs["飞马镖局"].phase < phase["任务结算"] do
        wait(0.1)
    end
    timer.delete("feima_job_wait_timeout")
    if config.jobs["飞马镖局"].phase == phase["任务放弃"] then
        return feima_job_p4()
    end
    if var.job.thread_suspend == false and automation.skill ~= nil then
        run("set 中断事件")
    end
    if var.job.thread ~= nil then
        while var.job.thread_suspend == false do
            wait(0.1)
        end
        var.job.thread_suspend = false
        coroutine.resume(var.job.thread)
    end
    if wield(config.fight["通用"].weapon or config.fight["通用"].weapon) < 0 then
        return -1
    end
    return feima_job_p3()
end

function feima_job_settle()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_settle ］")
    local l = wait_line("ask ma xingkong about 完成",
                        30, nil, nil,
                        "^你向马行空打听有关「完成」的消息。$|"..
                        "^这里没有 \\S+ 这个人$|"..
                        "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return feima_job_settle()
    elseif l[0] == "你向马行空打听有关「完成」的消息。" then
        l = wait_line(nil,
                      30, nil, nil,
                      "^马行空轻轻地拍了拍你的头。$|"..
                      "^马行空说道：我没让你走镖啊？$|"..
                      "^但是很显然的，马行空现在的状况没有办法给你任何答覆。$|"..
                      "^> $")
        if l == false then
            return -1
        elseif l[0] == "> " then
            config.jobs["飞马镖局"].phase = phase["任务放弃"]
            return
        elseif l[0] == "马行空轻轻地拍了拍你的头。" then
            config.jobs["飞马镖局"].phase = phase["任务获取"]
            if run_score() < 0 then
                return -1
            end
            var.job.statistics.result = "成功"
            return 0
        elseif l[0] == "但是很显然的，马行空现在的状况没有办法给你任何答覆。" then
            return 1
        else
            config.jobs["飞马镖局"].phase = phase["任务获取"]
            return 1
        end
    else
        return 1
    end
end

function feima_job_abandon_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_abandon_job ］")
    local l = wait_line("ask ma xingkong about 放弃",
                        30, nil, nil,
                        "^你向马行空打听有关「放弃」的消息。$|"..
                        "^这里没有 \\S+ 这个人$|"..
                        "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return feima_job_abandon_job()
    elseif l[0] == "你向马行空打听有关「放弃」的消息。" then
        repeat
            l = wait_line("ask ma xingkong about 赔偿",
                          30, nil, nil,
                          "^你可以重新开始押镖了。$|"..
                          "^马行空似乎不懂你是什么意思。$|"..
                          "^这里没有 \\S+ 这个人$|"..
                          "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$|"..
                          "^但是很显然的，马行空现在的状况没有办法给你任何答覆。$")
            if l == false then
                return -1
            elseif string.match(l[0], "忙着") then
                wait(0.1)
                if l[1] == "你" then
                    run("halt")
                end
            elseif l[0] == "你可以重新开始押镖了。" then
                config.jobs["飞马镖局"].phase = phase["任务获取"]
                var.job.statistics.result = "失败"
                return 1
            elseif l[0] == "马行空似乎不懂你是什么意思。"  then
                config.jobs["飞马镖局"].phase = phase["任务获取"]
                return feima_job()
            else
                return 1
            end
        until false
    else
        return 1
    end
end

function feima_job_start_sub_thread()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_start_sub_thread ］")
    var.job.thread = var.job.thread or coroutine.running()
    if config.jobs["飞马镖局"].phase >= phase["任务结算"] then
        if var.job ~= nil then
            var.job.thread = nil
            var.job.thread_suspend = true
        end
        return 0
    end
    var.move = false

    local rc = yun_bidu()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return feima_job_pause_sub_thread()
    end
    rc = yun_forceheal()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return feima_job_pause_sub_thread()
    end
    if config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].biaoche].next == nil then
        return feima_job_pause_sub_thread()
    end
    rc = heal_regenerate(70)
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return feima_job_pause_sub_thread()
    end
    rc = heal_recover()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return feima_job_pause_sub_thread()
    end
    rc = feima_job_dazuo()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return feima_job_pause_sub_thread()
    end
    rc = feima_job_full_skill()
    if (rc or 0) < 0 then
        return -1
    end
    return feima_job_pause_sub_thread()
end

function feima_job_pause_sub_thread()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_pause_sub_thread ］")
    var.move = true
    var.job.thread_suspend = true
    coroutine.yield()
    return feima_job_start_sub_thread()
end

function feima_job_dazuo()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_dazuo ］")
    local target = state.nl_max * 2 - 1
    local _,_,base = dazuo_analysis(target)
    local dismiss
    if carryon.inventory["炼心石:lianxin shi"] == nil then
        dismiss = base + 1
    else
        dismiss = (base + 1) * 2
    end
    if state.qx <= state.qx_max - 10 then
        if yun_recover() ~= 0 then
            return -1
        end
    end

    repeat
        if state.jl <= state.jl_max - 10 then
            if yun_refresh() ~= 0 then
                return -1
            end
        end
        if state.js <= state.js_max - 10 then
            if yun_regenerate() ~= 0 then
                return -1
            end
        end
        if state.nl > target - dismiss then
            if state.qx <= state.qx_max - 10 then
                if yun_recover() ~= 0 then
                    return -1
                end
            else
                return 0
            end
        end
        if break_event() == true then
            return 1
        end
        if var.job.enemy.count > 0 or var.job.addenemy.count > 0 then
            return 1
        end
        if dazuo() ~= 0 then
            return 1
        end
        if state.qx < state.qx_max * 0.7 then
            if yun_recover() ~= 0 then
                return -1
            end
        end
    until false
end

function feima_job_full_skill()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ feima_job_full_skill ］")
    if var.job.skill == false then
        return 0
    end
    if var.job.enemy.count <= 0 and var.job.addenemy.count <= 0 then
        automation.skill = true
        local rc = zuanyan()
        if rc ~= 0 then
            automation.skill = nil
            return rc
        else
            rc = lian()
            if rc ~= 0 then
                automation.skill = nil
                return rc
            else
                if automation.skill == true then
                    automation.skill = nil
                    var.job.skill = false
                    return 0
                end
            end
        end
        return feima_job_full_skill()
    end
end

function feima_job_addenemy()
    if (var.job.addenemy[get_matches(1)] or 0) > 0 then
        var.job.addenemy[get_matches(1)] = var.job.addenemy[get_matches(1)] - 1
        var.job.addenemy.count = var.job.addenemy.count - 1
        if var.job.addenemy.count == 0 then
            trigger.disable("feima_job_addenemy")
            if var.job.enemy.count <= 0 then
                if var.fight ~= nil then
                    var.fight.stop = 0
                    run("set 中断事件")
                end
            end
        end
    end
end

function feima_job_enemy()
    if (var.job.enemy[get_matches(1)] or 0) > 0 then
        var.job.enemy[get_matches(1)] = var.job.enemy[get_matches(1)] - 1
        var.job.enemy.count = var.job.enemy.count - 1
        if var.job.enemy.count == 0 then
            trigger.disable("feima_job_enemy")
            if var.job.addenemy.count <= 0 or var.job.move == true then
                if var.fight ~= nil then
                    var.fight.stop = 0
                    run("set 中断事件")
                end
            end
        end
    end
end

function feima_job_count_addenemy()
    if set.has(job_enemys, get_matches(1)) then
        trigger.enable("feima_job_addenemy")
        var.job.addenemy[get_matches(1)] = (var.job.addenemy[get_matches(1)] or 0) + 1
        var.job.addenemy.count = var.job.addenemy.count + 1
    end
end

function feima_job_count_enemy()
    trigger.enable("feima_job_enemy")
    var.job.enemy[get_matches(1)] = (var.job.enemy[get_matches(1)] or 0) + 1
    var.job.enemy.count = var.job.enemy.count + 1
end

function feima_job_complete()
    trigger.disable_group("feima_job")
    config.jobs["飞马镖局"].phase = phase["任务结算"]
    if var.fight ~= nil then
        var.fight.stop = math.max(1, (var.fight.stop or 0))
    end
end

function feima_job_biaoche()
    if var.job ~= nil then
        var.job.move = true
        if var.fight ~= nil then
            if var.job.enemy.count <= 0 then
                var.fight.stop = 0
            end
        end
    end
end

config.jobs["飞马镖局"].func = feima_job
config.jobs["飞马镖局"].efunc = enable_feima_job
config.jobs["飞马镖局"].dfunc = disable_feima_job
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
