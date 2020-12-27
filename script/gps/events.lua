function event_locate()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ event_locate ］")
    if #env.current.id > 0 then
        return 0,env.current.id[1]
    else
        return 1,"重新定位"
    end
end

function event_goto_pause(tmp)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ event_goto_pause ］参数：tmp = "..table.tostring(tmp))
    if var.goto.pause ~= nil then
        if tmp.power ~= nil then
            run("jiali "..tostring(tmp.power))
        end
        if tmp.energy ~= nil then
            run("jiajin "..tostring(tmp.energy))
        end
        return 1,"移动暂停"
    end
    return 0
end

function event_draw_pay(money)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ event_draw_pay ］参数：money = "..tostring(money))
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    if wait_line("score;i", 30, nil, 20, "^你身上带着\\S+件物品\\(负重\\s*\\d+%\\)：$|^目前你身上没有任何东西。$", "^> $") == false then
        return -1
    end
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    if profile.balance + carryon.money < money then
        show("钱不够", "orange")
        return -1
    end
    if carryon.money >= money then
        return 0
    end
    local var_goto = var.goto
    var.goto = {room_ids = {1028}, index = 1, thread = var_goto.thread, event = true, report = true}
    if goto_move() ~= 0 then
        return -1
    end
    if var.goto.event == true then
        var_goto.pause = var.goto.pause
        var.goto = var_goto
    else
        var.goto.event = nil
        return 1,"移动调整"
    end
    if var.goto.pause == nil then
        if draw(money - carryon.money) ~= 0 then
            return -1
        end
    end
    return 1,"移动调整"
end

function faint()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ faint ］")
    trigger.disable_group("goto")
    var.goto.pause = function()
        var.goto.pause = nil
        trigger.enable_group("goto")
        local l = wait_line(nil, 180, {StopEval=true}, 20, "^慢慢地一阵眩晕感传来，你终于又有了知觉....$|^鬼门关 - ")
        if l == false or l[0] == "鬼门关 - " then
            return -1
        else
            global.flood = 0
            if run_hp() < 0 then
                return -1
            end
            if recover_goto() ~= 0 then
                return -1
            else
                return 0
            end
        end
    end
end

function terminate()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ die ］")
    trigger.disable_group("goto")
    var.goto.pause = function()
        var.goto.pause = nil
        trigger.enable_group("goto")
        return -1
    end
end

function lost()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ lost ］")
    trigger.disable_group("goto")
    var.goto.pause = function()
        var.goto.pause = nil
        env.current.name = ""
        trigger.enable_group("goto")
        return 0
    end
end

function tired()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ tired ］")
    trigger.disable_group("goto")
    var.goto.pause = function()
        var.goto.pause = nil
        trigger.enable_group("goto")
        if run_hp() < 0 then
            return -1
        end
        if recover_goto() ~= 0 then
            return -1
        else
            return 0
        end
    end
end

function yell_boat()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yell_boat ］")
    var.goto.yell_boat = var.goto.yell_boat or {}
    local rc,msg = event_locate()
    if rc > 0 then
        return yell_boat_return(rc, msg)
    end
    var.goto.yell_boat.room_id = msg
    local l = wait_line("yell boat", 30, {StopEval=true}, 20, "^什么\\?$|"..
                                                              "^你使出吃奶的力气喊了一声：“船家”$|"..
                                                              "^你吸了口气，一声“船家”，声音中正平和地远远传了出去。$|"..
                                                              "^你鼓足中气，长啸一声：“船家！”$")
    if l == false then
        return yell_boat_return(-1)
    elseif var.goto.pause ~= nil then
        return yell_boat_return(1, "移动暂停")
    elseif l[0] == "什么?" then
        map_adjust("开放松花江冰面")
        if env.current.name == "船厂" then
            var.goto.path[1508].next = 3036
            var.goto.path[3036] = {step = "east", last = 1508, next = 1507}
            var.goto.path[1507] = {step = "east", last = 3036, next = 1506}
        else
            var.goto.path[1507].next = 3036
            var.goto.path[3036] = {step = "west", last = 1507, next = 1508}
            var.goto.path[1508] = {step = "west", last = 3036, next = 1485}
        end
        return yell_boat_return(walk_ice())
    else
        l = wait_line(nil, 30, nil, 20, "^一叶扁舟缓缓地驶了过来，(?:艄公|船夫)将一块踏脚板搭上堤岸，以便乘客$|"..
                                        "^岸边一只(?:渡船|小舟)上的(?:老艄公|船夫)说道：正等着你呢，上来吧。$|"..
                                        "^只听得(?:江|湖)面(?:上|不远处)隐隐传来：“别急嘛，这儿正忙着呐……”$")
        if l == false then
            return yell_boat_return(-1)
        elseif var.goto.pause ~= nil then
            return yell_boat_return(1, "移动暂停")
        elseif string.match(l[0], "正忙着") or string.match(l[0], "请稍候") then
            rc,msg = yell_boat_wait()
            if rc ~= nil then
                return yell_boat_return(rc, msg)
            end
        end
        l = wait_line("enter", 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                        "^你的眼前一黑，接著什么也不知道了....$|"..
                                                        "^你已经精疲力尽，动弹不得。$|"..
                                                        "^鬼门关 - $|"..
                                                        "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return yell_boat_return(-1)
        elseif var.goto.pause ~= nil then
            return yell_boat_return(1, "移动暂停")
        else
           if wait_line(nil, 30, nil, 20, "^> $") == false then
                return yell_boat_return(-1)
           end
           env.current.id = {var.goto.path[var.goto.yell_boat.room_id].next}
           return yell_boat_return(0)
        end
    end
end

function yell_boat_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yell_boat_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.goto.yell_boat == nil then
        return rc,msg
    end
    var.goto.yell_boat = nil
    return rc,msg
end

function yell_boat_wait()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ yell_boat_wait ］")
    local l
    if env.current.name == "汉水南岸" and var.goto.room_ids[var.goto.index] ~= 1964 then
        var.goto.path[1048] = {step = "northwest", last = 1049, next = 1965}
        var.goto.path[1965] = {step = "yell boat;enter", last = 1048, next = 1528}
        if var.goto.path[1528] == nil then
            var.goto.path[1528] = {step = "out", last = 1965, next = 1527}
        else
            var.goto.path[1528].step = "out"
            var.goto.path[1528].last = 1965 
        end
        if var.goto.path[1528].next == 1527 then
            if var.goto.path[1527] == nil then
                var.goto.path[1527] = {step = "northeast", last = 1528, next = 1526}
            else
                var.goto.path[1527].step = "northeast"
                var.goto.path[1527].last = 1528
            end
        end
        if var.goto.path[1527].next == 1526 then
            if var.goto.path[1526] == nil then
                var.goto.path[1526] = {step = "east", last = 1527, next = 1525}
            else
                var.goto.path[1526].step = "east"
                var.goto.path[1526].last = 1527
            end
        end
        l = wait_line("northwest", 30, {StopEval=true}, 20, "^汉水畔 - |"..
                                                            "^你的眼前一黑，接著什么也不知道了....$|"..
                                                            "^你已经精疲力尽，动弹不得。$|"..
                                                            "^鬼门关 - $|"..
                                                            "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            if wait_line(nil, 30, nil, 20, "^> $") == false then
                return -1
            end
            var.goto.yell_boat.room_id = 1048
        end
    elseif env.current.name == "汉水北岸" and var.goto.room_ids[var.goto.index] ~= 1964 then
        var.goto.path[1528] = {step = "southwest", last = 1527, next = 1965}
        var.goto.path[1965] = {step = "yell boat;enter", last = 1528, next = 1048}
        if var.goto.path[1048] == nil then
            var.goto.path[1048] = {step = "out", last = 1965, next = 1049}
        else
            var.goto.path[1049].step = "out"
            var.goto.path[1049].last = 1965
        end
        if var.goto.path[1048].next == 1049 then
            if var.goto.path[1049] == nil then
                var.goto.path[1049] = {step = "southeast", last = 1048, next = 1050}
            else
                var.goto.path[1049].step = "southeast"
                var.goto.path[1049].last = 1048
            end
        end
        l = wait_line("west;southwest", 30, {StopEval=true}, 20, "^汉水畔 - |"..
                                                                 "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                 "^你已经精疲力尽，动弹不得。$|"..
                                                                 "^鬼门关 - $|"..
                                                                 "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            if wait_line(nil, 30, nil, 20, "^> $") == false then
                return -1
            end
            var.goto.yell_boat.room_id = 1528
        end
    elseif set.last(env.current.id) == 1048 and var.goto.room_ids[var.goto.index] ~= 1965 then
        if var.goto.path[1049] == nil then
            var.goto.path[1049] = {step = "southeast", last = 1048, next = 1964}
        else
            var.goto.path[1049].next = 1964
        end
        var.goto.path[1964] = {step = "yell boat;enter", last = 1049, next = 1526}
        if var.goto.path[1526] == nil then
            var.goto.path[1526] = {step = "out", last = 1964, next = 1527}
        else
            var.goto.path[1526].step = "out"
            var.goto.path[1526].last = 1964
        end
        if var.goto.path[1526].next == 1527 then
            if var.goto.path[1527] == nil then
                var.goto.path[1527] = {step = "west", last = 1526, next = 1528}
            else
                var.goto.path[1527].step = "west"
                var.goto.path[1527].last = 1526
            end
        end
        if var.goto.path[1527].next == 1528 then
            var.goto.path[1528] = {step = "southwest", last = 1527}
        end
        l = wait_line("southeast", 30, {StopEval=true}, 20, "^汉水南岸 - |"..
                                                            "^你的眼前一黑，接著什么也不知道了....$|"..
                                                            "^你已经精疲力尽，动弹不得。$|"..
                                                            "^鬼门关 - $|"..
                                                            "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            if wait_line(nil, 30, nil, 20, "^> $") == false then
                return -1
            end
            var.goto.yell_boat.room_id = 1049
        end
    elseif set.last(env.current.id) == 1528 and var.goto.room_ids[var.goto.index] ~= 1965 then
        if var.goto.path[1526] == nil then
            var.goto.path[1526] = {step = "east", last = 1527, next = 1964}
        else
            var.goto.path[1526].next = 1964
        end
        var.goto.path[1964] = {step = "yell boat;enter", last = 1526, next = 1049}
        if var.goto.path[1049] == nil then
            var.goto.path[1049] = {step = "out", last = 1964, next = 1048}
        else
            var.goto.path[1049].step = "out"
            var.goto.path[1049].last = 1964
        end
        if var.goto.path[1049].next == 1048 then
            var.goto.path[1048] = {step = "northwest", last = 1049}
        end
        l = wait_line("northeast;east", 30, {StopEval=true}, 20, "^汉水北岸 - |"..
                                                                 "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                 "^你已经精疲力尽，动弹不得。$|"..
                                                                 "^鬼门关 - $|"..
                                                                 "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            if wait_line(nil, 30, nil, 20, "^> $") == false then
                return -1
            end
            var.goto.yell_boat.room_id = 1526
        end
    else
        var.goto.pause = true
        l = wait_line(nil, 1, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                   "^你的眼前一黑，接著什么也不知道了....$|"..
                                                   "^你已经精疲力尽，动弹不得。$|"..
                                                   "^鬼门关 - $|"..
                                                   "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            return yell_boat()
        end
    end
    env.current.id = { var.goto.yell_boat.room_id }
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    l = wait_line("yell boat", 30, nil, 20, "^你使出吃奶的力气喊了一声：“船家”$|"..
                                            "^你吸了口气，一声“船家”，声音中正平和地远远传了出去。$|"..
                                            "^你鼓足中气，长啸一声：“船家！”$",
                                            "^一叶扁舟缓缓地驶了过来，艄公将一块踏脚板搭上堤岸，以便乘客$|"..
                                            "^岸边一只渡船上的老艄公说道：正等着你呢，上来吧。$|"..
                                            "^只听得江面上隐隐传来：“别急嘛，这儿正忙着呐……”$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif string.match(l[2][0], "正忙着") then
        var.goto.pause = true
        l = wait_line(nil, 1, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                   "^你的眼前一黑，接著什么也不知道了....$|"..
                                                   "^鬼门关 - $|"..
                                                   "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            return yell_boat()
        end
    end
    return
end

function knock_lou()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ knock_lou ］")
    local l = wait_line("knock lou", 30, nil, 20, "^你用力的敲了敲铜锣。$",
                                                  "^一个大竹篓缓缓的(?:升了起|降了下)来。$|"..
                                                  "^吊篮还没有离开呢，快上去吧。$"..
                                                  "^吊篮正在运转过程中，请稍候。$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[2][0] == "吊篮正在运转过程中，请稍候。" then
        var.goto.pause = true
        l = wait_line(nil, 1, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                   "^你的眼前一黑，接著什么也不知道了....$|"..
                                                   "^鬼门关 - $|"..
                                                   "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            return knock_lou()
        end
    end
    l = wait_line("enter", 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                    "^你的眼前一黑，接著什么也不知道了....$|"..
                                                    "^你已经精疲力尽，动弹不得。$|"..
                                                    "^鬼门关 - $|"..
                                                    "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    else
       if wait_line(nil, 30, nil, nil, "^> $") == false then
            return -1
       end
       env.current.id = { 3103 }
       return 0
    end
end

function leave_transport()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ leave_transport ］")
    local rc,msg = event_locate()
    var.goto.pause = true
    local l = wait_line(nil, 180, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                       "^艄公说“到啦，上岸吧”，随即把一块踏脚板搭上堤岸。$|"..
                                                       "^艄公轻声说道：“都\\S+回去了。”$|"..
                                                       "^又划出三四里，溪心忽有九块大石迎面耸立，犹如屏风一般，挡住了来船去路。$|"..
                                                       "^又划出三四里，溪流曲折，小舟经划过了几个弯后又回到溪边。$|"..
                                                       "^(?:终于到了(?:岸|小岛)边，|)船夫把小舟靠在岸边，快下船吧。$|"..
                                                       "^过了良久，竹篓(?:停止下降，|)已经到达崖(?:顶|底)，快(?:上|下)去吧。$|"..
                                                       "^你的眼前一黑，接著什么也不知道了....$|"..
                                                       "^鬼门关 - $|"..
                                                       "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if var.goto.pause == true then
        var.goto.pause = nil
    end
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    l = wait_line("out", 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                  "^你的眼前一黑，接著什么也不知道了....$|"..
                                                  "^你已经精疲力尽，动弹不得。$|"..
                                                  "^鬼门关 - $|"..
                                                  "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    else
       if wait_line(nil, 30, nil, nil, "^> $") == false then
            return -1
       end
    end
    if var.goto.path ~= nil then
        if rc == 0 then
            env.current.id = {var.goto.path[msg].next}
        else
            return 1,"移动调整"
        end
    end
    return 0
end

function murong()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ murong ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, nil, 20, "^穷光蛋，一边呆着去！$|"..
                                                                                  "^你把钱交给船家，船家领你上了一条小舟。$|"..
                                                                                  "^你随着船家上了一条小舟。$|"..
                                                                                  "^你弹了一下琴，突然脚下一空，掉了下去。$|"..
                                                                                  "^(?:却见|)你\\S+运起斗转星移使用慕容身法一个纵身便往水面飞去。$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    if l[0] == "穷光蛋，一边呆着去！" then
        return event_draw_pay(400)
    elseif string.find(l[0], "慕容身法") then
        if wait_line(nil, 30, nil, 20, "^(?:小岛边|岸边|码头) - ") == false or 
           wait_line(nil, 30, nil, 20, "^> $") == false then
            return -1
        end
    else
        if wait_line(nil, 30, nil, 20, "^(?:渡船|小舟) - ") == false then
            return -1
        end
        global.flood = 0
    end
    env.current.id = {var.goto.path[msg].next}
    return 0
end

function jump_boat()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ jump_boat ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    if env.current.name == "小溪边" then
        if wait_line("look boat", 30, nil, 20, "^一叶小舟，飘飘忽忽地随着溪流而晃来晃去。$") == false then
            return -1
        end
    else
        local current_wield
        if carryon.wield[1] ~= "" then
            current_wield = table.copy(carryon.wield)
            if unwield() < 0 then
                return -1
            end
        end
        if wait_line("tui boat", 30, nil, 20, "^你双掌一使劲，用力将小舟推入溪中。$") then
            if wait_no_busy() < 0 then
                return -1
            end
        end
        if current_wield ~= nil then
            if wield(current_wield) ~= 0 then
                return -1
            end
        end
    end
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    if wait_line("jump boat", 30, nil, 20, "^你屏气凝神，稳稳地站落在小舟之上。$") == false then
        return -1
    end
    env.current.id = {var.goto.path[msg].next}
    return 0
end

function walk_ice()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ walk_ice ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local current_wield
    if carryon.wield[1] ~= "" then
        current_wield = table.copy(carryon.wield)
        if unwield() < 0 then
            return -1
        end
    end
    local l  = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^冰面 - |"..
                                                                                               "^松花江化冻了，你喊\\(yell\\)条船过江吧。$|"..
                                                                                               "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                               "^你已经精疲力尽，动弹不得。$|"..
                                                                                               "^鬼门关 - $|"..
                                                                                               "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "松花江化冻了，你喊(yell)条船过江吧。" then
        map_adjust("松花江", "渡船")
        if calibration["过河"][1] == "大圣" then
            var.goto.path[var.goto.path[3036].last].next = var.goto.path[3036].next
            if var.goto.path[3036].next ~= nil then
                var.goto.path[var.goto.path[3036].next].last = var.goto.path[3036].last
                var.goto.path[var.goto.path[3036].next].step = "yell 大圣"
            end
            return 0
        else
            var.goto.path[var.goto.path[3036].last].next = 1963
            var.goto.path[1963] = var.goto.path[3036]
            var.goto.path[1963].step = "yell boat;enter"
            if var.goto.path[3036].next ~= nil then
                var.goto.path[var.goto.path[3036].next].last = 1963
                var.goto.path[var.goto.path[3036].next].step = "out"
            end
            return yell_boat()
        end
    end
    if current_wield ~= nil then
        if wield(current_wield) ~= 0 then
            return -1
        end
    end
    env.current.id = {3036}
    l = wait_line(var.goto.path[var.goto.path[3036].next].step, 30, {StopEval=true}, 20, "^(?:船厂|大门坎子) - |"..
                                                                                         "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                         "^你已经精疲力尽，动弹不得。$|"..
                                                                                         "^鬼门关 - $|"..
                                                                                         "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    else
        env.current.id = {var.goto.path[3036].next}
        return 0
    end
end

function quicksand()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ quicksand ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    if msg == 1090 then
        local l = wait_line("west", 30, {StopEval=true}, 20, "^你的眼前一黑，接著什么也不知道了....|"..
                                                             "^你已经精疲力尽，动弹不得。$")
        if l == false then
            return -1
        else
            if l[0] ~= "你已经精疲力尽，动弹不得。" then
                env.current.id = { 2980 }
            end
            return 1,"移动暂停"
        end
    else
        if type(env.current.exits) == "string" then
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
        for _,v in ipairs(env.current.exits) do
            rc = look_dir(v)
            if rc < 0 then
                return -1
            elseif rc == 1 then
                if wait_line("look", 30, nil, 20, "^爱力生 - $", "^> $") == false then
                    return -1
                end
                if locate() < 0  then
                    return -1
                end
                if var.goto.pause ~= nil then
                    return 1,"移动暂停"
                else
                    return quicksand()
                end
            else
                if locate_nextto() < 0  then
                    return -1
                end
                if env.nextto.id[1] == 1090 then
                    if wait_line(v, 30, {StopEval=true}, 20, "爱力生 - ", "> ") == false then
                        return -1
                    end
                    if var.goto.pause ~= nil then
                        return 1,"移动暂停"
                    else
                        env.current.id = {1090}
                        return quicksand()
                    end
                end
            end
        end
        if global.flood > 40 then
            wait(1)
            global.flood = 0
        end
        if one_step() ~= 0 then
            return -1
        else
            if locate() < 0  then
                return -1
            end
            if var.goto.pause ~= nil then
                return 1,"移动暂停"
            else
                return quicksand()
            end
        end
    end
end

local navigation_port = {
    ["桃花岛"] = "东海桃花岛",
    ["神龙岛"] = "辽东神龙岛",
    ["灵蛇岛"] = "东海灵蛇岛",
    ["王盘山"] = "海外",
    ["冰火岛"] = "海外冰火岛"
}

local navigation_list = {
    ["东海桃花岛"] = {
        port = "舟山",
        range = 2,
        coordinate = {x = 18, y = -9}
    },
    ["海外"] = {
        port = "舟山",
        range = 2,
        coordinate = {x = 9, y = -5}
    },
    ["辽东神龙岛"] = {
        port = "塘沽口",
        range = 5,
        coordinate = {x = 30, y = 21}
    },
    ["东海灵蛇岛"] = {
        port = "塘沽口",
        range = 5,
        coordinate = {x = 40, y = -53}
    },
    ["海外冰火岛"] = {
        port = "塘沽口",
        range = 6,
        coordinate = {x = 105, y = 627}
    }
}

function navigation()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ navigation ］")
    var.goto.navigation = var.goto.navigation or { phase = 1 }
    local rc,msg = event_locate()
    if rc > 0 then
        return navigation_return(rc, msg)
    end
    var.goto.navigation.room_id = msg
    if env.current.name ~= "海船" then
        rc,msg = navigation_take_ship()
        if rc ~= nil then
            return navigation_return(rc, msg)
        end
    end
    rc,msg = navigation_drive_ship(navigation_list[map[var.goto.room_ids[var.goto.index]].zone])
    if rc ~= nil then
        return navigation_return(rc, msg)
    end
    l = wait_line("out", 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                  "^你的眼前一黑，接著什么也不知道了....$|"..
                                                  "^你已经精疲力尽，动弹不得。$|"..
                                                  "^鬼门关 - $|"..
                                                  "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return navigation_return(-1)
    elseif var.goto.pause ~= nil then
        return navigation_return(1, "移动暂停")
    else
       if wait_line(nil, 30, nil, 20, "^> $") == false then
            return navigation_return(-1)
       end
    end
    env.current.id = {var.goto.path[var.goto.navigation.room_id].next}
    return navigation_return(0)
end

function navigation_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ navigation_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.goto.navigation == nil then
        return rc,msg
    end
    var.goto.navigation = nil
    return rc,msg
end

function navigation_take_ship()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ navigation_take_ship ］")
    local l = wait_line("yell chuan", 30, nil, 20, "^你吸了口气，一声“船家”，声音中正平和地远远传了出去。$|"..
                                                   "^你鼓足中气，长啸一声：“船家！”$|"..
                                                   "^别叫了，这么大眼睛没看见船？$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    l = wait_line("enter", 30, {StopEval=true}, 20, "^海船 - |^穷光蛋，一边呆着去！$|"..
                                                    "^这个方向没有出路。$|^什么\\?$|"..
                                                    "^你的眼前一黑，接著什么也不知道了....$|"..
                                                    "^你已经精疲力尽，动弹不得。$|"..
                                                    "^鬼门关 - $|"..
                                                    "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif l[0] == "这个方向没有出路" or l[0] == "什么?" then
        return navigation()
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "穷光蛋，一边呆着去！" then
        return event_draw_pay(2000)
    else
        env.current.id = {var.goto.path[var.goto.navigation.room_id].next}
        var.goto.navigation.room_id = env.current.id[1]
    end
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif var.goto.room_ids[var.goto.index] == var.goto.navigation.room_id then
        return 0
    end
    if wait_line("start", 30, nil, 20, "^你大喝一声“开船”，于是船便离了岸。$|^船已经出海了。$") == false then
        return -1
    end
    return
end

function navigation_drive_ship(dst)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ navigation_drive_ship ］参数："..table.tostring(dst))
    local l
    local coordinate = {x = 0, y = 0}
    if var.goto.navigation.phase < 4 then
        l = wait_line("locate", 30, nil, 20, "^你现在在((?:舟山|塘沽口|永宁港|安海港))(?:|(?:正|)(\\S+?)约(\\S+?)海哩(?:(\\S+?)约(\\S+?)海哩|))。$|"..
                                             "^船夫说：“(\\S+)到啦，上岸吧”。$|"..
                                             "^船还没开呢。$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        elseif l[0] == "船还没开呢。" then
            if wait_line("start", 30, nil, 20, "^你大喝一声“开船”，于是船便离了岸。$") == false then
                return -1
            end
            l = wait_line("locate", 30, nil, 20, "^你现在在((?:舟山|塘沽口|永宁港|安海港))(?:|(?:正|)(\\S+?)约(\\S+?)海哩(?:(\\S+?)约(\\S+?)海哩|))。$|"..
                                                 "^船夫说：“(\\S+)到啦，上岸吧”。$")
            if l == false then
                return -1
            elseif var.goto.pause ~= nil then
                return 1,"移动暂停"
            end
        end
        if string.match(l[0], "上岸吧") then
            if navigation_port[l[6]] == map[var.goto.path[var.goto.navigation.room_id].next].zone then
                return
            elseif navigation_port[l[6]] == nil and 
                   l[6] == dst.port then
                return
            end
            run("start")
            return navigation()
        end
        if dst == nil or l[1] ~= dst.port then
            dst = {
                port = l[1], range = 3,
                coordinate = {x = 0, y = 0}
            }
        end
        if l[2] == "南" then
            coordinate.y = chs2num(l[3]) * -1
        elseif l[2] == "东" then
            coordinate.x = chs2num(l[3])
        elseif l[2] == "北" then
            coordinate.y = chs2num(l[3])
        end
        if l[4] == "南" then
            coordinate.y = chs2num(l[5]) * -1
        elseif l[4] == "东" then
            coordinate.x = chs2num(l[5])
        elseif l[4] == "北" then
            coordinate.y = chs2num(l[5])
        end
    end
    if var.goto.navigation.phase < 3 then
        if coordinate.x < 3 and dst.coordinate.x > coordinate.x then
            var.goto.navigation.nowdir= "go east"
        elseif var.goto.navigation.phase == 1 and math.abs(dst.coordinate.y - coordinate.y) > dst.range then
            if dst.coordinate.y > coordinate.y then
                var.goto.navigation.nowdir= "go north"
            else
                var.goto.navigation.nowdir= "go south"
            end
        elseif math.abs(dst.coordinate.x - coordinate.x) > dst.range then
            if var.goto.navigation.phase ==  1 then
                var.goto.navigation.phase = 2
            end
            if dst.coordinate.x > coordinate.x then
                var.goto.navigation.nowdir= "go east"
            else
                var.goto.navigation.nowdir= "go west"
            end
        else
            if dst.coordinate.x == 0 then
                dst.range = 0
                var.goto.navigation.phase = 3
            else
                var.goto.navigation.phase = 4
            end
            return navigation_drive_ship(dst)
        end
        var.goto.pause = true
        l = wait_line(var.goto.navigation.nowdir, 3, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                                          "^船夫说：“(\\S+)到啦，上岸吧”。$|"..
                                                                          "^船夫说：叹！漂到了一荒岛，还是赶紧离开吧。$|"..
                                                                          "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                          "^鬼门关 - $|"..
                                                                          "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        if l ~= false and l[1] ~= false then
            if navigation_port[l[1]] == map[var.goto.path[var.goto.navigation.room_id].next].zone then
                return
            elseif navigation_port[l[1]] == nil then
                if l[1] == dst.port then
                    return
                end
            end
            run("start")
        end
    end
    if var.goto.navigation.phase == 3 then
        if math.abs(dst.coordinate.x - coordinate.x) < dst.range and math.abs(dst.coordinate.y - coordinate.y) < dst.range then
            var.goto.navigation.phase = 4
            return navigation_drive_ship(dst)
        end
        if math.abs(dst.coordinate.x - coordinate.x) > math.abs(dst.coordinate.y - coordinate.y) then
            if dst.coordinate.x > coordinate.x then
                var.goto.navigation.nowdir= "go east"
            else
                var.goto.navigation.nowdir= "go west"
            end
        else
            if dst.coordinate.y > coordinate.y then
                var.goto.navigation.nowdir= "go north"
                var.goto.navigation.dir = var.goto.navigation.nowdir
            elseif dst.coordinate.y < coordinate.y then
                var.goto.navigation.nowdir= "go south"
                var.goto.navigation.dir = var.goto.navigation.nowdir
            end
        end
        var.goto.pause = true
        l = wait_line(var.goto.navigation.nowdir, 0.5, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                                            "^船夫说：“(\\S+)到啦，上岸吧”。$|"..
                                                                            "^船夫说：叹！漂到了一荒岛，还是赶紧离开吧。$|"..
                                                                            "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                            "^鬼门关 - $|"..
                                                                            "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        if l ~= false then
            if l[0] == "船夫说：叹！漂到了一荒岛，还是赶紧离开吧。" then
                var.goto.navigation.nowdir= var.goto.navigation.dir or "go west"
            elseif l[1] ~= false then
                if navigation_port[l[1]] == map[var.goto.path[var.goto.navigation.room_id].next].zone then
                    return
                elseif navigation_port[l[1]] == nil then
                    if l[1] == dst.port then
                        return
                    end
                end
                run("start")
            end
        end
    end
    if var.goto.navigation.phase == 4 then
        l = wait_line("lookout", 30, {StopEval=true}, 20, "^船夫说：“(\\S+)到啦，上岸吧”。$|"..
                                                          "^你极目远眺，发现(\\S+)方向(?:出现一片陆地|似乎有个山石嶙峋荒凉小岛|似乎有一条烟柱|数里外是个树木葱翠的海岛，岛上奇峰挺拔，耸立着好几座高山|有一股夹着扑鼻花香的海风吹来)(?:！|。)$|"..
                                                          "^你极目远眺，只觉大海茫茫。$|"..
                                                          "^你的眼前一黑，接著什么也不知道了....$|"..
                                                          "^鬼门关 - $|"..
                                                          "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        elseif l[0] == "你极目远眺，只觉大海茫茫。" then
            var.goto.navigation.phase = 3
        else
            if l[2] ~= false then
                var.goto.pause = true
                l = wait_line("go "..get_desc_dir(string.sub(l[2], 1, 3)), 0.5, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                                                                 "^船夫说：“(\\S+)到啦，上岸吧”。$|"..
                                                                                                 "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                                 "^鬼门关 - $|"..
                                                                                                 "^一道闪电从天降下，直朝你劈去……结果没打中！$")
            end
            if var.goto.pause == true then
                var.goto.pause = nil
            end
            if var.goto.pause ~= nil then
                return 1,"移动暂停"
            end
            if l ~= false then
                if navigation_port[l[1]] == map[var.goto.path[var.goto.navigation.room_id].next].zone then
                    return
                elseif navigation_port[l[1]] == nil then
                    if l[1] == dst.port then
                        return
                    end
                end
                var.goto.navigation.phase = 3
                run("start")
            end
        end
    end
    return navigation_drive_ship(dst)
end

local kill_npc_list = {
    ["虚通"] = "kill xutong",
    ["虚明"] = "kill xuming"
}

function kill_npc()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ kill_npc ］")
    var.goto.kill_npc = var.goto.kill_npc or { step = {} }
    local rc,msg = event_locate()
    if rc > 0 then
        return kill_npc_return(rc, msg)
    end
    var.goto.kill_npc.room_id = msg
    for _,v in ipairs(string.split(var.goto.path[var.goto.path[msg].next].step, ";")) do
        if string.find(v, "kill ") then
            var.goto.kill_npc.kill = v
        else
            set.append(var.goto.kill_npc.step, v)
        end
    end
    return kill_npc_return(kill_npc_exec())
end

function kill_npc_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ kill_npc_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.goto.kill_npc == nil then
        return rc,msg
    end
    var.goto.kill_npc = nil
    return rc,msg
end

function kill_npc_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ kill_npc_exec ］")
    local l = wait_line(set.concat(var.goto.kill_npc.step, ";"), 30, {StopEval=true}, 20, "^(\\S+)\\s+- |"..
                                                                                          "^这个方向没有出路。$|^什么\\?$|"..
                                                                                          "^张松溪喝道：里面是武当重地，闲人请止步。$|"..
                                                                                          "^千年以来，少林向不许女流擅入。$|"..
                                                                                          "^你不是少林弟子，不得进入后殿。$|"..
                                                                                          "^帮众拦在你面前，说道：里面是关押本帮叛徒的地方，你请回吧。$|"..
                                                                                          "^采花子挡住了你：我的小妞可不是给你们邪派弟子准备的！$|"..
                                                                                          "^狮吼子一言不发，闪身拦在你面前。$|"..
                                                                                          "^都大锦拦在你面前，喝道：\\S+里面是镖局重地，不得闯入！$|"..
                                                                                          "^高根明拦住你说：由此往上乃本派禁地，请止步。$|"..
                                                                                          "^施戴子拦住你说：两位师叔祖不欲见客，请回吧。$|"..
                                                                                          "^劳德诺欠身说道：这位\\S+(?:可有拜帖呈予家师？|请止步！那里是本派的兵器房。)$|"..
                                                                                          "^梁发挡住你说道：后面是本派书院，这位\\S+请留步。$|"..
                                                                                          "^陆大有喝道：后面是华山派的内院，这位\\S+请止步。$|"..
                                                                                          "^岳灵姗拦身说道：后面是本派厨房，\\S+请往前厅奉茶。$|"..
                                                                                          "^宁中则拦在你身前斥道：外人不能随易出入本派重地！还不快给我离开？$|"..
                                                                                          "^葛伦布挡住你说：你准备用什麽供奉我们佛爷呀？$|"..
                                                                                          "^公冶乾喝道：闲杂人等，不得入内。$|"..
                                                                                          "^胡老爷说: 我把阿凡提关在我的客厅里了，谁也不许进去。$|"..
                                                                                          "^夫人吩咐没有重要的事情不要打扰小姐休息。$|"..
                                                                                          "^黄衫女子说道：本门重地，\\S+止步！$|"..
                                                                                          "^家丁挡住了你的去路：老爷正在练功，请改日再来。$|"..
                                                                                          "^家丁喝道：“到慕容山庄不要乱闯”。$|"..
                                                                                          "^家丁做了个揖，说道：尊驾与敝庄素无往来，庄主不见外客，还是请回吧$|"..
                                                                                          "^简长老一把揪住你的衣领说：“慢着！”$|"..
                                                                                          "^江百胜伸手拦住你说道：盟主很忙，现在不见外客，你下山去吧！$|"..
                                                                                          "^戒律僧挡住你说：后面乃本寺重地，请回吧！$|"..
                                                                                          "^静心师太走上前说：后边是峨嵋弟子练功休息的地方，请留步。$|"..
                                                                                          "^凌虚道长喝道：如不是上山敬香，即刻请回！$|"..
                                                                                          "^楼上是我曼佗罗山庄的藏书阁，你不是慕容弟子，还是不要上去了吧？$|"..
                                                                                          "^蒙古军官一语不发，站在你面前挡著你的去路！$|"..
                                                                                          "^你也太目中无人了吧，这儿还有人守着呢。$|"..
                                                                                          "^清乐比丘拦住你说；你资格不够，不能进入方丈室。$|"..
                                                                                          "^石嫂伸手拦住你，说道：“对不起，本门重地，请回！”$|"..
                                                                                          "^说不得伸手拦住你，说道：上面是明教光明顶，这位\\S+并非我教弟子，请止步!$|"..
                                                                                          "^天鹰教守卫喝道：这位\\S+并非我教弟子，请回吧!$|"..
                                                                                          "^未经许可，不得进入藏经阁三楼！$|"..
                                                                                          "^卫士对你喝道：看招！别妄想(?:闯入本教重地|在本大爷手下救人)！$|"..
                                                                                          "^无根道人说道“想上去先过了我这关！”。$|"..
                                                                                          "^西华子拦在你身前斥道：外人不能随易出入本派重地！还不快给我离开？$|"..
                                                                                          "^小兰大声叫道：大色狼！看清楚点，(?:男|女)弟子休息室在(?:东|西)边！$|"..
                                                                                          "^校尉挡住了你的去路！$|"..
                                                                                          "^一品堂武士挡住了你的去路！$|"..
                                                                                          "^殷\\s*锦冷笑一声“想上去杀了我再说！”。$|"..
                                                                                          "^张志光拦住说道：对不起，养心殿不对外开放！$|"..
                                                                                          "^这位\\S+请留步，恕小寺不接待女客。$|"..
                                                                                          "^壮汉拦住你说：你来洛阳金刀门撒野？快出去！$|"..
                                                                                          "^婢女伸手挡住了你的去路：少庄主正在调训毒蛇，请改日再来。$|"..
                                                                                          "^司徒横拦在你面前，喝道：\\S+不得无礼！后面是帮主的卧房。$|"..
                                                                                          "^邱山风拦在你面前，说道：\\S+怎么连一点江湖规矩都不懂？起码也得孝敬一下老子。$|"..
                                                                                          "^蒙面女郎伸手拦住你，说道：“对不起，本门重地，请回！”$|"..
                                                                                          "^樊一翁拦住你的去路，抱拳道：绝情谷中禁止外人进入。$|"..
                                                                                          "^公孙止怒斥道：谷内私邸不便参观，请回！$|"..
                                                                                          "^欧阳锋怒喝道：哪里来的野种，胆敢私闯老夫的密室？！$|"..
                                                                                          "^欧阳锋说道：等你在我庄里呆得长些我再让你下去练功吧。$|"..
                                                                                          "^一品堂武士一言不发地挡在你前面。$|"..
                                                                                          "^卫士对你大吼一声：放肆！那不是你能进去的地方。$|"..
                                                                                          "^清观喝道：你不是少林弟子，不得进入后山竹林！$|"..
                                                                                          "^(虚(?:明|通))(?:迈步挡在你身前，双手合什说道：阿弥陀佛，这位\\S+请收起|"..
                                                                                                          "拦住你说道：这位\\S+请放下兵刃。少林千年的规矩，外客)$|"..
                                                                                          "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                          "^你已经精疲力尽，动弹不得。$|"..
                                                                                          "^鬼门关 - $|"..
                                                                                          "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif l[1] ~= false then
        if var.goto.kill_npc.power ~= nil then
            run("jiali "..tostring(var.goto.kill_npc.power))
        end
        if var.goto.kill_npc.energy ~= nil then
            run("jiajin "..tostring(var.goto.kill_npc.energy))
        end
        env.current.id = { var.goto.path[var.goto.kill_npc.room_id].next }
        return 0
    elseif l[0] == "这个方向没有出路。" or l[0] == "什么?" then
        env.current.id = {}
        return 1,"移动调整"
    else
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        if state.power > 0 then
            var.goto.kill_npc.power = state.power
        end
        if state.energy > 1 then
            var.goto.kill_npc.energy = state.energy
        end
        jia_min()
        if l[2] ~= false then
            var.goto.kill_npc.kill = kill_npc_list[l[2]]
        end
        var.goto.pause = true
        l = wait_line(var.goto.kill_npc.kill, 180, {StopEval=true}, 20, "^这里没有这个人。$|"..
                                                                        "^(?:蒙面女郎|邱山风|司徒横|婢女|壮汉|张志光|皇宫卫士|公孙止|樊一翁|银甲侍卫|殷锦|一品堂武士|校尉|小兰|西华子|无根道人|日月神教卫士|谭处端|天鹰教守卫|说不得|石嫂|清乐比丘|清观比丘|蒙古军官|(?:男|女)教众|凌虚道长|王夫人|静心|戒律僧|江百胜|简长老|家丁|胡老爷|黄衫女子|公冶乾|葛伦布|宁中则|陆大有|岳灵姗|梁发|劳德诺|施戴子|高根明|都大锦|狮吼子|采花子|帮众|张松溪|丫鬟|慧空尊者|虚通|虚明|欧阳锋|一品堂武士|皇宫卫士|清观比丘)倒在地上，挣扎了几下就死了。$|"..
                                                                        "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                                        "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                        "^鬼门关 - $|"..
                                                                        "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if l == false then
            return -1
        end
        local rc,msg = event_goto_pause(var.goto.kill_npc)
        if rc > 0 then
            return rc,msg
        end
        return kill_npc_exec()
    end
end

local hit_npc_list = {
    ["武将"] = "hit wu jiang",
    ["官兵"] = "hit guan bing",
    ["明苦"] = "hit ming ku",
    ["明难"] = "hit ming nan"
}

function hit_npc()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hit_npc ］")
    var.goto.hit_npc = var.goto.hit_npc or { step = {} }
    local rc,msg = event_locate()
    if rc > 0 then
        return hit_npc_return(rc, msg)
    end
    var.goto.hit_npc.room_id = msg
    for _,v in ipairs(string.split(var.goto.path[var.goto.path[var.goto.hit_npc.room_id].next].step, ";")) do
        if string.find(v, "hit ") then
            var.goto.hit_npc.hit = v
        else
            set.append(var.goto.hit_npc.step, v)
        end
    end
    return hit_npc_return(hit_npc_exec())
end

function hit_npc_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hit_npc_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.goto.hit_npc == nil then
        return rc,msg
    end
    var.goto.hit_npc = nil
    return rc,msg
end

function hit_npc_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hit_npc_exec ］")
    local l = wait_line(set.concat(var.goto.hit_npc.step, ";"), 30, {StopEval=true}, 20, "^(\\S+)\\s+- |"..
                                                                                         "^这个方向没有出路。$|^什么\\?$|"..
                                                                                         "^衙役喝道：“威……武……。”$|"..
                                                                                         "^守卫喝道：闲杂人等，不得乱闯。$|"..
                                                                                         "^你不是胡家山庄的弟子，还是不要进去为好。$|"..
                                                                                         "^银甲侍卫上前挡住你，朗声说道：皇宫禁地，禁止闲杂人等出入！$|"..
                                                                                         "^宋兵向你喝道：什么人胆敢擅闯守备府衙门！$|"..
                                                                                         "^凌翰林挡住了你：请勿入内宅。$|"..
                                                                                         "^店小二一下挡在楼梯前，白眼一翻：怎麽着，想白住啊！$|"..
                                                                                         "^光天化日的想抢劫啊？$|"..
                                                                                         "^((?:武将|官兵|明苦|明难))(?:大喝道：都督有令，闲杂人等不能由此经过！|"..
                                                                                                                   "拦住了你的去路。|"..
                                                                                                                   "(?:拦住你|迈步挡在你身前，双手合什)说道：(?:阿弥陀佛，|)这位\\S+请回吧，本寺不接待生人(?:，还请施主鉴谅|)。)$|"..
                                                                                         "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                         "^你已经精疲力尽，动弹不得。$|"..
                                                                                         "^鬼门关 - $|"..
                                                                                         "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif l[1] ~= false then
        if var.goto.hit_npc.power ~= nil then
            run("jiali "..tostring(var.goto.hit_npc.power))
        end
        if var.goto.hit_npc.energy ~= nil then
            run("jiajin "..tostring(var.goto.hit_npc.energy))
        end
        env.current.id = { var.goto.path[var.goto.hit_npc.room_id].next }
        return 0
    elseif l[0] == "这个方向没有出路。" or l[0] == "什么?" then
        env.current.id = {}
        return 1,"移动调整"
    else
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        if state.power > 0 then
            var.goto.hit_npc.power = state.power
        end
        if state.energy > 1 then
            var.goto.hit_npc.energy = state.energy
        end
        jia_min()
        if l[2] ~= false then
            var.goto.hit_npc.hit = hit_npc_list[l[2]]
        end
        var.goto.pause = true
        l = wait_line(var.goto.hit_npc.hit, 180, {StopEval=true}, 20, "^你想攻击谁？$|"..
                                                                      "^你必须等此人醒来才能进行切磋比试。$|"..
                                                                      "^(?:武将|官兵|明苦|明难|衙役|傅思归|平阿四|宋兵|凌退思|一等侍卫|店小二)脚下一个不稳，跌在地上昏了过去。$|"..
                                                                      "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                                      "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                      "^鬼门关 - $|"..
                                                                      "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if l == false then
            return -1
        end
        local rc,msg = event_goto_pause(var.goto.hit_npc)
        if rc > 0 then
            return rc,msg
        end
        if l[0] == "你想攻击谁？" then
            return hit_npc_exec()
        else
            local npc = string.gsub(var.goto.hit_npc.hit, "hit ", "")
            rc,msg = hit_npc_carry_block(npc)
            if rc == 1 then
                return hit_npc_exec()
            elseif rc ~= nil then
                return rc,msg
            end
            return hit_npc_drop_block(npc)
        end
    end
end

function hit_npc_carry_block(npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hit_npc_carry_block ］参数：npc = "..tostring(npc))
    local rc,msg
    local l = wait_line("get "..npc, 30, nil, 20, "^对方还没有完全昏迷，先等等吧。$|"..
                                                  "^你将\\S+扶了起来背在背上。$|"..
                                                  "^你上一个动作还没有完成！$|"..
                                                  "^\\S+对你而言太重了。$|"..
                                                  "^你附近没有这样东西。$")
    if l == false then
        return -1
    elseif l[0] == "对方还没有完全昏迷，先等等吧。" or 
           l[0] == "你上一个动作还没有完成！" then
        rc,msg = event_goto_pause(var.goto.hit_npc)
        if rc > 0 then
            return rc,msg
        end
        wait(0.1)
    elseif string.find(l[0], "对你而言太重") then
        rc,msg = event_goto_pause(var.goto.hit_npc)
        if rc > 0 then
            return rc,msg
        end
        if run_i() < 0 then
            return -1
        end
        l = wait_line("get all from "..npc, 30, nil, 20, "^捡好了。$|"..
                                                         "^那里面没有任何东西。$|"..
                                                         "^光天化日的想抢劫啊？$")
        if l == false then
            return -1
        elseif l[0] == "光天化日的想抢劫啊？" then
            rc,msg = event_goto_pause(var.goto.hit_npc)
            if rc > 0 then
                return rc,msg
            end
            return 1
        elseif l[0] == "那里面没有任何东西。" then
            return -1
        else
            local inventory = table.deepcopy(carryon.inventory)
            if run_i() < 0 then
                return -1
            end
            if drop(compare_carryon(inventory, carryon.inventory)) < 0  then
                return -1
            end
            rc,msg = event_goto_pause(var.goto.hit_npc)
            if rc > 0 then
                return rc,msg
            end
        end
    else
        rc,msg = event_goto_pause(var.goto.hit_npc)
        if rc > 0 then
            return rc,msg
        end
        if l[0] == "你附近没有这样东西。" then
            return hit_npc()
        end
        return
    end
    return hit_npc_carry_block(npc)
end

function hit_npc_drop_block(npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hit_npc_drop_block ］参数：npc = "..tostring(npc))
    local rc = one_step()
    if rc < 0 then
        return -1
    end
    local l = wait_line("drop "..npc, 30, nil, 20, "^你将\\S+从背上放了下来，躺在地上。$|"..
                                                   "^你身上没有这样东西。$")
    if l == false then
        return -1
    end
    if state ~= nil then
        if var.goto.hit_npc.power ~= nil then
            run("jiali "..tostring(var.goto.hit_npc.power))
        end
        if var.goto.hit_npc.energy ~= nil then
            run("jiajin "..tostring(var.goto.hit_npc.energy))
        end
    end
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    if rc ~= 0 then
        return 1,"移动调整"
    else
        env.current.id = {map[var.goto.hit_npc.room_id].esc}
        if var.goto.path[env.current.id[1]] == nil then
            for k,v in pairs(map[env.current.id[1]].links) do
                if v == var.goto.hit_npc.room_id then
                    var.goto.path[var.goto.hit_npc.room_id].step = k
                    var.goto.path[var.goto.hit_npc.room_id].last = env.current.id[1]
                    var.goto.path[env.current.id[1]] = {step = "", next = var.goto.hit_npc.room_id}
                    break
                end
            end
        end
        return 0
    end
end

function open_door()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ open_door ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^(\\S+)\\s+- |"..
                                                                                              "^这个方向没有出路。$|^什么\\?$|"..
                                                                                              "^壮年僧人说道：对不起，俗家弟子不得入寺修行。$|"..
                                                                                              "^壮年僧人说道：这位施主请回罢，本寺不接待俗人。$|"..
                                                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                                                              "^鬼门关 - $|"..
                                                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[1] ~= false then
        env.current.id = {var.goto.path[msg].next}
        return 0
    elseif l[0] == "壮年僧人说道：这位施主请回罢，本寺不接待俗人。" or l[0] == "壮年僧人说道：对不起，俗家弟子不得入寺修行。" then
        return -1
    else
        return open_door()
    end
end

function busy()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ busy ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, nil, 20, "^\\S+\\s+- |"..
                                                                                  "^就你这点功夫还想飞檐走壁？$")
    if l == false then
        return -1
    elseif l[0] == "就你这点功夫还想飞檐走壁？" then
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            map_adjust("北京城墙", "关闭")
            return 1,"移动调整"
        end
    end
    if var.goto.path[var.goto.path[msg].next].step == "jump wall" then
        wait(3)
        global.flood = 0
    end
    if wait_no_busy() < 0 then
        return -1
    end
    env.current.id = {var.goto.path[msg].next}
    return 0
end

local fall_land = {
    [412] = 1984,
    [1068] = 1060,
    [1069] = 1060,
    [1454] = 1454,
}

function fall()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ fall ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^(\\S+)\\s+- |"..
                                                                                              "^你一不小心脚下踏了个空，... 啊...！$|"..
                                                                                              "^你一不小心脚下一滑，... 啊...！$|"..
                                                                                              "^只见你一不小心脚下踏空，摔了下来。$|"..
                                                                                              "^突然轰隆一声巨响，你脚下踏了个空，... 啊...雪崩了！$|"..
                                                                                              "^突然你一失手，从峭壁上掉了下来，屁股重重地摔在地上。$|"..
                                                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                                                              "^鬼门关 - $|"..
                                                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[1] ~= false then
        env.current.id = {var.goto.path[msg].next}
    else
        env.current.id = {fall_land[msg]}
    end
    return 0
end

function xueshan()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ xueshan ］")
    if #env.current.id == 0 then
        return 1,"重新定位"
    end
    if global.flood > config.flood_control then
        var.goto.pause = true
        local l = wait_line(nil, 1, {StopEval=true}, 20, "^你目前还没有任何为 移动暂停 的变量设定。$|"..
                                                         "^你的眼前一黑，接著什么也不知道了....$|"..
                                                         "^鬼门关 - $|"..
                                                         "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if var.goto.pause == true then
            var.goto.pause = nil
        end
        if l == false then
            global.flood = 0
        else
            return 1,"移动调整"
        end
    end
    local l = wait_line("southup", 30, {StopEval=true}, 20, "^(?:谷口|大雪山口) - |"..
                                                            "^你的眼前一黑，接著什么也不知道了....$|"..
                                                            "^你已经精疲力尽，动弹不得。$|"..
                                                            "^鬼门关 - $|"..
                                                            "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "大雪山口 - " then
        env.current.id = { 1984 }
        return 0
    else
        l = wait_line("northdown", 30, {StopEval=true}, 20, "大雪山 - |"..
                                                            "^你的眼前一黑，接著什么也不知道了....$|"..
                                                            "^你已经精疲力尽，动弹不得。$|"..
                                                            "^鬼门关 - $|"..
                                                            "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        if wait_line(nil, 30, nil, 20, "^> $") == false then
            return -1
        end
        env.current.id = { 413 }
    end
    return xueshan()
end

function huashan_cliff()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ huashan_cliff ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local step = string.split(var.goto.path[var.goto.path[msg].next].step, ";")
    l = wait_line(step[1], 30, {StopEval=true}, 20, "^什么\\?$|^你拿什么来绑树啊？$|"..
                                                    "^你将一条长约两丈的绳子牢牢地扎在岩石上的凹痕里。$|"..
                                                    "^你将绳子仔细地在松树上捆绑好。$|"..
                                                    "^你要扎几条绳子才会过瘾？$")
    if l == false then
        return -1
    elseif l[0] == "什么?" or 
           l[0] == "你拿什么来绑树啊？" then
        rc,msg = event_draw_pay(30)
        if rc > 0 and var.goto.event == nil then
            return rc,msg
        end
        if var.goto.pause == nil then
            local var_goto = var.goto
            var.goto = {room_ids = {615}, index = 1, thread = var_goto.thread, event = true, report = true}
            if goto_move() ~= 0 then
                return -1
            else
                if var.goto.event == true then
                    var_goto.pause = var.goto.pause
                    var.goto = var_goto
                else
                    var.goto.event = nil
                    return 1,"移动调整"
                end
            end
            if var.goto.pause == nil then
                if buy({["绳子:sheng zi"] = 1}) ~= 0 then
                    return -1
                end
            end
        end
        return 1,"移动调整"
    end
    if wait_line(step[2], 30, nil, 20, "^绝壁|^平台") == false then
        return -1
    end
    if step[2] == "climb down" then
        env.current.name = "平台"
        env.current.exits = {}
        if wait_no_busy() < 0 then
            return -1
        end
    end
    env.current.id = { var.goto.path[msg].next }
    return 0
end

function quanzhen_cliff()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ quanzhen_cliff ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^悬崖|^崖顶|"..
                                                                                              "^你还在忙着呢。$"..
                                                                                              "^四面光溜溜的崖陡如壁，你轻功不够，怎么也爬不上去。$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "四面光溜溜的崖陡如壁，你轻功不够，怎么也爬不上去。" then
        map_adjust("全真悬崖", "关闭")
        return 1,"移动调整"
    elseif l[0] == "你还在忙着呢。" then
        wait(0.1)
        if wait_no_busy() < 0 then
            return -1
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        return quanzhen_cliff()
    else
        run("look")
        if wait_no_busy() < 0 then
            return -1
        end
        if locate() < 0  then
            return -1
        end
        if set.has(env.current.id, var.goto.path[msg].next) then
            env.current.id = { var.goto.path[msg].next }
            return 0
        else
            return 1,"移动调整"
        end
    end
end

local beijing_gate_list = {
    [2304] = true, [2306] = true, [2324] = true, [2323] = true,
    [2314] = true, [2313] = true, [2331] = true, [2336] = true,
    [2294] = true, [2403] = true, [2290] = true
}

function beijing_gate()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ beijing_gate ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^(\\S+)\\s+- |"..
                                                                                              "^这个方向没有出路。$|^什么\\?$|"..
                                                                                              "^官兵拦住你说道：站住，把\\S+留下再说！$|"..
                                                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                                                              "^鬼门关 - $|"..
                                                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[1] == false then
        if l[0] == "什么?" or l[0] == "这个方向没有出路。" then
            if beijing_gate_list[msg] ~= nil then
                map_adjust("北京城门", "关闭", "北京城墙", "开放")
                return 1,"移动调整"
            end
        end
        l = wait_line("jump wall", 30, nil, 20, "^你一个轻旋，潇洒落地。$|"..
                                                "^就你这点功夫还想飞檐走壁？$")
        if l == false then
            return -1
        elseif l[0] == "就你这点功夫还想飞檐走壁？" then
            map_adjust("北京城墙", "关闭")
            return 1,"移动调整"
        end
        wait(3)
        global.flood = 0
        if wait_no_busy() < 0 then
            return -1
        end
    end
    if wait_line(nil, 30, nil, 20, "^> $") == false then
        return -1
    end
    env.current.id = { var.goto.path[msg].next }
    return 0
end

function quanzhou_gate()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ quanzhou_gate ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                                                              "^这个方向没有出路。$|^什么\\?$|"..
                                                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                                                              "^鬼门关 - $|"..
                                                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "什么?" or l[0] == "这个方向没有出路。" then
        map_adjust("泉州城门", "关闭")
        return 1,"移动调整"
    else
        if wait_line(nil, 30, nil, 20, "^> $") == false then
            return -1
        else
            env.current.id = {var.goto.path[msg].next}
            return 0
        end
    end
end

function emei_99guai()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ emei_99guai ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    if env.current.name == "树上" then
        if wait_no_busy() < 0 then
            return -1
        end
        if wait_line("kill ju mang", 30, nil, 20, "^巨蟒全身扭曲，翻腾挥舞，终於僵直而死了。$|^这里没有这个人。$") == false then
            return -1
        end
        local l = wait_line("down", 30, {StopEval=true}, 20, "^九十九道拐 - |"..
                                                             "^你的眼前一黑，接著什么也不知道了....$|"..
                                                             "^你已经精疲力尽，动弹不得。$|"..
                                                             "^鬼门关 - $|"..
                                                             "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        elseif wait_line(nil, 30, nil, 20, "^> $") == false then
            return -1
        end
        if locate() < 0 then
            return -1
        end
        return 1,"移动调整"
    else
        local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                                                                  "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                                  "^你已经精疲力尽，动弹不得。$|"..
                                                                                                  "^鬼门关 - $|"..
                                                                                                  "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
        l = wait_line("eat busy", 30, nil, 20, "^你身上没有 busy 这样食物。$|"..
                                               "^你正忙着呢，先忍忍吧。$")
        if l == false then
            return -1
        elseif l[0] == "你正忙着呢，先忍忍吧。" then
            if wait_line(nil, 30, nil, 20, "^树上 - ") == false then
                return -1
            end
            env.current.id = { 1718 }
            if wait_no_busy() < 0 then
                return -1
            end
            if wait_line("kill ju mang", 30, nil, 20, "^巨蟒全身扭曲，翻腾挥舞，终於僵直而死了。$|^这里没有这个人。$") == false then
                return -1
            end
            l = wait_line("down", 30, {StopEval=true}, 20, "^九十九道拐 - |"..
                                                           "^你的眼前一黑，接著什么也不知道了....$|"..
                                                           "^你已经精疲力尽，动弹不得。$|"..
                                                           "^鬼门关 - $|"..
                                                           "^一道闪电从天降下，直朝你劈去……结果没打中！$")
            if l == false then
                return -1
            elseif var.goto.pause ~= nil then
                return 1,"移动暂停"
            elseif wait_line(nil, 30, nil, 20, "^> $") == false then
                return -1
            end
            if locate() < 0 then
                return -1
            end
            return 1,"移动调整"
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            env.current.id = { var.goto.path[msg].next }
            return 0
        end
    end
end

function nanjiang_desert()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ nanjiang_desert ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    if run_hp() < 0 then
        return -1
    end
    if state.drink <= 0 then
        rc = feed("desert")
        if rc < 0 then
            return -1
        elseif rc == 1 then
            map_adjust("南疆沙漠", "关闭")
            if env.current.name ~= "南疆沙漠" then
                return 1,"移动调整"
            end
        end
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                                                              "^你已经感到不行了，冥冥中你觉得有人把你抬到天山脚下。$|"..
                                                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                                                              "^鬼门关 - $|"..
                                                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "你已经感到不行了，冥冥中你觉得有人把你抬到天山脚下。" then
        if wait_line(nil, 30, {StopEval=true}, 20, "^你的眼前一黑，接著什么也不知道了....$") == false then
            return -1
        end
        env.current.id = {1328}    
        return 1,"移动暂停"
    end
    if wait_line(nil, 30, nil, 20, "^> $") == false then
        return -1
    else
        env.current.id = { var.goto.path[msg].next }
        return 0
    end
end

local kitchen_check_item = {
    [432] = {"酥油茶:tea"},
    [681] = {"水蜜桃:tao","香茶:tea"},
    [760] = {"汽锅鸡:qiguo ji","烤鸭:kaoya","水蜜桃:tao","香茶:tea"},
    [791] = {"汽锅鸡:qiguo ji","烤鸭:kaoya","水蜜桃:tao","香茶:tea"},
    [1107] = {"小米粥:xiaomi zhou"},
    [1738] = {"汽锅鸡:qiguo ji","烤鸭:kaoya","水蜜桃:tao","岁寒三友:suihan sanyou","荷花办蒸鸡:hehua ji","鲜菱荷叶羹:heye geng"},
    [2685] = {"汽锅鸡:qiguo ji","高粱米饭:rice","野菜汤碗:soup"}
}

function kitchen()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ kitchen ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc,msg
    end
    local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^(\\S+)\\s+- |"..
                                                                                              "^老师傅拦着你说：你想把食物拿去哪里？东西放下再走。$|"..
                                                                                              "^小翠把嘴一撇：吃饱了喝足了还不够，临走怀里还揣上一些，小女子也替您脸红呢！$|"..
                                                                                              "^小翠对你道了个万福：张真人吩咐，饮食不得带出茶房。$|"..
                                                                                              "^吃饱喝足了还要外带酒菜，你想把长乐帮坐吃山空吗？$|"..
                                                                                              "^别着急，喝完茶再走 !$|"..
                                                                                              "^烧饭师傅瞪着一双怪眼：吃不了要兜着走啊？$|"..
                                                                                              "^小师弟拦著你说：您别急，还是把东西吃完再走吧。$|"..
                                                                                              "^哑仆拦着你，指了指你拿着的食物，摇了摇头。$|"..
                                                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                                                              "^鬼门关 - $|"..
                                                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[1] ~= false then
        env.current.id = { var.goto.path[msg].next }
        return 0
    else
        if run_i() < 0 then
            return -1
        end
        local trash = {}
        for _,v in ipairs(kitchen_check_item[msg]) do
            if carryon.inventory[v] ~= nil then
                trash[v] = carryon.inventory[v].count
            end
        end
        if table.is_empty(trash) == false then
            if drop(trash) ~= 0 then
                return -1
            end
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        else
            return kitchen()
        end
    end
end

local dynamic_exit_exclude = {
    [1299] = {"northwest"},
    [1302] = {"northeast"},
    [1432] = {"westup", "northup"},
    [1434] = {"eastdown"},
    [1529] = {"southdown"}
}

function dynamic_exit()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dynamic_exit ］")
    var.goto.dynamic_exit = var.goto.dynamic_exit or {}
    local rc,msg = event_locate()
    if rc > 0 then
        return dynamic_exit_return(rc, msg)
    end
    var.goto.dynamic_exit.room_id = msg
    if type(env.current.exits) == "string" then
        if env.current.exits == "" then
            env.current.exits = {}
        else
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
    end
    if #env.current.exits == 0 then
        if wait_line("look", 30, nil, 20, "^\\S+\\s+- ", "^> $") == false then
            return dynamic_exit_return(-1)
        end
        if env.current.exits == "" then
            env.current.exits = {}
        else
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
    end
    if var.goto.pause ~= nil then
        return dynamic_exit_return(1, "移动暂停")
    end
    rc,msg = dynamic_exit_exec(set.compl(env.current.exits, dynamic_exit_exclude[msg] or {}))
    if rc ~= nil then
        return dynamic_exit_return(rc, msg)
    end
    if wait_line("look", 30, nil, 20, "^\\S+\\s+- ", "^> $") == false then
        return dynamic_exit_return(-1)
    end
    env.current.id = { msg }
    if var.goto.pause ~= nil then
        return dynamic_exit_return(1, "移动暂停")
    else
        return dynamic_exit()
    end
end

function dynamic_exit_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ dynamic_exit_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.goto.dynamic_exit == nil then
        return rc,msg
    end
    var.goto.dynamic_exit = nil
    return rc,msg
end

function dynamic_exit_exec(exits)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ peach_grove ］参数：exits = "..table.tostring(exits))
    local dir,rc
    while #exits > 0 do
        dir = set.pop(exits)
        if (var.goto.dynamic_exit.room_id == 1433 or var.goto.dynamic_exit.room_id == 1301) and 
           var.goto.path[var.goto.dynamic_exit.room_id].step ~= nil and 
           get_reverse_dir(dir) == var.goto.path[var.goto.dynamic_exit.room_id].step then
            set.insert(exits, 1, dir)
            var.goto.path[var.goto.dynamic_exit.room_id].step = "go"
        else
            break
        end
    end
    if dir == nil then
        return
    end
    if #exits > 0 then
        rc = look_dir(dir)
    end
    if rc == -1 then
        return -1
    elseif rc == 1 then
        return
    else
        if rc == 0 then
            if locate_nextto() < 0 then
                return -1
            end
        else
            env.nextto.id = {}
        end
        if set.has(env.nextto.id, var.goto.path[var.goto.dynamic_exit.room_id].next) then
            local l = wait_line(dir, 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                              "^这个方向没有出路。$|^什么\\?$|"..
                                                              "^你的眼前一黑，接著什么也不知道了....$|"..
                                                              "^你已经精疲力尽，动弹不得。$|"..
                                                              "^鬼门关 - $|"..
                                                              "^一道闪电从天降下，直朝你劈去……结果没打中！$")
            if l == false then
                return -1
            elseif var.goto.pause ~= nil then
                return 1,"移动暂停"
            elseif l[0] == "这个方向没有出路。" or l[0] == "什么?" then
                return
            else
                env.current.id = {var.goto.path[var.goto.dynamic_exit.room_id].next}
                var.goto.path[env.current.id[1]].step = dir
                if wait_line(nil, 30, nil, 20, "^> $") == false then
                    return -1
                else
                    return 0
                end
            end
        elseif #exits == 1 then
            dir = exits[1]
            l = wait_line(dir, 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                        "^这个方向没有出路。$|^什么\\?$|"..
                                                        "^你的眼前一黑，接著什么也不知道了....$|"..
                                                        "^你已经精疲力尽，动弹不得。$|"..
                                                        "^鬼门关 - $|"..
                                                        "^一道闪电从天降下，直朝你劈去……结果没打中！$")
            if l == false then
                return -1
            elseif var.goto.pause ~= nil then
                return 1,"移动暂停"
            elseif l[0] == "这个方向没有出路。" or l[0] == "什么?" then
                return
            else
                if wait_line(nil, 30, nil, 20, "^> $") == false then
                    return -1
                end
                if locate() < 0 then
                    return -1
                end
                var.goto.path[env.current.id[1]].step = dir
                if #env.current.id == 1 then
                    return 0
                else
                    return 1,"移动调整"
                end
            end
        elseif #exits == 0 then
            l = wait_line(dir, 30, {StopEval=true}, 20, "^\\S+\\s+- |"..
                                                        "^这个方向没有出路。$|^什么\\?$|"..
                                                        "^你脚下一滑，踩了个空！$|"..
                                                        "^你的眼前一黑，接著什么也不知道了....$|"..
                                                        "^你已经精疲力尽，动弹不得。$|"..
                                                        "^鬼门关 - $|"..
                                                        "^一道闪电从天降下，直朝你劈去……结果没打中！$")
            if l == false then
                return -1
            elseif var.goto.pause ~= nil then
                return 1,"移动暂停"
            elseif l[0] == "这个方向没有出路。" or l[0] == "什么?" then
                return
            elseif l[0] == "你脚下一滑，踩了个空！" then
                env.current.id = {1527}
                return 1,"移动调整"
            else
                if wait_line(nil, 30, nil, nil, "^> $") == false then
                    return -1
                end
                if #env.nextto.id == 1 then
                    env.current.id = {env.nextto.id[1]}
                    if env.current.id[1] == var.goto.path[var.goto.dynamic_exit.room_id].next then
                        var.goto.path[env.current.id[1]].step = dir
                        return 0
                    end
                elseif #env.nextto.id > 1 then
                    env.current.id = set.copy(env.nextto.id)
                end
                return 1,"移动调整"
            end
        end
    end
    return dynamic_exit_exec(exits)
end

local peach_grove_dir = {
    ["子"] = "east",      ["辰"] = "northeast", ["申"] = "south",
    ["丑"] = "southeast", ["巳"] = "northeast", ["酉"] = "northwest",
    ["寅"] = "southeast", ["午"] = "west",      ["戌"] = "north",
    ["卯"] = "southwest", ["未"] = "south",     ["亥"] = "north"
}

function peach_grove()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ peach_grove ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc, msg
    end
    if var.goto.room_ids[var.goto.index] == 1759 then
        if wait_line("look", 30, nil, nil, "^桃花林 - $", "^> $") == false then
            return -1
        end
        env.current.id = { 1759 }
        return 0
    end
    local l
    if msg == 1758 then
        msg = is_own("铁八卦:tie bagua")
        if type(msg) ~= "boolean" then
            l = wait_line("get tie bagua from "..msg, 30, nil, 20, "^你从\\S+中拿出\\S+。$|"..
                                                                   "^你找不到 \\S+ 这样东西。$|"..
                                                                   "^你附近没有这样东西。$|"..
                                                                   "^那里面没有任何东西。$")
            if l == false then
                return -1
            elseif not string.match(l[0], "拿出") then
                if run_i() < 0 then
                    return -1
                end
                if var.goto.pause ~= nil then
                    return 1,"移动暂停"
                end
                return peach_grove()
            end
            carryon.inventory["铁八卦:tie bagua"] = { name = "铁八卦", id = "tie bagua", count = 1, seq = { "1" } }
            if var.goto.pause ~= nil then
                return 1,"移动暂停"
            end
        end
        if msg ~= false then
            if wait_line("put tie bagua in stone", 30, nil, 20, "^小径 - ", "^> $") == false then
                return -1
            end
            env.current.id = { 1719 }
            return 0
        else
            l = wait_line("north", 30, {StopEval=true}, 20, "^(桃花林) - |"..
                                                            "^你的眼前一黑，接著什么也不知道了....$|"..
                                                            "^你已经精疲力尽，动弹不得。$|"..
                                                            "^鬼门关 - $|"..
                                                            "^一道闪电从天降下，直朝你劈去……结果没打中！$")
            if l == false then
                return -1
            elseif var.goto.pause ~= nil then
                return 1,"移动暂停"
            end
        end
    else
        if wait_line("time", 30, nil, 20, "^现在泥潭时间是\\S+年\\S+月\\S+。$") == false then
            return -1
        end
        l = wait_line(peach_grove_dir[env.mud_time[4]], 30, {StopEval=true}, 20, "^((?:小径|桃花林)) - |"..
                                                                                 "^你的动作还没有完成，不能移动。$|"..
                                                                                 "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                 "^你已经精疲力尽，动弹不得。$|"..
                                                                                 "^鬼门关 - $|"..
                                                                                 "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        end
        if wait_no_busy() < 0 then
            return -1
        end
        if var.goto.pause ~= nil then
            return 1,"移动暂停"
        end
    end
    if l[1] == "小径" then
        env.current.id = { 1719 }
        return 0
    else
        env.current.id = { 1759 }
        return peach_grove()
    end
end

function hotel()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ hotel ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc, msg
    end
    local money
    if carryon.inventory["铜钱:coin"] ~= nil and carryon.inventory["铜钱:coin"].count >= 500 then
        money = "500 coin"
    elseif carryon.inventory["白银:silver"] ~= nil and carryon.inventory["白银:silver"].count >= 5 then
        money = "5 silver"
    else
        if wait_line("score;i", 30, nil, 20, "^你身上带着\\S+件物品\\(负重\\s*\\d+%\\)：$|^目前你身上没有任何东西。$", "^> $") then
            return -1
        end
    end
    if var.goto.pause ~= nil then
        return 1,"移动暂停"
    end
    if carryon.inventory["铜钱:coin"] ~= nil and carryon.inventory["铜钱:coin"].count >= 500 then
        money = "500 coin"
    elseif carryon.inventory["白银:silver"] ~= nil and carryon.inventory["白银:silver"].count >= 5 then
        money = "5 silver"
    end
    if money == nil then
        if carryon.money + profile.balance >= 500 then
            local var_goto = var.goto
            var.goto = {room_ids = {1028}, index = 1, thread = var_goto.thread, event = true, report = true}
            if goto_move() ~= 0 then
                return -1
            else
                if var.goto.event == true then
                    var_goto.pause = var.goto.pause
                    var.goto = var_goto
                else
                    var.goto.event = nil
                    return 1
                end
            end
            if var.goto.pause == nil then
                rc = draw(500 - (((carryon.inventory["白银:silver"] or {}).count or 0) * 100))
                if rc < 0 then
                    return -1
                elseif rc == 1 then
                    rc = draw(500 - carryon.money)
                    if rc ~= 0 then
                        return -1
                    else
                        if carryon.inventory["铜钱:coin"].count > 0 then
                            if wait_line("convert "..tostring(carryon.inventory["铜钱:coin"].count).." coin to silver", 30, nil, nil, "^掌柜的点点头，将你从身上取出的\\S+换成了\\S+。$") == false then
                                return -1
                            end
                        end
                    end
                end
            end
            return 1,"移动调整"
        else
            show("钱不够", "orange")
            return -1
        end
    end
    if wait_line("give "..money.." to xiao er", 30, nil, 20, "^小二对你笑笑，说：这房间很不错吧!$") == false then
        return -1
    end
    env.current.zone = { map[msg].zone }
    return 0
end

local xiyu_desert_dir = {[1327] = "east", [1826] = "west"}

function xiyu_desert()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ xiyu_desert ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc, msg
    end
    repeat
        local next_id = var.goto.adjust or var.goto.path[msg].next
        local l = wait_line(xiyu_desert_dir[next_id], 30, {StopEval=true}, 20, "^(\\S+) - |"..
                                                                                               "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                               "^你已经精疲力尽，动弹不得。$|"..
                                                                                               "^鬼门关 - $|"..
                                                                                               "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            return 1,"移动暂停"
        elseif l[1] ~= "大沙漠" then
            env.current.id = { next_id }
            return 0
        end
    until false
end

function heifeng()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ heifeng ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc, msg
    end
    if state.nl > state.nl_max / 15 then
        local l = wait_line(var.goto.path[var.goto.path[msg].next].step, 30, {StopEval=true}, 20, "^黑风口 - |"..
                                                                                                  "^你的眼前一黑，接著什么也不知道了....$|"..
                                                                                                  "^你已经精疲力尽，动弹不得。$|"..
                                                                                                  "^鬼门关 - $|"..
                                                                                                  "^一道闪电从天降下，直朝你劈去……结果没打中！$")
        if l == false then
            return -1
        elseif var.goto.pause ~= nil then
            if l[0] == "你的眼前一黑，接著什么也不知道了...." then
                env.current.id = { 1489 }
            end
            return 1,"移动暂停"
        end
        env.current.id = { 1494 }
        return 0
    else
        if dazuo() ~= 0 then
            return -1
        else
            if var.goto.pause ~= nil then
                return 1,"移动暂停"
            else
                return heifeng()
            end
        end
    end
end

function tiesuo()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ tiesuo ］")
    local rc,msg = event_locate()
    if rc > 0 then
        return rc, msg
    end
    local l = wait_line("zou tiesuo", 30, nil, 20, "^(?:仙愁门|百丈涧) - |"..
                                                   "^你从山坡上咕碌咕碌地滚了下来，只觉得浑身无处不疼，还受了几处伤。$|"..
                                                   "^你的眼前一黑，接著什么也不知道了....$|"..
                                                   "^你已经精疲力尽，动弹不得。$|"..
                                                   "^鬼门关 - $|"..
                                                   "^一道闪电从天降下，直朝你劈去……结果没打中！$")
    if l == false then
        return -1
    elseif var.goto.pause ~= nil then
        return 1,"移动暂停"
    elseif l[0] == "你从山坡上咕碌咕碌地滚了下来，只觉得浑身无处不疼，还受了几处伤。" then
         map_adjust("灵鹫索桥", "禁用")
         env.current.id = { 2157 }
        return 1,"移动调整"
    else
        if calibration["灵鹫索桥"][1] == "禁用" then
            map_adjust("灵鹫索桥", "启用")
        end
        env.current.id = { var.goto.path[msg].next }
        return 0
    end
end