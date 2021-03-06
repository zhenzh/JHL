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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job ］")
    automation.idle = false
    var.job = var.job or {name = "恒山任务"}
    var.job.enemy_name = "蒙面人"
    var.job.search = {"秦娟", "郑鄂", "仪文", "仪和", "仪琳", "仪质", "仪清"}
    var.job.delta = -1
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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    trigger.disable_group("hengshan_job")
    config.jobs["恒山任务"].confirm = nil
    config.jobs["恒山任务"].area = nil
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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_p1 ］")
    if profile.mole < 0 and profile.family ~= "恒山派" then
        local rc = zero_mole()
        if rc ~= 0 then
            return rc
        end
    end
    local rc = hengshan_job_go_dingxian()
    if rc ~= nil then
        return rc
    end
    rc = hengshan_job_refresh()
    if rc ~= nil then
        return rc
    end
end

function hengshan_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_p2 ］")
    if config.jobs["恒山任务"].area == nil then
        config.jobs["恒山任务"].area = hengshan_job_area
    end
    jia_min()
    if wield(config.fight["通用"].weapon) < 0 then
        return -1
    end
    if config.jobs["恒山任务"].phase > phase["任务执行"] then
        return hengshan_job()
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
            rc = go(k)
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
    return hengshan_job_p2()
end

function hengshan_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_p3 ］")
    automation.idle = false
    local rc = hengshan_job_go_dingxian("walk")
    if rc ~= nil then
        return rc
    end
    return hengshan_job_refresh()
end

function hengshan_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_p4 ］")
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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_p5 ］")
    local rc = hengshan_job_go_dingxian()
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

function hengshan_job_go_dingxian(mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_go_dingxian ］参数：mode = "..tostring(mode))
    if env.current.id[1] ~= 2449 then
        local rc = go(2449, mode)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function hengshan_job_refresh()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_refresh ］")
    local l = wait_line("ask dingxian shitai about job",
                        30, nil, nil,
                        "^你向定闲师太打听有关「job」的消息。$|"..
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
    elseif l[0] == "你向定闲师太打听有关「job」的消息。" then
        l = wait_line(nil,
                      30, nil, nil,
                      "^定闲师太说道：本派收到定静师姐飞鸽传书，我派(\\S+)名弟子在福建泉州遇袭，劳烦施主速到福建$|"..
                      "^定闲师太说道：施主可找到我派被困弟子 ？$|"..
                      "^定闲师太对你说道：“唉！施主既肯出手相助，为何不能彻底相助呢$|"..
                      "^定闲师太说道：施主上次未能将本派弟子尽数救出，看来未把本派弟子放在心上，贫尼暂时不敢劳烦施主大驾了。$|"..
                      "^定闲师太说道：施主救我派弟子于大难，无以为报，贫尼只有朝夕以清香一炷，祷祝施主福体康健，万事如意了。”$|"..
                      "^定闲师太说道：施主已堕入魔道，贫尼岂敢劳烦。$|"..
                      "^但是很显然的，定闲师太现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif l[0] == "定闲师太说道：施主救我派弟子于大难，无以为报，贫尼只有朝夕以清香一炷，祷祝施主福体康健，万事如意了。”" then
            config.jobs["恒山任务"].phase = phase["任务完成"]
            return hengshan_job_p4()
        elseif l[0] == "定闲师太对你说道：“唉！施主既肯出手相助，为何不能彻底相助呢" then
            config.jobs["恒山任务"].phase = phase["任务完成"]
            config.jobs["恒山任务"].active = false
            timer.add("hengshan_job_cd", 900, "config.jobs['恒山任务'].active = true", "hengshan_job", {Enable=true, OneShot=true})
            return hengshan_job_p4()
        elseif l[0] == "定闲师太说道：施主上次未能将本派弟子尽数救出，看来未把本派弟子放在心上，贫尼暂时不敢劳烦施主大驾了。" then
            config.jobs["恒山任务"].phase = phase["任务失败"]
            return hengshan_job_p5()
        elseif l[0] == "定闲师太说道：施主已堕入魔道，贫尼岂敢劳烦。" then
            if run_score() < 0 then
                return -1
            end
            if privilege_job("恒山任务") == true then
                var.job.statistics = nil
                return 1
            end
            return hengshan_job_p1()
        elseif l[0] == "但是很显然的，定闲师太现在的状况没有办法给你任何答覆。" then
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

function hengshan_job_search()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_search ］")
    local rc
    if var.job.pattern == nil then
        rc,var.job.npc,config.jobs["恒山任务"].area = search("^\\s+(?:\\S+位|)恒山派第十四代弟子 (set.concat(var.job.search, '|'))\\((\\w+ \\w+)\\)$", config.jobs["恒山任务"].area)
    else
        rc,var.job.npc,var.job.area = search(var.job.pattern, var.job.area)
    end
    if rc == -1 then
        return -1
    elseif rc > 0 then
        if var.job.pattern ~= nil then
            var.job.pattern = nil
            var.job.area = nil
            return hengshan_job_search()
        end
        config.jobs["恒山任务"].phase = phase["任务失败"]
        return hengshan_job_p5()
    end
    return
end

function hengshan_job_ask_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_ask_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if table.is_empty(npc) then
        return
    end
    if config.jobs["恒山任务"].confirm[set.last(npc)[1]] == true then
        var.job.num[set.last(npc)[1]] = 0
    end
    if var.job.num[set.last(npc)[1]] == 0 then
        var.job.num[set.last(npc)[1]] = nil
        set.pop(npc)
        return hengshan_job_ask_npc(room, npc)
    end
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." "..tostring(var.job.num[set.last(npc)[1]]).." about 援助",
                        30, nil, nil,
                        "^你向"..set.last(npc)[1].."打听有关「援助」的消息。$|"..
                        "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                        "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif string.match(l[0], "打听有关") then
        l = wait_line(nil,
                      30, nil, nil,
                      "^"..set.last(npc)[1].."说道：“是掌门请你来的吧，我派师姐被魔教之人伏击，多谢大侠相助。”$|"..
                      "^"..set.last(npc)[1].."对你说道：“多谢你的好意，现今我无需援助！”$|"..
                      "^但是很显然的，"..set.last(npc)[1].."现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif string.match(l[0], "无需援助") or string.match(l[0], "任何答覆") then
            var.job.num[set.last(npc)[1]] = var.job.num[set.last(npc)[1]] - 1
            return hengshan_job_ask_npc(room, npc)
        end
        local num = var.job.num[set.last(npc)[1]]
        var.job.num = {}
        var.job.num[set.last(npc)[1]] = num
        return hengshan_job_rescue_npc(room, set.last(npc))
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return hengshan_job_ask_npc(room, npc)
    end
    var.job.num[set.last(npc)[1]] = var.job.num[set.last(npc)[1]] - 1
    return hengshan_job_ask_npc(room, npc)
end

function hengshan_job_rescue_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_rescue_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if var.job.num[npc[1]] == 0 then
        if wait_line("look", 30, nil, nil, "^> $") == false then
            return -1
        end
        return
    end
    local l = wait_line("jiu "..string.lower(npc[2]).." "..tostring(var.job.num[npc[1]]),
                        30, nil, nil,
                        "^你转身一看，一个黑巾蒙面的蒙面人挥剑刺向你的要穴！$|"..
                        "^你要救谁？$|"..
                        "^这是你要救的人吗？$|"..
                        "^已经救醒了，还救什么？想吃豆腐呀！$")
    if l == false then
        return -1
    elseif l[0] == "这是你要救的人吗？" or l[0] == "你要救谁？" then
        var.job.num[npc[1]] = var.job.num[npc[1]] - 1
    elseif l[0] == "已经救醒了，还救什么？想吃豆腐呀！" then
        config.jobs["恒山任务"].confirm[npc[1]] = true
        return hengshan_job_order_npc(room, npc)
    else
        config.jobs["恒山任务"].confirm[npc[1]] = false
        trigger.add("hengshan_job_win", "hengshan_job_win()", "hengshan_job", {Enable=true, OneShot=true}, 99, "^蒙面人虚晃一招跳出战圈，一纵身逃了$")
        local rc = fight()
        if rc == 0 then
            config.jobs["恒山任务"].confirm[npc[1]] = true
            set.delete(var.job.search, npc[1])
            if wait_no_busy() < 0 then
                return -1
            end
            return hengshan_job_order_npc(room, npc)
        elseif rc == 2 then
            rc = hengshan_job_one_step()
            if rc ~= nil then
                return rc
            end
            if go(room) ~= 0 then
                var.job.pattern = nil
                var.job.area = nil
                return hengshan_job_p2()
            end
        end
    end
    return hengshan_job_rescue_npc(room, npc)
end

function hengshan_job_order_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ hengshan_job_order_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if var.job.num[npc[1]] == 0 then
        if var.job.retry == nil then
            var.job.retry = true
        else
            var.job.retry = nil
            config.jobs["恒山任务"].progress = config.jobs["恒山任务"].progress - 1
            return
        end
        var.job.delta = 1
        var.job.num[npc[1]] = 2
    end
    local l = wait_line("ask "..string.lower(npc[2]).." "..tostring(var.job.num[npc[1]]).." about 动身",
                        30, nil, nil,
                        "^你向"..npc[1].."打听有关「动身」的消息。$|"..
                        "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                        "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif string.match(l[0], "打听有关") then
        l = wait_line(nil, 30, nil, nil, "^"..npc[1].."决定开始跟随你一起行动。$|"..
                                         "^"..npc[1].."说道：我现在正忙着呢，有事儿等会再说吧。$|"..
                                         "^"..npc[1].."说道：我与你素未谋面，你想带我到哪去？$|"..
                                         "^"..npc[1].."说道：先赶走蒙面人再起程吧！$|"..
                                         "^但是很显然的，"..npc[1].."现在的状况没有办法给你任何答覆。$")
        if l == false then
            return -1
        elseif string.match(l[0], "跟随你") then
            var.job.retry = nil
            config.jobs["恒山任务"].progress = config.jobs["恒山任务"].progress - 1
            if config.jobs["恒山任务"].progress == 0 then
                return
            end
            return hengshan_job_next_info(room, npc)
        elseif string.match(l[0], "先赶走") then
            var.job.retry = nil
            config.jobs["恒山任务"].confirm[npc[1]] = false
            return hengshan_job_rescue_npc(room, npc)
        else
            var.job.num[npc[1]] = var.job.num[npc[1]] + var.job.delta
        end
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
    else
        if l[0] ~= "对方正忙着呢，你等会儿在问话吧。" then
            var.job.delta = -1 -- heal
        end
        var.job.num[npc[1]] = var.job.num[npc[1]] + var.job.delta
    end
    return hengshan_job_order_npc(room, npc)
end

function hengshan_job_next_info(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_next_info ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if var.job.num[npc[1]] == 0 then
        if var.job.retry == nil then
            var.job.retry = true
        else
            var.job.retry = nil
            config.jobs["恒山任务"].progress = config.jobs["恒山任务"].progress - 1
            return
        end
        var.job.delta = 1
        var.job.num[npc[1]] = 2
    end
    local l = wait_line("ask "..string.lower(npc[2]).." "..tostring(var.job.num[npc[1]]).." about 下落", 30, nil, nil, "^"..npc[1].."说道：“我只知道(\\S+)师姐被困在(\\S+)请大侠一并解救吧！$|"..
                                                                                                                      "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                                                                                                                      "^"..npc[1].."素未谋面，怎可告之$|"..
                                                                                                                      "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
    elseif l[0] == "对方正忙着呢，你等会儿在问话吧。" then
        wait(0.1) -- heal
    elseif l[1] ~= nil then
        var.job.npc = {}
    else
        if string.match(l[0], "这里没有") then
            var.job.delta = -1
        end
        var.job.num[npc[1]] = var.job.num[npc[1]] + var.job.delta
    end
    return hengshan_job_next_info(room, npc)
end

function hengshan_job_separate_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hengshan_job_separate_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
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