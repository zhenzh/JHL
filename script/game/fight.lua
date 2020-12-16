trigger.add("fight_snake", "fight_stop(1)", "fight", {Enable=false}, nil, "^忽然一阵腥风袭来，一条巨蟒从身旁大树上悬下，把你卷走了。$")
trigger.add("fight_danger", "fight_stop()", "fight", {Enable=false}, nil, "^\\( 你(?:已经一副头重脚轻的模样，正在勉力支撑著不倒下去|已经陷入半昏迷状态，随时都可能摔倒晕去|受伤过重，已经有如风中残烛，随时都可能断气)。 \\)$")
trigger.add("fight_faint", "fight_stop(2)", "fight", {Enable=false}, nil, "^你的眼前一黑，接著什么也不知道了....$")
trigger.add("fight_idle", "fight_idle()", "fight", {Enable=false}, nil, "^\\S+只能对战斗中的对手使用。$|^\\S+只有在战斗中才能使用。$")

function unwield()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ unwield ］")
    if wait_line("unwield all", 30, {Gag=true}, nil, "^> $") == false then
        return -1
    end
    carryon.wield = {"", ""}
    return 0
end

function wield(weapon)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wield ］参数：weapon = "..table.tostring(weapon))
    var.wield = var.wield or { weapon = weapon, lun_num = 5, personal_weapon = "" }
    if carryon.wield[1] ~= weapon[1] and 
       carryon.wield[1] ~= "" then
        if unwield() < 0  then
            return wield_return(-1)
        end
    end
    if carryon.wield[2] ~= weapon[2] and 
       carryon.wield[2] ~= "" then
        if unwield() < 0  then
            return wield_return(-1)
        end
    end
    if carryon.weapon.name ~= "" then
        var.wield.personal_weapon = "^"..carryon.weapon.wield.."$|"
    end
    local rc = wield_position(1)
    if rc ~= nil then
        return wield_return(rc)
    end
    rc = wield_position(2)
    if rc ~= nil then
        return wield_return(rc)
    end
    return wield_return(0)
end

function wield_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wield_return ］参数：rc = "..tostring(rc))
    if var.wield == nil then
        return rc
    end
    var.wield = nil
    return rc
end

function wield_position(pos)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wield_position ］参数：pos = "..tostring(pos))
    if var.wield.weapon[1] == "" then
        return
    end
    if carryon.wield[pos] == var.wield.weapon[pos] then
        return
    end
    if is_own(var.wield.weapon[pos]) ~= true then
        return 1
    end
    local wid
    if var.wield.weapon[1] == var.wield.weapon[2] then
        if pos == 2 then
            if carryon.inventory[var.wield.weapon[pos]].count < 2 then
                return 1
            end
            wid = carryon.inventory[var.wield.weapon[pos]].id.." "..carryon.inventory[var.wield.weapon[pos]].seq[2]
        end
    end
    if wid == nil then
        wid = carryon.inventory[var.wield.weapon[pos]].id.." "..carryon.inventory[var.wield.weapon[pos]].seq[1]
    end
    if string.match(wid, " lun ") then
        if carryon.inventory[var.wield.weapon[pos]].count > var.wield.lun_num then
            if drop({[var.wield.weapon[pos]] = carryon.inventory[var.wield.weapon[pos]].count - var.wield.lun_num}) < 0 then
                return -1
            end
        end
    end
    local l = wait_line("wield "..wid, 30, nil, 10, "^你正忙着呢。$|"..
                                                    "^你身上没有这样东西。$|"..
                                                    "^你使不了那么多法轮。$|"..
                                                    "^你已经装备著了。$|"..
                                                    "^你必须空出一只手来使用武器。$|"..
                                                    "^你必须先放下你目前装备的武器。$|"..
                                                    var.wield.personal_weapon..
                                                    "^.*你.*$|"..
                                                    "^> $")
    if l == false then
        return -1
    elseif l[0] == "你正忙着呢。" then
        if wait_no_busy("halt") < 0  then
            return -1
        end
    elseif l[0] == "你身上没有这样东西。" then
        if run_i() < 0 then
            return -1
        end
    elseif l[0] == "你使不了那么多法轮。" then
        if run_i() < 0 then
            return -1
        end
        if carryon.inventory[var.wield.weapon[pos]].count == var.wield.lun_num then
            var.wield.lun_num = var.wield.lun_num - 1
        end
    elseif string.match(l[0], "你.*武器。") then
        if unwield() < 0  then
            return -1
        end
        return wield(var.wield.weapon)
    else
        carryon.wield[pos] = var.wield.weapon[pos]
        return
    end
    return wield_position(pos)
end

function process_killer()
    return false
end

function fight()  -- 0 成功， 1 未知， 2 失败， 3 普攻
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ fight ］")
    var.fight = var.fight or { idle = 0, refresh = false }
    trigger.enable_group("fight")
    if run_hp() < 0 then
        return fight_return(-1)
    end
    var.fight.refresh = false
    if state.qx < state.qx_max and 
       state.qx / (state.qx_max * 100 / state.qx_pct) < 0.7 then
        if state.nl >= 20 then
            var.fight.refresh = true
            run("yun recover")
        else
            return fight_return(2)
        end
    end
    if state.jl / state.jl_max < 0.3 then
        if state.nl >= 20 then
            var.fight.refresh = true
            run("yun refresh")
        else
            return fight_return(2)
        end
    end
    if var.fight.refresh == true then
        if run_hp() < 0 then
            return fight_return(-1)
        end
    end
    if state.qx / (state.qx_max * 100 / state.qx_pct) < 0.5 then
        return fight_return(2)
    end
    if state.jl / state.jl_max < 0.3 then
        return fight_return(2)
    end
    if (var.fight.stop or 3) < 3 then
        return fight_return(var.fight.stop)
    end
    local rc = wield((config.fight[config.jobs[global.jid]] or config.fight["通用"]).weapon)
    if rc < 0 then
        return fight_return(-1)
    elseif rc == 1 then
        return fight_return(2)
    end
    if (var.fight.stop  or 0) < 3 then
        if state.nl <= profile.power * 7 and 
           state.power > 0 then
            run("jiali none")
        elseif state.nl > profile.power * 7 and 
               config.fight[config.jobs[global.jid]].power ~= "none" then
            if state.power == 0 then
                run("jiali "..config.fight[config.jobs[global.jid]].power)
            end
        end
        if state.nl <= profile.energy * 7 and 
           state.energy > 1 then
            run("jiajin 1")
        elseif state.jl > profile.energy * 7 and 
               config.fight[config.jobs[global.jid]].energy ~= 1 then
            if state.energy == 1 then
                run("jiajin "..config.fight[config.jobs[global.jid]].energy)
            end
        end
        trigger.enable("fight_idle")
        run(set.concat(config.fight[config.jobs[global.jid]].yuns, ";")..";"..set.concat(config.fight[config.jobs[global.jid]].performs, ";"))
    end
    wait_line(nil, 2, nil, 100, "^"..(var.job.enemy_name or "\\S+").."倒在地上，挣扎了几下就死了。$|"..
                                "^你目前还没有任何为 中断事件 的变量设定。$")
    return fight()
end

function fight_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ fight_return ］参数：rc = "..tostring(rc))
    if var.fight == nil then
        return rc
    end
    var.fight = nil
    trigger.disable_group("fight")
    return rc
end

function fight_stop(rc)
    var.fight.stop = rc or var.fight.stop
    run("set 中断事件")
end

function fight_idle()
    trigger.disable("fight_idle")
    if var.fight.idle > 3 then
        fight_stop(0)
    else
        var.fight.idle = var.fight.idle + 1
    end
end
--日月神教使者对着你大吼：还想跑？快跟大爷回去晋见本神教教主！
--日月神教使者对着你大吼：还想跑？快跟大爷回去晋见本神教教主！