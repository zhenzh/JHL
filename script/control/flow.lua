require "skills"

global.phase = {
    ["挂起"] = 0,
    ["空闲"] = 1,
    ["准备"] = 2,
    ["任务"] = 3,
    ["练功"] = 4,
}

config.lian.weapon = {
    force   = "",
    dodge   = "",
    strike  = "",
    cuff    = "",
    hand    = "",
    finger  = "",
    claw    = "",
    kick    = ""
}

local noisy_rooms = {
    ["德陵"] = 1591,
    ["西夏王陵"] = 1591,
    ["林中空地"] = 1591,
    ["落日林"] = 1591,
    ["佛山镇街"] = 107,
    ["林中小路"] = 620,
    ["黄土路"] = 620,
    ["丝绸之路"] = 1347,
    ["碎石沙路"] = 1347,
    ["楼兰废墟"] = 1347,
    ["星宿海"] = 1356,
}

local lian_weapon = {
    sword  = "钢剑:gangjian",
    blade  = "钢刀:blade",
    hammer = "铁锤:hammer",
    staff  = "禅杖:chan zhang",
    club   = "铁棍:tiegun",
    stick  = "铜棒:tong bang",
    whip   = "长鞭:changbian",
    axe    = "大斧头:da futou",
    pike   = "长枪:chang qiang",
    stroke = "判官笔:panguan bi",
    hook   = "双钩:shuang gou"
}

trigger.add("reduce_exp", "reduce_exp(tonumber(get_matches(1)))", "automation", {Enable=true}, 100, "^你的经验下降了(\\d+)点。$")

function reduce_exp(exp)
    state.exp = state.exp - exp
    if var.job.statistics ~= nil then
        var.job.statistics.exp = var.job.statistics.exp - exp
    end
end

function automation_reset(func)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset ］参数："..tostring(func))
    automation.reconnect = func or "automation.reconnect = nil"
    set.append(automation.statistics.reset, time.epoch())
    if var.job ~= nil then
        statistics_append(var.job.name)
        if var.job.name == "飞马镖局" and config.jobs["飞马镖局"].phase == 2 then
            config.jobs["飞马镖局"].biaoche = nil
            config.jobs["飞马镖局"].dest = nil
            config.jobs["飞马镖局"].phase = 4
        end
    end
    reset()
end

function automation_reset_faint()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset_faint ］")
    automation.reconnect = nil
    automation.idle = false
    local l = wait_line(nil,
                        180, {StopEval=true}, 9,
                        "^慢慢地一阵眩晕感传来，你终于又有了知觉....$|"..
                        "^鬼门关 - $")
    if l == false then
        return -1
    elseif l[0] == "慢慢地一阵眩晕感传来，你终于又有了知觉...." then
        if run_hp() < 0 then
            return automation_reset()
        end
        return 0
    else
        return automation_reset_die()
    end
end

function automation_reset_die()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset_die ］")
    automation.reconnect = nil
    automation.idle = false
    set.append(automation.statistics.death, time.epoch())
    local l = wait_line(nil,
                        60, nil, 10,
                        "^鬼卒将你的「阴司路引」收了起来，伸手指了指关门，好象是叫你进去。$|"..
                        "^你被吓了一大跳，连滚代爬地跑进关内去了。$|"..
                        "^但见阴天子把手一招，飘来了牛头马面，架起你就往内殿而去。$|"..
                        "^武庙 - $")
    if l == false then
        return automation_reset_die()
    elseif l[0] == "鬼卒将你的「阴司路引」收了起来，伸手指了指关门，好象是叫你进去。" then
        wait_line("north;north", 30, nil, 10, "^阴司第\\S+殿 - $")
        return automation_reset_die()
    elseif l[0] == "你被吓了一大跳，连滚代爬地跑进关内去了。" then
        wait_line("north", 60, nil, 10, "^阴司第\\S+殿 - $")
        return automation_reset_die()
    else
        if wait_line("score;hp;skills;enable;prepare", 30, nil, 10, "^以下是你目前组合中的特殊拳术技能。$|^你现在没有组合任何特殊拳术技能。$", "^> $") == false then
            return automation_reset()
        end
    end
    return 0
end

function automation_reset_connect()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset_connect ］")
    set.append(automation.statistics.connect, time.epoch())
    if get_lines(-1)[1] == "请输入您的英文ID：" or 
       get_lines(-1)[1] == "请重新输入您的ID：" then
        local last_line = get_lines(-1)[1]
        run(config.userid)
        while get_lines(-1)[1] == last_line do
            wait(0.1)
        end
        return automation_reset_connect()
    end
    if string.match(get_lines(-1)[1], "请您输入密码：") then
        local l = wait_line(config.passwd,
                            30, nil, 5,
                            "^您目前的权限是：.*，您设定为.*显示。$|^重新连线完毕。$|"..
                            "^对不起，密码错误！$|"..
                            "^您要将另一个连线中的相同人物赶出去，取而代之吗？\\(Yes/No\\)")
        if l == false or l[0] == "对不起，密码错误！" then
            return automation_reset_connect()
        elseif l[0] == "您要将另一个连线中的相同人物赶出去，取而代之吗？(Yes/No)" then
            if wait_line("y", 30, nil, 5, "^您目前的权限是：.*，您设定为.*显示。$|^重新连线完毕。$") == false then
                return automation_reset_connect()
            end
        end
        automation.reconnect = nil
        return 0
    end
    wait(0.1)
    return automation_reset_connect()
end

function automation_reset_heal()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset_heal ］")
    automation.reconnect = nil
    automation.idle = false
    local l = wait_line(nil,
                        120, nil, 10,
                        "^纪晓芙正在运功为你疗伤，忽觉自己内息後继乏力，祗得暂缓疗伤，站起身来。$|"..
                        "^运功良久，你感觉经脉顺畅，内伤尽去，神元气足地站了起来。$")
    if l == false then
        return automation_reset()
    elseif l[0] == "纪晓芙正在运功为你疗伤，忽觉自己内息後继乏力，祗得暂缓疗伤，站起身来。" then
        if one_step() ~= 0 then
            return automation_reset()
        end
    end
    return 0
end

function automation_reset_killer()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset_killer ］")
    automation.reconnect = nil
    automation.idle = false
    trigger.add("automation_reset_killer_win", "automation_reset_killer_win()", "automation_reset", {Enable=true}, 10, "^日月神教使者突然卖一破绽，跳出战圈，逃了！$|"..
                                                                                                                       "^日月神教使者悻然说道：算你够狠！老子先不奉陪了！咱们走着瞧！$|"..
                                                                                                                       "^猫也会心碎指着\\S+赞叹道：“\\S+是古往今来绿林第一大强盗！$")
    trigger.add("automation_reset_faint", "automation_reset('automation_reset_faint()')", "automation_reset", {Enable=true}, 30, "^你的眼前一黑，接著什么也不知道了....$")
    trigger.add("automation_reset_die", "automation_reset('automation_reset_die()')", "automation_reset", {Enable=true}, 10, "^鬼门关 - $")
    if wait_no_busy("halt") < 0 then
        return -1
    end
    local rc = fight()
    if rc < 0 then
        return automation_reset("automation_reset_killer()")
    end
    return 0
end

function automation_reset_killer_win()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
end

function automation_reset_escape()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_reset_escape ］")
    automation.reconnect = nil
    automation.idle = false
    trigger.add("automation_reset_faint", "automation_reset('automation_reset_faint()')", "automation_reset", {Enable=true}, 30, "^你的眼前一黑，接著什么也不知道了....$")
    trigger.add("automation_reset_die", "automation_reset('automation_reset_die()')", "automation_reset", {Enable=true}, 10, "^鬼门关 - $")
    if wait_no_busy("halt") < 0 then
        return -1
    end
    if one_step() ~= 0 then
        return automation_reset()
    end
    return 0
end

function automation_idle()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ automation_idle ］")
    if automation.idle == true then
        set.append(automation.statistics.idle, time.epoch())
        automation_reset()
    end
    automation.idle = true
end

function start()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ start ］")
    minimal_resources()
    automation.thread = automation.thread or coroutine.running()
    trigger.enable("others_come")
    trigger.enable("others_leave")
    trigger.enable("hide_busy")
    timer.add("automation_idle", 180, "automation_idle()", "automation", {Enable=true})
    trigger.add("automation_reset_faint", "automation_reset('automation_reset_faint()')", "automation", {Enable=true}, 30, "^你的眼前一黑，接著什么也不知道了....$")
    trigger.add("automation_reset_die", "automation_reset('automation_reset_die()')", "automation", {Enable=true}, 10, "^鬼门关 - $")
    trigger.add("automation_reset_connect", "automation_reset('automation_reset_connect()')", "automation", {Enable=true}, 10, "^一道闪电从天降下，直朝你劈去……结果没打中！$|^英文ID识别\\( 新玩家请输入 new 进入人物建立单元 \\)$")
    trigger.add("automation_reset_heal", "automation_reset('automation_reset_heal()')", "automation", {Enable=true}, 10, "^纪晓芙坐了下来运起内功，将手掌贴在你背心，缓缓地将真气输入你的体内....")
    trigger.add("automation_reset_killer", "automation_reset('automation_reset_killer()')", "automation", {Enable=true}, 10, "^看起来(?:"..set.concat(automation.killer, "|")..")想杀死你！$|"..
                                                                                                                             "^日月神教使者对着你大吼：(?:跟我回去参见教主！|还想跑？快跟大爷回去晋见本神教教主！)$")
    if config.beat_killer == false then
        trigger.add("automation_reset_escape", "automation_reset('automation_reset_escape()')", "automation", {Enable=true, StopEval=true}, 9, "^看起来猫也会心碎想杀死你！$")
    end

    if profile.master == "金轮法王" then
        if profile.longxiang == nil then
            profile.longxiang = { progress = 0, pozhang = 0 }
        end
        local l = wait_line("set pozhang",
                            30, nil, nil,
                            "^你目前还没有任何为 pozhang 的变量设定。$|"..
                            "^您目前 pozhang 的变量设定为：\\s+(\\d+)$")
        if l == false then
            return -1
        elseif l[0] == "你目前还没有任何为 pozhang 的变量设定。" then
            run("set pozhang 0")
        end
        profile.longxiang.pozhang = tonumber(l[1] or 0)
        require "longxiang_pozhang"
    elseif config.jobs["龙象破障"] ~= nil then
        config.jobs["龙象破障"] = nil
        table.delete(config.jobs, "龙象破障")
    end

    run("halt")
    if flow() < 0 then
        automation_reset()
    else
        return 0
    end
end

function flow()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ flow ］")
    var.flow = var.flow or { loop = 0 }
    global.jid = automation.jid or 1
    if config.jobs["门派任务"].enable and config.jobs["门派任务"].phase == nil then
        config.jobs["门派任务"].active = true
    end
    automation.phase = global.phase['空闲']

    repeat
        automation.idle = false
        local rc = flow_prepare_job()
        if rc ~= nil then
            return rc
        end
        rc = flow_do_job()
        if rc < 0 then
            return -1
        elseif rc ~= 0 then
            local last_rc = rc
            rc = flow_full_skill()
            if rc == -1 then
                return -1
            end
            if rc == 1 and last_rc == 1 then
                automation.phase = global.phase["挂起"]
                flow_suspend()
            end
        end
    until false
end

function flow_prepare_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ flow_prepare_job ］")
    automation.phase = global.phase["准备"]
    if prepare_skills() < 0 then
        return -1
    end
    if table.is_empty(carryon.repository) then
        if go(290) ~= 0 then
            return -1
        end
        if run_list() < 0 then
            return -1
        end
    end
    if run_i() < 0 then
        return -1
    end
    if prepare_items() < 0 then
        return -1
    end
    local pots
    if config.save_pots == true then
        if state.pot > state.pot_max + 1000 then
            pots = 0
        end
    else
        if state.pot > 100000 then
            pots = 90000
        end
    end
    if pots ~= nil then
        if go(2399) ~= 0 then
            return -1
        end
        local l = wait_line("cun",
                            30, nil, nil,
                            "^你存储了(\\d+)点潜能。$")
        if l == false then
            return -1
        end
        state.pot = state.pot - tonumber(l[1])
        if pots > 0 then
            l = wait_line("qu "..tostring(pots),
                          30, nil, nil,
                          "^你取出了(\\d+)点潜能。$")
            if l == false then
                return -1
            end
            state.pot = state.pot + tonumber(l[1])
        end
        if wait_line(nil, 30, nil, nil, "^你当前储存的潜能有\\d+点。$") == false then
            return -1
        end
    end
    if noisy_rooms[env.current.name] ~= nil then
        if go(noisy_rooms[env.current.name]) ~= 0 then
            return -1
        end
    end
    if recover(config.job_nl) ~= 0 then
        return -1
    end
    return
end

function flow_do_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ flow_do_job ］")
    automation.phase = global.phase["任务"]
    local rc
    if config.jobs[config.jobs[global.jid]].enable == true and config.jobs[config.jobs[global.jid]].active == true then
        if config.jobs[config.jobs[global.jid]].limit == nil then
            rc = config.jobs[config.jobs[global.jid]].func()
        elseif statistics("classify", 1, config.jobs[global.jid]) < config.jobs[config.jobs[global.jid]].limit then
            rc = config.jobs[config.jobs[global.jid]].func()
        end
        if (rc or 0) < 0 then
            return -1
        end
    end
    if rc == 0 then
        global.jid = 1
        automation.jid = nil
        automation.idle = false
        var.flow.loop = 0
        if config.skill_prior == true then
            return
        end
        return 0
    else
        if privilege_job(config.jobs[global.jid]) == true then
            global.jid = 1
            return flow_do_job()
        end
        if config.jobs[global.jid] == "嵩山任务" then
            if config.jobs[global.jid].enable == true and config.jobs[global.jid].active == true then
                if statistics("classify", 1, config.jobs[global.jid]) < config.jobs[config.jobs[global.jid]].limit then
                    global.jid = global.jid - 1
                end
            end
        end
        if global.jid == #config.jobs then
            global.jid = 0
        end
        if global.jid + 1 == (automation.jid or 1) then
            global.jid = 0
            automation.jid = nil
            var.flow.loop = var.flow.loop + 1
            if var.flow.loop == 3 then
                var.flow.loop = 0
                global.jid = 1
                return 1
            end
        end
        global.jid = global.jid + 1
        return flow_do_job()
    end
end

function flow_full_skill()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ flow_full_skill ］")
    automation.phase = global.phase["练功"]
    if break_event() == true then
        return
    end
    automation.skill = true
    local rc = zuanyan()
    if rc < 0 then
        return -1
    elseif rc == 1 or break_event() == true then
        rc = flow_full_skill_checkhp()
        return rc
    end
    rc = lian()
    if rc < 0 then
        return -1
    elseif rc == 1 or break_event() == true then
        rc = flow_full_skill_checkhp()
        return rc
    end
    if automation.skill == true then
        return 1
    end
    return flow_full_skill()
end

function flow_full_skill_checkhp()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ flow_full_skill_checkhp ］")
    if automation.skill ~= true then
        if run_enable() < 0 or run_prepare() < 0 then
            return -1
        end
    end
    automation.skill = nil
    return
end

function flow_suspend()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ flow_suspend ］")
    if timer.is_exist("flow_suspend") == false then
        timer.add("flow_suspend", 900, "automation.phase = global.phase['空闲']", nil, {Enable=true, OneShot=true})
    end
    for _,v in ipairs(config.jobs) do
         if config.jobs[v].active == true then
             return
         end
    end
    wait(1)
    if automation.phase == global.phase["空闲"] then
        return
    end
    return flow_suspend()
end

function plan()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ plan ］")
    local list = plan_fight_weapon()
    list = plan_lian_weapon(list)
    if items[config.fight.armor] == nil then
        show("未定义 "..config.fight.armor, "orange")
        return -1
    else
        if items[config.fight.armor].treasure == true and carryon.inventory[config.fight.armor] == nil then
            config.fight.armor = items[config.fight.armor].spare
        end
    end
    list[config.fight.armor] = 1
    for _,v in ipairs(config.fight.others or {}) do
        if items[v] == nil then
            show("未定义 "..v, "orange")
            return -1
        end
        list[v] = 1
    end
    if profile.family == "日月神教" then
        list["黑木令:heimu ling"] = 1
    end
    if profile.family == "明教" then
        list["铁焰令:tieyan ling"] = 1
    end
    if profile.family == "天鹰教" then
        list["天鹰令:tianying ling"] = 1
    end
    if profile.family == "御林军" then
        list["侍卫腰牌:yaopai"] = 1
    end
    if profile.family == "万兽山庄" then
        list["皮帽:wanshou pimao"] = 1
    end
    if table.is_empty(carryon.repository) then
        list["饱腹玉:baofu yu"] = 1
        list["炼心石:lianxin shi"] = 1
    else
        if carryon.repository["饱腹玉"] ~= nil or is_own("饱腹玉:baofu yu") == true then
            list["饱腹玉:baofu yu"] = 1
        else
            list["食盒:shi he"] = 1
            list["牛皮酒袋:jiudai"] = 1
            list["汽锅鸡:qiguo ji"] = 10
        end
        if carryon.repository["炼心石"] ~= nil or is_own("炼心石:lianxin shi") == true then
            list["炼心石:lianxin shi"] = 1
        end
    end
    local box = false
    for k,v in pairs(carryon.container) do
        if v.water == nil then
            box = true
            repeat
                local l = wait_line("get all from "..k,
                          30, nil, nil,
                          "^你上一个动作还没有完成！$|"..
                          "^> $")
                if l == false then
                    return -1
                elseif l[0] == "你上一个动作还没有完成！" then
                    if wait_no_busy("halt") < 0 then
                        return -1
                    end
                else
                    break
                end
            until false
        end
    end
    if box == true then
        if run_i() < 0 then
            return -1
        end
    end
    local trash = {}
    for k,v in pairs(carryon.inventory) do
        if list[k] == nil then
            if items[k] == nil or items[k].reserve ~= true then
                trash[k] = v.count
            end
        end
    end
    local money = 10000
    for k,v in pairs(list) do
        if carryon.inventory[k] ~= nil then
            if carryon.inventory[k].count > v then
                trash[k] = carryon.inventory[k].count - v
                list[k] = nil
            else
                list[k] = v - carryon.inventory[k].count
                if k == "汽锅鸡:qiguo ji" and list[k] < 8 then
                    list[k] = nil
                end
            end
        end
        if (list[k] or 0) > 0 then
            money = money + ((set.max(items[k].price) or 0) * list[k])
        end
        if list[k] == 0 then
            list[k] = nil
        end
    end
    return list,trash,money - carryon.money
end

function prepare_items()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ prepare_items ］")
    local rc = prepare_items_obtain()
    if rc ~= nil then
        return rc
    end
    if is_own("牛皮酒袋:jiudai") == true and (carryon.container["jiudai 1"].water == false or carryon.container["jiudai 1"].stage < 5) then
        if go(959) ~= 0 then
            return -1
        end
        local l = wait_line("fill jiudai",
                            30, nil, nil,
                            "^你将手中的牛皮酒袋放入水槽，灌满了水。$")
        if wait_no_busy() < 0 then
            return -1
        end
    end
    for _,v in ipairs(config.fight.others or {}) do
        run("wear "..items[v].id)
    end
    if run_hp() < 0 then
        return -1
    end
    if state.food < 100 or state.drink < 100 or state.food * state.drink == 0 then
        if feed("full") < 0  then
            return -1
        end
    end
    if is_own("食盒:shi he") == true  then
        if pack("shi he 1", {["汽锅鸡:qiguo ji"] = carryon.inventory["汽锅鸡:qiguo ji"].count}) < 0  then
            return -1
        end
    end
    return 0
end

function prepare_items_obtain()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ prepare_items_obtain ］")
    local obtain,trash,expense = plan()
    trash["铁焰令:tieyan ling"] = nil
    trash["天鹰令:tianying ling"] = nil
    trash["黑木令:heimu ling"] = nil
    trash["侍卫腰牌:yaopai"] = nil
    trash["皮帽:wanshou pimao"] = nil
    if automation.statistics.processing["嵩山任务"] ~= nil then
        trash["面罩:mian zhao"] = nil
    end
    if drop(trash) < 0  then
        return -1
    end
    if expense > 0 then
        if draw(expense) ~= 0 then
            return -1
        end
    elseif expense < -110000 then
        if deposit(math.abs(expense + 10000)) < 0  then
            return -1
        end
    end
    if aquire(obtain) ~= 0 then
        return -1
    else
        return
    end
    return prepare_items()
end

function plan_fight_weapon()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ plan_fight_weapon ］")
    local list = {}
    for k,v in pairs(config.fight) do
        if  v.weapon ~= nil and (k == "通用" or (config.jobs[k] or {}).enable == true) then
            local fight_weapon = {}
            if v.weapon[1] == "" then
                fight_weapon["圣阿武契的战书:santa glove"] = 1
            else
                if fight_weapon["圣阿武契的战书:santa glove"] == nil then
                    if v.performs ~= nil and #set.inter(v.performs, {"perform dazhuan", "perform feizhang"}) > 0 then
                        fight_weapon["圣阿武契的战书:santa glove"] = 1
                    end
                end
                if items[v.weapon[1]] ~= nil then
                    if items[v.weapon[1]].treasure == true then
                        if carryon.inventory[v.weapon[1]] then
                            fight_weapon[v.weapon[1]] = items[v.weapon[1]].count or 1
                            if v.weapon[1] == "金轮:jin lun" then
                                fight_weapon[items["打铁锤:datie chui"]] = 1
                            else
                                fight_weapon[items[v.weapon[1]].spare] = 1
                            end
                        else
                            v.weapon[1] = items[v.weapon[1]].spare
                        end
                    end
                    if items[v.weapon[1]].treasure ~= true then
                        if items[v.weapon[1]].id == "fa lun" then
                            fight_weapon[v.weapon[1]] = 5
                            fight_weapon["打铁锤:datie chui"] = 1
                        else
                            if string.match(v.weapon[1], "personal ") then
                                fight_weapon[v.weapon[1]] = 1
                                fight_weapon[items[v.weapon[1]].spare] = 1
                            else
                                fight_weapon[v.weapon[1]] = 2
                            end
                        end
                    end
                else
                    show("未定义 "..v.weapon[1], "orange")
                    return -1
                end
                if (v.weapon[2] or "") ~= "" then
                    if fight_weapon[v.weapon[2]] ~= nil then
                        if v.weapon[2] ~= "金轮:jin lun" and 
                           v.weapon[2] ~= "铜轮:fa lun" and 
                           v.weapon[2] ~= "法轮:fa lun" then
                            fight_weapon[v.weapon[2]] = fight_weapon[v.weapon[2]] + 1
                        end
                    else
                        if items[v.weapon[2]] ~= nil then
                            if items[v.weapon[2]].treasure == true then
                                if carryon.inventory[v.weapon[2]] ~= nil then
                                    fight_weapon[v.weapon[2]] = items[v.weapon[2]].count or 1
                                    if v.weapon[2] == "金轮:jin lun" then
                                        fight_weapon[items["打铁锤:datie chui"]] = 1
                                    else
                                        fight_weapon[items[v.weapon[2]].spare] = 1
                                    end
                                else
                                    v.weapon[2] = items[v.weapon[2]].spare
                                    if v.weapon[1] == "铜轮:fa lun" and v.weapon[1] == v.weapon[2] then
                                        v.weapon[2] = "法轮:fa lun"
                                    end
                                end
                            end
                            if items[v.weapon[2]].treasure ~= true then
                                if items[v.weapon[2]].id == "fa lun" then
                                    fight_weapon[v.weapon[2]] = 5
                                    fight_weapon["打铁锤:datie chui"] = 1
                                else
                                    if string.match(v.weapon[2], "personal ") then
                                        fight_weapon[v.weapon[2]] = 1
                                        fight_weapon[items[v.weapon[2]].spare] = 1
                                    else
                                        fight_weapon[v.weapon[2]] = 2
                                    end
                                end
                            end
                        else
                            show("未定义 "..v.weapon[2], "orange")
                            return -1
                        end
                    end
                end
            end
            for i,j in pairs(fight_weapon) do
                list[i] = math.max(j, (list[j] or 0))
                if config.lian.weapon[items[i].type] == nil then
                    config.lian.weapon[items[i].type] = i
                end
            end
        end
    end
    return list
end

function plan_lian_weapon(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ plan_lian_weapon ］参数：list = "..table.tostring(list))
    for _,v in ipairs(config.lian) do
        if set.has({"sword", "blade", "hammer", "stick", "club", "axe", "whip", "pike", "staff", "hook", "stroke"}, v) then
            if config.lian.weapon[v] == nil then
                config.lian.weapon[v] = lian_weapon[v]
            end
            list[config.lian.weapon[v]] = math.max(1, (list[config.lian.weapon[v]] or 0))
        end
    end
    return list
end

function prepare_skills()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ prepare_skills ］")
    local cfg,skill_id = {},{}
    if io.exists(get_work_path().."skills.cfg") then
        cfg = table.load(get_work_path().."skills.cfg")
    end
    if table.is_empty(cfg) then
        if sync_skills() < 0 then
            return -1
        else
            return 0
        end
    end
    local check_enable = false
    for k,v in pairs(skills.enable) do
        -- if cfg[k] == nil then
        --     check_enable = true
        --     run("enable "..k.." none")
        -- else
        if cfg[k] ~= nil then
            if cfg[k][2] ~= v.name then
                check_enable = true
                run("enable "..k.." "..cfg[k][1])
            end
            skill_id[k] = cfg[k][1]
            cfg[k] = nil
        end
    end
    local prepare = set.pop(cfg)
    for k,v in pairs(cfg) do
        check_enable = true
        run("enable "..k.." "..v[1])
        skill_id[k] = cfg[k][1]
    end
    local current_prepare = table.keys(skills.prepare)
    if not set.eq(current_prepare, prepare) then
        if #set.inter(current_prepare, prepare) < #current_prepare then
            run("prepare none")
        else
            prepare = set.compl(prepare, current_prepare)
        end
        if #prepare > 0 then
            prepare[1] = skill_id[prepare[1]]
            if prepare[2] ~= nil then
                prepare[2] = skill_id[prepare[2]]
            end
            run("prepare "..set.concat(prepare, " "))
        end
        if run_prepare() < 0 then
            return -1
        end
    end
    if check_enable == true then
        if run_enable() < 0 then
            return -1
        end
    end
    return 0
end

function sync_skills()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ sync_skills ］")
    if run_enable() < 0 then
        return -1
    end
    if run_prepare() < 0 then
        return -1
    end
    local special = {}
    for k,v in pairs(skills.special) do
        special[v.name] = k
    end
    local cfg = {{}}
    for k,v in pairs(skills.enable) do
        if v.name ~= "无" then
            cfg[k] = {special[v.name], v.name}
        end
    end
    for k,v in pairs(skills.prepare) do
        set.append(cfg[1], k)
    end
    table.save(get_work_path().."skills.cfg", cfg)
    return 0,cfg
end

function privilege_job(job)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ privilege_job ］参数：job = "..tostring(job))
    for k,v in ipairs(config.jobs) do
        if k >= set.index_of(config.jobs, job) then
            return false
        end
        if config.jobs[v].enable == true and config.jobs[v].active == true then
            if config.jobs[config.jobs[global.jid]].limit == nil then
                return true
            elseif statistics("classify", 1, config.jobs[global.jid]) < config.jobs[config.jobs[global.jid]].limit then
                return true
            end
        end
    end
end

function break_event()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ break_event ］")
    if automation.phase ~= nil then
        if automation.phase == global.phase["练功"] then
            if config.jobs["门派任务"].active == true then
                return true
            end
            if config.skill_prior == false then
                if config.jobs["寻访任务"].active == true or 
                   config.jobs["斧头帮任务"].active == true then
                    return true
                end
            end
        end
        if automation.phase == global.phase["任务"] then
            if var.job ~= nil then
                if var.job.bevent == true then
                    return true
                end
                if config.jobs[global.jid] == "门派任务" then
                    if (config.jobs["门派任务"].phase or 0) == 2 then
                        return true
                    end
                    if (config.jobs["门派任务"].phase or 0) >= 4 then
                        return true
                    end
                end
                if config.jobs[global.jid] == "飞马镖局" then
                    if (config.jobs["飞马镖局"].phase or 0) >= 3 then
                        return true
                    end
                    if var.job.enemy.count > 0 or var.job.addenemy.count > 0 then
                        return true
                    end
                    if config.jobs["飞马镖局"].path[config.jobs["飞马镖局"].biaoche].next == nil then
                        return true
                    end
                end
            end
        end
    end
    return false
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
