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
    ["任务失败"] = 4,
}

function ftb_job()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job ］")
    automation.idle = false
    var.job = var.job or {name = "斧头帮任务"}
    var.job.statics = var.job.statics or {name = "斧头帮任务"}
--    var.job.enemy_name = var.job.enemy_name or family_info[profile.family].enemy_name
    trigger.enable_group("ftb_job_active")
    if (config.jobs["斧头帮任务"].phase or 1) <= phase["任务更新"] then
        local rc = ftb_job_p1()
        if rc ~= nil then
            return ftb_job_return(rc)
        end
    end
    if config.jobs["斧头帮任务"].phase == phase["任务执行"] then
        return ftb_job_return(ftb_job_p2())
    end
    repeat
        
        if active_job.state == "搜寻目标" then
            local retry = false
            local cleared_enemy = 0
            local leave = true
            local search_area = false
            local enemy_name = false
            local enemy = 0
            prepare("斧头帮任务")
            repeat
                if active_job.destination == false then
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 目的地未知")
                    active_job.destination = parseDest(active_job.target)
                    if active_job.destination == false then
                        clean_ftb_job("放弃任务")
                        verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 没有可用目的地，放弃任务，当前任务状态："..active_job.state)
                        return false
                    end
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 获得目的地："..table.tostring(active_job.destination))
                    if #active_job.destination > 1 and active_job.roomto ~= false then
                        for _,v in ipairs(active_job.roomto) do
                            active_job.destination = get_room_id_by_roomsto(get_room_id_by_name(v), nil, active_job.destination)
                            if active_job.destination == false then
                                clean_ftb_job("放弃任务")
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 没有可用目的地，放弃任务，当前任务状态："..active_job.state)
                                return false
                            end
                            verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 更新目的地："..table.tostring(active_job.destination))
                            if #active_job.destination == 1 then
                                break
                            end
                        end
                    end
                    active_job.destination = get_range(active_job.destination, active_job.range)
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 获得目的地范围："..table.tostring(active_job.destination))
                    active_job.destination = get_room_id_by_tags("nojob", active_job.destination, "exclude")
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 去除非任务区")
                    if active_job.destination == false then
                        clean_ftb_job("放弃任务")
                        verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 没有可用目的地，放弃任务，当前任务状态："..active_job.state)
                        return false
                    end
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 确认任务区域："..table.tostring(active_job.destination))
                end
                if search_area == false then
                    search_area = copytable.shallow(active_job.destination)
                end
                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 获得最终任务区域："..table.tostring(search_area))
                if #search_area > 200 then
                    clean_ftb_job("放弃任务")
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 目的地太多，放弃任务，当前任务状态："..active_job.state)
                    return false
                end
                repeat
                    flyto(search_area[1])
                    l,_ = wait.regexp("^[>\\s]*你目前还没有任何为 移动(?:完成|失败) 的变量设定。$", 180)
                    if not no_response(l) then
                        if string.find(l, "移动失败") then
                            if #active_job.destination > 1 then
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 目的地"..search_area[1].." 无法到达")
                                table.remove(active_job.destination, 1)
                                search_area = copytable.shallow(active_job.destination)
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 更新任务区域："..table.tostring(search_area))
                            else
                                clean_ftb_job("放弃任务")
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 所有目的地无法到达，放弃本次任务，当前任务状态："..active_job.state)
                                return false
                            end
                        else
                            break
                        end
                    end
                until false
                if search_npc("「(?:"..table.concat(ftb_job_nick1, "|")..")(?:"..table.concat(ftb_job_nick2, "|")..")」(\\S{4,8})", search_area) == true then
                    for i = 1, tonumber(GetVariable("room_id_destpos")) do
                        table.remove(search_area, 1)
                    end
                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 剩余未搜索目的地："..table.tostring(search_area))
                    for _,v in ipairs(found_npc) do
                        for _,i in ipairs(found_npc[v]) do
                            repeat
                                if GetVariable("room_id") ~= v then
                                    flyto(v)
                                    l,_ = wait.regexp("^[>\\s]*你目前还没有任何为 移动(?:完成|失败) 的变量设定。$", 180)
                                end
                                if GetVariable("room_id") == v or string.find(l, "移动完成") then
                                    if enemy_name == false then
                                        l,w = ask(string.lower(i), "刺客", "^[>\\s]*(\\S+)说道：老子怎么看都觉得你比我像杀手!$|"..
                                                                               "^[>\\s]*(\\S+)说道：青天白日的, 哪里有刺客\\? 笑话.$")
                                        if l then
                                            if string.find(l, "你比我像") then
                                                enemy_name = w[1]
                                            else
                                                if skip_npc == nil then
                                                    skip_npc = {}
                                                end
                                                for _,m in ipairs(w) do
                                                    if m ~= "" then
                                                        set.append(skip_npc, m)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if enemy_name ~= false then
                                        Execute("kill "..string.lower(i))
                                        l,_ = wait.regexp("^[>\\s]*你对著"..enemy_name.."喝道：「\\S+」$|"..
                                                          "^[>\\s]*这里没有这个人。$|"..
                                                          "^[>\\s]*你现在正忙着呢。$|"..
                                                          "^[>\\s]*这里不准战斗。$", 30)
                                        if no_response(l) then
                                            clean_ftb_job("放弃任务")
                                            verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 战斗无响应，放弃任务，当前任务状态："..active_job.state)
                                            return false
                                        elseif string.find(l, "正忙") then
                                            wait_nobusy()
                                        elseif string.find(l, "喝道") then
                                            action_state = "主动战斗"
                                            fight_enemy = {enemy_name}
                                            verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 状态："..action_state..", 敌人："..tostring(enemy_name))
                                            local fight_result = fight()
                                            fight_enemy = nil
                                            if fight_result == true then
                                                enemy = enemy + 1
                                                set.append(skip_npc, enemy_name)
                                                enemy_name = false
                                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 清除当前目标，累计清除目标数："..tostring(cleared_enemy + enemy))
                                                wait_nobusy()
                                                full_state(config.mana)
                                                break
                                            else
                                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 战斗失败，立刻逃跑")
                                                leave = leave_room()
                                                if leave == true then
                                                    if not full_state(config.mana) then
                                                        if enemy > 0 then
                                                            active_job.state = "回复任务"
                                                            break
                                                        else
                                                            clean_ftb_job("放弃任务")
                                                            verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 无法恢复状态，放弃任务")
                                                            return false
                                                        end
                                                    end
                                                else
                                                    enemy_name = false
                                                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 放弃当前目标，去下一目的地")
                                                    break
                                                end
                                            end
                                        elseif string.find(l, "没有这个") then
                                            enemy_name = false
                                            verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 未找到攻击目标")
                                            break
                                        else
                                            verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 处于禁止战斗房间")
                                            l,w = ask(string.lower(i), "程金斧", "^[>\\s]*"..enemy_name.."(?:急步|)往(\\S+)(?:离开|走了出去)。$")
                                            local npc_dir = nil
                                            if w ~= nil and w[1] ~= "" then
                                                npc_dir = dir_desc[w[1]]
                                            end
                                            for _,m in ipairs(get_room_id_by_tags("nojob", get_room_id_by_roomsfrom(GetVariable("room_id"), npc_dir, table.keys(map[GetVariable("room_id")].links)), "exclude")) do
                                                if found_npc[m] ~= nil then
                                                    set.append(found_npc[m], i)
                                                else
                                                    set.append(found_npc, m)
                                                    found_npc[m] = {i}
                                                end
                                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 更新目的地列表："..table.tostring(found_npc))
                                            end
                                            enemy_name = false
                                            break
                                        end
                                    else
                                        verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 不是任务目标，处理下个目标")
                                        break
                                    end
                                else
                                    verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 前往目的地失败，去下一目的地")
                                    break
                                end
                            until false
                            if GetVariable("room_id") ~= v then
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 已离开当前搜索目的地，去下一目的地")
                                break
                            end
                            if leave == false then
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 逃跑失败，去下一目的地")
                                break
                            end
                            if active_job.state == "回复任务" then
                                break
                            end
                        end
                        if active_job.state == "回复任务" then
                            break
                        end
                        found_npc[v] = nil
                    end
                    if active_job.state ~= "回复任务" then
                        if enemy > 0 then
                            cleared_enemy = cleared_enemy + enemy
                            enemy = 0
                            if cleared_enemy < active_job.enemy then
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 目标未完全清除："..tostring(cleared_enemy).." / "..tostring(active_job.enemy))
                                if #search_area == 0 then
                                    search_area = copytable.shallow(active_job.destination)
                                end
                            else
                                active_job.state = "回复任务"
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 所有目标都已清除")
                            end
                        else
                            if #search_area == 0 then
                                search_area = copytable.shallow(active_job.destination)
                            end
                        end
                    end
                else
                    if #active_job.destination == #search_area then
                        if retry == false then
                            active_job.range = math.min(9, active_job.range + 3)
                            active_job.destination = false
                            search_area = false
                            idle = false
                            retry = true
                        else
                            if cleared_enemy > 0 then
                                active_job.state = "回复任务"
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 部分目标已清除")
                            else
                                clean_ftb_job("放弃任务")
                                verbose("#"..debug.getinfo(1).currentline.." [start_ftb_job] 未找到目标，放弃任务，当前任务状态："..active_job.state)
                                return false
                            end
                        end
                    else
                        search_area = copytable.shallow(active_job.destination)
                    end
                end
                if active_job.state == "回复任务" then
                    break
                end
            until false
        end
    until false
end

function ftb_job_return(rc)
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_return ］参数：rc = "..tostring(rc))
    if var.job == nil then
        return rc
    end
    config.jobs["斧头帮任务"].info = nil
    config.jobs["斧头帮任务"].dest = nil
    config.jobs["斧头帮任务"].enemy = 0
    var.statics = var.job.statics
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
    if config.jobs["斧头帮任务"].dest == nil then
        local dest = parse(config.jobs["斧头帮任务"].info)
        if #dest == 0 then
            return ftb_job_p3()
        elseif #dest > 1 then
            local around = string.split(config.jobs["斧头帮任务"].around, "[和 、]+")
            dest = get_room_id_by_around(around, dest)
        end
    end
    jia_min()
    if wield(config.fight["通用"].weapon) < 0 then
        return -1
    end
end

function ftb_job_p3()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_p3 ］")
end

function ftb_job_p4()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_p4 ］")
end

function ftb_job_goto_chengjinfu()
    message("info", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ ftb_job_goto_chengjinfu ］")
    if env.current.id[1] ~= 1705 then
        var.job.statics["begin"] = var.job.statics["begin"] or time.epoch()
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
            if privilege_job("斧头帮任务") == true then
                var.job.statics = nil
                return 1
            end
            return ftb_job_refresh()
        elseif l[0] == "程金斧对着你竖起了右手大拇指，好样的。" then
            config.jobs["斧头帮任务"].phase = phase["任务完成"]
            return ftb_job_p3()
        elseif l[0] == "> " then
            if privilege_job("斧头帮任务") == true then
                var.job.statics = nil
                return 1
            end
            wait(1)
            return ftb_job_refresh()
        else
            if (l[0] == "程金斧说道：我早就告诉过你了:" and config.jobs["斧头帮任务"].phase == phase["任务失败"]) or 
               string.find(l[0], "BUG") then
                config.jobs["斧头帮任务"].active = false
                timer.add("ftb_job_cd", 300, "config.jobs['斧头帮任务'].active = true", "ftb_job", {Enable=true, OneShot=true})
                return ftb_job_p4()
            else
                return
            end
        end
    end
end

function ftb_job_wait_info()
    config.jobs["斧头帮任务"].enemy = chs2num(get_matches(1))
    config.jobs["斧头帮任务"].info = get_matches(2)
    config.jobs["斧头帮任务"].around = get_matches(3)
    config.jobs["斧头帮任务"].range = chs2num(get_matches(4))
    if config.jobs["斧头帮任务"].info == "少林寺0" then
        config.jobs["斧头帮任务"].info = "塘沽口"  -- BUG 临时处理
    end
    config.jobs["斧头帮任务"].phase = phase["任务执行"]
end