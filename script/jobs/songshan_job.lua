local songshan_job_area = {
    1144,1295,1279,1280,1294,1286,1294,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,
    1293,1296,22,23,24,23,22,17,18,19,21,19,18,1,18,17,16,15,14,13,12,10,26,10,11,10,9,8,7,3,120,3,4,6,
    4,5,4,3,2,1,87,89,90,91,90,89,87,88,87,1,28,85,84,82,83,82,81,46,28,29,30,29,31,32,33,34,35,42,35,41,
    35,39,40,36,39,36,38,36,37,36,35,34,33,32,31,43,44,45,44,46,47,48,49,74,75,76,77,78,77,76,75,79,80,
    79,75,74,49,50,51,52,51,59,51,50,60,61,60,50,49,70,71,70,69,72,73,72,69,62,63,64,68,64,65,64,67,66
}

function enable_songshan_job()
    trigger.delete_group("songshan_job")
    trigger.add("ftb_job_wait_info", "ftb_job_wait_info()", "ftb_job", {Enable=false, Multi=true}, 99, "^程金斧说道：听说有(\\S+)个家伙想对本帮不利.\\n程金斧说道：据说他们已经到了(\\S+)(?:\\(该处靠近([\\S, ]+)\\)|)方圆(\\S+)里之内.$")
end

function disable_songshan_job()
    trigger.delete_group("songshan_job")
end

local phase = {
    ["任务获取"] = 1,
    ["任务执行"] = 2,
    ["任务结算"] = 3,
    ["任务完成"] = 4,
    ["任务失败"] = 5
}

function songshan_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job ］")
    automation.idle = false
    var.job = var.job or {name = "嵩山任务"}
    var.job.statistics = var.job.statistics or {name = "嵩山任务"}
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    if config.jobs["嵩山任务"].phase == phase["任务获取"] then
        local rc = songshan_job_p1()
        if rc ~= nil then
            return songshan_job_return(rc)
        end
    end
    if config.jobs["嵩山任务"].phase == phase["任务执行"] then
        return songshan_job_return(songshan_job_p2())
    end
    if config.jobs["嵩山任务"].phase == phase["任务结算"] then
        local rc = songshan_job_p3()
        if rc ~= nil then
            return songshan_job_return(rc)
        end
    end
    if config.jobs["嵩山任务"].phase == phase["任务完成"] then
        return songshan_job_return(songshan_job_p4())
    end
    if config.jobs["嵩山任务"].phase == phase["任务失败"] then
        return songshan_job_return(songshan_job_p5())
    end
end

function songshan_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    config.jobs["嵩山任务"].npc = nil
    var.statistics = var.job.statistics
    trigger.disable_group("songshan_job")
    var.job = nil
    return rc
end

function songshan_job_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_p1 ］")
    local rc = songshan_job_goto_zuolengchan()
    if rc ~= nil then
        return rc
    end
    rc = songshan_job_aquire()
    if rc ~= nil then
        return rc
    end
end

function songshan_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_p2 ］")
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    if config.jobs["嵩山任务"].area == nil then
        config.jobs["嵩山任务"].area = songshan_job_area
    end
end

function songshan_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_p3 ］")
    
end

function songshan_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_p4 ］")
    return 0
end

function songshan_job_p5()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_p5 ］")
    config.jobs["嵩山任务"].active = false
    if timer.is_exist("songshan_job_cd") == false then
        timer.add("songshan_job_cd", 120, "config.jobs['嵩山任务'].active = true", "songshan_job", {Enable=true, OneShot=true})
    end
    if var.job.statistics ~= nil then
        var.job.statistics.exp = state.exp - var.job.statistics.exp
        var.job.statistics.pot = state.pot - var.job.statistics.pot
        var.job.statistics.result = "失败"
        var.job.statistics.end_time = time.epoch()
    end
    return 1
end

function songshan_job_goto_zuolengchan()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_goto_zuolengchan ］")
    if env.current.id[1] ~= 2478 then
        local rc = goto(2478)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function songshan_job_aquire()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_refresh ］")
    local l = wait_line("ask zuo lengchan about job", 30, nil, nil, "^你向左冷禅打听有关「job」的消息。$|"..
                                                                    "^这里没有 \\S+ 这个人$|"..
                                                                    "^(\\S+)忙着呢，你等会儿在问话吧。$|"..
                                                                    "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$")
    if l == false then
        return -1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return songshan_job_aquire()
    elseif l[0] == "你向左冷禅打听有关「job」的消息。" then
        l = wait_line(nil, 30, nil, nil, "^左冷禅给你一个面罩。$|"..
                                         "^左冷禅说道：叫你去福建你怎么还在这里闲逛？$|"..
                                         "^左冷禅说道：去了这么久才回来，那些恒山派的女尼早已脱身了！$")
        if l == false then
            return -1
        end
        config.jobs["嵩山任务"].phase = phase["任务执行"]
        if l[0] == "左冷禅说道：叫你去福建你怎么还在这里闲逛？" then
            if run_i() < 0 then
                return -1
            end
            if is_own("面罩:mian zhao") ~= true then
                config.jobs["嵩山任务"].phase = phase["任务失败"]
                return songshan_job_p5()
            end
        elseif l[0] == "左冷禅说道：去了这么久才回来，那些恒山派的女尼早已脱身了！" then
            config.jobs["嵩山任务"].phase = phase["任务获取"]
            if privilege_job("嵩山任务") == true then
                var.job.statistics = nil
                return 1
            end
            return songshan_job_aquire()
        end
        return
    end
end

function songshan_job_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_exec ］")
    jia_min()
    if wield(config.fight["通用"].weapon) < 0 then
        return -1
    end
    if config.jobs["嵩山任务"].phase > phase["任务执行"] then
        return
    end
    if config.jobs["嵩山任务"].npc == nil then
        local rc = songshan_job_search()
        if rc ~= nil then
            return rc
        end
    end
    for k,v in pairs(config.jobs["嵩山任务"].npc) do
        local rc = songshan_job_ask_npc(k, v)
        if rc == nil then
            rc = songshan_job_hit_npc(k, v)
        end
        if rc == -1 then
            return -1
        end
    end
    return songshan_job_exec()
end

function songshan_job_search()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_search ］")
    local rc
    rc,config.jobs["嵩山任务"].npc,config.jobs["嵩山任务"].area = search("^\\s+(?:\\S+位|)恒山派第十四代弟子 (\\S+)\\((\\w+ \\w+)\\)$", config.jobs["嵩山任务"].area)
    if rc == -1 then
        return -1
    elseif rc > 0 then
        config.jobs["嵩山任务"].phase = phase["任务失败"]
        return songshan_job_p5()
    end
    return
end

function songshan_job_ask_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ songshan_job_ask_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if table.is_empty(npc) then
        return 1
    end
    if env.current.id[1] ~= room then
        if goto(room) ~= 0 then
            config.jobs["嵩山任务"].npc[room] = nil
            return 1
        end
    end
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." about 援助", 30, nil, nil, "^你向"..set.last(npc)[1].."打听有关「援助」的消息。$|"..
                                                                                            "^你忙着呢，你等会儿在问话吧。$|"..
                                                                                            "^这里没有 .+ 这个人。$|"..
                                                                                            "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$|"..
                                                                                            "^"..set.last(npc)[1].."忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif string.match(l[0], "打听有关") then
        l = wait_line(nil, 30, nil, nil, "^"..set.last(npc)[1].."说道：“原来是嵩山派的朋友，派师姐被魔教之人伏击，多谢这位师兄解围。”$|"..)
        set.append(config.jobs["斧头帮任务"].confirm, set.last(npc)[1])
        return
    elseif string.match(l[0], "你忙着呢，你等会儿在问话吧。") then
        wait(0.1)
    else
        set.pop(npc)
    end
    return ftb_job_ask_npc(room, npc)
end

function ftb_job_kill_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_kill_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if prepare_skills() < 0 then
        return -1
    end
    if wield(config.fight["斧头帮任务"].weapon) ~= 0 then
        return -1
    end
    local l = wait_line("kill "..string.lower(set.last(npc)[2]), 30, nil, nil, "^你对著"..set.last(npc)[1].."喝道：「\\S+」$|"..
                                                                               "^这里没有这个人。$|"..
                                                                               "^你现在正忙着呢。$|"..
                                                                               "^这里不准战斗。$")
    if l == false then
        return -1
    elseif l[0] == "你现在正忙着呢。" then
        wait(0.1)
    elseif l[0] == "这里没有这个人。" then
        local around = get_room_id_around()
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
        return
    elseif l[0] == "这里不准战斗。" then
        local rc = ftb_job_drive_npc(room, npc)
        timer.delete("ftb_job_timeout")
        return rc
    else
        var.job.enemy_name = set.last(npc)[1]
        trigger.add("ftb_job_enemy_die", "ftb_job_enemy_die()", "ftb_job", {Enable=true}, 99, "^"..var.job.enemy_name.."倒在地上，挣扎了几下就死了。$")
        local rc = fight()
        if rc == 0 then
            config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy - 1
            config.jobs["斧头帮任务"].progress = (config.jobs["斧头帮任务"].progress or 0) + 1
            set.pop(npc)
            rc = ftb_job_post_kill()
            if rc ~= nil then
                return rc
            end
            return
        elseif rc == 2 then
            return ftb_job_one_step()
        elseif rc == 1 then
            if var.job.npc[1718] == nil then
                config.jobs["斧头帮任务"].dest = set.union({1718}, config.jobs["斧头帮任务"].dest)
            end
            if env.current.name ~= "树上" then
                set.pop(npc)
            end
            return
        end
    end
    return ftb_job_kill_npc(npc)
end

function ftb_job_drive_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_kill_npc ］room = "..tostring(room)..", npc = "..table.tostring(npc))
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." about 程金斧", 30, nil, nil, "^你忙着呢，你等会儿在问话吧。$|"..
                                                                                              "^这里没有 .+ 这个人。$|"..
                                                                                              "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$|"..
                                                                                              "^"..set.last(npc)[1].."\\S*往(\\S+)走了出去。$|"..
                                                                                              "^"..set.last(npc)[1].."忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return ftb_job_drive_npc(npc)
    elseif string.match(l[0], "这里没有") then
        local around = get_room_id_around()
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
    elseif l[1] ~= false then
        room = get_room_id_by_roomsfrom(env.current.id, get_room_id_around(), get_desc_dir(l[1]))[1]
        var.job.npc[room] = var.job.npc[room] or {}
        set.append(var.job.npc[room], set.pop(npc))
    else
        if config.jobs["斧头帮任务"].enemy > 1 then
            config.jobs["斧头帮任务"].dest = set.union(get_room_id_around(), config.jobs["斧头帮任务"].dest)
            set.insert(config.jobs["斧头帮任务"].dest, env.current.id[1], 1)
            return
        else
            if var.job.timeout == true then
                config.jobs["斧头帮任务"].enemy = 0
                return
            end
            if var.job.timeout == nil then
                timer.add("ftb_job_timeout", 60, "var.job.timeout = true")
            end
            local nl = state.nl
            local rc = dazuo()
            if rc < 0 then
                return -1
            elseif rc ~= 0 or state.nl == nl then
                wait(1)
            end
            return ftb_job_drive_npc(npc)
        end
    end
    return
end

function ftb_job_one_step()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_one_step ］")
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

function ftb_job_post_kill()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_post_kill ］")
    if wait_no_busy() < 0 then
        return -1
    end
    local rc = yun_bidu()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        rc = ask_ping()
        if rc < 0 then
            return -1
        end
    end
    rc = yun_forceheal()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        rc = ask_ping()
        if rc < 0 then
            return -1
        end
    end
    return
end

function ftb_job_wait_info()
    config.jobs["斧头帮任务"].enemy = chs2num(get_matches(1))
    if get_matches(2) == config.jobs["斧头帮任务"].info then
        config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy - (config.jobs["斧头帮任务"].progress or 0)
        if config.jobs["斧头帮任务"].enemy == 0 then
            config.jobs["斧头帮任务"].enemy = 1
        end
    end
    config.jobs["斧头帮任务"].info = get_matches(2)
    config.jobs["斧头帮任务"].around = get_matches(3)
    config.jobs["斧头帮任务"].range = chs2num(get_matches(4))
    if config.jobs["斧头帮任务"].info == "少林寺0" then
        config.jobs["斧头帮任务"].info = "塘沽口"  -- BUG 临时处理
    end
    var.job.range = config.jobs["斧头帮任务"].range
    config.jobs["斧头帮任务"].phase = phase["任务执行"]
end

function ftb_job_enemy_die()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
end

function ftb_job_active()
    config.jobs["斧头帮任务"].active = true
    config.jobs["斧头帮任务"].phase = phase["任务更新"]
end

config.jobs["斧头帮任务"].func = ftb_job
config.jobs["斧头帮任务"].efunc = enable_ftb_job
config.jobs["斧头帮任务"].dfunc = disable_ftb_job
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")