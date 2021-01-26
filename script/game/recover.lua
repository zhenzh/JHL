function yun_regenerate(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_regenerate ］参数：layer = "..tostring(layer))
    if var.yun_regenerate == nil then
        var.yun_regenerate = { layer = 0 }
    else
        if var.yun_regenerate.layer + 1 ~= (layer or 0) then
            return yun_regenerate_return(1, "重复循环")
        end
        var.yun_regenerate.layer = var.yun_regenerate.layer + 1
    end
    local l,rc,msg
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        end
    else
        l = wait_line("yun regenerate", 30, nil, 10, "^你现在精神饱满。$|"..
                                                     "^你深深吸了几口气，精神看起来好多了。$|"..
                                                     "^你的内力不够。$|"..
                                                     "^\\( 你上一个动作还没有完成，不能施用内功。\\)$|"..
                                                     "^你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|"..
                                                     "^这里是武当弟子讲玄清谈之处，不是给你练功的。$")
        if l == false then
            return yun_regenerate_return(-1)
        elseif l[0] == "你深深吸了几口气，精神看起来好多了。" or 
               l[0] == "你现在精神饱满。" then
            if run_hp() < 0 then
                return yun_regenerate_return(-1)
            end
            return yun_regenerate_return(0)
        elseif l[0] == "你的内力不够。" then
            if run_hp() < 0 then
                return yun_regenerate_return(-1)
            end
            rc = dazuo()
            if rc < 0 then
                return yun_regenerate_return(-1)
            elseif rc == 1 then
                rc = wait_recover()
                if rc < 0 then
                    return yun_regenerate_return(-1)
                elseif rc == 1 then
                    rc,msg = feed()
                    if rc ~= 0 then
                        return yun_regenerate_return(rc, msg)
                    end
                else
                    return yun_regenerate_return(0)
                end
            else
                return yun_regenerate((layer or 0)+1)
            end
        elseif l[0] == "( 你上一个动作还没有完成，不能施用内功。)" then
            wait(0.1)
        else
            if wait_line("look", 30, nil, 10, "^\\S+\\s+- ", "^> $") then
                return yun_regenerate_return(-1)
            end
        end
    end
    return yun_regenerate_return(yun_regenerate((layer or 0)+1))
end

function yun_regenerate_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_regenerate_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.yun_regenerate == nil then
        return rc,msg
    end
    var.yun_regenerate = nil
    return rc,msg
end

function yun_recover(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_recover ］参数：layer = "..tostring(layer))
    if var.yun_recover == nil then
        var.yun_recover = { layer = 0 }
    else
        if var.yun_recover.layer + 1 ~= (layer or 0) then
            return yun_recover_return(1, "重复循环")
        end
        var.yun_recover.layer = var.yun_recover.layer + 1
    end
    local l,rc,msg
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        rc,msg = one_step()
        if rc ~= 0 then
            return yun_recover_return(rc, msg)
        end
    else
        l = wait_line("yun recover", 30, nil, 10, "^你现在气力充沛。$|"..
                                                  "^你深深吸了几口气，脸色看起来好多了。$|"..
                                                  "^你的内力不够。$|"..
                                                  "^\\( 你上一个动作还没有完成，不能施用内功。\\)$|"..
                                                  "^你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$|"..
                                                  "^这里是武当弟子讲玄清谈之处，不是给你练功的。$")
        if l == false then
            return yun_recover_return(-1)
        end
        if l[0] == "你深深吸了几口气，脸色看起来好多了。" or 
           l[0] == "你现在气力充沛。" then
            if run_hp() < 0 then
                return yun_recover_return(-1)
            end
            return yun_recover_return(0)
        elseif l[0] == "你的内力不够。" then
            if run_hp() < 0 then
                return yun_recover_return(-1)
            end
            rc = dazuo()
            if rc < 0 then
                return yun_recover_return(-1)
            elseif rc == 1 then
                rc = wait_recover()
                if rc < 0 then
                    return yun_recover_return(-1)
                elseif rc == 1 then
                    rc,msg = feed()
                    if rc ~= 0 then
                        return yun_recover_return(rc, msg)
                    end
                else
                    return yun_recover_return(0)
                end
            else
                return yun_recover((layer or 0)+1)
            end
        end
        if l[0] == "( 你上一个动作还没有完成，不能施用内功。)" then
            wait(0.1)
        else
            if wait_line("look", 30, nil, 10, "^\\S+\\s+- ", "^> $") then
                return yun_recover_return(-1)
            end
        end
    end
    return yun_recover_return(yun_recover((layer or 0)+1))
end

function yun_recover_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_recover_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.yun_recover == nil then
        return rc,msg
    end
    var.yun_recover = nil
    return rc,msg
end

function yun_refresh(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_refresh ］参数：layer = "..tostring(layer))
    if var.yun_refresh == nil then
        var.yun_refresh = { layer = 0 }
    else
        if var.yun_refresh.layer + 1 ~= (layer or 0) then
            return yun_refresh_return(1, "重复循环")
        end
        var.yun_refresh.layer = var.yun_refresh.layer + 1
    end
    local l,rc,msg
    if env.current.name == "擂台下" then
        rc,msg = one_step()
        if rc ~= 0 then
            return yun_refresh_return(rc, msg)
        end
    else
        l = wait_line("yun refresh", 30, nil, 10, "^你现在精力充沛。$|"..
                                                  "^你伸了伸腰，长长地吸了口气。$|"..
                                                  "^你的内力不够。$|"..
                                                  "^\\( 你上一个动作还没有完成，不能施用内功。\\)$|"..
                                                  "^你正要有所动作，突然身旁有人将你一拍：好好看比武，别乱动！$")
        if l == false then
            return yun_refresh_return(-1)
        end
        if l[0] == "你伸了伸腰，长长地吸了口气。" or 
           l[0] == "你现在精力充沛。" then
            if run_hp() < 0 then
                return yun_refresh_return(-1)
            end
            return yun_refresh_return(0)
        elseif l[0] == "你的内力不够。" then
            if run_hp() < 0 then
                return yun_refresh_return(-1)
            end
            rc = dazuo()
            if rc < 0 then
                return yun_refresh_return(-1)
            elseif rc == 1 then
                rc = wait_recover()
                if rc < 0 then
                    return yun_refresh_return(-1)
                elseif rc == 1 then
                    rc,msg = feed()
                    if rc ~= 0 then
                        return yun_refresh_return(rc, msg)
                    end
                else
                    return yun_refresh_return(0)
                end
            else
                return yun_refresh((layer or 0)+1)
            end
        end
        if l[0] == "( 你上一个动作还没有完成，不能施用内功。)" then
            wait(0.1)
        else
            if wait_line("look", 30, nil, 10, "^\\S+\\s+- ", "^> $") then
                return yun_refresh_return(-1)
            end
        end
    end
    return yun_refresh_return(yun_refresh((layer or 0)+1))
end

function yun_refresh_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_refresh_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.yun_refresh == nil then
        return rc,msg
    end
    var.yun_refresh = nil
    return rc,msg
end

function wait_recover()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wait_recover ］参数：")
    var.wait_recover = var.wait_recover or { layer = 0 }
    if state.food * state.drink == 0 then
        return wait_recover_return(1,"缺少饮食")
    end
    wait(0.1)
    if run_hp() < 0 then
        return wait_recover_return(-1)
    end
    var.wait_recover.js = state.js
    var.wait_recover.jl = state.jl
    var.wait_recover.qx = state.qx
    var.wait_recover.nl = state.nl
    if state.js > var.wait_recover.js then
        return wait_recover_return(0)
    end
    if state.jl > var.wait_recover.jl then
        return wait_recover_return(0)
    end
    if state.qx > var.wait_recover.qx then
        return wait_recover_return(0)
    end
    if state.nl > var.wait_recover.nl then
        return wait_recover_return(0)
    end
    if state.js >= state.js_max and 
       state.jl >= state.jl_max and 
       state.qx >= state.qx_max and 
       state.nl >= state.nl_max then
        return wait_recover_return(0)
    end
    return wait_recover_return(wait_recover())
end

function wait_recover_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wait_recover_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.wait_recover == nil then
        return rc,msg
    end
    var.wait_recover = nil
    return rc,msg
end

function yun_bidu(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_bidu ］参数：layer = "..tostring(layer))
    if var.yun_bidu == nil then
        var.yun_bidu = { layer = 0, base = 50 }
    else
        if var.yun_bidu.layer + 1 ~= (layer or 0) then
            return yun_bidu_return(1, "重复循环")
        end
        var.yun_bidu.layer = var.yun_bidu.layer + 1
    end
    if var.fight ~= nil then
        return yun_bidu_return(1, "治疗失败")
    end
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        local rc,msg = one_step()
        if rc ~= 0 then
            return yun_bidu_return(rc,msg)
        end
        return yun_bidu_return(yun_bidu((layer or 0)+1))
    end
    return yun_bidu_return(yun_bidu_exec())
end

function yun_bidu_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_bidu_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.yun_bidu == nil then
        return rc,msg
    end
    var.yun_bidu = nil
    return rc,msg
end

function yun_bidu_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_bidu_exec ］")
    if state.nl < var.yun_bidu.base then
        local rc,msg = dazuo()
        if rc ~= 0 then
            return rc,msg
        end
        return yun_bidu_exec()
    end
    local l = wait_line("yun bidu", 300, {StopEval=true}, 10, "^你闭目而坐，急呼缓吸，过了一顿饭工夫，脸色略复红润。$|"..
                                                              "^你并未中毒。$|"..
                                                              "^你无法在战斗中运功疗毒。$|"..
                                                              "^你现在正忙着呢。$|"..
                                                              "^\\( 你上一个动作还没有完成，不能施用内功。\\)$|"..
                                                              "^你目前还没有任何为 中断事件 的变量设定。$|"..
                                                              "^你现在的内力不足以运使内功逼出身上毒质。$")
    if l == false then
        return -1
    elseif l[0] == "你并未中毒。" then
        return 0
    elseif l[0] == "你无法在战斗中运功疗毒。" then
        if break_event() == true then
            return 1,"中断事件"
        end
        if wait_no_fight() < 0 then
            return -1
        end
        if break_event() == true then
            return 1,"中断事件"
        end
    elseif l[0] == "你现在正忙着呢。" or 
           l[0] == "( 你上一个动作还没有完成，不能施用内功。)" then
        local rc = wait_no_busy("halt")
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return 1,"中断事件"
        end
    elseif l[0] == "你现在的内力不足以运使内功逼出身上毒质。" then
        var.yun_bidu.base = math.max(50, state.nl)
    elseif l[0] == "你目前还没有任何为 中断事件 的变量设定。" then
        return 1,"中断事件"
    end
    return yun_bidu_exec()
end

function yun_forceheal(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_forceheal ］参数：layer = "..tostring(layer))
    if var.yun_forceheal == nil then
        var.yun_forceheal = { layer = 0 }
    else
        if var.yun_forceheal.layer + 1 ~= (layer or 0) then
            return yun_forceheal_return(1, "重复循环")
        end
        var.yun_forceheal.layer = var.yun_forceheal.layer + 1
    end
    if var.fight ~= nil then
        return yun_forceheal_return(1, "治疗失败")
    end
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        local rc,msg = one_step()
        if rc ~= 0 then
            return yun_forceheal_return(rc,msg)
        end
        return yun_forceheal_return(yun_forceheal((layer or 0)+1))
    end
    return yun_forceheal_return(yun_forceheal_exec())
end

function yun_forceheal_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_forceheal_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.yun_forceheal == nil then
        return rc,msg
    end
    var.yun_forceheal = nil
    return rc,msg
end

function yun_forceheal_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_forceheal_exec ］")
    local rc,msg
    if state.qx_pct < 50 then
        rc,msg = heal_recover(50)
        if rc ~= 0 then
            return rc,msg
        end
    end
    if state.js_pct < 70 then
        rc,msg = heal_regenerate(70)
        if rc ~= 0 then
            return rc,msg
        end
    end
    if state.js / (state.js_max * 100 / state.js_pct) < 0.7 then
        if state.nl >= 20 then
            rc = yun_regenerate()
            if rc ~= 0 then
                return rc
            end
            return yun_forceheal_exec()
        end
        rc = wait_recover()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            rc,msg = feed()
            if rc ~= 0 then
                return rc,msg
            end
        end
        return yun_forceheal_exec()
    end
    if state.nl < 50 then
        rc,msg = dazuo()
        if rc ~= 0 then
            return rc,msg
        end
        return yun_forceheal_exec()
    end
    local l = wait_line("yun forceheal", 300, {StopEval=true}, 10, "^你没有内伤。$|"..
                                                                   "^你无法在战斗中运功疗伤。$|"..
                                                                   "^你现在正忙着呢。|"..
                                                                   "^\\( 你上一个动作还没有完成，不能施用内功。\\)$|"..
                                                                   "^在坐骑上运功疗伤，会走火入魔。$|"..
                                                                   "^你必须先用 enable 选择你要用的内功心法。$|"..
                                                                   "^你对内功的认识还不够，不知如何搬运内息疗伤。$|"..
                                                                   "^你已经受伤过重，只怕一运真气便有生命危险！$|"..
                                                                   "^你体内\\S+胶固於经络百脉之中，凭你的\\S+修为化解十分困难。$|"..
                                                                   "^你现在精不够，无法控制内息的流动！$|"..
                                                                   "^你现在的内力太少不足以治疗内伤。$|"..
                                                                   "^你\\S+，自觉经脉顺畅，内伤尽去，\\S+。$|"..
                                                                   "^你只觉\\S+，将真气还合丹田，站起身来。$|"..
                                                                   "^你\\S+疗伤\\S+运转无碍，\\S+。$|"..
                                                                   "^过了片刻，你感觉自己已经将玄天无极神功气聚丹田，深吸口气站了起来。$|"..
                                                                   "^你暗自提了三次气，自觉内息顺畅，於是在南方丙火乾位停下了脚步。$|"..
                                                                   "^你依法盘旋得数下，真气便如是细流归支流、支流汇大川，内息畅通无碍。$|"..
                                                                   "^你将寒冰真气按周天之势搬运了一周，感觉精神充沛多了。|$"..
                                                                   "^过了一会，雾气消去，你看起来脸色好多了。$|"..
                                                                   "^你慢慢收气，归入丹田，睁开眼睛，轻轻的吐了一口气。$|"..
                                                                   "^你正\\S+，祗得\\S+。$|"..
                                                                   "^你渐感真气\\S+，不得不将在体内搬运的内息收回。$|"..
                                                                   "^你闭目运气，忽觉内力不继，哇哇两声，喷出几口鲜血，站了起来。$|"..
                                                                   "^你双眼一睁，极速压下内息站了起来。$|"..
                                                                   "^过了一会，你头晕脑涨，热血上涌，骤觉这伤势，非浅薄的琴音所能调理。$|"..
                                                                   "^你渐感真气不纯，后劲不继，内息一转，迅速收气，停止了内息的运转。$|"..
                                                                   "^你目前还没有任何为 中断事件 的变量设定。$|"..
                                                                   "^忽然你一阵头晕目眩，你所中的\\S+发作了！$")
    if l == false then
        return -1
    elseif l[0] == "你没有内伤。" then
        return 0
    elseif l[0] == "你无法在战斗中运功疗伤。" then
        if break_event() == true then
            return 1,"中断事件"
        end
        if wait_no_fight() < 0 then
            return rc,"中断事件"
        end
        if break_event() == true then
            return 1,"中断事件"
        end
    elseif l[0] == "你现在正忙着呢。" or 
           l[0] == "( 你上一个动作还没有完成，不能施用内功。)" then
        rc = wait_no_busy("halt")
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return 1,"中断事件"
        end
    elseif l[0] == "你目前还没有任何为 中断事件 的变量设定。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return 1,"中断事件"
    elseif l[0] == "你现在的内力太少不足以治疗内伤。" then
        rc,msg = dazuo()
        if rc ~= 0 then
            return rc,msg
        end
    elseif l[0] == "在坐骑上运功疗伤，会走火入魔。" or 
           l[0] == "你必须先用 enable 选择你要用的内功心法。" or 
           l[0] == "你对内功的认识还不够，不知如何搬运内息疗伤。" or 
           string.match(l[0], "化解十分困难") then
        return 1,"治疗失败"
    else
        if run_hp() < 0 then
            return -1
        end
    end
    return yun_forceheal_exec()
end

function yun_heal(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_heal ］参数：layer = "..tostring(layer))
    if var.yun_heal == nil then
        var.yun_heal = { layer = 0 }
    else
        if var.yun_heal.layer + 1 ~= (layer or 0) then
            return yun_heal_return(1, "重复循环")
        end
        var.yun_heal.layer = var.yun_heal.layer + 1
    end
    if var.fight ~= nil then
        return yun_heal_return(1, "治疗失败")
    end
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        local rc,msg = one_step()
        if rc ~= 0 then
            return yun_heal_return(rc,msg)
        end
        return yun_heal_return(yun_heal((layer or 0)+1))
    end
    return yun_heal_return(yun_heal_exec())
end

function yun_heal_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_heal_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.yun_heal == nil then
        return rc,msg
    end
    var.yun_heal = nil
    return rc,msg
end

function yun_heal_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yun_heal_exec ］")
    local rc,msg
    if state.qx_pct < 50 then
        return 1,"治疗失败"
    end
    if state.qx_pct >= 100 then
        return 0
    end
    if state.js_pct < 70 then
        rc,msg = heal_regenerate(70)
        if rc ~= 0 then
            return rc,msg
        end
    end
    if state.js / (state.js_max * 100 / state.js_pct) < 0.7 then
        if state.nl >= 20 then
            rc = yun_regenerate()
            if rc ~= 0 then
                return rc
            end
            return yun_heal_exec()
        end
        rc = wait_recover()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            rc,msg = feed()
            if rc ~= 0 then
                return rc,msg
            end
        end
        return yun_heal_exec()
    end
    if state.nl < 50 then
        rc,msg = dazuo()
        if rc ~= 0 then
            return rc,msg
        end
        return yun_heal_exec()
    end
    l = wait_line("yun heal", 300, {StopEval=true}, 10, "^你并未受到内伤。$|"..
                                                        "^战斗中运功疗伤？找死吗？$|"..
                                                        "^你现在正忙着呢。$|"..
                                                        "^\\( 你上一个动作还没有完成，不能施用内功。\\)$|"..
                                                        "^在坐骑上运功疗伤，会走火入魔。$|"..
                                                        "^你必须先用 enable 选择你要用的内功心法。$|"..
                                                        "^你对内功的认识还不够，不知如何搬运内息疗伤。$|"..
                                                        "^你的内力修为太低，尚无法搬运内息疗伤。$|"..
                                                        "^你已经受伤过重，只怕一运真气便有生命危险！$|"..
                                                        "^你现在精不够，无法控制内息的流动！$|"..
                                                        "^你体内的真气不够。$|"..
                                                        "^你\\S+，自觉经脉顺畅，内伤尽去，\\S+。$|"..
                                                        "^你只觉\\S+，将真气还合丹田，站起身来。$|"..
                                                        "^你\\S+疗伤\\S+运转无碍，\\S+。$|"..
                                                        "^过了片刻，你感觉自己已经将玄天无极神功气聚丹田，深吸口气站了起来。$|"..
                                                        "^你暗自提了三次气，自觉内息顺畅，於是在南方丙火乾位停下了脚步。$|"..
                                                        "^你依法盘旋得数下，真气便如是细流归支流、支流汇大川，内息畅通无碍。$|"..
                                                        "^你将寒冰真气按周天之势搬运了一周，感觉精神充沛多了。|$"..
                                                        "^过了一会，雾气消去，你看起来脸色好多了。$|"..
                                                        "^你慢慢收气，归入丹田，睁开眼睛，轻轻的吐了一口气。$|"..
                                                        "^你正\\S+，祗得\\S+。$|"..
                                                        "^你渐感真气\\S+，不得不将在体内搬运的内息收回。$|"..
                                                        "^你闭目运气，忽觉内力不继，哇哇两声，喷出几口鲜血，站了起来。$|"..
                                                        "^你双眼一睁，极速压下内息站了起来。$|"..
                                                        "^过了一会，你头晕脑涨，热血上涌，骤觉这伤势，非浅薄的琴音所能调理。$|"..
                                                        "^你渐感真气不纯，后劲不继，内息一转，迅速收气，停止了内息的运转。$|"..
                                                        "^你目前还没有任何为 中断事件 的变量设定。$|"..
                                                        "^忽然你一阵头晕目眩，你所中的\\S+发作了！$")
    if l == false then
        return -1
    elseif l[0] == "战斗中运功疗伤？找死吗？" then
        if break_event() == true then
            return 1,"中断事件"
        end
        if wait_no_fight() < 0 then
            return rc,"中断事件"
        end
        if break_event() == true then
            return 1,"中断事件"
        end
    elseif l[0] == "你现在正忙着呢。" or 
           l[0] == "( 你上一个动作还没有完成，不能施用内功。)" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
    elseif l[0] == "你目前还没有任何为 中断事件 的变量设定。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return 1
    elseif l[0] == "在坐骑上运功疗伤，会走火入魔。" or 
           l[0] == "你必须先用 enable 选择你要用的内功心法。" or 
           l[0] == "你对内功的认识还不够，不知如何搬运内息疗伤。" or 
           l[0] == "你的内力修为太低，尚无法搬运内息疗伤。" then
        return 1,"治疗失败"
    else
        if run_hp() < 0 then
            return -1
        end
    end
    return yun_heal_exec()
end

function take_drugs(drugs, layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ take_drugs ］参数：drugs = "..table.tostring(drugs)..", layer = "..tostring(layer))
    if var.take_drugs == nil then
        var.take_drugs = { layer = 0 }
    else
        if var.take_drugs.layer + 1 ~= (layer or 0) then
            return take_drugs_return(1, "重复循环")
        end
        var.take_drugs.layer = var.take_drugs.layer + 1
    end
    for _,v in ipairs(drugs) do
        local rc = take_drugs_exec(v)
        if (rc or 1) <= 0 then
            return take_drugs_return(rc)
        end
    end
    return take_drugs_return(1, "治疗失败")
end

function take_drugs_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ take_drugs_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.take_drugs == nil then
        return rc,msg
    end
    var.take_drugs = nil
    return rc,msg
end

function take_drugs_exec(drug)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ take_drugs_exec ］参数：drug = "..tostring(drug))
    local msg = is_own(drug)
    local rc
    if msg == true then
        rc = take(items[drug].id)
        if rc ~= 1 then
            if run_hp() < 0 then
                return -1
            end
            return rc
        end
    elseif msg == false then
        if var.move == nil then
            rc = aquire({[drug] = 1})
            if rc < 0 then
                return -1
            elseif rc == 0 then
                return take_drugs_exec(drug)
            end
        end
        return
    end
    if env.current.name == "擂台下" then
        rc = one_step()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            return
        end
    end
    local l = wait_line("get "..string.split(drug, ":")[2].." from "..msg, 30, nil, 10, "^你从\\S+中拿出\\S+。$|"..
                                                                                        "^你找不到 \\S+ 这样东西。$|"..
                                                                                        "^你附近没有这样东西。$|"..
                                                                                        "^那里面没有任何东西。$")
    if l == false then
        return -1
    elseif not string.match(l[0], "中拿出") then
        carryon.inventory[drug] = table.copy(carryon.container[msg][drug])
        carryon.inventory[drug].count = 1
        carryon.inventory[drug].seq = { "1" }
        carryon.container[msg][drug].count = carryon.container[msg][drug].count - 1
        if carryon.container[msg][drug].count == 0 then
            carryon.container[msg][drug] = nil
        end
    else
        if run_i() < 0 then
            return -1
        end
    end
    return take_drugs_exec(drug)
end

function ask_ping()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ask_ping ］")
    if var.ask_ping == nil then
        var.ask_ping = { layer = 0 }
    else
        if var.ask_ping.layer + 1 > 0 then
            return ask_ping_return(1, "重复循环")
        end
        var.ask_ping.layer = var.ask_ping.layer + 1
    end
    if state.buff.ask_ping == false then
        return ask_ping_return(1, "治疗失败")
    end
    if profile.family ~= "日月神教" and 
       profile.balance + carryon.money < 100000 then
        return ask_ping_return(1, "治疗失败")
    end
    if var.move == false then
        return ask_ping_return(1, "治疗失败")
    end
    local rc = goto(1024)
    if rc ~= 0 then
        return ask_ping_return(1, "治疗失败")
    end
    if wait_line("ask ping yizhi about 疗伤", 30, nil, 10, "^你向平一指打听有关「疗伤」的消息。$")  == false then
        return ask_ping_return(-1)
    end
    local l = wait_line(nil, 30, nil, 10, "^你吃下大力丸之后，顿时感觉百病全消。$|"..
                                          "^平一指说道：上次你吃的药药性未过，不能重复吃药。$|"..
                                          "^平一指说道：你付不起老夫的诊金。$")
    if l == false then
        return ask_ping_return(-1)
    elseif l[0] == "你吃下大力丸之后，顿时感觉百病全消。" then
        if run_hp() < 0 then
            return ask_ping_return(-1)
        else
            return ask_ping_return(0)
        end
    else
        return ask_ping_return(1, "治疗失败")
    end
end

function ask_ping_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ask_ping_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.ask_ping == nil then
        return rc,msg
    end
    var.ask_ping = nil
    return rc,msg
end

function force_recover()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ force_recover ］")
    if var.force_recover == nil then
        var.force_recover = { layer = 0 }
    else
        if var.force_recover.layer + 1 > 0 then
            return force_recover_return(1, "重复循环")
        end
        var.force_recover.layer = var.force_recover.layer + 1
    end
    if state.qx_pct >= 100 then
        return force_recover_return(0)
    end
    local rc,msg
    if skills.enable.force.name == "临济十二庄" and 
       skills.special["linji-zhuang"].level >= 150 then
        rc,msg = linjizhuang_yun_daxiao()
        if rc <= 0 then
            return force_recover_return(rc, msg)
        end
    end
    if skills.enable.force.name == "毒龙大法" and 
       skills.special["dulong-dafa"].level >= 30 then
        rc,msg = dulong_yun_powerup()
        if rc <= 0 then
            return force_recover_return(rc, msg)
        end
    end
    if skills.enable.force.name == "玄天无极" and 
       skills.special["xuantian-wuji"].level >= 600 then
        rc,msg = wuji_yun_wuji()
        if rc <= 0 then
            return force_recover_return(rc, msg)
        end
    end
    return force_recover_return(1, "治疗失败")
end

function force_recover_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ force_recover_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.force_recover == nil then
        return rc,msg
    end
    var.force_recover = nil
    return rc,msg
end

function force_regenerate()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ force_regenerate ］")
    if var.force_regenerate == nil then
        var.force_regenerate = { layer = 0 }
    else
        if var.force_regenerate.layer + 1 > 0 then
            return force_regenerate_return(1, "重复循环")
        end
        var.force_regenerate.layer = var.force_regenerate.layer + 1
    end
    if state.js_pct >= 100 then
        return force_regenerate_return(0)
    end
    local rc,msg
    if skills.enable.force.name == "临济十二庄" and 
       skills.special["linji-zhuang"].level >= 150 then
        rc,msg = linjizhuang_yun_daxiao()
        if rc <= 0 then
            return force_recover_return(rc, msg)
        end
    end
    if skills.enable.force.name == "毒龙大法" and 
       skills.special["dulong-dafa"].level >= 50 then
        rc,msg = dulong_yun_cure()
        if rc <= 0 then
            return dulong_yun_cure(rc, msg)
        end
    end
    return force_regenerate_return(1, "治疗失败")
end

function force_regenerate_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ force_regenerate_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.force_regenerate == nil then
        return rc,msg
    end
    var.force_regenerate = nil
    return rc,msg
end

function linjizhuang_yun_daxiao()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ linjizhuang_yun_daxiao ］")
    if state.buff["linji-zhuang_daxiao"] ~= nil then
        return 1,"治疗失败"
    end
    if state.qx_pct < 50 then
        return 1,"治疗失败"
    end
    local rc,msg
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        end
        return linjizhuang_yun_daxiao()
    end
    if state.nl < 2000 then
        if state.qx_pct < 70 then
            rc = wait_recover()
            if rc < 0 then
                return -1
            elseif rc == 1 then
                rc,msg = feed()
                if rc ~= 0 then
                    return rc,msg
                end
            end
            return linjizhuang_yun_daxiao()
        end
        rc,msg = dazuo(2000)
        if rc ~= 0 then
            return rc,msg
        end
        return linjizhuang_yun_daxiao()
    end
    local l = wait_line("yun daxiao", 30, nil, 10, "^你屏息静气，交错运行大小二庄，只觉一股暖流出天门，穿地户，沿着全身经脉运行一周，汇入丹田气海。$|"..
                                                   "^你已经运功调节精气大小了。$|"..
                                                   "^你的内力不够。$|"..
                                                   "^你已经受伤过重，只怕一运真气便有生命危险！$")
    if l == false then
        return -1
    elseif l[0] == "你已经运功调节精气大小了。" then
        return 1,"治疗失败"
    else
        if run_hp() < 0 then
            return -1
        end
    end
    if l[0] == "你屏息静气，交错运行大小二庄，只觉一股暖流出天门，穿地户，沿着全身经脉运行一周，汇入丹田气海。" then
        return 0
    else
        return linjizhuang_yun_daxiao()
    end
end

function dulong_yun_powerup()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dulong_yun_powerup ］")
    if profile.family ~= "神龙教" then 
        return 1,"治疗失败"
    end
    if state.buff["dulong-dafa_powerup"] ~= nil then
        return 1,"治疗失败"
    end
    if state.qx_pct < 50 then
        return 1,"治疗失败"
    end
    local rc,msg
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        end
        return dulong_yun_powerup()
    end
    if state.nl < 300 then
        if state.qx_pct < 70 then
            rc = wait_recover()
            if rc < 0 then
                return -1
            elseif rc == 1 then
                rc,msg = feed()
                if rc ~= 0 then
                    return rc,msg
                end
            end
            return dulong_yun_powerup()
        end
        rc,msg = dazuo(300)
        if rc ~= 0 then
            return rc,msg
        end
        return dulong_yun_powerup()
    end
    local l = wait_line("yun powerup", 30, nil, 10, "^只见你高声叫道：“洪教主万年不老，永享仙福，寿与天齐！”$|"..
                                                    "^你已经在运功中了。$|"..
                                                    "^你的内力不够。$|"..
                                                    "^你已经受伤过重，只怕一运真气便有生命危险！$")
    if l == false then
        return -1
    elseif l[0] == "你已经在运功中了。" then
        return 1,"治疗失败"
    else
        if run_hp() < 0 then
            return -1
        end
    end
    if l[0] == "只见你高声叫道：“洪教主万年不老，永享仙福，寿与天齐！”" then
        return 0
    else
        return dulong_yun_powerup()
    end
end

function dulong_yun_cure()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dulong_yun_cure ］")
    if state.qx_pct < 50 then
        return 1,"治疗失败"
    end
    local rc,msg
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        end
        return dulong_yun_cure()
    end
    if state.nl < 300 then
        if state.qx_pct < 70 then
            rc = wait_recover()
            if rc < 0 then
                return -1
            elseif rc == 1 then
                rc,msg = feed()
                if rc ~= 0 then
                    return rc,msg
                end
            end
            return dulong_yun_cure()
        end
        rc,msg = dazuo(300)
        if rc ~= 0 then
            return rc,msg
        end
        return dulong_yun_cure()
    end
    l = wait_line("yun cure", 30, nil, 10, "^你默念神龙口诀，将手指划破，开始凝神疗精。$|"..
                                           "^你现在不须要疗精！$|"..
                                           "^你的内力不够。$")
    if l == false then
        return -1
    elseif l[0] == "你已经在运功中了。" then
        return 1,"治疗失败"
    else
        if run_hp() < 0 then
            return -1
        end
    end
    if l[0] == "只见你高声叫道：“洪教主万年不老，永享仙福，寿与天齐！”" then
        return 0
    else
        return dulong_yun_cure()
    end
end

function wuji_yun_wuji()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wuji_yun_wuji ］")
    if state.buff["xuantian-wuji_wuji"] ~= nil then
        return 1,"治疗失败"
    end
    local rc,msg
    if env.current.name == "擂台下" or 
       env.current.name == "讲玄室" then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        end
        return wuji_yun_wuji()
    end
    if state.nl < 3500 then
        if state.qx_pct < 70 then
            rc = wait_recover()
            if rc < 0 then
                return -1
            elseif rc == 1 then
                rc,msg = feed()
                if rc ~= 0 then
                    return rc,msg
                end
            end
            return wuji_yun_wuji()
        end
        rc,msg = dazuo(3500)
        if rc ~= 0 then
            return rc,msg
        end
        return wuji_yun_wuji()
    end
    l = wait_line("yun wuji", 30, nil, 10, "^你将玄天无极功第\\S+层功力充塞全身。$|"..
                                           "^你已经在运功中了。$|"..
                                           "^你的内力不足。$")
    if l == false then
        return -1
    elseif l[0] == "你已经在运功中了。" then
        return 1,"治疗失败"
    else
        if run_hp() < 0 then
            return -1
        end
    end
    if string.match(l[0], "充塞全身") then
        return 0
    else
        return wuji_yun_wuji()
    end
end

function heal_regenerate(pct, layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ heal_regenerate ］参数：pct = "..tostring(pct)..", layer = "..tostring(layer))
    if var.heal_regenerate == nil then
        var.heal_regenerate = { layer = 0 }
    else
        if var.heal_regenerate.layer + 1 ~= (layer or 0) then
            return heal_regenerate_return(1, "重复循环")
        end
        var.heal_regenerate.layer = var.heal_regenerate.layer + 1
    end
    if state.js_pct >= (pct or 100) then
        return heal_regenerate_return(0)
    end
    local rc = force_regenerate()
    if rc < 0 then
        return heal_regenerate_return(-1)
    elseif rc == 0 then
        return heal_regenerate_return(heal_regenerate(pct, (layer or 0) + 1))
    end
    rc = take_drugs(drugs.js)
    if rc < 0 then
        return heal_regenerate_return(-1)
    elseif rc == 0 then
        return heal_regenerate_return(heal_regenerate(pct, (layer or 0) + 1))
    end
    rc = ask_ping()
    if rc < 0 then
        return heal_regenerate_return(-1)
    elseif rc == 0 then
        return heal_regenerate_return(0)
    end
    return heal_regenerate_return(1, "治疗失败")
end

function heal_regenerate_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ heal_regenerate_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.heal_regenerate == nil then
        return rc,msg
    end
    var.heal_regenerate = nil
    return rc,msg
end

function heal_recover(pct, layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ heal_recover ］参数：pct = "..tostring(pct)..", layer = "..tostring(layer))
    if var.heal_recover == nil then
        var.heal_recover = { layer = 0 }
    else
        if var.heal_recover.layer + 1 ~= (layer or 0) then
            return heal_recover_return(1, "重复循环")
        end
        var.heal_recover.layer = var.heal_recover.layer + 1
    end
    if state.qx_pct >= (pct or 100) then
        return heal_recover_return(0)
    end
    local rc,msg
    if state.qx_pct < 80 then
        rc = force_recover()
        if rc < 0 then
            return heal_recover_return(-1)
        elseif rc == 0 then
            return heal_recover_return(heal_recover(pct, (layer or 0) + 1))
        end
        rc = take_drugs(drugs.qx)
        if rc < 0 then
            return heal_recover_return(-1)
        elseif rc == 0 then
            return heal_recover_return(heal_recover(pct, (layer or 0) + 1))
        end
        rc = ask_ping()
        if rc < 0 then
            return heal_recover_return(-1)
        elseif rc == 0 then
            return heal_recover_return(0)
        end
        return heal_recover_return(yun_heal())
    end
    rc = force_recover()
    if rc < 0 then
        return heal_recover_return(-1)
    elseif rc == 0 then
        return heal_recover_return(heal_recover(pct, (layer or 0) + 1))
    end
    rc = yun_heal(pct)
    if rc <= 0 then
        return heal_recover_return(rc)
    end
    rc = take_drugs(drugs.qx)
    if rc < 0 then
        return heal_recover_return(-1)
    elseif rc == 0 then
        return heal_recover_return(heal_recover(pct, (layer or 0) + 1))
    end
    return heal_recover_return(ask_ping())
end

function heal_recover_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ heal_recover_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.heal_recover == nil then
        return rc,msg
    end
    var.heal_recover = nil
    return rc,msg
end

local dazuo_forbiden = {
    "客店二楼", "擂台下", "存物室", "武庙", "神仙会客厅", "交流厅", "鲜花店", "驿站",
    "当铺", "潜能存储室", "兵器坊", "矿坑", "讲玄室",
}

function dazuo(target, mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dazuo ］")
    if var.dazuo == nil then
        var.dazuo = { layer = 0, mode = mode }
    else
        if var.dazuo.layer + 1 > 0 then
            return dazuo_return(1, "重复循环")
        end
        var.dazuo.layer = var.dazuo.layer + 1
    end
    if var.fight ~= nil then
        return dazuo_return(1)
    end
    if tostring(target) == "double" then
        target = state.nl_max * 2 - 1
    end
    var.dazuo.param = { dazuo_analysis(target, mode) }
    return dazuo_return(dazuo_exec(target))
end

function dazuo_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dazuo_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.dazuo == nil then
        return rc,msg
    end
    var.dazuo = nil
    return rc,msg
end

function dazuo_exec(target)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dazuo_exec ］参数：target = "..tostring(target))
    if var.dazuo.param[1] == 0 then
        return 0
    end
    if carryon.inventory["炼心石:lianxin shi"] == nil then
        var.dazuo.param[2] = var.dazuo.param[3] + 1
    else
        var.dazuo.param[2] = (var.dazuo.param[3] + 1) * 2
    end
    if target == nil then
        target = math.min(state.nl + var.dazuo.param[2], state.nl_max * 2 - 1)
    end
    if state.nl > target - var.dazuo.param[2] then
        if var.dazuo.mode ~= "normal" then
            return 0
        end
        if state.nl + var.dazuo.param[2] >= state.nl_max * 2 then
            return 0
        end
    end
    local rc,msg
    if set.has(dazuo_forbiden, env.current.name) then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        else
            return dazuo_exec(target)
        end
    end
    if state.js_pct < 70 then
        rc,msg = heal_regenerate(70)
        if rc ~= 0 then
            return rc,msg
        end
        return dazuo_exec(target)
    end
    if state.js / (state.js_max * 100 / state.js_pct) < 0.7 then
        if state.nl >= 20 then
            rc = yun_regenerate()
            if rc < 0 then
                return -1
            end
            if rc == 0 then
                return dazuo_exec(target)
            end
        end
        rc = wait_recover()
        if rc < 0 then
            return -1
        elseif rc == 1 then
            rc,msg = feed()
            if rc ~= 0 then
                return rc,msg
            end
        end
        return dazuo_exec(target)
    end
    if var.dazuo.param[1] < var.dazuo.param[3] then
        if state.nl >= 20 then
            rc,msg = yun_recover()
            if rc ~= 0 then
                return rc,msg
            end
        elseif var.dazuo.param[1] == 0 then
            rc = wait_recover()
            if rc < 0 then
                return -1
            elseif rc == 1 then
                rc,msg = feed()
                if rc ~= 0 then
                    return rc,msg
                end
            end
        end
        var.dazuo.param = { dazuo_analysis(target, var.dazuo.mode) }
        return dazuo_exec(target)
    end
    local l = wait_line("dazuo "..tostring(var.dazuo.param[1]), 300, nil, 10, "^你运功完毕，深深吸了口气，站了起来。$|"..
                                                                              "^你现在正忙着呢。$|"..
                                                                              "^你现在的气太少了，无法产生内息运行全身经脉。$|"..
                                                                              "^你现在精不够，无法控制内息的流动！$|"..
                                                                              "^这里空气不好，不能打坐。$|"..
                                                                              "^战斗中不能练内功，会走火入魔。$|"..
                                                                              "^你一声长啸，脚下踩著奇门步法，趋前抢后，尤如天神行法，鬼魅遁影，瞬间只见数十个身影飞射而出，游走不定！$|"..
                                                                              "^你目前还没有任何为 中断事件 的变量设定。$|"..
                                                                              "^练内功要有间隙，太劳累会走火入魔的。$")
    if l == false then
        return -1
    end
    automation.idle = false
    if l[0] == "你运功完毕，深深吸了口气，站了起来。" then
        if run_hp() < 0 then
            return -1
        end
        if state.qx <= var.dazuo.param[3] then
            if yun_recover() < 0 then
                return -1
            end
        end
    elseif l[0] == "你现在正忙着呢。" or 
           l[0] == "练内功要有间隙，太劳累会走火入魔的。" then
        if break_event() == true then
            return 1
        end
        wait(0.1)
        return dazuo_exec(target)
    elseif l[0] == "战斗中不能练内功，会走火入魔。" or 
           l[0] == "你一声长啸，脚下踩著奇门步法，趋前抢后，尤如天神行法，鬼魅遁影，瞬间只见数十个身影飞射而出，游走不定！" then
        if break_event() == true then
            return 1
        end
        if wait_no_fight() < 0 then
            return -1
        end
        if run_hp() < 0 then
            return -1
        end
    elseif l[0] == "这里空气不好，不能打坐。" then
        rc,msg = one_step()
        if rc ~= 0 then
            return rc,msg
        end
    elseif l[0] == "你目前还没有任何为 中断事件 的变量设定。" then
        run("halt")
        return 1
    else
        if run_hp() < 0 or 
           run_score() < 0 or 
           run_i() < 0 then
            return -1
        end
    end
    var.dazuo.param = { dazuo_analysis(target, var.dazuo.mode) }
    return dazuo_exec(target)
end

function dazuo_analysis(target, mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dazuo_analysis ］参数：target = "..tostring(target)..", mode = "..tostring(mode))
    local base,income,outcome = profile.dazuo,nil,nil
    if env.room.name == "观潮台" and (env.weather_time == "傍晚" or env.weather_time == "凌晨") then
        base = math.modf(base * 1.5)
    elseif env.room.id == 1422  and env.weather_time == "午夜" then
        base = math.modf(base * 1.25)
    elseif carryon.inventory["《神照经》:shenzhao jing"] ~= nil then
        base = base * 2
    elseif carryon.inventory["《玄门内功心法》:xuanmen xinfa"] ~= nil then
        if skills.enable.force.name == "先天功" then
            if profile.family_name == "全真教" and env.room.name == "养心殿" then
                base = base * 2
            else
                base = math.modf(base * 1.5)
            end
        else
            base = math.modf(base * 1.25)
        end
    end
    if mode == "normal" then
        income = math.max(target - state.nl, 0)
        if carryon.inventory["炼心石:lianxin shi"] == nil then
            outcome = math.min(income - 1, math.max(state.qx - 1, 0))
        else
            outcome = math.min(math.max(math.modf(income / 2 - 1), 0), math.max(state.qx - 1, 0))
        end
        if (outcome < 10) or (outcome < base and state.qx > base) then
            outcome = 0
            income = 0
        end
    else
        outcome = math.min(base, state.qx - 1)
        if carryon.inventory["炼心石:lianxin shi"] == nil then
            income = outcome + 1
        else
            income = (outcome + 1) * 2
        end
        if (outcome < 10) or (state.nl + income > state.nl_max * 2) then
            outcome = 0
            income = 0
        end
    end
    return outcome,income,base
end

function recover_goto()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ recover_goto ］")
    if state.qx * state.js > 0 and 
       state.jl >= state.jl_max / 10 then
        return 0
    end
    if state.js == 0 then
        if yun_regenerate() < 0  then
            return -1
        end
    end
    if state.qx == 0 then
        if yun_recover() < 0  then
            return -1
        end
    end
    if state.jl < state.jl_max / 10 then
        return yun_refresh()
    end
    return 0
end

function recover(nl)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ recover ］参数：nl = "..tostring(nl))
    local rc,msg = yun_bidu()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return ask_ping()
    end
    rc,msg = yun_forceheal()
    if rc < 0 then
        return -1
    elseif rc == 1 then
        return ask_ping()
    end
    rc,msg = heal_regenerate(70)
    if rc ~= 0  then
        return rc,msg
    end
    rc,msg = heal_recover()
    if rc ~= 0  then
        return rc,msg
    end
    return recover_dazuo(nl)
end

function recover_dazuo(nl)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ recover_dazuo ］参数：nl = "..tostring(nl))
    local rc,msg = dazuo(nl or "double", "normal")
    if rc ~= 0 then
        return rc,msg
    end
    if state.js > state.js_max - 10 and 
       state.qx > state.qx_max - 10 and 
       state.jl > state.jl_max - 10 then
        return 0
    end
    if state.js <= state.js_max - 10 then
        rc,msg = yun_regenerate()
        if rc ~= 0 then
            return rc,msg
        end
    end
    if state.qx <= state.qx_max - 10 then
        rc,msg = yun_recover()
        if rc ~= 0 then
            return rc,msg
        end
    end
    if state.jl <= state.jl_max - 10 then
        rc,msg = yun_refresh()
        if rc ~= 0 then
            return rc,msg
        end
    end
    return recover_dazuo(nl)
end