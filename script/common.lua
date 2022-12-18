local run_hide = {
    ["hp"] =      function() trigger.enable("hide_hp")
                             trigger.add(nil, "trigger.disable('hide_hp')", nil, {Enable=true, OneShot=true}, 10, "^\\s+饮水：\\s+\\d+/\\s+\\d+\\s+经验：\\s+[-\\d]+$")
                  end,
    ["score"] =   function() trigger.enable("hide_score")
                             trigger.add(nil, "trigger.disable('hide_score')", nil, {Enable=true, OneShot=true}, 10, "^└[─]+ Brotherhood ─┘$")
                  end,
    ["i"] =       function() trigger.enable("hide_i")
                             trigger.add("disable_hide_i", "trigger.disable('hide_i')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             trigger.add(nil, "trigger.enable('disable_hide_i')", nil, {Enable=true, OneShot=true}, 10, "^你\\(你\\)身上携带物品的别称如下\\(右方\\)：$|^目前你身上没有任何东西。$")
                  end,
    ["skills"] =  function() trigger.enable("hide_skills")
                             trigger.add("disable_hide_skills", "trigger.disable('hide_skills')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             trigger.add(nil, "trigger.enable('disable_hide_skills')", nil, {Enable=true, OneShot=true}, 10, "^你目前所学过的技能：（共\\S+项技能）[　]+$")
                  end,
    ["enable"] =  function() trigger.enable("hide_enable")
                             trigger.add("disable_hide_enable", "trigger.disable('hide_enable')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             trigger.add(nil, "trigger.enable('disable_hide_enable')", nil, {Enable=true, OneShot=true}, 10, "^以下是你目前使用中的特殊技能。$")
                  end,
    ["prepare"] = function() trigger.enable("hide_prepare")
                             trigger.add("disable_hide_prepare", "trigger.disable('hide_prepare')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             trigger.add(nil, "trigger.enable('disable_hide_prepare')", nil, {Enable=true, OneShot=true}, 10, "^以下是你目前组合中的特殊拳术技能。$|^你现在没有组合任何特殊拳术技能。$")
                  end,
    ["set"] =     function() trigger.enable("hide_set")
                             trigger.add("disable_hide_set", "trigger.disable('hide_set')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             trigger.add(nil, "trigger.enable('disable_hide_set')", nil, {Enable=true, OneShot=true}, 10, "^你目前设定的环境变量有：$")
                  end,
    ["list"] =    function() trigger.enable("hide_list")
                             trigger.add("disable_hide_list", "trigger.disable('hide_list')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             trigger.add(nil, "trigger.enable('disable_hide_list')", nil, {Enable=true, OneShot=true}, 10, "^你保存的物品如下:$")
                  end
}

function run(cmd)
    if not string.is_empty(cmd) then
        local splited = string.split(cmd, ";")
        global.flood = global.flood + #splited
        for _,v in ipairs(splited) do
            if run_hide[v] ~= nil then
                run_hide[v]()
            end
        end
        return send_cmd(cmd)
    end
end

threads = threads or {}
waits = waits or {}

function wait(seconds)
    local name = "wait_"..unique_id()
    threads[name] = coroutine.running()
    if threads[name] == nil then
        show("必须使用协程", "orange")
        return false
    end
    waits[name] = true
    timer.add(name, seconds, "wait_resume('"..name.."')", nil, {Enable=true, OneShot=true})
    return coroutine.yield()
end

function wait_resume(name)
    local thread = (threads or {})[name]
    if thread == nil then
        show("协程不存在", "orange")
        return false
    end
    threads[name] = nil
    waits[name] = nil
    local success,msg = coroutine.resume(thread)
    if success == false then
        show(msg, "red")
        show(debug.traceback(thread), "gray")
        return false
    end
    return true
end

function wait_line(action, timeout, options, order, ...)
    local name = "wait_line_"..unique_id()
    threads[name] = { coroutine.running() }
    if threads[name][1] == nil then
        show("必须使用协程", "orange")
        return false
    end
    local pattern
    options = options or {}
    options.Enable = false
    options.OneShot = true
    if select("#", ...) > 1 then
        pattern = {...}
        threads[name][2] = {}
        trigger.add(name.."_"..tostring(#pattern), "wait_line_trigger('"..name.."', "..tostring(#pattern)..", true)", name, options, order, set.last(pattern))
        for i = #pattern-1, 1, -1 do
            trigger.add(name.."_"..tostring(i), "wait_line_trigger('"..name.."', "..tostring(i)..", false)", name, {Enable=false, OneShot=true}, order, pattern[i])
        end
        trigger.enable(name.."_1")
    else
        pattern = select(1, ...)
        options.Enable = true
        trigger.add(name, "wait_line_trigger('"..name.."')", name, options, order, pattern)
    end
    timeout = timeout or 0
    waits[name] = true
    if timeout > 0 then
        timer.add(name, timeout, "wait_line_timer('"..name.."')", nil, {Enable=true, OneShot=true})
    end
    run(action)
    return coroutine.yield() or false
end

function wait_line_trigger(name, n, islast)
    if n == nil then
        timer.delete(name)
        threads[name][2] = get_matches()
        wait_line_resume(name)
    else
        if islast == true then
            timer.delete(name)
            threads[name][2][n] = get_matches()
            wait_line_resume(name)
        else
            threads[name][2][n] = get_matches()
            trigger.enable(name.."_"..tostring(n+1))
        end
    end
end

function wait_line_timer(name)
    trigger.delete_group(name)
    threads[name][2] = nil
    wait_line_resume(name)
end

function wait_line_resume(name)
    trigger.delete_group(name)
    local thread = ((threads or {})[name] or {})[1]
    if thread == nil then
        show("Coroutine lost", "orange")
        return false
    end
    if coroutine.status(thread) == "suspended" then
        local args = threads[name][2]
        threads[name] = nil
        waits[name] = nil
        local success,msg = coroutine.resume(thread, args)
        if success == false then
            show(msg, "red")
            show(debug.traceback(thread), "gray")
        end
    else
        timer.add(nil, 0, "wait_line_resume('"..name.."')", nil, {Enable=true, OneShot=true})
    end
end

function message(level, file, row, output, head)
    if global.debug[level] <= global.debug.level then
        local lua = set.last(string.split(file, "/"))
        head = string.rep("　　", head or 0)
        show(string.format("\n%-24s%-s%-s", lua.." - "..tostring(row)..":", head, output))
        if global.debug.level == "debug" then
            if time.epoch() - (global.debug.endless[output] or 0) < 1 then
                global.debug.endless.count = (global.debug.endless.count or 0) + 1
            else
                global.debug.endless.count = 0
            end
            if global.debug.endless.count > 100 then
                automation_reset()
            end
            global.debug.endless[output] = time.epoch()
        end
    end
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
