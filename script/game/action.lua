require "general"
require "recover"
require "fight"

function wait_no_busy(action)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wait_no_busy ］参数：action = "..tostring(action))
    var.wait_no_busy = var.wait_no_busy or {}
    if var.wait_no_busy.stop == true then
        return wait_no_busy_return(1)
    end
    local l = wait_line((action or "")..";eat busy", 30, nil, 10, "^你正忙着呢，先忍忍吧。$|^你身上没有 busy 这样食物。$")
    if l == false then
        return wait_no_busy_return(-1)
    elseif l[0] == "你身上没有 busy 这样食物。" then
        return wait_no_busy_return(0)
    else
        wait(0.1)
        return wait_no_busy_return(wait_no_busy(action))
    end
end

function wait_no_busy_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wait_no_busy ］参数：rc = "..tostring(rc))
    var.wait_no_busy = nil
    return rc
end

function wait_no_fight()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wait_no_fight ］")
    var.wait_no_fight = var.wait_no_fight or {}
    if var.wait_no_fight.stop == true then
        return wait_no_fight_return(1)
    end
    local rc = is_fighting()
    if rc < 0 then
        return -1
    elseif rc == 0 then
        return 0
    else
        wait(0.1)
        return wait_no_fight_return(wait_no_fight())
    end
end

function wait_no_fight_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ wait_no_fight_return ］参数：rc = "..tostring(rc))
    var.wait_no_fight = nil
    return rc
end

function look_dir(dir)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ look_dir ］参数：dir = "..tostring(dir))
    var.look_dir = var.look_dir or {}
    var.look_dir.dir = dir
    env.room = env.nextto
    trigger.add("look_dir", "", nil, {Enable=true, Gag=true}, nil, "^.*")
    local l = wait_line("look "..dir, 30, nil, 10, "^你要看什么？$|^\\S+\\s+-\\s+$")
    if l == false then
        return look_dir_return(-1)
    elseif l[0] == "你要看什么？" then
        return look_dir_return(1, l[0])
    else
        if wait_line(nil, 30, nil, 10, "^> $") == false then
            return look_dir_return(-1)
        else
            return look_dir_return(0)
        end
    end
end

function look_dir_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ look_dir_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.look_dir == nil then
        return rc,msg
    end
    var.look_dir = nil
    trigger.delete("look_dir")
    env.room = env.current
    return rc,msg
end

function one_step(layer)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ one_step ］参数：layer = "..tostring(layer))
    if var.move == false then
        return one_step_return(1, "移动失败")
    end
    if var.one_step == nil then
        var.one_step = { layer = 0 }
    else
        if var.one_step.layer + 1 ~= (layer or 0) then
            return one_step_return(1, "重复循环")
        end
        var.one_step.layer = var.one_step.layer + 1
    end
    local rc,msg,nid = one_step_get_dir()
    if rc ~= 0 then
        return one_step_return(rc, msg)
    else
        rc,msg = one_step_exec(msg)
        if rc ~= nil then
            return one_step_return(rc, msg)
        end
    end
    if wait_line(nil, 30, nil, 10, "^> $") == false then
        return one_step_return(-1)
    end
    if nid ~= nil then
        env.current.id = { nid }
    end
    return one_step_return(0, msg)
end

function one_step_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ one_step_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.one_step == nil then
        return rc,msg
    end
    var.one_step = nil
    return rc,msg
end

function one_step_get_dir()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ one_step_get_dir ］")
    local dir,next_id
    if #env.current.id ~= 1 and type(env.current.desc) == "table" then
        if locate() < 0 then
            return -1
        end
    end
    if type(env.current.exits) == "string" then
        if env.current.exits == "" then
            env.current.exits = {}
        else
            env.current.exits = string.split(env.current.exits, "[和 、]+")
        end
    end
    if #env.current.exits == 0 then
        return 1,"移动失败"
    end
    if #env.current.id == 1 then
        if map[env.current.id[1]].esc ~= nil then
            for k,v in pairs(map[env.current.id[1]].links) do
                if v == map[env.current.id[1]].esc then
                    dir = k
                    next_id = v
                    break
                end
            end
        end
    end
    if dir == nil then
        local alternative_exits
        if #env.current.id == 1 then
            alternative_exits = {}
            for _,v in ipairs(env.current.exits) do
                if map[env.current.id[1]].links[v] ~= nil then
                    set.append(alternative_exits, v)
                end
            end
            if #alternative_exits == 0 then
                for _,v in ipairs(env.current.exits) do
                    if is_dir(v) == true then
                        for _,i in ipairs(map[env.current.id[1]].links) do
                            local rdir = regular_dir(v..tostring(i))
                            if is_dir() == true then
                                set.append(alternative_exits, rdir)
                                break
                            end
                        end
                    end
                end
            end
            if #alternative_exits == 0 then
                alternative_exits = env.current.exits
            end
        else
            alternative_exits = env.current.exits
        end
        if #alternative_exits > 0 then
            dir = alternative_exits[math.random(1, #alternative_exits)]
        end
        if dir == nil then
            return 1,"移动失败"
        end
        if #env.current.id == 1 then
            next_id = map[env.current.id[1]].links[dir]
        end
    end
    return 0,dir,next_id
end

function one_step_exec(dir)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ one_step_exec ］参数：dir = "..tostring(dir))
    if state.jl < state.jl_max / 10 then
        local rc,msg = yun_refresh()
        if rc ~= 0 then
            return rc,msg
        end
        return one_step_exec(dir)
    end
    local l = wait_line(dir, 30, {StopEval=true}, 10, "^什么\\?$|^这个方向没有出路。$|"..
                                                      "^你的动作还没有完成，不能移动。$|"..
                                                      "^糟糕，你逃跑失败了！$|"..
                                                      "^你已经精疲力尽，动弹不得。$|"..
                                                      "^(\\S+)\\s+-\\s+")
    if l == false then
        return -1
    elseif l[0] == "什么?" or 
           l[0] == "这个方向没有出路。" then
        if wait_line("look", 30, nil, 10, "^\\S+\\s+-\\s+$", "^>\\s+$") == false then
            return -1
        end
        return one_step(var.one_step.layer+1)
    elseif l[0] == "你的动作还没有完成，不能移动。" then
        if wait_no_busy("halt") < 0  then
            return -1
        end
    elseif l[0] == "糟糕，你逃跑失败了！" then
        wait(0.1)
        run("halt")
    elseif l[0] == "你已经精疲力尽，动弹不得。" then
        if run_hp() < 0 then
            return -1
        end
    else
        if l[1] == "鬼门关" then
            return -1
        end
        return nil,dir
    end
    return one_step_exec(dir)
end

function eat(food)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ eat ］参数："..tostring(food))
    var.eat = var.eat or { halt = false }
    local l = wait_line("eat "..food, 30, nil, 10, "^你(?:捧|拿)起\\S+咬了几口。$|"..
                                                   "^你将剩下的\\S+吃得乾乾净净。$|"..
                                                   "^你已经吃太饱了，再也塞不下了！$|"..
                                                   "^你正忙着呢，先忍忍吧。$|"..
                                                   "^看清楚点，这东西能吃吗？$|"..
                                                   "^你身上没有 \\S+ 这样食物。$")
    if l == false then
        return eat_return(-1)
    elseif l[0] == "你正忙着呢，先忍忍吧。" then
        wait(0.1)
        if var.eat.halt == false then
            var.eat.halt = true
            run("halt")
        end
        return eat_return(eat(food))
    elseif l[0] == "看清楚点，这东西能吃吗？" then
        return eat_return(1, l[0])
    elseif string.match(l[0], "你身上没有") then
        if run_i() < 0 then
            return eat_return(-1)
        end
        return eat_return(1, l[0])
    else
        if string.match(l[0], "吃得乾乾净净") then
            if run_i() < 0 then
                return eat_return(-1)
            end
        end
        return eat_return(0, l[0])
    end
end

function eat_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ eat_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.eat == nil then
        return rc,msg
    end
    var.eat = nil
    return rc,msg
end

function drink(water)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drink ］参数："..tostring(water))
    var.drink = var.drink or { halt = false }
    local l = wait_line("drink "..water, 30, nil, 10, "^你(?:拿|捧|端)起\\S+(?:，有滋有味地品了几口|咕噜噜地喝了几口\\S+|，慢慢喝了下去)。$|"..
                                                      "^你拿起饱腹玉猛的啃了一口，结果差点崩了自己的牙，疼的你嗷嗷叫。$|"..
                                                      "^你在盅里舀起一大勺鸡肉带着鸡汤，大口吃了起来。$|"..
                                                      "^你(?:拿|捧|端)起\\S+，把剩下的\\S+一(?:饮|扫)而尽。$|"..
                                                      "^你已经喝太多了，再也灌不下啦。$|"..
                                                      "^你喝了一口井中从天山上流淌下来的雪水，简直比蜜还甜。$|"..
                                                      "^逮着不要钱的水就这么喝，至于吗?|"..
                                                      "^你正忙着呢，先忍忍吧。$|"..
                                                      "^\\S+已经被喝得一滴也不剩了。$|"..
                                                      "^渴啦？可这东西能喝吗？$|"..
                                                      "^你身上没有这样东西。$")
    if l == false then
        return drink_return(-1)
    elseif l[0] == "你正忙着呢，先忍忍吧。" then
        wait(0.1)
        if var.drink.halt == false then
            var.drink.halt = true
            run("halt")
        end
        return drink_return(drink(water))
    elseif l[0] == "渴啦？可这东西能喝吗？" then
        return drink_return(1, l[0])
    elseif string.match(l[0], "你身上没有") or string.match(l[0], "一滴也不剩") then
        if run_i() < 0 then
            return drink_return(-1)
        end
        return drink_return(1, l[0])
    else
        if string.match(l[0], "把剩下的") then
            if run_i() < 0 then
                return drink_return(-1)
            end
        else
            local ll = wait_line(nil, 30, nil, 10, "^你已经将\\S+里的\\S+喝得底朝天了。$|^> $")
            if ll == false then
                return drink_return(-1)
            elseif string.match(ll[0], "底朝天") then
                if run_i() < 0 then
                    return drink_return(-1)
                end
            end
        end
        return drink_return(0, l[0])
    end
end

function drink_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drink_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.drink == nil then
        return rc,msg
    end
    var.drink = nil
    return rc,msg
end

function take(drug)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ take ］参数：drug = "..tostring(drug))
    var.take = var.take or { halt = false }
    local l = wait_line("fu "..drug, 30, {StopEval=true}, 10, "^你吃下一\\S+|"..
                                                              "^你已经吃过一颗了，多吃无益。$|"..
                                                              "^什么\\?$|"..
                                                              "^你要服用什么？$")
    if l == false then
        return take_return(-1)
    elseif l[0] == "什么?" then
        wait(0.1)
        if var.take.halt == false then
            var.take.halt = true
            run("halt")
        end
        return take_return(take(drug))
    else
        if run_i() < 0 then
            return take_return(-1)
        end
        if l[0] == "你要服用什么？" or l[0] == "你已经吃过一颗了，多吃无益。" then
            return take_return(1, l[0])
        else
            return take_return(0)
        end
    end
end

function take_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ take_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.take == nil then
        return rc,msg
    end
    var.take = nil
    return rc,msg
end

function buy(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ buy ］参数：list = "..table.tostring(list))
    var.buy = var.buy or { surplus = {} }
    for k,v in pairs(list) do
        if items[k] == nil then
            var.buy.surplus[k] = v
        else
            local rc = buy_exec(k, v)
            if rc ~= nil then
                return buy_return(rc)
            end
        end
    end
    if table.is_empty(var.buy.surplus) then
        return buy_return(0)
    else
        return buy_return(1, var.buy.surplus)
    end
end

function buy_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ buy_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.buy == nil then
        return rc,msg
    end
    var.buy = nil
    return rc,msg
end

function buy_exec(item, count)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ buy_exec ]参数：item = "..tostring(item)..", count = "..tostring(count))
    if count == 0 then
        return
    end
    local batch = math.min(10, count)
    if items[item].group == "weapon" or 
       items[item].group == "equpment" then
        batch = math.min(8, count)
    end
    local l = wait_line("buy "..tostring(batch).." "..items[item].id, 30, {StopEval=true}, 10, "^你从\\S+那里买下了\\S+。$|"..
                                                                                               "^哟，抱歉啊，我这儿正忙着呢……您请稍候。$|"..
                                                                                               "^你想买的东西我这里没有。$|"..
                                                                                               "^穷光蛋，一边呆着去！$")
    if l == false then
        return -1
    elseif l[0] == "哟，抱歉啊，我这儿正忙着呢……您请稍候。" then
        wait(0.1)
        return buy_exec(item, count)
    elseif l[0] == "你想买的东西我这里没有。" or 
           l[0] == "穷光蛋，一边呆着去！" then
        var.buy.surplus[item] = count
        return
    else
        return buy_exec(item, count - batch)
    end
end

function qu(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ qu ］参数：list = "..table.tostring(list))
    var.qu = var.qu or { mapping = {} }
    local rc,msg
    if env.current.name ~= "存物室" then
        rc = goto(290)
        if rc ~= 0 then
            return rc
        end
    end
    for k,v in pairs(list) do
        if items[k] ~= nil and 
           carryon.repository[items[k].name] ~= nil then
            for _,i in ipairs(carryon.repository[items[k].name].index) do
                var.qu.mapping[tonumber(i)] = k
            end
        end
    end
    var.qu.index = table.index(var.qu.mapping)
    set.reverse(var.qu.index)
    for _,v in ipairs(var.qu.index) do
        rc,msg = qu_exec(list, v)
        if rc ~= nil then
            return qu_return(rc, msg)
        end
    end
    if var.qu.refresh ~= nil then
       if run_i() < 0 then
           return qu_return(-1)
       end
       if var.qu.refresh == true then
           if run_list() < 0 then
               return -1
           end
       end
    end
    if table.is_empty(list) then
        return qu_return(0)
    else
        return qu_return(1, list)
    end
end

function qu_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ qu_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.qu == nil then
        return rc,msg
    end
    var.qu = nil
    return rc,msg
end

function qu_exec(list, index)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ qu_exec ］参数：list = "..table.tostring(list)..", index = "..tostring(index))
    local item = var.qu.mapping[index]
    if list[item] == 0 then
        list[item] = nil
        return
    end
    local l = wait_line("qu "..tostring(index), 30, {StopEval=true}, 10, "^你取(?:出|光)了(\\S+)$")
    if l == false then
        return -1
    elseif l[1] == items[item].name then
        list[item] = list[item] - 1
        carryon.repository[items[item].name].count = carryon.repository[items[item].name].count - 1
        if string.match(l[0], "取光") then
            var.qu.refresh = true
            if list[item] == 0 then
                list[item] = nil
            end
            return
        end
        var.qu.refresh = var.qu.refresh or false
    else
        if run_list() < 0 or 
           run_i() < 0 then
            return -1
        end
        for k,v in pairs(carryon.inventory) do
            if v.name == l[1] then
                l = wait_line("cun "..k, 30, {StopEval=true}, 10, "^你将\\S+保存了起来。$")
                if l == false then
                    return -1
                else
                    break
                end
            end
        end
        return qu(list)
    end
    return qu_exec(list, index)
end

function drop(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drop ］参数：list = "..table.tostring(list))
    var.drop = var.drop or {}
    for k,v in pairs(list) do
        local rc = drop_exec(k, v)
        if rc ~= nil then
            return drop_return(rc)
        end
    end
    return drop_return(0)
end

function drop_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drop_return ］参数：rc = "..tostring(rc))
    if var.drop == nil then
        return rc
    end
    var.drop = nil
    return rc
end

function drop_exec(item, count)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drop_exec ］参数：item = "..tostring(item)..", count = "..tostring(count))
    if carryon.inventory[item] == nil or 
       count == 0 then
        return
    end
    var.drop.item = item
    var.drop.count = count
    if items[item] == nil or 
       items[item].stack == nil then
        return drop_nonstack(carryon.inventory[item])
    else
        return drop_stack(carryon.inventory[item])
    end
end

function drop_nonstack(carry, seq)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drop_nonstack ］参数：carry = "..table.tostring(carry)..", seq = "..tostring(seq))
    if var.drop.count == 0 or 
       carry.count == 0 then
        if run_i() < 0 then
            return -1
        end
        return
    end
    if seq == nil then
        seq = " "..(set.pop(carry.seq) or "1")
        if seq == " 1" then
            seq = ""
        end
    end
    local l = wait_line("drop "..carry.id..seq, 30, {StopEval=true}, 10, "^你现在正忙着呢。$|"..
                                                                         "^你丢下\\S+。$|"..
                                                                         "^你身上没有这样东西。$")
    if l == false then
        return -1
    elseif l[0] == "你现在正忙着呢。" then
        wait(0.1)
        return drop_nonstack(carry, seq)
    elseif l[0] == "你身上没有这样东西。" then
        carry.count = 0
    else
        var.drop.count = var.drop.count - 1
        carry.count = carry.count - 1
    end
    return drop_nonstack(carry)
end

function drop_stack(carry)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ drop_stack ］参数：carry = "..table.tostring(carry))
    if global.flood > config.flood_control then
        wait(1)
        global.flood = 0
    end
    if var.drop.count == 0 or 
       carry.count == 0 then
        if run_i() < 0 then
            return -1
        end
        return
    end
    local l = wait_line("drop "..tostring(math.min(var.drop.count, carry.count)).." "..carry.id, 30, {StopEval=true}, 10, "^你现在正忙着呢。$|"..
                                                                                                                                   "^你丢下\\S+。$|"..
                                                                                                                                   "^你身上没有这样东西。$")
    if l == false then
        return -1
    elseif l[0] == "你现在正忙着呢。" then
        wait(0.1)
    else
        var.drop.count = var.drop.count - math.min(var.drop.count, carry.count)
        carry.count = carry.count - math.min(var.drop.count, carry.count)
    end
    return drop_stack(carry)
end

function draw(money)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ draw ］参数：money = "..tostring(money))
    if env.current.name ~= "钱庄" then
        local rc = goto(1028)
        if rc ~= 0 then
            return rc
        end
    end
    local exchange,currency = {},{"coin", "silver", "gold"}
    while money > 0 do
        set.append(exchange, math.min(1001, money))
        if exchange[#exchange] > 1000 then
            exchange[#exchange] = money % 100
        end
        money = (money - exchange[#exchange]) / 100
    end
    for k,v in ipairs(exchange) do
        if v > 0 then
            local l = wait_line("qu "..tostring(v).." "..currency[k], 30, nil, 10, "^掌柜的点点头，从内屋里取出\\S+交到你手里。$|"..
                                                                                   "^掌柜的笑道：请壮士赎罪，但您存在本庄的钱物不够这个数儿。$|"..
                                                                                   "^掌柜的笑道：「这位\\S+还是头一次光临本庄吧？」$")
            if l == false then
                return -1
            elseif not string.match(l[0], "交到你手里") then
                return 1
            end
        end
    end
    return 0
end

function deposit(money)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ deposit ］参数：money = "..tostring(money))
    if env.current.name ~= "钱庄" then
        local rc = goto(1028)
        if rc ~= 0 then
            return rc
        end
    end
    local exchange,currency = {},{"gold", "silver", "coin"}
    set.append(exchange, math.min(math.modf(money / 10000), (carryon.inventory["黄金:gold"] or {}).count or 0))
    money = money - exchange[1] * 10000
    set.append(exchange, math.min(math.modf(money / 100), (carryon.inventory["白银:silver"] or {}).count or 0))
    money = money - exchange[2] * 100
    set.append(exchange, math.min(money, (carryon.inventory["铜钱:coin"] or {}).count or 0))
    money = money - exchange[3]
    for k,v in ipairs(exchange) do
        if v > 0 then
            local l = wait_line("cun "..tostring(v).." "..currency[k], 30, nil, 10, "^掌柜的点点头，将你拿出的\\S+放进了内屋。$|"..
                                                                                    "^掌柜的笑道：\\S+您怕是没带够\\S+吧？$")
            if l == false then
                return -1
            elseif string.match(l[0], "没带够") then
                if run_i() < 0 then
                    return -1
                else
                    return 1
                end
            end
        end
    end
    if money > 0 then
        return 1
    else
        return 0
    end
end

function get_from_container(item, container, count)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ get_from_container ］参数：item = "..tostring(item)..", container = "..tostring(container)..", count = "..tostring(count))
    if carryon.container[container] == nil then
        return 1
    end
    if carryon.container[container][item] == nil or 
       carryon.container[container][item].count <= 0 then
        return 1
    end
    if count == nil then
        count = ""
    end
    if type(count) == "number" then
        count = " "..tostring(count)
    end
    local l = wait_line("get"..count.." "..carryon.container[container][item].id.." from "..container, 30, nil, 10, "^你从\\S+中拿出\\S+。$|"..
                                                                                                                    "^你找不到 \\S+ 这样东西。$|"..
                                                                                                                    "^你上一个动作还没有完成！$|"..
                                                                                                                    "^你附近没有这样东西。$|"..
                                                                                                                    "^那里面没有任何东西。$")
    if l == false then
        return -1
    elseif string.match(l[0], "没有完成！") then
        wait(0.1)
        return get_from_container(item, container, count)
    end
    if run_i() < 0 then
        return -1
    end
    if string.match(l[0], "中拿出") then
        return 0
    end
    return 1
end

function pack(box, list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ pack ］box = "..tostring(box)..", list = "..table.tostring(list))
    var.pack = var.pack or { refresh = false, list = list}
    trigger.add("hide_pack_ga", "", nil, {Enable=true, Gag=true}, 1, "^> $")
    for k,_ in pairs(list) do
        if items[k] == nil or 
           items[k].stack == nil then
            rc = pack_nonstack(box, k)
            if rc ~= nil then
                return pack_return(rc, list)
            end
        else
            rc = pack_stack(box, k)
            if rc ~= nil then
                return pack_return(rc, list)
            end
        end
        if var.pack.refresh == true then
            var.pack.refresh = false
            if run_i() < 0 then
                return pack_return(-1)
            end
        end
    end
    if table.is_empty(list) then
        return pack_return(0)
    else
        return pack_return(1, list)
    end
end

function pack_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ pack_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.pack == nil then
        return rc,msg
    end
    trigger.delete("hide_pack_ga")
    if var.pack.refresh == true then
        if run_i() < 0 then
            return -1
        end
    end
    var.pack = nil
    return rc,msg
end

function pack_stack(box, item)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ pack_stack ］参数：box = "..tostring(box)..", item = "..tostring(item))
    if var.pack.list[item] == 0 then
        var.pack.list[item] = nil
        return
    end
    if carryon.inventory[item] == nil then
        var.pack.refresh = true
        return
    end
    local count = math.min(var.pack.list[item], carryon.inventory[item].count)
    if count == 0 then
        var.pack.refresh = true
        return
    end
    local l = wait_line("put "..tostring(count).." "..items[item].id.." in "..box, 30, {StopEval=true}, 10, "^你将\\S+放进(?:食盒|皮腰带|布袋)。$|"..
                                                                                                            "^\\S+对(?:食盒|皮腰带|布袋)而言太重了。$|"..
                                                                                                            "^你先忙完再说吧。$|"..
                                                                                                            "^这里没有 \\S+ 这个容器或不能将物品放进\\(上\\)去。$|"..
                                                                                                            "^你身上没有.+这样东西。$|"..
                                                                                                            "^你没有那么多的\\S+。$")
    if l == false then
        return -1
    elseif string.match(l[0], "放进") then
        var.pack.refresh = true
        var.pack.list[item] = var.pack.list[item] - count
    elseif string.match(l[0], "这里没有") then
        return 1
    elseif l[0] == "你先忙完再说吧。" then
        if wait_no_busy() < 0 then
            return -1
        end
    else
        var.pack.refresh = true
        return
    end
    return pack_stack(box, item)
end

function pack_nonstack(box, item)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ pack ］box = "..tostring(box)..", item = "..tostring(item))
    if var.pack.list[item] == 0 then
        var.pack.list[item] = nil
        return
    end
    if carryon.inventory[item] == nil then
        var.pack.refresh = true
        return
    end
    local id = set.pop(carryon.inventory[item].seq)
    if id == "1" then
        id = carryon.inventory[item].id
    else
        id = carryon.inventory[item].id.." "..(id or "")
    end
    local l = wait_line("put "..id.." in "..box, 30, {StopEval=true}, 10, "^你将\\S+放进(?:食盒|皮腰带|布袋)。$|"..
                                                                          "^\\S+对(?:食盒|皮腰带|布袋)而言太重了。$|"..
                                                                          "^这里没有 \\S+ 这个容器或不能将物品放进\\(上\\)去。$|"..
                                                                          "^你身上没有.+这样东西。$")
    if l == false then
        return -1
    elseif string.match(l[0], "放进") then
        var.pack.list[item] = var.pack.list[item] - 1
        var.pack.refresh = true
    elseif string.match(l[0], "这里没有") then
        return 1
    else
        var.pack.refresh = true
        return
    end
    return pack_nonstack(box, item)
end

function store_all_pots()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ store_all_pots ］")
    local rc = goto(2399)
    if rc ~= 0 then
        return rc
    end
    local l = wait_line("cun", 30, nil, 10, "^你当前储存的潜能有(\\d+)点。$")
    if l == false then
        return -1
    end
    profile.pot = l[1]
    state.pot = 0
    return 0
end

function feed(mode)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed ］参数：mode = "..tostring(mode))
    if var.feed == nil then
        var.feed = { layer = 0, target = 1, num = 1, mode = mode }
    else
        if var.feed.layer + 1 > 0 then
            return feed_return(1, "重复循环")
        end
        var.feed.layer = var.feed.layer + 1
    end
    if mode == "full" then
        var.feed.target = state.food_max
    end
    local rc = feed_drink()
    if rc ~= nil then
        return feed_return(rc)
    end
    var.feed.num = 1
    rc = feed_eat()
    if rc ~= nil then
        return feed_return(rc)
    end
    if state.drink >= math.max(var.feed.target, 1) and 
       state.food >= var.feed.target then
        return feed_return(0)
    end
    return feed_return(1)
end

function feed_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.feed == nil then
        return rc,msg
    end
    var.feed = nil
    return rc,msg
end

function feed_drink()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_drink ］")
    if state.drink >= var.feed.target then
        if is_own("饱腹玉:baofu yu") == false then
            return
        end
        if state.food >= var.feed.target then
            return 0
        end
    end
    local rc
    rc,var.feed.num = feed_drink_exec(var.feed.num)
    if rc == -1 then
        return -1
    elseif rc == 1 then
        return
    end
    if global.flood > config.flood_control then
        wait(1)
        global.flood = 0
    end
    return feed_drink()
end

function feed_drink_exec(num)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_drink_exec ］参数：i = "..tostring(num))
    if drinks[num] == nil then
        return 1
    end
    if state.food >= state.food_max and 
       drinks[num] == "汽锅鸡:qiguo ji" then
        return feed_drink_exec(num+1)
    end
    local msg,rc = is_own(drinks[num])
    if msg == false then
        return feed_drink_exec(num+1)
    elseif msg ~= true then
        if env.current.name == "擂台下" then
            rc = one_step()
            if rc < 0 then
                return -1
            end
            if rc > 0 then
                return feed_drink_exec(num+1)
            end
        end
        rc = get_from_container(drinks[num], msg)
        if rc < 0 then
            return -1
        end
        if rc > 0 then
            return feed_drink_exec(num+1)
        end
    end
    local drink_item = feed_choose_drink(drinks[num])
    if drink_item == nil then
        carryon.inventory[drinks[num]] = nil
        return feed_drink_exec(num)
    end
    rc,msg = drink(drink_item)
    if rc < 0 then
        return -1
    elseif rc == 0 then
        if var.feed.mode ~= "full" or 
           msg == "你已经喝太多了，再也灌不下啦。" then
            if run_hp() < 0 then
                return -1
            end
            var.feed.refresh = nil
        end
    else
        return feed_drink_exec(num+1)
    end
    return nil,num
end

function feed_choose_drink(item)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_choose_drink ］参数：item = "..tostring(item))
    local drink_item = carryon.inventory[item]
    if set.has(containers, drink_item.name) == true then
        for i=#drink_item.seq,1,-1 do
            if carryon.container[drink_item.id.." "..drink_item.seq[i]].water == true and 
               carryon.container[drink_item.id.." "..drink_item.seq[i]].stage > 0 then
                return drink_item.id.." "..drink_item.seq[i]
            end
        end
    else
        if drink_item.name == "饱腹玉" or 
           drink_item.name == "汽锅鸡" then
            return drink_item.id
        elseif set.last(drink_item.seq) ~= "1" then
            return drink_item.id.." "..set.last(drink_item.seq)
        else
            return drink_item.id
        end
    end
    return
end

function feed_eat()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_eat ］")
    if state.food >= var.feed.target then
        return
    end
    local rc
    rc,var.feed.num = feed_eat_exec(var.feed.num)
    if rc ~= nil then
        return rc
    end
    if global.flood > config.flood_control then
        wait(1)
        global.flood = 0
    end
    return feed_eat()
end

function feed_eat_exec(num)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_eat_exec ］参数：num = "..tostring(num))
    if foods[num] == nil then
        return 1
    end
    local msg,rc = is_own(foods[num])
    if msg == false then
        return feed_eat_exec(num+1)
    elseif msg ~= true then
        if env.current.name == "擂台下" then
            rc = one_step()
            if rc < 0 then
                return -1
            end
            if rc > 0 then
                return feed_eat_exec(num+1)
            end
        end
        rc = get_from_container(foods[num], msg)
        if rc < 0 then
            return -1
        end
        if rc > 0 then
            return feed_eat_exec(num+1)
        end
    end
    local eat_item = feed_choose_eat(foods[num])
    rc,msg = eat(eat_item)
    if rc < 0 then
        return -1
    elseif rc == 0 then
        if var.feed.mode ~= "full" or 
           msg == "你已经吃太饱了，再也塞不下了！" then
            if run_hp() < 0 then
                return -1
            end
            var.feed.refresh = nil
        end
    else
        return feed_eat_exec(num+1)
    end
    return nil,num
end

function feed_choose_eat(item)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ feed_choose_eat ］参数：item = "..tostring(item))
    local eat_item = carryon.inventory[item]
    if set.last(eat_item.seq) ~= "1" then
        return eat_item.id.." "..set.last(eat_item.seq)
    else
        return eat_item.id
    end
end

function aquire(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire ］参数：list = "..table.tostring(list))
    if table.is_empty(list) then
        return aquire_return(0)
    end
    if var.aquire == nil then
        var.aquire = var.aquire or { layer = 0, list = list, place = {}, get = {}, plan = {} }
    else
        if var.aquire.layer + 1 > 0 then
            return aquire_return(1, "重复循环")
        end
        var.aquire.layer = var.aquire.layer + 1
    end
    return aquire_return(aquire_exec(list))
end

function aquire_return(rc, msg)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_return ］参数：rc = "..tostring(rc)..", msg = "..tostring(msg))
    if var.aquire == nil then
        return rc,msg
    end
    if var.aquire.refresh == true then
        if run_i() < 0 then
            return -1
        end
    end
    var.aquire = nil
    return rc,msg
end

function aquire_plan(item, count)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_plan ］参数：item = "..tostring(item)..", count = "..tostring(count))
    if count == 0 then
        var.aquire.list[item] = nil
        return
    end
    if items[item] == nil then
        show("未定义 "..item, "orange")
        return
    end
    if #items[item].place == 0 then
        show("无法获得 "..item, "orange")
        return
    end
    var.aquire.place[item] = var.aquire.place[item] or set.copy(items[item].place)
    var.aquire.get[item] = var.aquire.get[item] or set.copy(items[item].get)
    if #var.aquire.place[item] > 0 then
        local room_id,method = set.shift(var.aquire.place[item]),set.shift(var.aquire.get[item])
        if method == "get" then
            method = "get "..items[item].id
        end
        if var.aquire.plan[room_id] == nil then
            var.aquire.plan[room_id] = {[method] = {[item] = count}}
            var.aquire.plan[room_id].all = {[item] = count}
        else
            var.aquire.plan[room_id][method] = var.aquire.plan[room_id][method] or {}
            var.aquire.plan[room_id][method][item] = var.aquire.plan[room_id][method][item] or 0
            var.aquire.plan[room_id][method][item] = var.aquire.plan[room_id][method][item] + count
            var.aquire.plan[room_id].all[item] = var.aquire.plan[room_id][method][item]
        end
    else
        show("无法获得 "..item, "orange")
    end
    return
end

function aquire_exec(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_exec ］参数：list = "..table.tostring(list))
    for k,v in pairs(list) do
        aquire_plan(k, v)
    end
    for _,v in pairs(table.index(var.aquire.plan)) do
        local rc,msg = goto(v)
        if rc < 0 then
            return -1
        elseif rc == 1 then
            msg = var.aquire.plan[v].all
            var.aquire.plan[v] = nil
            return aquire_exec(msg)
        end
        var.aquire.plan[v].all = nil
        if var.aquire.plan[v]["buy"] ~= nil then
            rc,msg = aquire_buy(var.aquire.plan[v]["buy"])
            var.aquire.plan[v]["buy"] = nil
            if rc == -1 then
                return -1
            elseif rc == 1 then
                return aquire_exec(msg)
            end
        end
        if var.aquire.plan[v]["qu"] ~= nil then
            rc,msg = aquire_qu(var.aquire.plan[v]["qu"])
            var.aquire.plan[v]["qu"] = nil
            if rc == -1 then
                return -1
            elseif rc == 1 then
                return aquire_exec(msg)
            end
        end
        for x,y in pairs(var.aquire.plan[v]) do
            if string.match(x, "kill ") then
                rc = aquire_kill(x, y)
            else
                rc = aquire_other(x, y)
            end
            var.aquire.plan[v][x] = nil
            if rc == -1 then
                return -1
            elseif rc == 1 then
                return aquire_exec(y)
            end
        end
        if table.is_empty(var.aquire.plan[v]) then
            var.aquire.plan[v] = nil
        end
    end
    if table.is_empty(var.aquire.list) then
        return 0
    else
        return 1,var.aquire.list
    end
end

function aquire_buy(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_buy ］参数：list = "..table.tostring(list))
    local rc,msg = buy(list)
    if rc < 0 then
        return -1
    else
        if rc > 0 then
            var.aquire.list = table.compl(var.aquire.list, table.compl(list, msg))
            return 1,msg
        else
            var.aquire.list = table.compl(var.aquire.list, list)
        end
    end
    var.aquire.refresh = true
    return
end

function aquire_qu(list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_qu ］参数：list = "..table.tostring(list))
    local rc,msg = qu(list)
    if rc < 0 then
        return -1
    else
        if rc > 0 then
            var.aquire.list = table.compl(var.aquire.list, table.compl(list, msg))
            return 1,msg
        else
            var.aquire.list = table.compl(var.aquire.list, list)
        end
    end
    var.aquire.refresh = true
    return
end

function aquire_kill(method, list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_kill ］参数：method = "..tostring(method)..", list = "..table.tostring(list))
    for k,v in pairs(list) do
        local l = wait_line(method, 30, nil, 10, "^这里没有.*这个人。$|"..
                                                 "^(?:冯锡范|血刀老祖|丁不三|金轮法王|黄衣女子|(?:白|红|青)衣武士)倒在地上，挣扎了几下就死了。$")
        if l == false then
            return -1
        end
        local post_kill = "get "..items[k].id.." from corpse"
        if k == "血刀:xue dao" then
            post_kill = "get "..items[k].id
        end
        l = wait_line(post_kill, 30, {StopEval=true}, 10, "^你从\\S+的尸体身上(?:搜出|除下)\\S+。$|"..
                                                          "^你捡起一柄血刀。$|"..
                                                          "^你附近没有这样东西。$|"..
                                                          "^你找不到 corpse 这样东西。$")
        if l == false then
            return -1
        elseif l[0] == "你附近没有这样东西。" or 
               l[0] == "你找不到 corpse 这样东西。" then
            return 1
        end
        list[k] = v - 1
        var.aquire.list[k] = v - 1
        var.aquire.refresh = true
        if list[k] > 0 then
            return aquire_kill(method, list)
        end
        list[k] = nil
        var.aquire.list[k] = nil
    end
    return
end

function aquire_other(method, list)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ aquire_other ］参数：method = "..tostring(method)..", list = "..table.tostring(list))
    local item = table.keys(list)[1]
    local count = list[item]
    if count == 0 then
        list[item] = nil
        var.aquire.list[item] = nil
        return
    end
    local l = wait_line(method, 30, {StopEval=true}, 10, "^你(?:得到了|捡起)一(?:柄|根|把|对|只)(?:钢剑|钢刀|禅杖|铜棒|铁棍|长鞭|铁锤|长枪|大斧头|双钩|判官笔|法轮)。$|"..
                                                         "^(?:李天恒|冷谦)从身上拿出一块(?:天鹰|铁焰)令交给你。$|"..
                                                         "^多隆说道：小心点，别老搞丢了。$|"..
                                                         "^嵇康给你一个盒子。$|"..
                                                         "^陆乘风递给你一块铁八卦。$|"..
                                                         "^陆乘风给你一粒九花玉露丸。$|"..
                                                         "^陆乘风说道：抱歉，你来得不是时候，已经发完了。$|"..
                                                         "^陆乘风说道：我不是才给过你药吗？怎麽又来要了，真是贪得无厌！$|"..
                                                         "^拉章活佛说道：好吧，这本经书你拿回去好好钻研。$|"..
                                                         "^然後梁长老伸手入怀，取出一颗百草丹给你。$|"..
                                                         "^梁长老说道：我身上此刻没有百草丹，你还是快到城里去找大夫吧！$|"..
                                                         "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif l[0] == "梁长老说道：我身上此刻没有百草丹，你还是快到城里去找大夫吧！" or 
           l[0] == "陆乘风说道：抱歉，你来得不是时候，已经发完了。" or 
           l[0] == "陆乘风说道：我不是才给过你药吗？怎麽又来要了，真是贪得无厌！" or 
           string.match(l[0], "这里没有") then
        return 1
    else
        list[item] = count - 1
        var.aquire.list[item] = count - 1
        var.aquire.refresh = true
    end
    return aquire_other(method, list)
end

function search(obj, rooms)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ search ］参数：obj = "..tostring(obj)..", rooms = "..table.tostring(rooms))
    trigger.add("search_found_obj", "search_found_obj()", "search", {Enable=true}, 99, obj)
    trigger.add("search_check_result", "search_check_result()", "search", {Enable=false}, 90, "^> $")
    trigger.add("search_locate", "search_locate()", "search", {Enable=true}, 90, "^\\S+\\s+- [、a-z0-9]+$")
    var.search = var.search or { result = {}, obj = {}, nobj = {}, optical = {}, past = {} }
    var.search.area = set.copy(rooms)
    return search_return(search_room(obj))
end

function search_return(rc, msg1, msg2)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ search_return ］参数：rc = "..tostring(rc)..", msg1 = "..table.tostring(msg1)..", msg2 = "..table.tostring(msg2))
    if var.search == nil then
        return rc,msg1,msg2
    end
    trigger.delete_group("search")
    var.search = nil
    return rc,msg1,msg2
end

function search_room(obj)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ search_room ］参数：obj = "..tostring(obj))
    if #var.search.area == 0 then
        return 1
    end
    if #env.current.id > 0 and 
       set.le(env.current.id, var.search.area) then
        var.search.area = set.union(set.compl(var.search.area, env.current.id), env.current.id)
    end
    var.search.dest = set.pop(var.search.area)
    local rc = goto(var.search.dest)
    if rc ~= 0 then
        return search_room(obj)
    end
    if #env.current.objs > 0 then
        if var.search.result[env.current.id[1]] == nil then
            for _,v in ipairs(env.current.objs) do
                local msg = regex.match("  "..v, obj)
                if msg ~= nil then
                    var.search.result[env.current.id[1]] = var.search.result[env.current.id[1]] or {}
                    set.append(var.search.result[env.current.id[1]], msg)
                end
            end
            if var.search.result[env.current.id[1]] ~= nil then
                set.pop(var.search.optical)
            end
        end
    end
    if #var.search.optical > 0 then
        for i = #var.search.optical, 1, -1 do
            if #var.search.optical[i] > 0 then
                var.search.area = set.compl(var.search.area, var.search.optical[i])
                set.extend(var.search.area, var.search.optical[i])
            end
        end
        var.search.optical = {}
    end
    if #var.search.past > 0 then
        var.search.area = set.compl(var.search.area, var.search.past)
    end
    if not table.is_empty(var.search.result) then
        var.search.area = set.compl(var.search.area, table.keys(var.search.result))
        return 0,var.search.result,var.search.area
    end
    return search_room(obj)
end

function search_found_obj()
    if var.look_dir ~= nil then
        var.search.nobj[var.look_dir] = var.search.nobj[var.look_dir] or {}
        set.append(var.search.nobj[var.look_dir], get_matches())
    else
        set.append(var.search.obj, get_matches())
    end
    trigger.enable("search_check_result")
end

function search_check_result()
    trigger.disable("search_check_result")
    if #env.current.id == 1 then
        local area = var.search.area
        if var.job ~= nil and var.job.search ~= nil then
            area = set.union(area, var.job.search)
        end
        if not table.is_empty(var.search.obj) then
            if env.current.id[1] == var.search.dest then
                var.search.result[env.current.id[1]] = var.search.obj
            elseif set.has(area, env.current.id[1]) then
                var.search.result[env.current.id[1]] = var.search.obj
            end
        end
        if not table.is_empty(var.search.nobj) then
            for k,v in pairs(var.search.nobj) do
                local nid = get_room_id_by_roomsfrom(env.current.id, nil, k)
                if #nid > 0 then
                    if var.search.result[nid] == nil and set.has(area, nid)then
                        var.search.result[nid] = v
                    end
                end
            end
        end
    else
        env.current.id = get_room_id_by_name(env.current.name)
        if #env.current.id == 1 then
            return search_check_result()
        elseif #env.current.id > 0 then
            if type(env.current.exits) == "string" then
                env.current.exits = string.split(env.current.exits, "[和 、]+")
            end
            env.current.id = get_room_id_by_exits(env.current.exits, env.current.id)
            if #env.current.id == 1 then
                return search_check_result()
            elseif #env.current.id > 0 then
                set.append(var.search.optical, set.inter(env.current.id, var.search.area))
            end
        end
    end
    var.search.obj = {}
    var.search.nobj = {}
end

function search_locate()
    env.current.id = get_room_id_by_name(env.current.name)
    if #env.current.id > 1 then
        env.current.exits = string.split(env.current.exits, "[ 、]+")
        env.current.id = get_room_id_by_exits(env.current.exits, env.current.id)
    end
    if #env.current.id == 1 then
        set.append(var.search.past, env.current.id[1])
    end
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
