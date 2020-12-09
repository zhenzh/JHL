show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

local run_hide = {
    ["hp"] =      function() enable_trigger("hide_hp")
                             add_trigger(nil, "disable_trigger('hide_hp')", nil, {Enable=true, OneShot=true}, 10, "^\\s+饮水：\\s+\\d+/\\s+\\d+\\s+经验：\\s+[-\\d]+$")
                  end,
    ["score"] =   function() enable_trigger("hide_score")
                             add_trigger(nil, "disable_trigger('hide_score')", nil, {Enable=true, OneShot=true}, 10, "^└[─]+ Brotherhood ─┘$")
                  end,
    ["i"] =       function() enable_trigger("hide_i")
                             add_trigger("disable_hide_i", "disable_trigger('hide_i')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             add_trigger(nil, "enable_trigger('disable_hide_i')", nil, {Enable=true, OneShot=true}, 10, "^你\\(你\\)身上携带物品的别称如下\\(右方\\)：$|^目前你身上没有任何东西。$")
                  end,
    ["skills"] =  function() enable_trigger("hide_skills")
                             add_trigger("disable_hide_skills", "disable_trigger('hide_skills')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             add_trigger(nil, "enable_trigger('disable_hide_skills')", nil, {Enable=true, OneShot=true}, 10, "^你目前所学过的技能：（共\\S+项技能）[　]+$")
                  end,
    ["enable"] =  function() enable_trigger("hide_enable")
                             add_trigger("disable_hide_enable", "disable_trigger('hide_enable')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             add_trigger(nil, "enable_trigger('disable_hide_enable')", nil, {Enable=true, OneShot=true}, 10, "^以下是你目前使用中的特殊技能。$")
                  end,
    ["prepare"] = function() enable_trigger("hide_prepare")
                             add_trigger("disable_hide_prepare", "disable_trigger('hide_prepare')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             add_trigger(nil, "enable_trigger('disable_hide_prepare')", nil, {Enable=true, OneShot=true}, 10, "^以下是你目前组合中的特殊拳术技能。$|^你现在没有组合任何特殊拳术技能。$")
                  end,
    ["set"] =     function() enable_trigger("hide_set")
                             add_trigger("disable_hide_set", "disable_trigger('hide_set')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             add_trigger(nil, "enable_trigger('disable_hide_set')", nil, {Enable=true, OneShot=true}, 10, "^你目前设定的环境变量有：$")
                  end,
    ["list"] =    function() enable_trigger("hide_list")
                             add_trigger("disable_hide_list", "disable_trigger('hide_list')", nil, {Enable=false, OneShot=true}, 10, "^> $")
                             add_trigger(nil, "enable_trigger('disable_hide_list')", nil, {Enable=true, OneShot=true}, 10, "^你保存的物品如下:$")
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
function wait(seconds)
    local name = "wait_"..unique_id()
    threads[name] = coroutine.running()
    if threads[name] == nil then
        show("必须使用协程", "orange")
        return false
    end
    add_timer(name, seconds, "wait_resume('"..name.."')", nil, {Enable=true, OneShot=true})
    return coroutine.yield()
end

function wait_resume(name)
    local thread = (threads or {})[name]
    if thread == nil then
        show("协程不存在", "orange")
        return false
    end
    threads[name] = nil
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
        add_trigger(name.."_"..tostring(#pattern), "wait_line_trigger('"..name.."', "..tostring(#pattern)..", true)", name, options, order, set.last(pattern))
        for i = #pattern-1, 1, -1 do
            add_trigger(name.."_"..tostring(i), "wait_line_trigger('"..name.."', "..tostring(i)..", false)", name, {Enable=false, OneShot=true}, order, pattern[i])
        end
        enable_trigger(name.."_1")
    else
        pattern = select(1, ...)
        options.Enable = true
        add_trigger(name, "wait_line_trigger('"..name.."')", name, options, order, pattern)
    end
    timeout = timeout or 0
    if timeout > 0 then
        add_timer(name, timeout, "wait_line_timer('"..name.."')", nil, {Enable=true, OneShot=true})
    end
    run(action)
    return coroutine.yield() or false
end

function wait_line_trigger(name, n, islast)
    if n == nil then
        del_timer(name)
        threads[name][2] = get_matches()
        wait_line_resume(name)
    else
        if islast == true then
            del_timer(name)
            threads[name][2][n] = get_matches()
            wait_line_resume(name)
        else
            threads[name][2][n] = get_matches()
            enable_trigger(name.."_"..tostring(n+1))
        end
    end
end

function wait_line_timer(name)
    del_trigger_group(name)
    threads[name][2] = nil
    wait_line_resume(name)
end

function wait_line_resume(name)
    del_trigger_group(name)
    local thread = ((threads or {})[name] or {})[1]
    if thread == nil then
        show("Coroutine lost", "orange")
        return false
    end
    if coroutine.status(thread) == "suspended" then
        local args = threads[name][2]
        threads[name] = nil
        local success,msg = coroutine.resume(thread, args)
        if success == false then
            show(msg, "red")
            show(debug.traceback(thread), "gray")
        end
    else
        add_timer(nil, 0, "wait_line_resume('"..name.."')", nil, {Enable=true, OneShot=true})
    end
end

function message(level, file, row, output, head)
    if global.debug[level] <= global.debug.level then
        local lua = set.last(string.split(file, "/"))
        head = string.rep("　　", head or 0)
        show(string.format("\n%-24s%-s%-s", lua.." - "..tostring(row)..":", head, output))
    end
end

show(" 已加载", "green")