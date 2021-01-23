trigger.add("fight_snake", "fight_stop(1)", "fight", {Enable=false}, nil, "^忽然一阵腥风袭来，一条巨蟒从身旁大树上悬下，把你卷走了。$")
trigger.add("fight_danger", "fight_stop()", "fight", {Enable=false}, nil, "^\\( 你(?:已经一副头重脚轻的模样，正在勉力支撑著不倒下去|已经陷入半昏迷状态，随时都可能摔倒晕去|受伤过重，已经有如风中残烛，随时都可能断气)。 \\)$")
trigger.add("fight_faint", "fight_stop(2)", "fight", {Enable=false}, nil, "^你的眼前一黑，接著什么也不知道了....$")
trigger.add("fight_idle", "fight_idle()", "fight", {Enable=false}, nil, "^\\S+只能对战斗中的对手使用。$|^\\S+只有在战斗中才能使用。$")
trigger.add("fight_lost_weapon", "fight_lost_weapon()", "fight", {Enable=false}, nil, "^你只觉得手中\\S+把持不定，脱手飞出！$")

function unwield()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ unwield ］")
    if wait_line("unwield all", 30, {Gag=true}, nil, "^你(?:把|将)手(?:中|上)的\\S+。$|"..
                                                     "^你放下\\S+。$|"..
                                                     "^你将\\S+插\\S+。$|"..
                                                     "^你将圣火令放入怀中。$|"..
                                                     "^你反手将\\S+。$|"..
                                                     "^你把\\S+收了起来。$|"..
                                                     "^你(?:作|画)个剑势，将\\S+剑缓缓插回剑鞘，\\S+。$|"..
                                                     "^啪的一声，你把摺扇合了起来，收进袖中。$|"..
                                                     "^你把旱烟管在鞋底上嗑一嗑，小心地放回怀里。$|"..
                                                     "^你把墓碑往地上一放，不小心砸到自己的脚。$|"..
                                                     "^你缓缓散去内力, 冰王笛化为雪花四散而去。$|"..
                                                     "^青光晃闪，血腥臭味消失无踪！「绿波香露刀」 已收回刀鞘。$|"..
                                                     "^只听「嗽」的一声，\\S+没入了你腰间的剑鞘。$|"..
                                                     "^你从容地将\\S+慢慢插回剑鞘。背手而立。$|"..
                                                     "^你将\\S+仔细地用布革包好藏妥。$|"..
                                                     "^伏魔刀自你掌中飞起，在半空中一转，「唰」地跃入刀鞘。$|"..
                                                     "^玄铁乍收，生机徒现。$|"..
                                                     "^ 蛇进刀鞘。|$"..
                                                     "^你将\\S+放回锦匣中。但见锦匣似乎还隐隐闪耀著碧光。$|"..
                                                     "^你回身收剑，刹那间\\S+凛冽的光华陡然没入了你腰间的剑鞘，四周顿时阴暗了下来。$|"..
                                                     "^你手一抖，将\\S+插回刀鞘。$|"..
                                                     "^你仰天一声清啸，伸手在屠龙刀上一弹，放入长袍之内。$|"..
                                                     "^"..(carryon.weapon.unwield or "no personal").."$", "^> $") == false then
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
        if var.job ~= nil then
            if items[var.wield.weapon[pos]] ~= nil and items[var.wield.weapon[pos]].spare ~= nil then
                var.job.weapon = var.job.weapon or table.copy(var.wield.weapon)
                var.job.weapon_ori = var.wield.weapon
                var.wield.weapon[pos] = items[var.wield.weapon[pos]].spare
                return wield(var.wield.weapon)
            end
        end
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
                                                    "^你「\\S+」的一声\\S+握在手中。$|"..
                                                    "^你(?:抽|拿|拔)出一\\S+。$|"..
                                                    "^你从背后\\S+在手中。$|"..
                                                    "^你从\\S+抽出一把\\S+。$|"..
                                                    "^你从地上捧起一些沙子，把沙子灌入\\S+中，握在手里。$|"..
                                                    "^你从口袋中拈出一根\\S+套在小手指上。$|"..
                                                    "^你从腰间抽出\\S+。$|"..
                                                    "^你从衣袋里掏出一根\\S+，握在手中当武器。$|"..
                                                    "^你端起一把\\S+在手中。$|"..
                                                    "^你捧起一张\\S+在手中。$|"..
                                                    "^你取出一对\\S+，双手合处，当地一声，震耳欲聋。$|"..
                                                    "^你双手(?:提|握)起\\S+。$|"..
                                                    "^你用拇指和食指从鬓间拈出一根\\S+。$|"..
                                                    "^你把判官笔取在手中，说：你我好朋友，我这秃笔上就不蘸墨了。$|"..
                                                    "^你搬起一块石头准备战斗。$|"..
                                                    "^你对着地上一座坟磕了个头，说声对不起，搬起一座墓碑。$|"..
                                                    "^你举起一根大树干托在手中。$|"..
                                                    "^你摸出一支旱烟管，点上火，叼在嘴角，慢慢喷出烟雾。$|"..
                                                    "^你缓缓抽出君子剑，只觉轻飘飘无甚份量，到是一阵凉意凛然逼人，令人莫可忽视。$|"..
                                                    "^你拔剑出鞘。只见\\S+明亮如秋水，端的是一口利器。$|"..
                                                    "^你从腰间解下\\S+拿在手中，绸带抖动，圆球如铃子般响了起来，玎玲玎玲，清脆动听。$|"..
                                                    "^你合手作个揖，缓缓抽出淑女剑，只觉轻飘飘无甚份量，到是一阵凉意凛然逼人，另人莫可忽视。$|"..
                                                    "^你劲贯双臂，举起了一把\\S+。$|"..
                                                    "^你轻轻一笑，抽出\\S+握在手中。$|"..
                                                    "^你阴恻恻地一笑，抽出一根哭丧棒抓在手中。$|"..
                                                    "^「唰」的一声，一柄\\S+在你手中轻轻颤动。$|"..
                                                    "^你从怀中拿出一根圣火令握在手中。$|"..
                                                    "^随著你抽出\\S+，缕缕寒光有如水波粼粼般溢出了剑鞘。$|"..
                                                    "^你将\\S+拔剑出鞘。寒气辉芒随剑而出，如明月之破云而来。$|"..
                                                    "^你拔出\\S+只觉得青光耀眼，寒气袭体。但见那你手中\\S+不住颤动，便如一根闪闪发出丝光的缎带。$|"..
                                                    "^你一声冷笑，“波”的一声，横刀当胸，身前绿光闪闪。$|"..
                                                    "^你将\\S+抽出剑鞘，只见锋芒利刃，寒光闪烁，令人立感剑气纵横，豪气顿生。$|"..
                                                    "^你从身旁包袱中取出一口长剑，伸指在剑刃上一弹，那剑陡地弯了过来，随即弹直，嗡嗡作响，声音清越。$|"..
                                                    "^你取出\\S+，扳转剑尖，和剑柄圈成一个圆圈，手一放，铮的一声，剑身又弹得笔直，微微晃动。$|"..
                                                    "^你举起\\S+，但见日月无光，沉雷郁郁，似乎要将一切生机压毁。$|"..
                                                    "^见你小心翼翼地敲了几敲，又掂了几掂之后，方才将\\S+从鞘中缓缓拔出。$|"..
                                                    "^你抽出\\S+，只见一团光华从剑鞘绽放而出，宛如出水的芙蓉雍容而清冽。$|"..
                                                    "^只见你取出一根\\S+握在手中。$|"..
                                                    "^只见\\S+光一闪，你手中已多了一\\S+$|"..
                                                    "^一道金光在你眼前一闪，你操出一根降魔杵，举过头顶，光茫万照。$|"..
                                                    "^你从袖中掏出一柄摺扇，一挥，张了开来，露出扇上一朵娇艳欲滴的牡丹。$|"..
                                                    "^只听「唰」的一声，血刀脱鞘飞出，你手中似是握住一条赤蛇泛着红光，弥漫着一片血气。$|"..
                                                    "^你打开了锦匣，取出\\S+，只见剑刃不住颤动，似乎只须轻轻一抖，便能折断。$|"..
                                                    "^"..(carryon.weapon.wield or "no personal").."$")
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
    local rc = wield((config.fight[config.jobs[global.jid]] or config.fight["通用"]).weapon or config.fight["通用"].weapon)
    if rc < 0 then
        return fight_return(-1)
    elseif rc == 1 then
        return fight_return(2)
    end
    if prepare_skills() < 0 then
        return fight_return(-1)
    end
    if (var.fight.stop  or 0) < 3 then
        if state.nl <= profile.power * 7 and state.power > 0 then
            run("jiali none")
        elseif state.nl > profile.power * 7 and 
               (config.fight[config.jobs[global.jid]].power or config.fight["通用"].power) ~= "none" then
            if state.power == 0 then
                run("jiali "..(config.fight[config.jobs[global.jid]].power or config.fight["通用"].power))
            end
        end
        if state.nl <= profile.energy * 7 and state.energy > 1 then
            run("jiajin 1")
        elseif state.jl > profile.energy * 7 and (config.fight[config.jobs[global.jid]].energy or config.fight["通用"].energy) ~= 1 then
            if state.energy == 1 then
                run("jiajin "..(config.fight[config.jobs[global.jid]].energy or config.fight["通用"].energy))
            end
        end
        trigger.enable("fight_idle")
        run(set.concat((config.fight[config.jobs[global.jid]].yuns or config.fight["通用"].yuns), ";")..";"..set.concat((config.fight[config.jobs[global.jid]].performs or config.fight["通用"].performs), ";"))
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

function fight_lost_weapon()
    if carryon.inventory[carryon.wield[1]] == nil then
        fight_stop(2)
        return
    end
    carryon.inventory[carryon.wield[1]].count = carryon.inventory[carryon.wield[1]].count - 1
    if carryon.wield[1] == "金轮:jin lun" or 
       carryon.wield[1] == "法轮:fa lun" or 
       carryon.wield[1] == "铜轮:fa lun" then
        carryon.inventory[carryon.wield[1]].count = 0
    end
    if carryon.inventory[carryon.wield[1]].count == 0 then
        carryon.inventory[carryon.wield[1]] = nil
    end
    set.remove(carryon.wield, 1)
    set.append(carryon.wield, "")
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