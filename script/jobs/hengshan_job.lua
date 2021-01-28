local hengshan_job_area = {
    1144,1295,1279,1280,1294,1286,1294,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,
    1293,1296,22,23,24,23,22,17,18,19,21,19,18,1,18,17,16,15,14,13,12,10,26,10,11,10,9,8,7,3,120,3,4,6,
    4,5,4,3,2,1,87,89,90,91,90,89,87,88,87,1,28,85,84,82,83,82,81,46,28,29,30,29,31,32,33,34,35,42,35,41,
    35,39,40,36,39,36,38,36,37,36,35,34,33,32,31,43,44,45,44,46,47,48,49,74,75,76,77,78,77,76,75,79,80,
    79,75,74,49,50,51,52,51,59,51,50,60,61,60,50,49,70,71,70,69,72,73,72,69,62,63,64,68,64,65,64,67,66
}

function enable_hengshan_job()
    trigger.delete_group("hengshan_job")
    trigger.add("hengshan_job_npc_come", "hengshan_job_npc_come()", "hengshan_job", {Enable=false}, 100, "^(?:秦娟|郑鄂|仪文|仪和|仪琳|仪质|仪清)\\S*走了过来。$")
    trigger.add("hengshan_job_npc_leave", "hengshan_job_npc_leave()", "hengshan_job", {Enable=false}, 100, "^(?:秦娟|郑鄂|仪文|仪和|仪琳|仪质|仪清)\\S*往\\S+(?:离开|走了出去)。$")
end

function disable_hengshan_job()
    trigger.delete_group("hengshan_job")
end

local phase = {
    ["任务获取"] = 1,
    ["任务执行"] = 2,
    ["任务结算"] = 3,
    ["任务完成"] = 4,
    ["任务失败"] = 5
}

function hengshan_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job ］")
    automation.idle = false
    var.job = var.job or {name = "恒山任务"}
    var.job.statistics = var.job.statistics or {name = "恒山任务"}
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    if (config.jobs["恒山任务"].phase or 0) <= phase["任务获取"] then
        local rc = hengshan_job_p1()
        if rc ~= nil then
            return hengshan_job_return(rc)
        end
    end
    if config.jobs["恒山任务"].phase == phase["任务执行"] then
        local rc = hengshan_job_p2()
        if rc ~= nil then
            return hengshan_job_return(rc)
        end
    end
    if config.jobs["恒山任务"].phase == phase["任务结算"] then
        return hengshan_job_return(hengshan_job_p3())
    end
    if config.jobs["恒山任务"].phase == phase["任务失败"] then
        return hengshan_job_return(hengshan_job_p5())
    end
end

function hengshan_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    trigger.disable_group("hengshan_job")
    config.jobs["恒山任务"].confirm = nil
    config.jobs["恒山任务"].area = nil
    config.jobs["恒山任务"].discuss = nil
    config.jobs["恒山任务"].arrest = nil
    statistics_append("恒山任务")
    if var.statistics ~= nil and var.statistics.result == "成功" then
        if var.job.statistics.exp < 10 then
            config.jobs["恒山任务"].active = false
            timer.add("hengshan_job_cd", 3600, "config.jobs['恒山任务'].active = true", "hengshan_job", {Enable=true, OneShot=true})
        end
    end
    if var.job.weapon_ori ~= nil then
        var.job.weapon_ori[1] = var.job.weapon[1]
        var.job.weapon_ori[2] = var.job.weapon[2]
    end
    var.job = nil
    return rc
end

function hengshan_job_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_p1 ］")
    if profile.mole > 0 and profile.family ~= "恒山派" then
        local rc = zero_mole()
        if rc ~= 0 then
            return rc
        end
    end
    local rc = hengshan_job_goto_zuolengchan()
    if rc ~= nil then
        return rc
    end
    rc = hengshan_job_refresh()
    if rc ~= nil then
        return rc
    end
end

function hengshan_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_p2 ］")
    if config.jobs["恒山任务"].area == nil then
        config.jobs["恒山任务"].area = hengshan_job_area
    end
    if config.jobs["恒山任务"].arrest == nil then
        if run_i() < 0 then
            return -1
        end
        if is_own("面罩:mian zhao") ~= true then
            config.jobs["恒山任务"].phase = phase["任务失败"]
            return hengshan_job_p5()
        end
    end
    return hengshan_job_exec()
end

function hengshan_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_p3 ］")
    automation.idle = false
    local rc = hengshan_job_goto_zuolengchan("walk")
    if rc ~= nil then
        return rc
    end
    return hengshan_job_refresh()
end

function hengshan_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_p4 ］")
    if recover(config.job_nl) < 0 then
        return -1
    end
    if run_score() < 0 then
        return -1
    end
    config.jobs["恒山任务"].phase = phase["任务获取"]
    var.job.statistics.result = "成功"
    return 0
end

function hengshan_job_p5()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_p5 ］")
    local rc = hengshan_job_goto_zuolengchan()
    if rc ~= nil then
        return rc
    end
    if wait_line("giveup", 30, nil, nil, "^左冷禅对你说道：“连几个柔弱的尼姑都搞不定，快快给我滚了下去！”$|^什么\\?$") == false then
        return -1
    end
    config.jobs["恒山任务"].phase = phase["任务获取"]
    if var.job.statistics ~= nil then
        var.job.statistics.result = "失败"
    end
    return 1
end

function hengshan_job_goto_zuolengchan(mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_goto_zuolengchan ］参数：mode = "..tostring(mode))
    if env.current.id[1] ~= 2478 then
        local rc = goto(2478, mode)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function hengshan_job_refresh()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_refresh ］")
    local l = wait_line("ask zuo lengchan about job", 30, nil, nil, "^你向左冷禅打听有关「job」的消息。$|"..
                                                                    "^这里没有 \\S+ 这个人$|"..
                                                                    "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return hengshan_job_refresh()
    elseif l[0] == "你向左冷禅打听有关「job」的消息。" then
        l = wait_line(nil, 30, nil, nil, "^左冷禅说道：倘若她们冥顽不灵便一并抓回，其他事宜再另行决议。$|"..
                                         "^左冷禅说道：叫你去福建你怎么还在这里闲逛？$|"..
                                         "^左冷禅说道：去了这么久才回来，那些恒山派的女尼早已脱身了！$|"..
                                         "^左冷禅对着你竖起了右手大拇指，好样的。$|"..
                                         "^左冷禅说道：我辈学武之人，最讲究的是正邪是非之辨，\\S+居然和妖魔勾搭成奸，实已犯了武林的大忌。$|"..
                                         "^但是很显然的，左冷禅现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif l[0] == "左冷禅对着你竖起了右手大拇指，好样的。" then
            return hengshan_job_p4()
        elseif l[0] == "左冷禅说道：去了这么久才回来，那些恒山派的女尼早已脱身了！" then
            config.jobs["恒山任务"].phase = phase["任务获取"]
            if privilege_job("恒山任务") == true then
                var.job.statistics = nil
                return 1
            end
            return hengshan_job_refresh()
        elseif l[0] == "左冷禅说道：我辈学武之人，最讲究的是正邪是非之辨，老匹夫居然和妖魔勾搭成奸，实已犯了武林的大忌。" then
            if run_score() < 0 then
                return -1
            end
            if privilege_job("恒山任务") == true then
                var.job.statistics = nil
                return 1
            end
            return hengshan_job_p1()
        elseif l[0] == "但是很显然的，左冷禅现在的状况没有办法给你任何答覆。" then
            var.job.statistics = nil
            return 1
        end
        config.jobs["恒山任务"].phase = phase["任务执行"]
        return
    else
        var.job.statistics = nil
        return 1
    end
end

function hengshan_job_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_exec ］")
    jia_min()
    if wield(config.fight["通用"].weapon) < 0 then
        return -1
    end
    if config.jobs["恒山任务"].phase > phase["任务执行"] then
        return
    end
    local rc
    if var.job.npc == nil then
        rc = hengshan_job_search()
        if rc ~= nil then
            return rc
        end
    end
    for k,v in pairs(var.job.npc) do
        if env.current.id[1] ~= k then
            rc = goto(k)
            if rc < 0 then
                return -1
            end
        end
        if (rc or 0) == 0 then
            var.job.num = {}
            for _,i in ipairs(v) do
                var.job.num[i[1]] = 0
            end
            for _,i in ipairs(env.current.objs) do
                local name = string.match(i, "%S*恒山派第十四代弟子 (%S+)%(.*%)") or string.match(i, "^(%S+)正在运功疗伤$")
                if var.job.num[name] ~= nil then
                    var.job.num[name] = var.job.num[name] + obj_analysis(string.gsub(i, "恒山派第十四代弟子 ", "").."(a b)")
                end
            end
            trigger.enable("hengshan_job_npc_come")
            trigger.enable("hengshan_job_npc_leave")
            rc = hengshan_job_ask_npc(k, v)
            trigger.disable("hengshan_job_npc_come")
            trigger.disable("hengshan_job_npc_leave")
            if rc ~= nil then
                return rc
            end
        end
        if config.jobs["恒山任务"].phase > phase["任务执行"] then
            return hengshan_job()
        end
    end
    var.job.npc = nil
    return hengshan_job_exec()
end

function hengshan_job_search()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_search ］")
    local rc
    rc,var.job.npc,config.jobs["恒山任务"].area = search("^\\s+(?:\\S+位|)恒山派第十四代弟子 (\\S+)\\((\\w+ \\w+)\\)$", config.jobs["恒山任务"].area)
    if rc == -1 then
        return -1
    elseif rc > 0 then
        config.jobs["恒山任务"].phase = phase["任务失败"]
        return hengshan_job_p5()
    end
    return
end

function hengshan_job_ask_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_ask_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if table.is_empty(npc) then
        return
    end
    if config.jobs["恒山任务"].confirm ~= nil then
        if set.last(npc)[1] ~= config.jobs["恒山任务"].confirm then
            set.pop(npc)
            return hengshan_job_ask_npc(room, npc)
        end
    end
    if config.jobs["恒山任务"].arrest == true then
        return hengshan_job_order_npc(room, set.last(npc))
    end
    if config.jobs["恒山任务"].discuss == true then
        return hengshan_job_arrest(room, set.last(npc))
    end
    if var.job.num[set.last(npc)[1]] == 0 then
        var.job.num[set.last(npc)[1]] = nil
        set.pop(npc)
        return hengshan_job_ask_npc(room, npc)
    end
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." "..tostring(var.job.num[set.last(npc)[1]]).." about 援助", 30, nil, nil, "^你向"..set.last(npc)[1].."打听有关「援助」的消息。$|"..
                                                                                                                                          "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                                                                                                                                          "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif string.match(l[0], "打听有关") then
        l = wait_line(nil, 30, nil, nil, "^"..set.last(npc)[1].."说道：“原来是恒山派的朋友，派师姐被魔教之人伏击，多谢这位师兄解围。”$|"..
                                         "^"..set.last(npc)[1].."对你说道：“多谢你的好意，现今我无需援助！”$|"..
                                         "^"..set.last(npc)[1].."说道：“恒山派这样狼子野心，休想知道我师姐妹们的下落。”$|"..
                                         "^但是很显然的，"..set.last(npc)[1].."现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif string.match(l[0], "无需援助") or string.match(l[0], "任何答覆") then
            var.job.num[set.last(npc)[1]] = var.job.num[set.last(npc)[1]] - 1
            return hengshan_job_ask_npc(room, npc)
        elseif string.match(l[0], "狼子野心") then
            config.jobs["恒山任务"].discuss = true
            return hengshan_job_arrest(room, set.last(npc))
        end
        local num = var.job.num[set.last(npc)[1]]
        var.job.num = {}
        var.job.num[set.last(npc)[1]] = num
        config.jobs["恒山任务"].confirm = set.last(npc)[1]
        return hengshan_job_discuss(room, set.last(npc))
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return hengshan_job_ask_npc(room, npc)
    end
    var.job.num[set.last(npc)[1]] = var.job.num[set.last(npc)[1]] - 1
    return hengshan_job_ask_npc(room, npc)
end

function hengshan_job_discuss(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_discuss ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if var.job.num[npc[1]] == 0 then
        if wait_line("look", 30, nil, nil, "^> $") == false then
            return -1
        end
        config.jobs["恒山任务"].area = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
        set.append(config.jobs["恒山任务"].area, room)
        return
    end
    local l = wait_line("discuss "..string.lower(npc[2]).." "..tostring(var.job.num[npc[1]]), 60, nil, nil, "^\\S+连连摇手，喝道：“你再说下去，没的污了我耳朵。”$|"..
                                                                                                            "^你要和谁商讨有关并派之事？$|"..
                                                                                                            "^什么\\?$")
    if l == false then
        return -1
    elseif l[0] == "你要和谁商讨有关并派之事？" then
        var.job.num[npc[1]] = var.job.num[npc[1]] - 1
    elseif l[0] == "什么?" then
        config.jobs["恒山任务"].discuss = true
        return hengshan_job_arrest(room, npc)
    else
        config.jobs["恒山任务"].discuss = true
        trigger.add("hengshan_job_npc_esc", "hengshan_job_npc_esc(get_matches(1))", "hengshan_job", {Enable=true, OneShot=true}, 100, "^"..npc[1].."\\S*往(\\S+)(?:离开|走了出去)。$")
        if wait_no_busy("halt") < 0 then
            return -1
        end
        if var.job.esc == nil then
            local around = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
            config.jobs["恒山任务"].area = set.union(set.compl(config.jobs["恒山任务"].area, around), around)
        else
            room = get_room_id_by_roomsfrom({room}, get_room_id_around(), var.job.esc)[1]
            l = wait_line(var.job.esc, 30, nil, nil, "^\\S+ - |"..
                                                     "^什么\\?$|"..
                                                     "^没有这个方向。$")
            if l == false then
                return -1
            elseif l[0] == "什么?" or l[0] == "没有这个方向。" then
                if wait_line("look", 30, nil, nil, "^> $") == false then
                    return -1
                end
                config.jobs["恒山任务"].area = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
                set.append(config.jobs["恒山任务"].area, room)
                return hengshan_job_exec()
            end
            var.job.num[npc[1]] = 1
            if room == nil then
                if locate() < 0 then
                    return -1
                end
                room = env.current.id[1]
            end
        end
        return hengshan_job_arrest(room, npc)
    end
    return hengshan_job_discuss(room, npc)
end

function hengshan_job_arrest(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_arrest ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if var.job.num[npc[1]] == 0 then
        if wait_line("look", 30, nil, nil, "^> $") == false then
            return -1
        end
        config.jobs["恒山任务"].area = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
        set.append(config.jobs["恒山任务"].area, room)
        return
    end
    if prepare_skills() < 0 then
        return -1
    end
    local l = wait_line("wear mian zhao", 30, nil, nil, "^你戴上一个面罩。$|"..
                                                        "^你已经装备着了。$|"..
                                                        "^你已经穿戴了同类型的护具了。$|"..
                                                        "^你身上没有这样东西。$")
    if l == false then
        return -1
    elseif l[0] == "你已经穿戴了同类型的护具了。" then
        if wait_line("remove all;wear mian zhao", 30, nil, nil, "^你戴上一个面罩。$") == false then
            return -1
        end
    elseif l[0] == "你身上没有这样东西。" then
        config.jobs["恒山任务"].phase = phase["任务失败"]
        return hengshan_job_p5()
    end
    if wield(config.fight["恒山任务"].weapon or config.fight["通用"].weapon) ~= 0 then
        return -1
    end
    l = wait_line("arrest "..string.lower(npc[2]).." "..tostring(var.job.num[npc[1]]), 30, nil, nil, "^看起来"..npc[1].."想杀死你！$|"..
                                                                                                     "^这里不准战斗。$|"..
                                                                                                     "^这里并无此人！$|"..
                                                                                                     "^左盟主派你来抓的不是此人。$")
    if l == false then
        return -1
    elseif l[0] == "这里并无此人！" or l[0] == "左盟主派你来抓的不是此人。" then
        var.job.num[npc[1]] = var.job.num[npc[1]] - 1
    elseif l[0] == "这里不准战斗。" then
        config.jobs["恒山任务"].phase = phase["任务失败"]
        return hengshan_job_p5()
    else
        var.job.enemy_name = npc[1]
        trigger.add("hengshan_job_win", "hengshan_job_win()", "hengshan_job", {Enable=true, OneShot=true}, 99, "^你说道：“左掌门好好劝你归降投诚，你偏偏固执不听，自今而后，武林中可再没恒山一派了。$")
        local rc = fight()
        if rc == 0 then
            config.jobs["恒山任务"].arrest = true
            if wait_no_busy() < 0 then
                return -1
            end
            return hengshan_job_order_npc(room, npc)
        elseif rc == 2 then
            rc = hengshan_job_one_step()
            if rc ~= nil then
                return rc
            end
            if goto(room) ~= 0 then
                config.jobs["恒山任务"].phase = phase["任务失败"]
                return hengshan_job_p5()
            end
        end
    end
    return hengshan_job_arrest(room, npc)
end

function hengshan_job_one_step()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_one_step ］")
    local rc = one_step()
    if rc ~= 0 then
        return -1
    else
        if recover(config.job_nl) ~= 0 then
            return -1
        end
        return
    end
end

function hengshan_job_order_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_order_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if var.job.num[npc[1]] == 0 then
        if wait_line("look", 30, nil, nil, "^> $") == false then
            return -1
        end
        config.jobs["恒山任务"].area = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
        set.append(config.jobs["恒山任务"].area, room)
        return
    end
    local l = wait_line("ask "..string.lower(npc[2]).." "..tostring(var.job.num[npc[1]]).." about 动身", 30, nil, nil, "^你向"..npc[1].."打听有关「动身」的消息。$|"..
                                                                                                                        "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                                                                                                                        "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif string.match(l[0], "打听有关") then
        l = wait_line(nil, 30, nil, nil, "^"..npc[1].."被迫开始跟随你一起行动。$|"..
                                         "^"..npc[1].."说道：我现在正忙着呢，有事儿等会再说吧。$|"..
                                         "^"..npc[1].."说道：我与你素未谋面，你想带我到哪去？$|"..
                                         "^但是很显然的，"..npc[1].."现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif string.match(l[0], "跟随你") then
            config.jobs["恒山任务"].phase = phase["任务结算"]
            return
        elseif string.match(l[0], "我现在正忙") then
            wait(1)
        else
            var.job.num[npc[1]] = var.job.num[npc[1]] - 1
        end
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
    else
        var.job.num[npc[1]] = var.job.num[npc[1]] - 1
    end
    return hengshan_job_order_npc(room, npc)
end

function hengshan_job_npc_come(name)
    if var.job.num[name] == nil then
        return
    end
    var.job.num[name] = var.job.num[name] + 1
end

function hengshan_job_npc_leave(name)
    if var.job.num[name] == nil then
        return
    end
    var.job.num[name] = var.job.num[name] - 1
end

function hengshan_job_win()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
end

function hengshan_job_npc_esc(esc)
    var.job.esc = get_desc_dir(esc)
end

config.jobs["恒山任务"].func = hengshan_job
config.jobs["恒山任务"].efunc = enable_hengshan_job
config.jobs["恒山任务"].dfunc = disable_hengshan_job
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")