trigger.add("fight_snake", "fight_stop(1)", "fight", {Enable=false}, nil, "^忽然一阵腥风袭来，一条巨蟒从身旁大树上悬下，把你卷走了。$")
trigger.add("fight_danger", "fight_stop()", "fight", {Enable=false}, nil, "^\\( 你(?:已经一副头重脚轻的模样，正在勉力支撑著不倒下去|已经陷入半昏迷状态，随时都可能摔倒晕去|受伤过重，已经有如风中残烛，随时都可能断气)。 \\)$")
trigger.add("fight_faint", "fight_stop(2)", "fight", {Enable=false}, nil, "^你的眼前一黑，接著什么也不知道了....$")
trigger.add("fight_idle", "fight_idle()", "fight", {Enable=false}, nil, "^\\S+只能对战斗中的对手使用。$|^\\S+只有在战斗中才能使用。$|^\\S+只能在战斗中对对手使用。$｜^你不在战斗中。$")
trigger.add("fight_lost_weapon", "fight_lost_weapon(get_matches(1) or get_matches(2))", "fight", {Enable=false}, 99, "^你只觉得手中(\\S+)把持不定，脱手飞出！$|^只听见「啪」地一声，你手中的(\\S+)已经断为两截！$")

function unwield()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ unwield ］")
    if wait_line("unwield all;set 卸除武器", 30, {Gag=true}, nil, "^你目前还没有任何为 卸除武器 的变量设定。$", "^> $") == false then
        return -1
    end
    carryon.wield = {"", ""}
    return 0
end

function wield(weapon)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ wield ］参数：weapon = "..table.tostring(weapon))
    var.wield = var.wield or { weapon = weapon, lun_num = 5, personal_weapon = "" }
    if carryon.wield[1] ~= weapon[1] and carryon.wield[1] ~= "" then
        if unwield() < 0  then
            return wield_return(-1)
        end
    end
    if carryon.wield[2] ~= weapon[2] and carryon.wield[2] ~= "" then
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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ wield_return ］参数：rc = "..tostring(rc))
    if var.wield == nil then
        return rc
    end
    var.wield = nil
    return rc
end

function wield_position(pos)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ wield_position ］参数：pos = "..tostring(pos))
    if var.wield.weapon[1] == "" then
        return
    end
    if carryon.wield[pos] == var.wield.weapon[pos] then
        return
    end
    if is_own(var.wield.weapon[pos]) ~= true then
        if var.job ~= nil then
            if items[var.wield.weapon[pos]].spare ~= nil then
                var.job.weapon = var.job.weapon or table.copy(var.wield.weapon)
                var.job.weapon_ori = var.wield.weapon
                var.wield.weapon[pos] = items[var.wield.weapon[pos]].spare
                return wield(var.wield.weapon)
            end
            if pos == 2 then
                var.job.weapon = var.job.weapon or table.copy(var.wield.weapon)
                var.job.weapon_ori = var.wield.weapon
                var.wield.weapon[pos] = ""
                return wield(var.wield.weapon)
            end
        end
        show("dbg1")
        printf(var.wield.weapon[pos])
        printf(carryon.inventory)
        return 1
    end
    local wid
    if var.wield.weapon[1] == var.wield.weapon[2] then
        if pos == 2 then
            if carryon.inventory[var.wield.weapon[pos]].count < 2 then
                show("dbg2")
                printf(var.wield.weapon[pos])
                printf(carryon.inventory)
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
    local l = wait_line("wield "..wid..";set 装备武器",
                        30, nil, 10,
                        "^你正忙着呢。$|"..
                        "^你身上没有这样东西。$|"..
                        "^你使不了那么多法轮。$|"..
                        "^你已经装备著了。$|"..
                        "^你必须空出一只手来使用武器。$|"..
                        "^你必须先放下你目前装备的武器。$|"..
                        "^你目前还没有任何为 装备武器 的变量设定。$")
    if l == false then
        return -1
    elseif l[0] == "你正忙着呢。" then
        if wait_no_busy("halt") < 0  then
            return -1
        end
        wait(0.1)
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
        if wait_line(nil, 30, nil, nil, "^> $") == false then
            return -1
        end
        carryon.wield[pos] = var.wield.weapon[pos]
        return
    end
    return wield_position(pos)
end

function process_killer()
    return false
end

function fight()  -- 0 成功， 1 未知， 2 失败， 3 普攻
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ fight ］")
    var.fight = var.fight or { idle = 0, refresh = false }
    var.fight.job = var.fight.job or config.jobs[global.jid or 0] or "通用"
    trigger.enable_group("fight")
    if prepare_skills() < 0 then
        return -1
    end
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
    if prepare_skills() < 0 then
        return fight_return(-1)
    end
    if var.wield == nil then
        local rc = wield(config.fight[var.fight.job].weapon or config.fight["通用"].weapon)
        if rc < 0 then
            return fight_return(-1)
        elseif rc == 1 then
            return fight_return(2)
        end
    end
    if (var.fight.stop  or 0) < 3 then
        if state.nl <= profile.power * 7 and state.power > 0 then
            run("jiali none")
        elseif state.nl > profile.power * 7 and 
               (config.fight[var.fight.job].power or config.fight["通用"].power) ~= "none" then
            if state.power == 0 then
                run("jiali "..(config.fight[var.fight.job].power or config.fight["通用"].power))
            end
        end
        if state.nl <= profile.energy * 7 and state.energy > 1 then
            run("jiajin 1")
        elseif state.jl > profile.energy * 7 and 
               (config.fight[var.fight.job].energy or config.fight["通用"].energy) ~= 1 then
            if state.energy == 1 then
                run("jiajin "..(config.fight[var.fight.job].energy or config.fight["通用"].energy))
            end
        end
        trigger.enable("fight_idle")
        run(set.concat((config.fight[var.fight.job].yuns or config.fight["通用"].yuns), ";")..";"..set.concat((config.fight[var.fight.job].performs or config.fight["通用"].performs), ";"))
    end
    wait_line(nil,
              2, nil, 100,
              "^"..((var.job or {}).enemy_name or "\\S+").."倒在地上，挣扎了几下就死了。$|"..
              "^你只觉得手中\\S+把持不定，脱手飞出！$|"..
              "^只听见「啪」地一声，你手中的\\S+已经断为两截！$|"..
              "^你目前还没有任何为 中断事件 的变量设定。$")
    return fight()
end

function fight_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ fight_return ］参数：rc = "..tostring(rc))
    if var.fight == nil then
        return rc
    end
    var.fight = nil
    trigger.disable_group("fight")
    if rc < 2 then
        if state.buff["riyue-lun_dazhuan"] ~= nil then
            wait_line(nil,
                      3, nil, 100,
                      "^\\S+在你身旁绕了个圈子，你伸手一招，那飞行中的\\S+便重新飞回你的手中！$")
            state.buff["riyue-lun_dazhuan"] = nil
        end
    end
    return rc
end

function fight_lost_weapon(weapon)
    for k,v in ipairs(carryon.wield) do
        if items[v].name == weapon then
            weapon = v
            carryon.wield[k] = ""
            break
        end
    end
    if items[weapon] == nil then
        fight_stop(2)
        return
    end
    if carryon.inventory[weapon] == nil then
        fight_stop(2)
        return
    end
    carryon.inventory[weapon].count = carryon.inventory[weapon].count - 1
    if weapon == "金轮:jin lun" or 
       weapon == "法轮:fa lun" or 
       weapon == "铜轮:fa lun" then
        carryon.inventory[weapon].count = 0
    end
    if carryon.inventory[weapon].count == 0 then
        carryon.inventory[weapon] = nil
    end
end

function fight_stop(rc)
    var.fight.stop = rc or var.fight.stop
    run("set 中断事件")
end

function fight_idle()
    show("dbg fight idle")
    printf(var.fight)
    trigger.disable("fight_idle")
    if var.fight.idle > 3 then
        fight_stop(0)
    else
        var.fight.idle = var.fight.idle + 1
    end
end