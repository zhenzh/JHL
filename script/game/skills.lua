function skills_dazuo()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ skills_dazuo ］")
    local skills_dazuo
    if var.zuanyan ~= nil then
        skills_dazuo = var.zuanyan
    end
    if var.xue ~= nil then
        skills_dazuo = var.xue
    end
    if var.lian ~= nil then
        skills_dazuo = var.lian
    end
    repeat
        if break_event() == true then
            return 1
        end
        if skills_dazuo.income == 0 then
            return
        end
        if state.nl >= state.nl_max * 2 - skills_dazuo.income then
            return
        end
        local rc = dazuo()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return
        end
        skills_dazuo.refresh = false
    until false
end

function zuanyan(times)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan ］参数：times = "..tostring(times))
    if config.job_zuanyan == false and var.job ~= nil then
        return zuanyan_return(0)
    end
    var.zuanyan = var.zuanyan or { times = math.max(30, times or 100) }
    _,var.zuanyan.income = dazuo_analysis()
    return zuanyan_num_i(1)
end

function zuanyan_return(rc)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan_return ］参数：rc = "..tostring(rc))
    var.zuanyan = nil
    _ = nil
    return rc
end

function zuanyan_refresh_hp(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan_refresh_hp ］参数：rc = "..tostring(rc))
    if var.zuanyan == nil then
        return rc
    end
    if var.zuanyan.refresh == true then
        if run_hp() < 0 then
            return -1
        end
    end
    return zuanyan_return(rc)
end

function zuanyan_num_i(i)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan_num_i ］参数：i = "..tostring(i))
    if config.zuanyan[i] == nil then
        return zuanyan_refresh_hp(0)
    end
    if skills.basic[config.zuanyan[i]] == nil then
        config.zuanyan[config.zuanyan[i]] = nil
        table.remove(config.zuanyan, i)
        return zuanyan_num_i(i)
    end
    if skills.special[config.zuanyan[config.zuanyan[i]].enable] == nil then
        config.zuanyan[config.zuanyan[i]] = nil
        table.remove(config.zuanyan, i)
        return zuanyan_num_i(i)
    end
    if config.zuanyan[i] == "force" then
        return zuanyan_num_i(i+1)
    end
    if skills.basic[config.zuanyan[i]].level > skills.special[config.zuanyan[config.zuanyan[i]].enable].level then
        return zuanyan_num_i(i+1)
    end
    if skills.basic[config.zuanyan[i]].level >= profile.level then
        return zuanyan_num_i(i+1)
    end
    automation.skill = false
    if skills.enable[config.zuanyan[i]].name ~= skills.special[config.zuanyan[config.zuanyan[i]].enable].name then
        if wait_line("enable "..config.zuanyan[i].." "..config.zuanyan[config.zuanyan[i]].enable, 30, nil, 30, "你从现在起用\\S+作为基本\\S+的特殊技能。") == false then
            return zuanyan_return(-1)
        end
    end
    repeat
        if break_event() == true then
            return zuanyan_refresh_hp(1)
        end
        local rc
        if automation.phase > global.phase["任务"] then
            if config.save_pots == true then
                if state.pot >= var.zuanyan.times then
                    if store_all_pots() < 0 then
                        return zuanyan_return(-1)
                    end
                end
            end
            rc = zuanyan_go_place(config.zuanyan[config.zuanyan[i]].place)
            if (rc or 0) < 0 then
                return zuanyan_return(-1)
            elseif rc == 1 then
                return zuanyan_num_i(i+1)
            end
            rc = zuanyan_prepare_state(0.8, 0.5)
            if rc ~= nil then
                return zuanyan_return(rc)
            end
        else
            if state.pot < var.zuanyan.times then
                return zuanyan_refresh_hp(0)
            end
            rc = zuanyan_prepare_state(0.8, 0.7)
            if rc ~= nil then
                return zuanyan_return(rc)
            end
        end
        rc = skills_dazuo()
        if rc ~= nil then
            return zuanyan_refresh_hp(rc)
        end
        if global.flood > config.flood then
            wait(1)
        end
        if break_event() == true then
            return zuanyan_refresh_hp(1)
        end
        rc = zuanyan_exec(i)
        if rc ~= nil then
            return zuanyan_refresh_hp(rc)
        end
    until false
end

function zuanyan_go_place(place)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan_go_place ］参数：place = "..tostring(place))
    if env.current.id[1] ~= place then
        local rc = go(place)
        if rc ~= 0 then
            return rc
        end
        if run_hp() < 0 then
            return -1
        end
        var.zuanyan.refresh = false
    end
    return
end

function zuanyan_prepare_state(js, qx)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan_prepare_state ］参数：js = "..tostring(js)..", qx = "..tostring(qx))
    if state.js / (state.js_max * 100 / state.js_pct) < 0.8 then
        if yun_regenerate() < 0 then
            return -1
        end
        var.zuanyan.refresh = false
    end
    if state.qx / (state.qx_max * 100 / state.qx_pct) < qx then
        if yun_recover() < 0 then
            return -1
        end
        var.zuanyan.refresh = false
    end
    return
end

function zuanyan_exec(i)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ zuanyan_exec ］参数：i = "..tostring(i))
    local l = wait_line("zuanyan "..config.zuanyan[i].." "..tostring(var.zuanyan.times),
                        30, nil, 30,
                        "^你现在精神不够，无法进行钻研。$|"..
                        "^你的潜能不够，没有办法再钻研了。$|"..
                        "^你只能参悟本派的武功。$|"..
                        "^你没有根底，无法钻研这门武功。$|"..
                        "^你的\\S+造诣不够，无法领悟更深一层的基本\\S+。$|"..
                        "^你必须有特殊武功方能与基本武技参照钻研！$|"..
                        "^也许是缺乏实战经验，你不能对此项技能进行钻研。$|"..
                        "^你对「\\S+」进行了钻研了\\S+次。$")
    if l == false then
        return -1
    elseif l[0] == "你现在精神不够，无法进行钻研。" then
        if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
            return -1
        end
        if run_hp() < 0 then
            return -1
        end
        var.zuanyan.refresh = false
        _,var.zuanyan.income = dazuo_analysis()
    elseif l[0] == "你只能参悟本派的武功。" or l[0] == "你没有根底，无法钻研这门武功。" then
        if break_event() == true then
            return 1
        end
        return zuanyan_num_i(i+1)
    elseif string.match(l[0], "进行了钻研") then
        automation.idle = false
        if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
            return -1
        end
        if var.job ~= nil and var.job.statistics ~= nil then
            var.job.statistics.pot = var.job.statistics.pot - (var.zuanyan.times)
        end
        var.zuanyan.refresh = true
    else
        if l[0] == "你的潜能不够，没有办法再钻研了。" then
            if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
                return -1
            end
            if run_hp() < 0 then
                return -1
            end
            var.zuanyan.refresh = false
        elseif l[0] == "也许是缺乏实战经验，你不能对此项技能进行钻研。" or 
               l[0] == "你必须有特殊武功方能与基本武技参照钻研！" or 
               string.match(l[0], "造诣不够") then
            if run_skills() < 0 or run_enable() < 0 then
                return -1
            end
        end
        if break_event() == true then
            return 1
        end
        return zuanyan_num_i(i)
    end
    return
end

function xue()
end

function lian(times)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian ］")
    var.lian = var.lian or { times = math.max(30, times or 100) }
    _,var.lian.income = dazuo_analysis()
    return lian_return(lian_num_i(1))
end

function lian_return(rc)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian_return ］参数：rc = "..tostring(rc))
    if var.lian == nil then
        return rc
    end
    if var.lian.refresh == true then
        if run_hp() < 0 then
            return -1
        end
    end
    var.lian = nil
    _ = nil
    return rc
end

function lian_refresh_hp(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian_refresh_hp ］参数：rc = "..tostring(rc))
    if var.lian == nil then
        return rc
    end
    if var.lian.refresh == true then
        if run_hp() < 0 then
            return -1
        end
    end
    return rc
end

function lian_num_i(i, j)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian_num_i ］参数：i = "..tostring(i)..",参数：j = "..tostring(j))
    if config.lian[i] == nil then
        if var.lian.limit == nil then
            var.lian.limit = true
            return lian_num_i(1)
        end
        return 0
    end
    if #config.lian[config.lian[i]] == 0 then
        config.lian[config.lian[i]] = nil
        table.remove(config.lian, i)
        return lian_num_i(i)
    end
    if config.lian[i] == "parry" then
        return lian_num_i(i+1)
    end
    if skills.basic[config.lian[i]] == nil then
        config.lian[config.lian[i]] = nil
        table.remove(config.lian, i)
        return lian_num_i(i)
    end
    local rc = lian_num_ij(i, j or 1)
    if rc ~= nil then
        return rc
    end
    return lian_num_i(i+1)
end

function lian_num_ij(i, j)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian_num_ij ］参数：i = "..tostring(i)..",参数：j = "..tostring(j))
    if config.lian[config.lian[i]][j] == nil then
        return
    end
    if break_event() == true then
        return 1
    end
    if skills.special[config.lian[config.lian[i]][j]] == nil then
        set.remove(config.lian[config.lian[i]], j)
        return lian_num_ij(i, j)
    end
    if skills.special[config.lian[config.lian[i]][j]].level > profile.level then
        return lian_num_ij(i, j+1)
    end
    if skills.special[config.lian[config.lian[i]][j]].level == profile.level then
        if var.lian.limit == nil then
            return lian_num_ij(i, j+1)
        end
    end
    if skills.enable[config.lian[i]].name ~= skills.special[config.lian[config.lian[i]][j]].name then
        local l = wait_line("enable "..config.lian[i].." "..config.lian[config.lian[i]][j],
                            30, nil, 30,
                            "^你从现在起用\\S+作为基本\\S+的特殊技能。$|"..
                            "^这个技能不能当成这种用途。$")
        if l == false then
            return -1
        elseif l[0] == "这个技能不能当成这种用途。" then
            return lian_num_ij(i, j+1)
        end
    end
    repeat
        if break_event() == true then
            return 1
        end
        local rc
        if automation.phase > global.phase["任务"] then
            rc = lian_prepare_state(0.2, 0.5)
            if rc ~= nil then
                return lian_return(rc)
            end
        else
            rc = lian_prepare_state(0.6, 0.8)
            if rc ~= nil then
                return rc
            end
        end
        _,var.lian.income = dazuo_analysis()
        rc = skills_dazuo()
        if rc ~= nil then
            return rc
        end
        if global.flood > config.flood then
            wait(1)
        end
        if break_event() == true then
            return 1
        end
        rc = wield({config.lian.weapon[config.lian[i]] or "", ""})
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return
        end
        rc = lian_exec(i, j)
        if rc ~= nil then
            return rc
        end
    until false
end

function lian_prepare_state(jl, qx)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian_prepare_state ］参数：jl = "..tostring(jl)..",参数：qx = "..tostring(qx))
    if state.jl / state.jl_max  < jl then
        if yun_refresh() < 0  then
            return -1
        end
    end
    if state.qx / (state.qx_max * 100 / state.qx_pct) < qx then
        if yun_recover() < 0  then
            return -1
        end
    end
    return
end

function lian_exec(i, j)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ lian_num_ij ］参数：i = "..tostring(i)..",参数：j = "..tostring(j))
    local l = wait_line("lian "..config.lian[i].." "..tostring(var.lian.times),
                        30, nil, 30,
                        "^你\\S+，开始(?:练|修)习\\S+。$|"..
                        "^这里不是练功的地方。$|"..
                        "^你只能练习用 enable 指定的特殊技能。$|".. 
                        "^(?:修行|练(?:习|))\\S+必须空手(?:挥掌运气方可|静坐|)。$|"..
                        "^你使用的武器不对。$|"..
                        "^你必须先找一\\S+，才能学\\S+$|"..
                        "^你的内力\\S*不够\\S+。$|"..
                        "^你的精力\\S*不(?:能|够)练\\S+。$|"..
                        "^你的精力太低了。$|"..
                        "^你现在手足酸软，休息一下再练吧。$|"..
                        "^你现在正忙着呢。$|"..
                        "^你的\\S+已经练习到顶峰了，必须先打好基础才能继续提高。$|"..
                        "^你的\\S+火候不够，无法练\\S+。$|"..
                        "^你不够坏呀，怎么能练习\\S+呢。$|"..
                        "^你不能通过练习招架来提高这项技能。$|"..
                        "^凌波微步只能通过研读《北冥秘籍》来提高。$|"..
                        "^九阴白骨爪只能向周芷若学习。$|"..
                        "^金花杖法只能在实战中提高。$|"..
                        "^黄沙百战不能自己修练。$|"..
                        "^寒冰绵掌必须通过特殊的法门才能修炼。$|"..
                        "^岳家枪法岂是你这等奸邪之人所能习之！$|"..
                        "^你还是多与别人切磋切磋吧。$|"..
                        "^\\S+，再难更上一层楼。$|"..
                        "^你的内功水平有限，无法领会更高深的\\S+。$|"..
                        "^你的\\S+的熟练度不够。$")
    if l == false then
        return -1
    elseif l[0] == "这里不是练功的地方。" then
        if automation.phase > global.phase["任务"] then
            rc = one_step()
            if rc ~= 0 then
                return rc
            end
            if break_event() == true then
                return 1
            end
            return lian_exec(i, j)
        else
            return 1
        end
    elseif l[0] == "你现在正忙着呢。" then
        if break_event() == true then
            return 1
        end
        wait(0.1)
        return lian_exec(i, j)
    elseif string.match(l[0], "开始.*习") then
        automation.idle = false
        automation.skill = false
        var.lian.refresh = true
        if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
            return -1
        end
        l = wait_line(nil,
                      300, nil, 30,
                      "^你修习完毕，深深吸了一口气，闭目而(?:坐|立)。$|"..
                      "^你硬生生收回招式，不继续练习了。$|"..
                      "^你硬生生将内息压回丹田，不继续修习了。$|"..
                      "^你左手一环，右跨半步，舞出四朵剑花，然后收剑归鞘，极是潇洒。$|"..
                      "^你目前还没有任何为 中断事件 的变量设定。$")
        if l == false then
            return -1
        else
            if l[0] == "你目前还没有任何为 中断事件 的变量设定。" then
                if wait_no_busy("halt") < 0  then
                    return -1
                end
            end
            if run_hp() < 0 then
                return -1
            end
            var.lian.refresh = false
            if not string.match(l[0], "修习完毕") then
                return 1
            end
        end
    elseif string.match(l[0], "你的精力") or 
           string.match(l[0], "你的内力") or 
           string.match(l[0], "手足酸软") then
        if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
            return -1
        end
        if run_hp() < 0 then
            return -1
        end
        var.lian.refresh = false
    elseif l[0] == "凌波微步只能通过研读《北冥秘籍》来提高。" or 
           l[0] == "九阴白骨爪只能向周芷若学习。" or 
           l[0] == "金花杖法只能在实战中提高。" or 
           l[0] == "黄沙百战不能自己修练。" or 
           l[0] == "寒冰绵掌必须通过特殊的法门才能修炼。" or 
           l[0] == "你还是多与别人切磋切磋吧。" or 
           l[0] == "你不能通过练习招架来提高这项技能。" or 
           string.match(l[0], "水平有限") or 
           string.match(l[0], "到顶峰") or 
           string.match(l[0], "火候不够") or 
           string.match(l[0], "再难更上") or 
           string.match(l[0], "不够坏") then
        if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
            return -1
        end
        if break_event() == true then
            return 1
        end
        return lian_num_i(i, j+1)
    else
        if l[0] == "你只能练习用 enable 指定的特殊技能。" then
            if run_skills() < 0 or run_enable() < 0 then
                return -1
            end
            return lian_num_i(i)
        else
            if wait_line(nil, 30, {Gag=true}, 30, "^> $") == false then
                return -1
            end
            if break_event() == true then
                return 1
            end
            if unwield() < 0  then
                return -1
            end
            return lian_exec(i, j)
        end
    end
    return
end