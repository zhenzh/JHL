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

config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy or 0
config.jobs["斧头帮任务"].confirm = config.jobs["斧头帮任务"].confirm or {}
config.jobs["斧头帮任务"].exclude = config.jobs["斧头帮任务"].exclude or {}

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
    ["任务失败"] = 3,
    ["任务完成"] = 4
}

local low_priority = { 2724, 1977, 290, 2399, 2400, 969, 971, 2042, 2043, 2044, 1017, 86, 25, 286 }

if automation.timer["ftb_job_cd"] ~= nil then
    config.jobs["斧头帮任务"].active = false
    local seconds = math.max(0.001, automation.timer["ftb_job_cd"].remain - (time.epoch() - automation.epoch) / 1000 )
    timer.add(automation.timer["ftb_job_cd"], seconds)
    automation.timer["ftb_job_cd"] = nil
else
    config.jobs["斧头帮任务"].active = true
end

if config.jobs["斧头帮任务"].phase == 2 then
    config.jobs["斧头帮任务"].phase = 1
    config.jobs["斧头帮任务"].dest = nil
end

function ftb_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job ］")
    automation.idle = false
    var.job = var.job or { name = "斧头帮任务" }
    var.job.statistics = var.job.statistics or { name = "斧头帮任务" }
    var.job.statistics.begin_time = var.job.statistics.begin_time or time.epoch()
    var.job.statistics.exp = var.job.statistics.exp or state.exp
    var.job.statistics.pot = var.job.statistics.pot or state.pot
    if config.jobs["斧头帮任务"].phase ~= phase["任务执行"] then
        local rc = ftb_job_p1()
        if rc ~= nil then
            return ftb_job_return(rc)
        end
    end
    return ftb_job_return(ftb_job_p2())
end

function ftb_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    trigger.disable_group("ftb_job")
    config.jobs["斧头帮任务"].info = nil
    config.jobs["斧头帮任务"].dest = nil
    config.jobs["斧头帮任务"].around = nil
    config.jobs["斧头帮任务"].range = nil
    config.jobs["斧头帮任务"].progress = nil
    config.jobs["斧头帮任务"].enemy = 0
    config.jobs["斧头帮任务"].confirm = {}
    config.jobs["斧头帮任务"].exclude = {}
    statistics_append("斧头帮任务")
    if var.job.weapon_ori ~= nil then
        var.job.weapon_ori[1] = var.job.weapon[1]
        var.job.weapon_ori[2] = var.job.weapon[2]
    end
    var.job = nil
    return rc
end

function ftb_job_p1()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_p1 ］")
<<<<<<< HEAD
    local rc = ftb_job_goto_chengjinfu()
=======
    local rc = ftb_job_go_chengjinfu()
>>>>>>> main
    if rc ~= nil then
        return rc
    end
    return ftb_job_refresh()
end

function ftb_job_p2()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_p2 ］")
    var.job.range = var.job.range or config.jobs["斧头帮任务"].range
    if config.jobs["斧头帮任务"].info == nil then
        config.jobs["斧头帮任务"].phase = phase["任务更新"]
        return ftb_job()
    end
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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_p3 ］")
    config.jobs["斧头帮任务"].phase = phase["任务失败"]
    config.jobs["斧头帮任务"].active = false
    if timer.is_exist("ftb_job_cd") == false then
        timer.add("ftb_job_cd", 300, "config.jobs['斧头帮任务'].active = true", "ftb_job", {Enable=true, OneShot=true})
    end
    if var.job.statistics ~= nil then
        var.job.statistics.result = "失败"
    end
    return 1
end

function ftb_job_go_chengjinfu()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_go_chengjinfu ］")
    if env.current.id[1] ~= 1705 then
        local rc = go(1705)
        if rc ~= 0 then
            return rc
        end
    end
    return
end

function ftb_job_refresh()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_refresh ］")
    local l = wait_line("ask cheng jinfu about job",
                        30, nil, nil,
                        "^你向程金斧打听有关「job」的消息。$|"..
                        "^这里没有 \\S+ 这个人$|"..
                        "^(\\S+)忙着呢，你等会儿在问话吧。$")
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
        l = wait_line(nil,
                      30, nil, nil,
                      "^程金斧说道：麻烦\\S+去查一查, 若真是刺客便替本帮主除却了吧.$|"..
                      "^程金斧说道：我早就告诉过你了:$|"..
                      "^程金斧说道：BUG|"..
                      "^程金斧一脚正好踢中你的屁股！$|"..
                      "^程金斧对着你竖起了右手大拇指，好样的。$|"..
                      "^但是很显然的，程金斧现在的状况没有办法给你任何答覆。$|"..
                      "^> $")
        if l == false then
            return -1
        elseif l[0] == "程金斧一脚正好踢中你的屁股！" then
            l = wait_line(nil,
                          30, nil, nil,
                          "^程金斧说道：说话的声音象蚊子那么大，老子听不清楚。$|"..
                          "^程金斧说道：去了这么久才回来, 人家早得手啦.$")
            if l == false then
                return -1
            elseif l[0] == "程金斧说道：去了这么久才回来, 人家早得手啦." then
                timer.delete("ftb_job_cd")
                config.jobs["斧头帮任务"].phase = phase["任务更新"]
                if privilege_job("斧头帮任务") == true then
                    var.job.statistics = nil
                    return 1
                end
            end
            return ftb_job_refresh()
        elseif l[0] == "程金斧对着你竖起了右手大拇指，好样的。" then
            timer.delete("ftb_job_cd")
            config.jobs["斧头帮任务"].progress = nil
            if recover(config.job_nl) < 0 then
                return -1
            end
            if run_score() < 0 then
                return -1
            end
            var.job.statistics.result = "成功"
            config.jobs["斧头帮任务"].phase = phase["任务完成"]
            return 0
        elseif l[0] == "> " then
            if privilege_job("斧头帮任务") == true then
                var.job.statistics = nil
                return 1
            end
            wait(1)
            return ftb_job_refresh()
        elseif string.find(l[0], "BUG") then
            timer.add("ftb_job_cd", 900, "ftb_job_active()", "ftb_job", {Enable=true, OneShot=true})
            return ftb_job_p3()
        elseif l[0] == "但是很显然的，程金斧现在的状况没有办法给你任何答覆。" then
            config.jobs["斧头帮任务"].phase = phase["任务失败"]
            var.job.statistics = nil
            return 1
        elseif l[0] == "程金斧说道：我早就告诉过你了:" then
            if (config.jobs["斧头帮任务"].phase or 0) == phase["任务失败"] then
                timer.delete("ftb_job_cd")
                return ftb_job_p3()
            end
            if wait_line(nil, 30, nil, nil, "^程金斧说道：麻烦\\S+去查一查, 若真是刺客便替本帮主除却了吧.$") == false then
                return -1
            end
            config.jobs["斧头帮任务"].phase = phase["任务执行"]
            return
        else
            timer.add("ftb_job_cd", 900, "ftb_job_active()", "ftb_job", {Enable=true, OneShot=true})
            return
        end
    else
        var.job.statistics = nil
        timer.delete("ftb_job_cd")
        return ftb_job_p3()
    end
end

function ftb_job_get_dest()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_get_dest ］")
    local dest = parse(config.jobs["斧头帮任务"].info)
    if #dest == 0 then
        return ftb_job_p3()
    elseif #dest > 1 and config.jobs["斧头帮任务"].around ~= false then
        local arounds = { string.split(config.jobs["斧头帮任务"].around, ", ") }
        for _,v in ipairs(arounds) do
            local dests = get_room_id_by_around(v, dest)
            if #dests > 0 then
                dest = dests
                break
            end
            if #v > 1 then
                arounds = set.union(arounds, set.permute(v, #v-1))
            end
        end
    end
    ftb_job_get_area(dest)
    return
end

function ftb_job_get_area(dest)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_get_area ］参数：dest = "..table.tostring(dest))
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
    config.jobs["斧头帮任务"].dest = set.union(set.inter(low_priority, config.jobs["斧头帮任务"].dest), config.jobs["斧头帮任务"].dest)
    var.job.search = config.jobs["斧头帮任务"].dest
end

function ftb_job_exec()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_exec ］")
    if var.job.npc == nil then
        local rc = ftb_job_search()
        if rc ~= nil then
            return rc
        end
    end
    for k,v in pairs(var.job.npc) do
        if not table.is_empty(v) then
            if set.has(config.jobs["斧头帮任务"].exclude, set.last(v)[1]) then
                set.pop(v)
            else
                local rc = 0
                if env.current.id[1] ~= k then
                    rc = go(k)
                end
                if rc == 0 then
                    rc = ftb_job_ask_npc(k, v)
                    if rc ~= nil then
                        return rc
                    end
                end
            end
        end
        if config.jobs["斧头帮任务"].enemy == 0 then
            break
        end
    end
    if config.jobs["斧头帮任务"].enemy == 0 then
        jia_min()
        if wield(config.fight["通用"].weapon) < 0 then
            return -1
        end
        if config.jobs["斧头帮任务"].progress ~= nil then
            config.jobs["斧头帮任务"].phase = phase["任务完成"]
            return ftb_job_p1()
        else
            return ftb_job_p3()
        end
    end
    var.job.npc = nil
    return ftb_job_exec()
end

function ftb_job_search()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_search ］")
    local rc
    rc,var.job.npc,config.jobs["斧头帮任务"].dest = search("^\\s+「(?:"..set.concat(ftb_job_nick1, "|")..")(?:"..set.concat(ftb_job_nick2, "|")..")」(\\S+)\\((\\w+ \\w+)\\)$", config.jobs["斧头帮任务"].dest)
    if rc == -1 then
        return -1
    elseif rc > 0 then
        if var.job.range >= 7 then
            if config.jobs["斧头帮任务"].progress ~= nil then
                config.jobs["斧头帮任务"].phase = phase["任务完成"]
                return ftb_job_p1()
            else
                if var.job.spare ~= nil then
                    local spare = var.job.spare
                    var.job.spare = nil
                    ftb_job_get_area(spare)
                    return ftb_job_p2()
                end
                return ftb_job_p3()
            end
        end
        var.job.range = 7
        config.jobs["斧头帮任务"].dest = nil
        var.job.spare = nil
        return ftb_job_p2()
    end
    return
end

function ftb_job_ask_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_ask_npc ］参数：room = "..table.tostring(room)..", npc = "..table.tostring(npc))
    if var.job.refresh == true then
        var.job.refresh = nil
        local current_id = env.current.id
        if wait_line("look", 30, nil, nil, "^\\S+\\s+- $", "^> $") == false then
            return -1
        end
        env.current.id = current_id
    end
    if table.is_empty(npc) then
        return
    end
    if set.has(config.jobs["斧头帮任务"].exclude, set.last(npc)[1]) then
        set.pop(npc)
        return ftb_job_ask_npc(room, npc)
    end
    if set.has(config.jobs["斧头帮任务"].confirm, set.last(npc)[1]) then
        local rc = ftb_job_kill_npc(room, set.pop(npc))
        if rc == nil then
            var.job.refresh = true
            return ftb_job_ask_npc(room, npc)
        else
            return rc
        end
    end
    if env.current.id[1] ~= room then
        if go(room) ~= 0 then
            return
        end
    end
    local l = wait_line("ask "..string.lower(set.last(npc)[2]).." about 刺客",
                        30, nil, nil,
                        "^你向"..set.last(npc)[1].."打听有关「刺客」的消息。$|"..
                        "^\\S+(?:正|)忙着呢，你等会儿在问话吧。$|"..
                        "^这里没有 .+ 这个人。$")
    if l == false then
        return -1
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        wait(0.1)
    elseif l[0] == "对方正忙着呢，你等会儿在问话吧。" then
        set.append(config.jobs["斧头帮任务"].exclude, set.pop(npc)[1])
        set.pop(npc)
    elseif string.match(l[0], "这里没有") then
        var.job.refresh = true
        local around = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
        set.pop(npc)
    else
        l = wait_line(nil,
                      30, nil, nil,
                      "^"..set.last(npc)[1].."说道：老子怎么看都觉得你比我像杀手!$|"..
                      "^"..set.last(npc)[1].."说道：青天白日的, 哪里有刺客\\? 笑话.$|"..
                      "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$|"..
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
            local rc = ftb_job_kill_npc(room, set.pop(npc))
            if rc == nil then
                var.job.refresh = true
                return ftb_job_ask_npc(room, npc)
            else
                return rc
            end
        else
            set.append(config.jobs["斧头帮任务"].exclude, set.pop(npc)[1])
        end
    end
    return ftb_job_ask_npc(room, npc)
end

function ftb_job_kill_npc(room, npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_kill_npc ］参数：room = "..table.tostring(room)..", npc = "..table.tostring(npc))
    if env.current.id[1] ~= room then
        if go(room) ~= 0 then
            return
        end
    end
    if prepare_skills() < 0 then
        return -1
    end
    if wield(config.fight["斧头帮任务"].weapon or config.fight["通用"].weapon) ~= 0 then
        return -1
    end
    if env.current.name == "迷宫树林" then
        local rc = ftb_job_drive_npc(npc)
        timer.delete("ftb_job_timeout")
        return rc
    end
    local l = wait_line("kill "..string.lower(npc[2]),
                        30, nil, nil,
                        "^你对著"..npc[1].."喝道：「\\S+」$|"..
                        "^这里没有这个人。$|"..
                        "^你现在正忙着呢。$|"..
                        "^这里不准战斗。$|"..
                        "^你来这是来打麻将而不是打架。$")
    if l == false then
        return -1
    elseif l[0] == "你现在正忙着呢。" then
        wait(0.1)
    elseif l[0] == "这里没有这个人。" then
        local around = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
        return
    elseif l[0] == "这里不准战斗。" or l[0] == "你来这是来打麻将而不是打架。" then
        local rc = ftb_job_drive_npc(npc)
        timer.delete("ftb_job_timeout")
        return rc
    else
        var.job.enemy_name = npc[1]
        trigger.add("ftb_job_enemy_die", "ftb_job_enemy_die()", "ftb_job", {Enable=true}, 99, "^"..var.job.enemy_name.."倒在地上，挣扎了几下就死了。$")
        local rc = fight()
        if rc == 0 then
            config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy - 1
            config.jobs["斧头帮任务"].progress = (config.jobs["斧头帮任务"].progress or 0) + 1
            rc = ftb_job_post_kill()
            if rc ~= nil then
                return rc
            end
            return
        elseif rc == 2 then
            rc = ftb_job_one_step()
            if rc ~= nil then
                return rc
            end
        elseif rc == 1 then
            if env.current.name == "树上" then
                return ftb_job_kill_npc(room, npc)
            end
            return
        end
    end
    return ftb_job_kill_npc(room, npc)
end

function ftb_job_drive_npc(npc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_kill_npc ］npc = "..table.tostring(npc))
    local l = wait_line("ask "..string.lower(npc[2]).." about 程金斧",
                        30, nil, nil,
                        "^你忙着呢，你等会儿在问话吧。$|"..
                        "^这里没有 .+ 这个人。$|"..
                        "^但是很显然的，\\S+现在的状况没有办法给你任何答覆。$|"..
                        "^"..npc[1].."\\S*往(\\S+)(?:离开|走了出去)。$|"..
                        "^"..npc[1].."说道：好家伙，真来了。$|"..
                        "^"..npc[1].."忙着呢，你等会儿在问话吧。$")
    if l == false then
        return -1
    elseif l[0] == "你忙着呢，你等会儿在问话吧。" then
        if wait_no_busy("halt") < 0 then
            return -1
        end
        return ftb_job_drive_npc(npc)
    elseif string.match(l[0], "这里没有") then
        local around = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
    elseif string.match(l[0], "真来了") then
        set.delete(config.jobs["斧头帮任务"].dest, env.current.id[1])
        set.append(config.jobs["斧头帮任务"].exclude, set.pop(npc)[1])
        config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy - 1
    elseif l[1] ~= false then
        local around =  get_room_id_by_tag("nojob", get_room_id_by_roomsfrom(env.current.id, get_room_id_around(), get_desc_dir(l[1])), "exclude")
        config.jobs["斧头帮任务"].dest = set.union(set.compl(config.jobs["斧头帮任务"].dest, around), around)
    else
        if config.jobs["斧头帮任务"].enemy > 1 then
            local around = get_room_id_by_tag("nojob", get_room_id_around(), "exclude")
            set.insert(around, env.current.id[1], 1)
            config.jobs["斧头帮任务"].dest = set.union(around, config.jobs["斧头帮任务"].dest)
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
            if dazuo() < 0 then
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
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_one_step ］")
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

function ftb_job_post_kill()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ ftb_job_post_kill ］")
    if wait_no_busy() < 0 then
        return -1
    end
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

function ftb_job_wait_info()
    config.jobs["斧头帮任务"].enemy = chs2num(get_matches(1))
    if config.jobs["斧头帮任务"].info == get_matches(2) then
        config.jobs["斧头帮任务"].enemy = config.jobs["斧头帮任务"].enemy - (config.jobs["斧头帮任务"].progress or 0)
        if config.jobs["斧头帮任务"].enemy == 0 then
            config.jobs["斧头帮任务"].enemy = 1
        end
    end
    config.jobs["斧头帮任务"].info = get_matches(2)
    config.jobs["斧头帮任务"].around = get_matches(3)
    config.jobs["斧头帮任务"].range = chs2num(get_matches(4))
    if config.jobs["斧头帮任务"].info == "少林寺0" then
        config.jobs["斧头帮任务"].info = "塘沽口"  -- BUG 临时处理
    end
    var.job.range = config.jobs["斧头帮任务"].range
    config.jobs["斧头帮任务"].phase = phase["任务执行"]
end

function ftb_job_enemy_die()
    if var.fight ~= nil then
        var.fight.stop = 0
    end
end

function ftb_job_active()
    show("dbg ftb active", "red")
    run("time")
    config.jobs["斧头帮任务"].active = true
end

config.jobs["斧头帮任务"].func = ftb_job
config.jobs["斧头帮任务"].efunc = enable_ftb_job
config.jobs["斧头帮任务"].dfunc = disable_ftb_job
show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")