family_info = {
    ["御林军"]   =   {master_name = "多隆",     master_id = "duo long",       master_place = 2286, enemy_name = "江湖反贼", enemy_id = "jianghu fanzei"},
    ["丐帮"]     =   {master_name = "洪七公",   master_id = "hong qigong",    master_place = 1121, enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["华山派"]   =   {master_name = "岳不群",   master_id = "yue buqun",      master_place = 874,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["日月神教"] =   {master_name = "杨莲亭",   master_id = "yang lianting",  master_place = 2784,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["神龙教"]   =   {master_name = "洪安通",   master_id = "hong antong",    master_place = 2246, enemy_name = "朝廷武官", enemy_id = "chaoting wuguan"},
    ["万兽山庄"] =   {master_name = "史伯威",   master_id = "shi bowei",      master_place = 2734, enemy_name = "蒙古哒子", enemy_id = "menggu dazi"},
    ["姑苏慕容"] =   {master_name = "慕容复",   master_id = "murong fu",      master_place = 2067, enemy_name = "朝廷武官", enemy_id = "chaoting wuguan"},
    ["明教"]     =   {master_name = "杨逍",     master_id = "yang xiao",      master_place = 573,  enemy_name = "江湖侠士", enemy_id = "jianghu xiashi"},
    ["昆仑派"]   =   {master_name = "何太冲",   master_id = "he taichong",    master_place = 2895, enemy_name = "蒙古哒子", enemy_id = "menggu dazi"},
    ["少林派"]   =   {master_name = "玄慈大师", master_id = "xuanci dashi",   master_place = 1651, enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["峨嵋派"]   =   {master_name = "灭绝师太", master_id = "miejue shitai",  master_place = 372,  enemy_name = "魔教弟子", enemy_id = "mojiao dizi"},
    ["桃花岛"]   =   {master_name = "陆乘风",   master_id = "lu chengfeng",   master_place = 1470, enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["全真教"]   =   {master_name = "马钰",     master_id = "ma yu",          master_place = 792,  enemy_name = "魔教弟子", enemy_id = "mojiao dizi"},
    ["星宿派"]   =   {master_name = "丁春秋",   master_id = "ding chunqiu",   master_place = 1442, enemy_name = "江湖侠士", enemy_id = "jianghu xiashi"},
    ["嵩山派"]   =   {master_name = "左冷禅",   master_id = "zuo lengchan",   master_place = 2478,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["雪山派"]   =   {master_name = "鸠摩智",   master_id = "jiumozhi",       master_place = 436,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["血刀门"]   =   {master_name = "鸠摩智",   master_id = "jiumozhi",       master_place = 436,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["大理段家"] =   {master_name = "段正淳",   master_id = "duan zhengchun", master_place = 191,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["白驼山"]   =   {master_name = "欧阳峰",   master_id = "ouyang feng",    master_place = 1801, enemy_name = "江湖侠士", enemy_id = "jianghu xiashi"},
    ["武当派"]   =   {master_name = "张三丰",   master_id = "zhang sanfeng",  master_place = 677,  enemy_name = "蒙古哒子", enemy_id = "menggu dazi"},
    ["古墓派"]   =   {master_name = "黄衫女子", master_id = "huangshan nuzi", master_place = 2374, enemy_name = "蒙古哒子", enemy_id = "menggu dazi"},
    ["灵鹫宫"]   =   {master_name = "天山童姥", master_id = "tong lao",       master_place = 2171,  enemy_name = "强盗",     enemy_id = "qiang dao"},
    ["关外胡家"] =   {master_name = "平阿四",   master_id = "ping si",        master_place = 3188,  enemy_name = "强盗",     enemy_id = "qiang dao"},
}

local enemy_choose = { -- 敌人选择
    ["全杀"]     =   false,
    ["御林军"]   =   { ["空手"] = false, ["钢杖"] = false, ["长剑"] = false, ["钢刀"] = false, ["双钩"] = false },
    ["丐帮"]     =   { ["空手"] = false, ["钢杖"] = true,  ["竹棒"] = true,  ["长剑"] = true,  ["钢刀"] = true },
    ["华山派"]   =   { ["空手"] = true,  ["长剑"] = true,  ["钢刀"] = true },
    ["日月神教"] =   { ["空手"] = true,  ["钢杖"] = true,  ["长剑"] = true,  ["钢刀"] = false, ["长鞭"] = false, ["双钩"] = false },
    ["神龙教"]   =   { ["空手"] = true,  ["钢杖"] = true,  ["长剑"] = true,  ["钢刀"] = false, ["长鞭"] = false, ["双钩"] = false },
    ["万兽山庄"] =   { ["空手"] = false, ["钢杖"] = false, ["竹棒"] = false, ["长剑"] = false, ["钢刀"] = false },
    ["姑苏慕容"] =   { ["空手"] = false, ["长剑"] = false, ["钢刀"] = false },
    ["明教"]     =   { ["空手"] = true,  ["钢杖"] = false, ["长剑"] = true,  ["钢刀"] = true },
    ["昆仑派"]   =   { ["空手"] = false, ["长剑"] = false, ["钢刀"] = false, ["长鞭"] = false },
    ["少林派"]   =   { ["空手"] = false, ["竹棒"] = false, ["长剑"] = false, ["钢刀"] = false, ["长鞭"] = false, ["禅杖"] = false },
    ["峨嵋派"]   =   { ["空手"] = false, ["长剑"] = false, ["钢刀"] = false, ["长鞭"] = false, ["双钩"] = false },
    ["桃花岛"]   =   { ["空手"] = false, ["铁箫"] = true,  ["长鞭"] = true },
    ["全真教"]   =   { ["空手"] = false, ["长剑"] = false, ["钢刀"] = false, ["长鞭"] = false },
    ["星宿派"]   =   { ["空手"] = true,  ["钢杖"] = true,  ["长剑"] = false, ["钢刀"] = false },
    ["嵩山派"]   =   { ["空手"] = false, ["钢杖"] = false, ["长剑"] = false, ["钢刀"] = false, ["长鞭"] = false },
    ["雪山派"]   =   { ["空手"] = false, ["长剑"] = true,  ["钢刀"] = true,  ["禅杖"] = true,  ["法轮"] = false },
    ["大理段家"] =   { ["空手"] = false, ["钢杖"] = false, ["长剑"] = false, ["钢刀"] = false },
    ["白驼山"]   =   { ["空手"] = false, ["蛇杖"] = true },
    ["武当派"]   =   { ["空手"] = false, ["长剑"] = false },
    ["古墓派"]   =   { ["空手"] = false, ["长剑"] = false, ["钢刀"] = false, ["长鞭"] = false, ["双钩"] = false },
    ["灵鹫宫"]   =   { ["空手"] = true,  ["长剑"] = true,  ["钢刀"] = false },
    ["关外胡家"] =   { ["空手"] = false, ["长剑"] = false, ["钢刀"] = false },
}

for k,v in pairs(config.jobs["门派任务"].echoose) do
    enemy_choose[k] = v
end

local phase = {
    ["任务获取"] = 1,
    ["任务执行"] = 2,
    ["任务结算"] = 3,
    ["任务完成"] = 4,
    ["任务放弃"] = 5,
    ["任务失败"] = 6,
}

function enable_family_job()
    trigger.delete_group("family_job")
    trigger.delete_group("family_job_active")
    trigger.add("family_job_enable_inform", "family_job_enable_inform()", "family_job", {Enable=true}, 100, "^一个\\S+弟子走了过来,对你报拳道：“在下奉\\S+之命，请你速回\\S+处晋见”。$|"..
                                                                                                            "^\\S+已传令要召见你，你还是快点去吧。$")
    trigger.add("family_job_enable_complete", "family_job_enable_complete()", "family_job", {Enable=true}, 100, "^任务已经完成，赶快回去复命吧。$")
    trigger.add("family_job_cancel", "family_job_cancel()", "family_job", {Enable=true}, 100, "^唉！你耽误的时间太久了，这次任务取消了。$")
    trigger.add("family_job_received", "family_job_received()", "family_job", {Enable=true}, 100, "^\\S+已派你去(\\S+)附近完成重要任务，赶快去执行吧。$")
    trigger.add("family_job_info", "family_job_info()", "family_job_active", {Enable=false, Multi=true}, 100, "^\\S+你\\S+说道：“"..profile.name.."，\\S+。”\\n\\S+说道:“近日在(\\S+)附近(?:经常|)有人杀我\\S+，你(?:速|)去\\S+。”$")
    trigger.add("family_job_settle", "family_job_settle()", "family_job_active", {Enable=false}, 100, "^\\S+说道:“辛苦你了，"..profile.name.."，\\S+。”$")
    trigger.add("family_job_enemy_found", "family_job_enemy_found()", "family_job_active", {Enable=false}, 100, "^你察觉四周好像有些不对劲......$")
    trigger.add("family_job_enemy", "var.job.fight = true", "family_job_active", {Enable=false}, 100, "^“受死吧，"..profile.name.."！”\\S+大声吼道。$")
    trigger.add("family_job_kill", "var.job.fight = true", "family_job_active", {Enable=false, Multi=true}, 100, "^"..family_info[profile.family].enemy_name.."(?:喝道：「你，我们的帐还没算完，看招！」|一眼瞥见你，「哼」的一声冲了过来！|喝道：「你，看招！」|和你仇人相见份外眼红，立刻打了起来！|一见到你，愣了一愣，大叫：「我宰了你！」|和你一碰面，二话不说就打了起来！|对著你大喝：「可恶，又是你！」)\\n看起来"..family_info[profile.family].enemy_name.."想杀死你！$")
    trigger.add("family_job_enemy_die", "family_job_enemy_die()", "family_job_active", {Enable=false}, 100, "^"..family_info[profile.family].enemy_name.."倒在地上，挣扎了几下就死了。$")
    trigger.add("family_job_enemy_faint", "family_job_enemy_faint()", "family_job_active", {Enable=false}, 100, "^"..family_info[profile.family].enemy_name.."说道：好，好厉害......没想到......我会命丧于此...... ...$")
    trigger.add("family_job_enemy_alive", "var.job.alive = true", "family_job_active", {Enable=false}, 100, "^"..family_info[profile.family].enemy_name.."\\s+=")
    trigger.add("family_job_enemy_corpse", "var.job.corpse = true", "family_job_active", {Enable=false}, 100, "^"..family_info[profile.family].enemy_name.."的尸体\\s+=")
    trigger.add("family_job_snake_break", "family_job_snake_break()", "family_job_active", {Enable=false}, 100, "^忽然一阵腥风袭来，一条巨蟒从身旁大树上悬下，把"..family_info[profile.family].enemy_name.."卷走了。$")
end

function disable_family_job()
    trigger.delete_group("family_job")
    trigger.delete_group("family_job_active")
    trigger.add("family_job_disable_inform", "family_job_disable_inform()", "family_job", {Enable=true}, 100, "^一个\\S+弟子走了过来,对你报拳道：“在下奉\\S+之命，请你速回\\S+处晋见”。$|"..
                                                                                                              "^\\S+已传令要召见你，你还是快点去吧。$|"..
                                                                                                              "^\\S+已派你去\\S+附近完成重要任务，赶快去执行吧。$")
    trigger.add("family_job_disable_complete", "family_job_disable_complete()", "family_job", {Enable=true}, 100, "^任务已经完成，赶快回去复命吧。$")
    timer.add("disable_family_job", 1800, "trigger.delete_group('family_job')", "family_job", {Enable=false, OneShot=true})
end

function family_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job ］")
    automation.idle = false
    var.job = var.job or { name = "门派任务" }
    var.job.enemy_name = var.job.enemy_name or family_info[profile.family].enemy_name
    var.job.statistics = var.job.statistics or { name = "门派任务" }
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    trigger.enable_group("family_job_active")
    if (config.jobs["门派任务"].phase or 0) <= phase["任务获取"] then
        local rc = family_job_p1()
        if rc ~= nil then
            return family_job_return(rc)
        end
    end
    if config.jobs["门派任务"].phase == phase["任务执行"] then
        return family_job_return(family_job_p2())
    end
    if config.jobs["门派任务"].phase == phase["任务结算"] then
        var.job.statistics.exp = var.job.statistics.exp or state.exp
        var.job.statistics.pot = var.job.statistics.pot or state.pot
        config.jobs["门派任务"].dest = nil
        local rc = family_job_p3()
        if rc ~= nil then
            return family_job_return(rc)
        end
    end
    if config.jobs["门派任务"].phase == phase["任务完成"] then
        return family_job_return(family_job_p4())
    end
    if config.jobs["门派任务"].phase > phase["任务完成"] then
        return family_job_return(family_job_p5())
    end
end

function family_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    trigger.disable_group("family_job_active")
    config.jobs["门派任务"].active = false
    append_statistics("门派任务")
    if var.job.weapon_ori ~= nil then
        var.job.weapon_ori[1] = var.job.weapon[1]
        var.job.weapon_ori[2] = var.job.weapon[2]
    end
    var.job = nil
    return rc
end

function family_job_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_p1 ］")
    local rc = family_job_goto_master()
    if rc ~= nil then
        return rc
    end
    if config.jobs["门派任务"].enable == false then
        rc = family_job_close_job()
        if rc ~= nil then
            trigger.delete_group("family_job")
            timer.delete_group("family_job")
            var.job = nil
            return math.max(1, rc)
        end
    end
    if config.jobs["门派任务"].phase == nil then
        rc = family_job_open_job()
        if rc ~= nil then
            trigger.disable_group("family_job_active")
            var.job = nil
            return rc
        end
        config.jobs["门派任务"].phase = config.jobs["门派任务"].phase or 0
        timer.add("family_job_inactive", 3, "family_job_inactive()", "family_job", {Enable=true, OneShot=true})
    end
    if trigger.is_exist("get_longxiang_status") == true then
        run("ask jiumozhi about 熟练度")
    end
    if config.jobs["门派任务"].phase <= phase["任务获取"] then
        rc = family_job_wait_info()
        if rc ~= nil then
            trigger.disable_group("family_job_active")
            var.job = nil
            return rc
        end
    end
    return
end

function family_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_p2 ］")
    timer.delete("family_job_inactive")
    if config.jobs["门派任务"].phase == phase["任务执行"] then
        jia_min()
        if wield(config.fight["通用"].weapon) < 0 then
            return -1
        end
    end
    if config.jobs["门派任务"].dest == nil then
        config.jobs["门派任务"].dest = parse(config.jobs["门派任务"].info)
        config.jobs["门派任务"].dest = get_room_id_by_tag("nojob", config.jobs["门派任务"].dest, "exclude")
    end
    if #config.jobs["门派任务"].dest == 0 then
        config.jobs["门派任务"].phase = phase["任务放弃"]
        return family_job_p5()
    end
    return family_job_exec()
end

function family_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_p3 ］")
    local rc = family_job_goto_master()
    if rc ~= nil then
        return rc
    end
    rc = family_job_post_recover()
    if rc ~= nil then
        return rc
    end
    if config.jobs["门派任务"].phase == phase["任务结算"] then
        rc = family_job_wait_settle()
        if rc ~= nil then
            return rc
        end
    end
    if config.jobs["门派任务"].enable == false then
        config.jobs["门派任务"].phase = phase["任务获取"]
        return family_job()
    else
        if recover(config.job_nl) ~= 0 then
            return -1
        end
        return
    end
end

function family_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_p4 ］")
    if config.jobs["门派任务"].contribution ~= nil then
        local rc = family_job_goto_master()
        if rc ~= nil then
            if rc == 1 then
                config.jobs["门派任务"].phase = phase["任务失败"]
                return family_job_p5()
            else
                return rc
            end
        end
        rc = family_job_clear_contribution()
        if rc ~= nil then
            return rc
        end
    end
    if recover(config.job_nl) < 0 then
        return -1
    end
    if run_score() < 0 then
        return -1
    end
    var.job.statistics.result = "成功"
    return 0
end

function family_job_p5()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_p5 ］")
    config.jobs["门派任务"].dest = nil
    if var.job.statistics ~= nil then
        var.job.statistics.result = "失败"
    end
    if config.jobs["门派任务"].phase == phase["任务放弃"] then
        local rc = family_job_goto_master()
        if rc ~= nil then
            return rc
        end
        rc = family_job_close_job()
        if rc == 1 then
            wait(1)
            return family_job_p5()
        elseif (rc or -1) < 0 then
            trigger.add("family_job_giveup", "", "family_job", {Enable=false, StopEval=true}, 90, "^\\S+已派你去\\S+附近完成重要任务，赶快去执行吧。$")
            trigger.add(nil, "trigger.delete('family_job_giveup')", "family_job", {Enable=false, OneShot=true, StopEval=true}, 90, "^唉！你耽误的时间太久了，这次任务取消了。$")
            return (rc or 1)
        end
        rc = family_job_open_job()
        if rc == -1 then
            return -1
        elseif rc == 1 then
            wait(1)
            return family_job_p5()
        end
    end
    if recover(config.job_nl) < 0 then
         return -1
    end
    return 1
end

function family_job_goto_master()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_goto_master ］")
    if env.current.id[1] ~= family_info[profile.family].master_place then
        var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
        local rc = goto(family_info[profile.family].master_place)
        if rc == 1 then
            config.jobs["门派任务"].phase = phase["任务失败"]
        end
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function family_job_close_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_close_job ］")
    local l = wait_line("ask "..family_info[profile.family].master_id.." about 要事在身", 30, nil, nil, "^\\S+对你说道：你不已经对我讲过此事吗？$|"..
                                                                                                       "^\\S+对你说道：你太令\\S+失望了，目前我\\S+正值用人之际，我看你还是以\\S+兴衰为重吧。$|"..
                                                                                                       "^\\S+对你说道：既然你有要事在身，我也不便强求，唉！靠你振兴我\\S+看来是没指望了。$|"..
                                                                                                       "^这里没有 \\S+ 这个人$|"..
                                                                                                       "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$|"..
                                                                                                       "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$")
    if l == false then
        return -1
    elseif string.match(l[0], "没有") then
        return 1
    elseif string.match(l[0], "用人之际") then
        config.jobs["门派任务"].phase = config.jobs["门派任务"].phase or phase["任务获取"]
        return
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return family_job_close_job()
    else
        config.jobs["门派任务"].active = false
        return 0
    end
end

function family_job_open_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_open_job ］")
    local l = wait_line("ask "..family_info[profile.family].master_id.." about 门派任务", 30, nil, nil, "^\\S+对你点了点头，说道：好，望你能为振兴我\\S+多做贡献，我有任务时自然会派人去通知你。$|"..
                                                                                                       "^\\S+拍了拍你的肩膀，说道：好，我有任务时自然会派人去通知你。$|"..
                                                                                                       "^这里没有 \\S+ 这个人$|"..
                                                                                                       "^(\\S+)(?:正|)忙着呢，你等会儿在问话吧。$|"..
                                                                                                       "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$")
    if l == false then
        return -1
    elseif string.match(l[0], "没有") then
        return 1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return family_job_open_job()
    end
    return
end

function family_job_wait_info()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_wait_info ］")
    automation.skill = true
    local rc = zuanyan()
    if rc < 0 then
        return -1
    elseif rc == 0 and config.jobs["门派任务"].phase <= phase["任务获取"] then
        rc = lian()
        if rc < 0 then
            return -1
        elseif rc == 0 and config.jobs["门派任务"].phase <= phase["任务获取"] then
            if automation.skill ~= true then
                return family_job_wait_info()
            else
                while config.jobs["门派任务"].phase <= phase["任务获取"] do
                    wait(0.1)
                end
            end
        end
    end
    automation.skill = nil
    timer.delete_group("family_job")
    if config.jobs["门派任务"].phase == phase["任务执行"] then
        if prepare_skills() < 0 then
            return -1
        end
        rc = dazuo(config.job_nl, "normal")
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function family_job_wait_enemy(timeout, fstate)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_wait_enemy ］参数：timeout = "..tostring(timeout)..", fstate = "..tostring(fstate))
    timer.add("family_job_wait_enemy", timeout, "", "family_job", {Enable=true, OneShot=true})
    while (var.job.fight == nil or var.job.fight == fstate) and timer.is_exist("family_job_wait_enemy") ~= false do
        if config.jobs["门派任务"].phase > phase["任务执行"] then
            timer.delete("family_job_wait_enemy")
            return family_job()
        end
        wait(0.01)
        if env.current.name == "树上" then
            timer.delete("family_job_wait_enemy")
            return family_job_exec()
        end
    end
    timer.delete("family_job_wait_enemy")
    return
end

function family_job_goto_dest()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_goto_dest ］")
    if #config.jobs["门派任务"].dest > 0 then
        local current = set.pop(config.jobs["门派任务"].dest)
        if env.current.id[1] ~= current then
            run("halt")
            local rc = goto(current)
            if rc ~= 0 then
                return rc
            end
        end
        local rc = family_job_wait_enemy(3)
        if rc ~= nil then
            return rc
        end
        if var.job.fight ~= nil then
            config.jobs["门派任务"].dest = { current }
            if wield(config.fight["门派任务"].weapon or config.fight["通用"].weapon) ~= 0 then
                return -1
            end
            return
        end
        return family_job_goto_dest()
    end
    if #config.jobs["门派任务"].dest == 0 then
        if var.job.retry == nil then
            var.job.retry = true
            return family_job_p2()
        else
            config.jobs["门派任务"].phase = phase["任务放弃"]
            return family_job_p5()
        end
    end
end

function family_job_select_enemy()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_select_enemy ］")
    if enemy_choose["全杀"] == true then
        return family_job_confirm_enemy()
    end
    local l = wait_line("look "..family_info[profile.family].enemy_id, 30, nil, nil, "你要看什么？$|"..
                                                                                     "^(\\S+)弟子 "..family_info[profile.family].enemy_name.."\\(\\w+ \\w+\\)$")
    local safe
    if l == false then
        return -1
    elseif l[0] ~= "你要看什么？" then
        safe = enemy_choose[l[1]]
        l = wait_line(nil, 10, nil, nil, "^  □(?:\\S+只|)(\\S+)\\(\\w+ \\w+\\)$")
        if l == false then
            return -1
        end
    end
    if l[0] == "你要看什么？" then
        if env.current.name == "树上" then
            return family_job_exec()
        elseif config.jobs["门派任务"].phase > phase["任务执行"] then
            return family_job()
        else
            return family_job_one_step()
        end
    else
        if safe[l[1]] or safe["空手"] then
            return family_job_confirm_enemy()
        else
            return family_job_one_step()
        end
    end
end

function family_job_confirm_enemy()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_confirm_enemy ］")
    local l = wait_line("kill "..family_info[profile.family].enemy_id, 30, nil, nil, "^你对著"..family_info[profile.family].enemy_name.."喝道：「.*」$|"..
                                                                                     "^这里没有这个人。$|"..
                                                                                     "^你现在正忙着呢。$")
    if l == false then
        return -1
    elseif l[0] == "这里没有这个人。" then
        if env.current.name == "树上" then
            return family_job_exec()
        elseif config.jobs["门派任务"].phase > phase["任务执行"] then
            return family_job()
        else
            return family_job_one_step()
        end
    elseif l[0] == "你现在正忙着呢。" then
        wait(0.1)
        return family_job_confirm_enemy()
    else
        l = wait_line(nil, 30, nil, nil, "^"..family_info[profile.family].enemy_name.."说道：既然你自己找死，也怨不得我。$|"..
                                         "^"..family_info[profile.family].enemy_name.."说道：今天点子不对，不能陪你玩了。$|"..
                                         "^看起来"..family_info[profile.family].enemy_name.."想杀死你！")
        if l == false then
            return -1
        elseif string.match(l[0], "想杀死你") then
            if state.power == 0 then
                run("jiali "..(config.fight[config.jobs[global.jid]].power or config.fight["通用"].power))
            end
            if state.energy == 1 then
                run("jiajin "..(config.fight[config.jobs[global.jid]].energy or config.fight["通用"].energy))
            end
            return
        else
            return family_job_one_step()
        end
    end
end

function family_job_one_step()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_one_step ］")
    run("halt")
    local rc,ldir = one_step()
    if rc ~= 0 then
        return -1
    else
        local current = map[config.jobs["门派任务"].dest[1]].links[ldir]
        if env.current.name == "九十九道拐" then
            local l = wait_line("eat busy", 30, nil, nil, "^你身上没有 busy 这样食物。$|"..
                                                          "^你正忙着呢，先忍忍吧。$")
            if l == false then
                return -1
            elseif l[0] == "你正忙着呢，先忍忍吧。" then
                if wait_line(nil, 30, nil, nil, "^树上 - $") == false then
                    return -1
                end
                env.current.id = { 1718 }
                if goto(current) ~= 0 then
                    return -1
                end
            end
        end
        var.job.fight = nil
        if recover(config.job_nl) ~= 0 then
            return -1
        end
        rc = wield((config.fight["门派任务"] or config.fight["通用"]).weapon or config.fight["通用"].weapon)
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return 0
        end
        if config.jobs["门派任务"].phase > phase["任务执行"] then
            return family_job()
        end
        if config.jobs["门派任务"].dest[1] == 1087 then
            current = 1086
        elseif config.jobs["门派任务"].dest[1] == 1530 then
            current = 1529
        end
        if env.current.id[1] ~= current then
            if goto(current) ~= 0 then
                return -1
            end
        end
    end
    if #env.current.id ~= 1 then
        rc = locate()
        if rc ~= 0 then
            return rc
        end
    end
    return family_job_reset_enemy(family_job_get_dir(ldir))
end

function family_job_get_dir(ldir)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_get_dir ］参数：ldir = "..tostring(ldir))
    local dir
    if config.jobs["门派任务"].dest[1] == 1433 then
        if type(env.current.exits) == "string" then
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
        for _,v in ipairs(env.current.exits) do
            if v ~= "westup" and v ~= "northup" and v ~= "eastdown" then
                dir = v
                break
            end
        end
    elseif config.jobs["门派任务"].dest[1] == 1530 then
        if type(env.current.exits) == "string" then
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
        for _,v in ipairs(env.current.exits) do
            if v ~= "southdown" then
                dir = v
                break
            end
        end
    elseif config.jobs["门派任务"].dest[1] == 1301 then 
        if type(env.current.exits) == "string" then
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
        for _,v in ipairs(env.current.exits) do
            if v ~= "northwest" and v ~= "northeast" then
                dir = v
                break
            end
        end  
    else
        if #env.current.id == 1 then
            for k,v in pairs(map[env.current.id[1]].links) do
                if v == config.jobs["门派任务"].dest[1] then
                    dir = k
                    break
                end
            end
        end
    end
    dir = regular_dir(dir)
    if not is_dir(dir) and is_dir(ldir) then
        dir = get_reverse_dir(ldir)
    end
    return dir
end

function family_job_reset_enemy(dir)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_reset_enemy ］参数：dir = "..tostring(dir))
    if dir == nil then
        wait(3)
        return family_job()
    end
    local rc,enemy_leave = look_dir(dir),true
    if rc < 0 then
        return -1
    elseif rc == 1 then
        if set.has({1301, 1530, 1433}, config.jobs["门派任务"].dest[1]) then
            if wait_line("look", 30, nil, nil, "^> $") == false then
                return -1
            end
            rc = locate()
            if rc ~= 0 then
                return rc
            end
            return family_job_reset_enemy(family_job_get_dir())
        else
            wait(3)
            return family_job()
        end
    else
        for _,v in ipairs(env.nextto.objs) do
            if string.match(v, "弟子 "..family_info[profile.family].enemy_name.."%(") or 
               string.match(v, family_info[profile.family].enemy_name.."正在运功疗伤。") then
                enemy_leave = false
                break
            end
        end
        if enemy_leave == true then
            return family_job_exec()
        end
        if global.flood > config.flood then
            wait(1)
        else
            wait(0.1)
        end
        automation.idle = false
        return family_job_reset_enemy(dir)
    end
end

function family_job_confirm_kill()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_confirm_kill ］")
    local rc = is_fighting()
    if rc < 0 then
        return -1
    elseif rc == 1 and config.jobs["门派任务"].phase < phase["任务结算"] then
        if run_hp() < 0 then
            return -1
        end
        local check = false
        if state.qx < state.qx_max and state.qx / (state.qx_max * 100 / state.qx_pct) < 0.7 then
            if state.nl >= 20 then
                check = true
                run("yun recover")
            else
                return family_job_one_step()
            end
        end
        if state.jl / state.jl_max < 0.3 then
            if state.nl >= 20 then
                check = true
                run("yun refresh")
            else
                return family_job_one_step()
            end
        end
        if check == true then
            if run_hp() < 0 then
                return -1
            end
        end
        if state.qx / (state.qx_max * 100 / state.qx_pct) < 0.5 or state.jl / state.jl_max < 0.3 then
            return family_job_one_step()
        end
        if state.nl > profile.power * 7 and (config.fight["门派任务"].power or config.fight["通用"].power) ~= "none" then
            run("jiali "..config.fight["门派任务"].power)
        elseif state.nl <= profile.power * 7 and state.power > 0 then
            run("jiali none")
        end
        if state.jl > profile.energy * 7 and (config.fight["门派任务"].energy or config.fight["通用"].energy) ~= 1 then
            run("jiajin "..config.fight["门派任务"].energy)
        elseif state.nl <= profile.energy * 7 and state.energy > 1 then
            run("jiajin 1")
        end
        rc = wield(config.fight["门派任务"].weapon or config.fight["通用"].weapon)
        if rc < 0 then
            return -1
        end
        if rc == 1 then
            return family_job_one_step()
        end
        wait_line(set.concat((config.fight["门派任务"].yuns or config.fight["通用"].yuns), ";")..";"..set.concat((config.fight["门派任务"].performs or config.fight["通用"].performs), ";"), 1, nil, nil, "^"..family_info[profile.family].enemy_name.."倒在地上，挣扎了几下就死了。$|"..
                                                                                                                                                                                                      "^任务已经完成，赶快回去复命吧。$|"..
                                                                                                                                                                                                      "^唉！你耽误的时间太久了，这次任务取消了。$")
    else
        config.jobs["门派任务"].phase = math.max(phase["任务结算"], config.jobs["门派任务"].phase)
        return
    end
    return family_job_confirm_kill()
end

function family_job_post_kill()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_post_kill ］")
    jia_min()
    if wait_no_fight() < 0 then
        return -1
    end
    run("get gold from corpse")
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

function family_job_kill_enemy()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_kill_enemy ］")
    if enemy_choose["全杀"] == false then
        trigger.add("family_job_enemy_change", "family_job_enemy_change()", "family_job_active", {Enable=true, OneShot=true, StopEval=true}, 100, "^"..family_info[profile.family].enemy_name.."只觉得手中\\S+把持不定，脱手飞出！$")
    end
    local rc = fight()
    trigger.delete("family_job_enemy_change")
    if rc < 0 then
        return -1
    elseif rc == 2 then
        return family_job_one_step()
    elseif config.jobs["门派任务"].phase <= phase["任务执行"] then
        if rc == 1 then
            if env.current.name == "树上" then
                return family_job_exec()
            end
            if var.job.change ~= nil then
                var.job.change = nil
                rc = family_job_select_enemy()
                if rc == nil then
                    return family_job_kill_enemy()
                else
                    return rc
                end
            end
            return family_job_one_step()
        end
        var.job.corpse = false
        var.job.alive = false
        if wait_line("id here", 30, nil, nil, "^在这个房间中, 生物及物品的\\(英文\\)名称如下：$", "^> $") == false then
            return -1
        elseif var.job.corpse == true and var.job.alive == false then
            config.jobs["门派任务"].phase = math.max(phase["任务结算"], config.jobs["门派任务"].phase)
        else
            return family_job_confirm_kill()
        end
    end
    return family_job_post_kill()
end

function family_job_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_exec ］")
    automation.idle = false
    local rc = family_job_goto_dest()
    if rc ~= nil then
        return rc
    end
    if var.job.fight == false then
        rc = family_job_wait_enemy(5, false)
        if rc ~= nil then
            return rc
        end
    end
    if var.job.fight ~= true then
        if var.job.retry == nil then
            var.job.retry = true
            return family_job_p2()
        else
            config.jobs["门派任务"].phase = phase["任务放弃"]
            return family_job_p5()
        end
    end
    rc = family_job_select_enemy()
    if rc ~= nil then
        return rc
    end
    rc = family_job_kill_enemy()
    if rc ~= nil then
        return rc
    else
        return family_job()
    end
end

function family_job_post_recover()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_post_recover ］")
    var.move = false -- 避免恢复时移动位置
    if heal_regenerate(70) < 0  then
        return -1
    end
    if heal_recover() < 0  then
        return -1
    end
    if break_event() == false then
        local _,_,base = dazuo_analysis(config.job_nl)
        local dismiss,target
        if carryon.inventory["炼心石:lianxin shi"] == nil then
            dismiss = base + 1
        else
            dismiss = (base + 1) * 2
        end
        if config.job_nl == "double" then
            target = state.nl_max * 2 - dismiss
        else
            target = config.job_nl - dismiss
        end
        if state.qx <= state.qx_max - 10 then
            if yun_recover() < 0 then
                return -1
            end
        end
        repeat
            if state.jl <= state.jl_max - 10 then
                if yun_refresh() < 0 then
                    return -1
                end
            end
            if state.js <= state.js_max - 10 then
                if yun_regenerate() < 0 then
                    return -1
                end
            end
            if state.nl > target then
                if state.qx <= state.qx_max - 10 then
                    if yun_recover() < 0 then
                        return -1
                    end
                else
                    break
                end
            end
            local rc = dazuo()
            if rc < 0 then
                return -1
            elseif rc > 0 then
                break
            end
            if state.qx < state.qx_max * 0.7 then
                if yun_recover() < 0 then
                    return -1
                end
            end
            if break_event() == true then
                break
            end
        until false
    end
    var.move = nil
    return
end

function family_job_wait_settle()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_wait_settle ］")
    automation.skill = true
    local rc = zuanyan()
    if rc < 0 then
        return -1
    elseif rc == 1 or config.jobs["门派任务"].phase ~= phase["任务结算"] then
        return
    else
        rc = lian()
        if rc < 0 then
            return -1
        elseif rc == 1 or config.jobs["门派任务"].phase ~= phase["任务结算"] then
            return
        else
            if automation.skill == true then
                automation.skill = nil
                return
            end
            if automation.skill == true then
                while config.jobs["门派任务"].phase == phase["任务结算"] do
                    wait(0.1)
                end
                automation.skill = nil
                return
            end
        end
    end
    return family_job_wait_settle()
end

function family_job_query_contribution()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_query_contribution ］")
    if global.flood > config.flood then
        wait(1)
    end
    local l = wait_line("ask "..family_info[profile.family].master_id.." about 贡献度", 30, nil, nil, "^\\S+对你说道：你为\\S+所做的贡献为(\\S+)点。|"..
                                                                                                     "^这里没有 \\S+ 这个人$|"..
                                                                                                     "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                                                                                                     "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$")
    if l == false then
        return -1
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        wait(0.1)
        run("halt")
        return family_job_query_contribution()
    elseif string.match(l[0], "贡献为") then
        return 0,chs2num(l[1])
    else
        return 1,0
    end
end

function family_job_clear_contribution()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ family_job_clear_contribution ］")
    local rc,contribution = family_job_query_contribution()
    if rc < 0 then
        return -1
    end
    if contribution > config.jobs["门派任务"].contribution then
        rc = family_job_close_job()
        if rc < 0 then
            return -1
        elseif (rc or 1) == 1 then
            return
        else
            repeat
                rc = family_job_open_job()
                if rc == nil then
                    break
                elseif rc < 0 then
                    return -1
                end
                wait(0.1)
            until false
        end
    else
        return
    end
    return family_job_clear_contribution()
end

function family_job_enable_inform()
    timer.delete_group("family_job")
    trigger.enable_group("family_job_active")
    config.jobs["门派任务"].phase = phase["任务获取"]
    config.jobs["门派任务"].dest = nil
    config.jobs["门派任务"].active = true
    if var.job ~= nil then
        return
    end
    if automation.skill ~= nil then
        run("set 中断事件")
    end
end

function family_job_enable_complete()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
    config.jobs["门派任务"].phase = phase["任务结算"]
    config.jobs["门派任务"].active = true
    if var.job == nil then
        if automation.skill ~= nil then
            run("set 中断事件")
        end
    else
        if var.job.name == "门派任务" and 
           var.fight ~= nil then
            run("set 中断事件")
        end
    end
end

function family_job_cancel()
    if var.fight ~= nil then
        var.fight.stop = 2
    end
    config.jobs["门派任务"].phase = phase["任务失败"]
    if var.job ~= nil and 
       var.job.name == "门派任务" then
        if var.fight ~= nil or 
           automation.skill ~= nil then
            run("set 中断事件")
        end
    end
end

function family_job_received()
    config.jobs["门派任务"].info = get_matches(1)
    config.jobs["门派任务"].phase = phase["任务执行"]
    config.jobs["门派任务"].active = true
    if automation.skill ~= nil then
        if var.job == nil then
            run("set 中断事件")
        else
            if var.job.name == "门派任务" then
                run("set 中断事件")
            end
        end
    end
end

function family_job_inactive()
    var.job.statistics = nil
    config.jobs["门派任务"].phase = phase["任务失败"]
    var.job.statistics = nil
    if automation.skill ~= nil then
        run("set 中断事件")
    end
end

function family_job_info()
    timer.delete_group("family_job")
    family_job_received()
end

function family_job_settle()
    config.jobs["门派任务"].phase = phase["任务完成"]
    if automation.skill ~= nil then
        run("set 中断事件")
        return
    end
    if var.yun_heal ~= nil then
        if state.qx_pct < 80 then
            run("set 中断事件")
        end
    end
end

function family_job_enemy_found()
    if var.goto.thread == nil then
        var.job.fight = false
    end
end

function family_job_enemy_die()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
end

function family_job_enemy_faint()
    if var.fight ~= nil then
        jia_min()
        var.fight.stop = 3
    end
end

function family_job_snake_break()
    if var.fight ~= nil then
        var.fight.stop = 1
    end
end

function family_job_enemy_change()
    if var.fight ~= nil then
        if var.fight.stop == nil then
            var.job.change = true
            var.fight.stop = 1
        end
    end
end

function family_job_disable_inform()
    config.jobs["门派任务"].phase = phase["任务获取"]
    config.jobs["门派任务"].active = true
    if var.job == nil and 
       automation.skill ~= nil then
        run("set 中断事件")
    end
end

function family_job_disable_complete()
    config.jobs["门派任务"].phase = phase["任务结算"]
    config.jobs["门派任务"].active = true
    if var.job == nil and 
       automation.skill ~= nil then
        run("set 中断事件")
    end
end

config.jobs["门派任务"].func = family_job
config.jobs["门派任务"].efunc = enable_family_job
config.jobs["门派任务"].dfunc = disable_family_job
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
