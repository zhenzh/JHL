local longxiang_pozhang_nenghai_area = { 647,409,410,411,412,413,416,415,414,1853,1854 }

local phase = {
    ["任务获取"] = 1,
    ["任务执行"] = 2,
    ["任务完成"] = 3
}

function longxiang_pozhang()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang ］")
    automation.idle = false
    var.job = var.job or {name = "龙象破障"}
    var.job.statistics = var.job.statistics or { name = "龙象破障" }
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    jia_min()
    if wield(config.fight["通用"].weapon) < 0 then
        return -1
    end
    if (config.jobs["龙象破障"].phase or 0) <= phase["任务获取"] then
        local rc = longxiang_pozhang_p1()
        if rc ~= nil then
            return longxiang_pozhang_return(rc)
        end
    end
    if config.jobs["龙象破障"].phase == phase["任务执行"] then
        return longxiang_pozhang_return(longxiang_pozhang_p2())
    end
end

function longxiang_pozhang_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    trigger.delete_group("longxiang_pozhang")
    var.job.statistics.result = "完成"
    statistics_append("龙象破障")
    var.job = nil
    return rc
end

function longxiang_pozhang_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_p1 ］")
    local rc = longxiang_pozhang_goto_fawang()
    if rc ~= nil then
        return rc
    end
    rc = longxiang_pozhang_refresh()
    if rc ~= nil then
        return rc
    end
end

function longxiang_pozhang_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_p2 ］")
    local rc = longxiang_pozhang_search_nenghai()
    if rc ~= nil then
        return rc
    end
    rc = longxiang_pozhang_poguan()
    if rc ~= nil then
        return rc
    end
end

function longxiang_pozhang_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_p3 ］")
    automation.idle = false
    if recover(config.job_nl) ~= 0 then
        return -1
    end
    return 0
end

function longxiang_pozhang_goto_fawang()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_goto_fawang ］")
    if env.current.id[1] ~= 1787 then
        local rc = goto(1787)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function longxiang_pozhang_refresh()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_refresh ］")
    local l = wait_line("ask jinlun fawang about 破障",
                        30, nil, nil,
                        "^你向金轮法王打听有关「破障」的消息。$|"..
                        "^这里没有 \\S+ 这个人$|"..
                        "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return longxiang_pozhang_refresh()
    elseif l[0] == "你向金轮法王打听有关「破障」的消息。" then
        l = wait_line(nil,
                      30, nil, nil,
                      "^金轮法王对你并不理睬，只是微不可查的扬了下白眉。$|"..
                      "^金轮法王说道：龙象般若功共十三层，威力巨大，所以，每层都要以相应的佛法来化解。$|"..
                      "^金轮法王说道：你龙象般若功修为不足，不足以破关修行下一层。$|"..
                      "^金轮法王说道：龙象般若功修为不易，若不能掌控好反而会走火入魔。$|"..
                      "^金轮法王说道：你\\S+不足，切莫妄图强行修行。$|"..
                      "^金轮法王说道：武学精进固然重要，但是却也不能操之过急，你先好好的休息休息吧。$|"..
                      "^金轮法王说道：你修为不够，还想着破障，快快去修炼才是正事$|"..
                      "^金轮法王说道：不是让你去找能海上师了么，你还留在这里做什么？$|"..
                      "^但是很显然的，金轮法王现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif l[0] == "金轮法王说道：你龙象般若功修为不足，不足以破关修行下一层。" or 
               l[0] == "金轮法王说道：龙象般若功共十三层，威力巨大，所以，每层都要以相应的佛法来化解。" or 
               l[0] == "金轮法王说道：龙象般若功修为不易，若不能掌控好反而会走火入魔。" or 
               string.match(l[0], "切莫妄图") then
            timer.delete("longxiang_pozhang_cd")
            config.jobs["龙象破障"].phase = phase["任务完成"]
            config.jobs["龙象破障"].active = false
            return longxiang_pozhang_p3()
        elseif l[0] == "金轮法王说道：武学精进固然重要，但是却也不能操之过急，你先好好的休息休息吧。" or 
               l[0] == "金轮法王说道：你修为不够，还想着破障，快快去修炼才是正事" then
            config.jobs["龙象破障"].active = false
            if trigger.is_exist("longxiang_pozhang_cd") == false then
                timer.add("longxiang_pozhang_cd", 1800, "longxiang_pozhang_active()", "longxiang_pozhang", {Enable=true, OneShot=true})
            end
            config.jobs["龙象破障"].phase = phase["任务完成"]
            return longxiang_pozhang_p3()
        elseif l[0] == "金轮法王对你并不理睬，只是微不可查的扬了下白眉。" then
            if wait_line(nil, 30, nil, nil, "^金轮法王挥了挥手：你去吧，为师当年却是意志未坚，未能得到上师垂青，中原之行，才一败涂地！$") == false then
                return -1
            end
            wait(2)
            if wait_no_busy() < 0 then
                return -1
            end
        elseif l[0] == "但是很显然的，金轮法王现在的状况没有办法给你任何答覆。" then
            wait(1)
            return longxiang_pozhang_refresh()
        end
        config.jobs["龙象破障"].phase = phase["任务执行"]
        return
    else
        return 1
    end
end

function longxiang_pozhang_search_nenghai()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_search_nenghai ］")
    local rc,npc = search("^\\s+苦行僧「密宗上师」能海\\(Neng hai\\)$", longxiang_pozhang_nenghai_area)
    if rc == -1 then
        return -1
    elseif rc > 0 then
        config.jobs["龙象破障"].phase = phase["任务更新"]
        return longxiang_pozhang()
    end
    for k,_ in pairs(npc) do
        if env.current.id[1] ~= k then
            if goto(k) ~= 0 then
                return -1
            end
        end
        local l = wait_line("follow nenghai",
                            30, nil, nil,
                            "^你决定开始跟随能海一起行动。$|^这里没有 nenghai。$")
        if l == false then
            return -1
        elseif l[0] == "你决定开始跟随能海一起行动。" then
            return longxiang_pozhang_kneel_nenghai()
        else
            return longxiang_pozhang_search_nenghai()
        end
    end
end

function longxiang_pozhang_kneel_nenghai()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_kneel_nenghai ］")
    local l = wait_line("kneel",
                        30, nil, nil,
                        "^能海默默的回头看了看你，一言不发，转身离去。$|"..
                        "^能海静静的看了你一眼，轻微颔首，然后消失在了风雪之中。$|"..
                        "^能海对你继续说道：谁料到，唉……我密宗近年来日益势微，恐法统断绝，你为我密宗弟子，当继我密宗衣钵。随我来。$|"..
                        "^什么\\?$")
    if l == false then
        return -1
    elseif l[0] == "能海默默的回头看了看你，一言不发，转身离去。" or 
           l[0] == "能海静静的看了你一眼，轻微颔首，然后消失在了风雪之中。" then
        if wait_line("look", 30, nil, nil, "^\\S+ - $", "^> $") == false then
            return -1
        end
        if locate() < 0 then
            return -1
        end
    elseif l[0] == "能海对你继续说道：谁料到，唉……我密宗近年来日益势微，恐法统断绝，你为我密宗弟子，当继我密宗衣钵。随我来。" then
        if wait_line("follow none", 30, nil, nil, "^一路且歌且行，盛雪布衣徐徐消失在无数漫天飞雪中。$") == false then
            return -1
        end
        return
    end
    return longxiang_pozhang_search_nenghai()
end

function longxiang_pozhang_poguan()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ longxiang_pozhang_poguan ］")
    local l = wait_line("xiuxing",
                        30, nil, nil,
                        "^你跪在大雪中高声朗读\\S+$|"..
                        "^什么\\?$|"..
                        "^你默默的在大雪中苦修，突然间能海上师再次出现，对着你默默颔首。$")
    if l == false then
        return -1
    elseif string.match(l[0], "高声朗读") then
        automation.idle = false
        wait(3)
        return longxiang_pozhang_poguan()
    elseif l[0] == "你默默的在大雪中苦修，突然间能海上师再次出现，对着你默默颔首。" then
        if wait_line(nil, 30, nil, nil, "^你功课已毕，不用再继续修行了。$") == false then
            return -1
        end
        if wait_no_busy() < 0 then
            return -1
        end
    else
        var.job.times_out = (var.job.times_out or 0) + 1
        if var.job.times_out < 10 then
            wait(0.2)
            return longxiang_pozhang_poguan()
        end
    end
    if recover(config.job_nl) < 0 then
        return -1
    end
    l = wait_line("poguan",
                  30, nil, nil,
                  "^你以天穹为盖，大地为基，凝冰为壁，以作静室。$|"..
                  "你跑哪里去了")
    if l == false then
        return -1
    elseif l[0] == "你跑哪里去了" then
    else
        trigger.add("longxiang_pozhang_idle", "automation.idle = false", "longxiang_pozhang", {Enable=true}, nil, "^你控制体内的龙象般若内功，缓缓游走")
        l = wait_line(nil,
                      1800, nil, nil,
                      "^你心魔骤起，无法自制。$|"..
                      "^你已经成功的领悟了龙象般若功\\S+$")
        if l == false then
            return -1
        end
        profile.longxiang.pozhang = profile.longxiang.pozhang + 1
        run("set pozhang "..tostring(profile.longxiang.pozhang))
        config.jobs["龙象破障"].active = false
        if l[0] == "你心魔骤起，无法自制。" then
            l = wait_line(nil,
                          30, nil, nil,
                          "^事已至此，你已知不可为，心中默念：于尔所世，无我相，无人相，无众生相，无寿者相,当舍此身证菩提。$|"..
                          "^你赶紧散去凝聚的内劲，方才躲过走火入魔的厄运。$")
            if l == false then
                return -1
            elseif l[0] == "事已至此，你已知不可为，心中默念：于尔所世，无我相，无人相，无众生相，无寿者相,当舍此身证菩提。" then
                if wait_line(nil, 30, nil, nil, "^你倒在地上，挣扎了几下就死了。$") == false then
                    return -1
                end
                timer.add("longxiang_pozhang_cd", (profile.longxiang.cd or 3600), "longxiang_pozhang_active()", "longxiang_pozhang", {Enable=true, OneShot=true})
                config.jobs["龙象破障"].phase = phase["任务完成"]
                return 0
            end
            timer.add("longxiang_pozhang_cd", (profile.longxiang.cd or 3600), "longxiang_pozhang_active()", "longxiang_pozhang", {Enable=true, OneShot=true})
        else
            timer.delete("longxiang_pozhang_cd")
            profile.longxiang.progress = 0
            profile.longxiang.level = profile.longxiang.level + 1
        end
    end
    config.jobs["龙象破障"].phase = phase["任务完成"]
    return longxiang_pozhang_p3()
end

function longxiang_pozhang_active()
    config.jobs['龙象破障'].active = true
    config.jobs["龙象破障"].phase = phase["任务更新"]
end

config.jobs["龙象破障"] = config.jobs["龙象破障"] or { name = "longxiang_pozhang", active = true, enable = true }
config.jobs["龙象破障"].func = longxiang_pozhang
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")