local ftb_job_nick1 = {"金", "水", "超", "铁", "刚", "强", "火", "神", "震", "木","护花", "催花", "五雷", "五魁", "老", "飘香", "飘雪", "飘雨",
                       "飞花", "飞雨","水火", "金火", "日月", "乾坤", "千万", "亿万", "月光", "火云", "泰山", "南洋","西方", "东方", "威武",
                       "轻烟", "南方", "北方", "护法", "雷电", "闪电", "迅雷","闪光", "暴雨", "千水", "灭心", "灭情", "绝情", "断情", "失意",
                       "春风", "秋霞","霜雪", "雪霜", "无敌", "神奇", "傲气", "冷傲", "冷血", "断情", "灭意", "断意","截血", "截穴", "断截",
                       "情飞", "审心", "孤独", "傲情", "施于", "绝断", "深水","痴情", "痴心", "如来", "菩萨", "阎罗", "恶鬼", "雷霆", "天王",
                       "无影", "火云", "柔情", "无痕", "无法", "无天", "无云", "君子", "铁血", "千里", "断魂", "雷震","迎风", "杀手", "追命",
                       "追魂", "断肠", "飞雨", "冷雨", "血雨", "鬼", "七杀","金童", "玉女", "摘星", "九幽", "五毒", "六夺", "三才", "四喜",
                       "六顺", "八步","双福", "一难", "十绝", "夺命", "夺魂", "断门", "中原", "塞北", "大漠", "海上","塞外", "沙漠", "漠北",
                       "东海", "南海", "北海", "极乐", "黑杀", "白杀", "屠夫","伴花", "翻天", "魔", "无心", "无花", "碎心", "逍遥", "红杀",
                       "吸血", "屠夫","威镇", "太极", "河朔", "七星", "毒", "罗汉", "玉", "无行", "五行", "拼命","百变", "千变", "万变", "百劫",
                       "千劫", "十劫", "万劫", "八卦", "八宝", "福星"}

local ftb_job_nick2 = {"剑", "刀", "手", "脚", "掌", "拳", "门", "客", "人", "枪", "箭", "腿", "足", "神", "棍", "棒", "斧", "钩", "叉", "戟",
                       "鞭", "锏", "锤", "爪", "霸", "霸天", "天霸", "游魂", "老", "王","门", "侠", "客", "霸", "霸天", "天霸", "游魂", "三郎",
                       "老", "王","皇", "昙花", "罗刹", "鬼", "仙子", "霸王", "邪", "无邪", "老邪", "小邪","如来", "菩萨", "阎罗", "恶鬼",
                       "柔情", "无痕", "无法", "无天", "无云", "天王","一剑", "一刀", "杀手", "之神", "之子", "少爷", "阎王", "侯爷", "土地",
                       "判官","无常", "魔", "印", "公子"}

function enable_ftb_job()
    trigger.delete_group("ftb_job")
    trigger.add("ftb_job_wait_info", "ftb_job_wait_info()", "ftb_job", {Enable=false, Multi=true}, 99, "^程金斧说道：听说有(\\S+)个家伙想对本帮不利.\\n程金斧说道：据说他们已经到了(\\S+)(?:\\(该处靠近([\\S, ]+)\\)|)方圆(\\S+)里之内.$")
end

function disable_ftb_job()
    trigger.delete_group("ftb_job")
end

local phase = {
    ["任务更新"] = 1,
    ["任务执行"] = 2,
    ["任务完成"] = 3,
    ["任务失败"] = 4
}

function ftb_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job ］")
    automation.idle = false
    var.job = var.job or {name = "斧头帮任务"}
    var.job.statistics = var.job.statistics or {name = "斧头帮任务"}
    var.job.statistics["begin"] = var.job.statistics["begin"] or time.epoch()
    var.job.statistics["exp"] = var.job.statistics["exp"] or state.exp
    var.job.statistics["pot"] = var.job.statistics["pot"] or state.pot
    trigger.enable_group("ftb_job_active")
    if config.jobs["斧头帮任务"].phase ~= phase["任务执行"] then
        local rc = ftb_job_p1()
        if rc ~= nil then
            return ftb_job_return(rc)
        end
    end
    return ftb_job_return(ftb_job_p2())
end

function ftb_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    config.jobs["斧头帮任务"].info = nil
    config.jobs["斧头帮任务"].dest = nil
    config.jobs["斧头帮任务"].progress = nil
    config.jobs["斧头帮任务"].enemy = 0
    config.jobs["斧头帮任务"].confirm = {}
    config.jobs["斧头帮任务"].exclude = {}
    var.statistics = var.job.statistics
    trigger.disable_group("ftb_job")
    var.job = nil
    return rc
end

function ftb_job_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_p1 ］")
    local rc = ftb_job_goto_chengjinfu()
    if rc ~= nil then
        return rc
    end
    rc = ftb_job_refresh()
    if rc ~= nil then
        return rc
    end
end

function ftb_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_p2 ］")
    var.job.range = var.job.range or config.jobs["斧头帮任务"].range
    var.job.statistics["begin"] = var.job.statistics["begin"] or time.epoch()
    var.job.statistics["exp"] = var.job.statistics["exp"] or state.exp
    var.job.statistics["pot"] = var.job.statistics["pot"] or state.pot
    if config.jobs["斧头帮任务"].dest == nil then
        local rc = ftb_job_get_dest()
        if rc ~= nil then
            return rc
        end
    end
    jia_min()
    if wield(config.fight["通用"].weapon) < 0 then
        return -1
    end
    return ftb_job_exec()
end

function ftb_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_p3 ］")
    config.jobs["斧头帮任务"].phase = phase["任务完成"]
    if recover(config.job_nl) < 0 then
        return -1
    end
    if prepare_items() < 0 then
        return -1
    end
    if run_score() < 0 then
        return -1
    end
    var.job.statistics["exp"] = state.exp - var.job.statistics["exp"]
    var.job.statistics["pot"] = state.pot - var.job.statistics["pot"]
    var.job.statistics["result"] = "成功"
    var.job.statistics["end"] = time.epoch()
    return 0
end

function ftb_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_p4 ］")
    config.jobs["斧头帮任务"].phase = phase["任务失败"]
    config.jobs["斧头帮任务"].active = false
    if timer.is_exist("ftb_job_cd") == false then
        timer.add("ftb_job_cd", 300, "config.jobs['斧头帮任务'].active = true", "ftb_job", {Enable=true, OneShot=true})
    end
    if var.job.statistics ~= nil then
        var.job.statistics["exp"] = state.exp - var.job.statistics["exp"]
        var.job.statistics["pot"] = state.pot - var.job.statistics["pot"]
        var.job.statistics["result"] = "失败"
        var.job.statistics["end"] = time.epoch()
    end
    return 1
end

function ftb_job_goto_chengjinfu()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_goto_chengjinfu ］")
    if env.current.id[1] ~= 1705 then
        var.job.statistics["begin"] = var.job.statistics["begin"] or time.epoch()
        local rc = goto(1705)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function ftb_job_refresh()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_refresh ］")
    local l = wait_line("ask cheng jinfu about job", 30, nil, nil, "^你向程金斧打听有关「job」的消息。$|"..
                                                                   "^这里没有 \\S+ 这个人$|"..
                                                                   "^(\\S+)忙着呢，你等会儿在问话吧。$|"..
                                                                   "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$")
    if l == false then
        return -1
    elseif string.match(l[0], "忙着") then
        wait(0.1)
        if l[1] == "你" then
            run("halt")
        end
        return ftb_job_refresh()
    elseif l[0] == "你向程金斧打听有关「job」的消息。" then
        trigger.enable("ftb_job_wait_info")
        l = wait_line(nil, 30, nil, nil, "^程金斧说道：麻烦\\S+去查一查, 若真是刺客便替本帮主除却了吧.$|"..
                                         "^程金斧说道：我早就告诉过你了:$|"..
                                         "^程金斧说道：BUG|"..
                                         "^程金斧一脚正好踢中你的屁股！$|"..
                                         "^程金斧对着你竖起了右手大拇指，好样的。$|"..
                                         "^> $")
        if l == false then
            return -1
        elseif l[0] == "程金斧一脚正好踢中你的屁股！" then
            config.jobs["斧头帮任务"].phase = phase["任务更新"]
            if privilege_job("斧头帮任务") == true then
                var.job.statistics = nil
                return 1
            end
            return ftb_job_refresh()
        elseif l[0] == "程金斧对着你竖起了右手大拇指，好样的。" then
            return ftb_job_p3()
        elseif l[0] == "> " then
            if privilege_job("斧头帮任务") == true then
                var.job.statistics = nil
                return 1
            end
            wait(1)
            return ftb_job_refresh()
        elseif string.find(l[0], "BUG") then
            timer.add("ftb_job_cd", 900, "ftb_job_active()", "ftb_job", {Enable=true, OneShot=true})
            return ftb_job_p4()
        elseif l[0] == "程金斧说道：我早就告诉过你了:" then
            if config.jobs["斧头帮任务"].phase == phase["任务失败"] then
                timer.delete("ftb_job_cd")
                return ftb_job_p4()
            end
            if (config.jobs["斧头帮任务"].phase or 0) >= phase["任务执行"] then
                return ftb_job_p4()
            end
            if wait_line(nil, 30, nil, nil, "^程金斧说道：麻烦老爷子去查一查, 若真是刺客便替本帮主除却了吧.$") == false then
                return -1
            end
            return
        else
            timer.add("ftb_job_cd", 900, "ftb_job_active()", "ftb_job", {Enable=true, OneShot=true})
            return
        end
    end
end

function ftb_job_get_dest()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_get_dest ］")
    local dest = parse(config.jobs["斧头帮任务"].info)
    if #dest == 0 then
        return ftb_job_p4()
    elseif #dest > 1 and config.jobs["斧头帮任务"].around ~= false then
        local arounds = { string.split(config.jobs["斧头帮任务"].around, ", ") }
        for _,v in ipairs(arounds) do
            local dests = get_room_id_by_around(v, dest)
            if #dests > 0 then
                dest = dests
                break
            end
            if #v > 1 then
                arounds = table.union(arounds, set.permute(v, #v-1))
            end
        end
    end
    ftb_job_get_area(dest)
    return
end

function ftb_job_get_area(dest)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_get_area ］参数：dest = "..table.tostring(dest))
    config.jobs["斧头帮任务"].dest = { dest[1] }
    map_adjust("门派接引", "禁用", "过河", "渡船", "丐帮密道", "禁用")
    for _,v in ipairs(dest) do
        if get_path(config.jobs["斧头帮任务"].dest[1], v)[v].cost > 10 then
            var.job.spare = var.job.spare or {}
            set.append(var.job.spare, v)
        else
            config.jobs["斧头帮任务"].dest = set.union(config.jobs["斧头帮任务"].dest , get_room_id_by_range(var.job.range, v))
        end
    end
    config.jobs["斧头帮任务"].dest = get_room_id_by_tag("nojob", config.jobs["斧头帮任务"].dest, "exclude")
end

function ftb_job_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_exec ］")
    if var.job.npc == nil then
        local rc = ftb_job_search()
        if rc ~= nil then
            return rc
        end
    end
    for k,v in pairs(var.job.npc) do
        local rc = ftb_job_ask_npc(k, v)
        if rc == nil then
            rc = ftb_job_kill_npc(k, v)
        elseif rc == -1 then
            return -1
        end
        if config.jobs["斧头帮任务"].enemy == 0 then
            jia_min()
            if wield(config.fight["通用"].weapon) < 0 then
                return -1
            end
            if config.jobs["斧头帮任务"].progress ~= nil then
                return ftb_job_p3()
            else
                return ftb_job_p4()
            end
        end
    end
    var.job.npc = nil
    return ftb_job_exec()
end

function ftb_job_search()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_search ］")
    local rc
    rc,var.job.npc,config.jobs["斧头帮任务"].dest = search("^\\s+「(?:"..set.concat(ftb_job_nick1, "|")..")(?:"..set.concat(ftb_job_nick2, "|")..")」(\\S+)\\((\\w+ \\w+)\\)$", config.jobs["斧头帮任务"].dest)
    if rc == -1 then
        return -1
    elseif rc > 0 then
        if var.job.range >= 7 then
            if var.job.spare ~= nil then
                var.job.range = config.jobs["斧头帮任务"].range
                local spare = var.job.spare
                var.job.spare = nil
                ftb_job_get_area(spare)
                return ftb_job_p2()
            end
            return ftb_job_p4()
        end
        var.job.range = 7
        config.jobs["斧头帮任务"].dest = nil
        var.job.spare = nil
        return ftb_job_p2()
    end
    return
end

function ftb_job_ask_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_ask_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if table.is_empty(npc) then
        return 1
    end
    if set.has(config.jobs["斧头帮任务"].exclude, set.last(npc)[1]) then
        set.pop(npc)
        return ftb_job_ask_npc(room, npc)
    end
    if env.current.id[1] ~= room then
        if goto(room) ~= 0 then
            var.job.npc[room] = nil
            return 1
        end
    end
    if set.has(config.jobs["斧头帮任务"].confirm, set.last(npc)[1]) then
        return
    end
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." about 刺客", 30, nil, nil, "^"..set.last(npc)[1].."说道：老子怎么看都觉得你比我像杀手!$|"..
                                                                                            "^"..set.last(npc)[1].."说道：青天白日的, 哪里有刺客\\? 笑话.$|"..
                                                                                            "^你忙着呢，你等会儿在问话吧。$|"..
                                                                                            "^这里没有 \\S+ 这个人$|"..
                                                                                            "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$|"..
                                                                                            "^"..set.last(npc)[1].."忙着呢，你等会儿在问话吧。$|"..
                                                                                            "^"..set.last(npc)[1].."摇摇头，说道：没听说过。$|"..
                                                                                            "^"..set.last(npc)[1].."耸了耸肩，很抱歉地说：无可奉告。$|"..
                                                                                            "^"..set.last(npc)[1].."睁大眼睛望着你，显然不知道你在说什么。$|"..
                                                                                            "^"..set.last(npc)[1].."想了一会儿，说道：对不起，你问的事我实在没有印象。$|"..
                                                                                            "^"..set.last(npc)[1].."说道：你在说外国话吧？我不会，你最好带个翻译来。$|"..
                                                                                            "^"..set.last(npc)[1].."说道：才阿八热古里古鲁。你看，我也能假装会说外国话。$|"..
                                                                                            "^"..set.last(npc)[1].."嘻嘻笑道：你说什么鸟语？$|"..
                                                                                            "^"..set.last(npc)[1].."说道：嗯....这我可不清楚，你最好问问别人吧。$")
    if l == false then
        return -1
    elseif string.match(l[0], "像杀手") then
        set.append(config.jobs["斧头帮任务"].confirm, set.last(npc)[1])
        return
    elseif string.match(l[0], "你忙着呢，你等会儿在问话吧。") then
        wait(0.1)
    elseif string.match(l[0], "这里没有") then
        local around = get_room_id_around()
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
        set.pop(npc)
    else
        set.append(config.jobs["斧头帮任务"].exclude, set.last(npc)[1])
        set.pop(npc)
    end
    return ftb_job_ask_npc(room, npc)
end

function ftb_job_kill_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_kill_npc ］参数：room = "..tostring(room)..", npc = "..table.tostring(npc))
    if prepare_skills() < 0 then
        return -1
    end
    if wield(config.fight["斧头帮任务"].weapon) ~= 0 then
        return -1
    end
    local l = wait_line("kill "..string.lower(set.last(npc)[2]), 30, nil, nil, "^你对著"..set.last(npc)[1].."喝道：「\\S+」$|"..
                                                                               "^这里没有这个人。$|"..
                                                                               "^你现在正忙着呢。$|"..
                                                                               "^这里不准战斗。$")
    if l == false then
        return -1
    elseif l[0] == "你现在正忙着呢。" then
        wait(0.1)
    elseif l[0] == "这里没有这个人。" then
        local around = get_room_id_around()
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
        return
    elseif l[0] == "这里不准战斗。" then
        local rc = ftb_job_drive_npc(room, npc)
        timer.delete("ftb_job_timeout")
        return rc
    else
        var.job.enemy_name = set.last(npc)[1]
        trigger.add("ftb_job_enemy_die", "ftb_job_enemy_die()", "ftb_job", {Enable=true}, 99, "^"..var.job.enemy_name.."倒在地上，挣扎了几下就死了。$")
        local rc = fight()
        if rc == 0 then
            config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy - 1
            config.jobs["斧头帮任务"].progress = (config.jobs["斧头帮任务"].progress or 0) + 1
            set.pop(npc)
            return
        elseif rc == 2 then
            return ftb_job_one_step()
        elseif rc == 1 then
            if var.job.npc[1718] == nil then
                config.jobs["斧头帮任务"].dest = set.union({1718}, config.jobs["斧头帮任务"].dest)
            end
            if env.current.name ~= "树上" then
                set.pop(npc)
            end
            return
        end
    end
    return ftb_job_kill_npc(npc)
end

function ftb_job_drive_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_kill_npc ］room = "..tostring(room)..", npc = "..table.tostring(npc))
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." about 程金斧", 30, nil, nil, "^你忙着呢，你等会儿在问话吧。$|"..
                                                                                              "^这里没有 \\S+ 这个人$|"..
                                                                                              "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$|"..
                                                                                              "^"..set.last(npc)[1].."忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return ftb_job_drive_npc(npc)
    elseif string.match(l[0], "这里没有") then
        local around = get_room_id_around()
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
    elseif l[1] ~= false then
        var.job.npc[room] = var.job.npc[room] or {}
        set.append(var.job.npc[room], set.pop(npc))
    else
        if config.jobs["斧头帮任务"].enemy > 1 then
            config.jobs["斧头帮任务"].dest = set.union(get_room_id_around(), config.jobs["斧头帮任务"].dest)
            set.insert(config.jobs["斧头帮任务"].dest, env.current.id[1], 1)
            return
        else
            if var.job.timeout == true then
                config.jobs["斧头帮任务"].enemy = 0
                return
            end
            if var.job.timeout == nil then
                timer.add("ftb_job_timeout", 60, "var.job.timeout = true")
            end
            local nl = state.nl
            local rc = dazuo()
            if rc < 0 then
                return -1
            elseif rc ~= 0 or state.nl == nl then
                wait(1)
            end
            return ftb_job_drive_npc(npc)
        end
    end
    return
end

function ftb_job_one_step()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_one_step ］")
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

function ftb_job_wait_info()
    config.jobs["斧头帮任务"].enemy = chs2num(get_matches(1))
    config.jobs["斧头帮任务"].info = get_matches(2)
    config.jobs["斧头帮任务"].around = get_matches(3)
    config.jobs["斧头帮任务"].range = chs2num(get_matches(4))
    var.job.range = config.jobs["斧头帮任务"].range
    if config.jobs["斧头帮任务"].info == "少林寺0" then
        config.jobs["斧头帮任务"].info = "塘沽口"  -- BUG 临时处理
    end
    config.jobs["斧头帮任务"].phase = phase["任务执行"]
end

function ftb_job_enemy_die()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
end

function ftb_job_active()
    config.jobs["斧头帮任务"].active = true
    config.jobs["斧头帮任务"].phase = phase["任务更新"]
end

config.jobs["斧头帮任务"].func = ftb_job
config.jobs["斧头帮任务"].efunc = enable_ftb_job
config.jobs["斧头帮任务"].dfunc = disable_ftb_job
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")