alias = alias or {}
aliases = aliases or {}

function alias_process(cmd)
    for k,v in pairs(aliases) do
        if v.enable == true then
            global.regex = regex.match(cmd, v.pattern)
            if global.regex ~= nil then
                loadstring(v.send)()
                return true
            end
        end
    end
    return false
end

function alias.add(name, pattern, send)
    aliases[name] = { pattern = pattern, send = send, enable = true }
    return name
end

function alias.delete(name)
    aliases[name] = nil
    return true
end

function alias.enable(name)
    aliases[name].enable = true
    return true
end

function alias.disable(name)
    aliases[name].enable = false
    return true
end

alias.add("reset", [[^\s*reset\s*$]], [[
    automation = automation or {}   
    automation.reconnect = nil
    reset()
]])

alias.add("repeat", [[^\s*#(\d+)\s+(.+)\s*$]], [[
    local num,send = tonumber(get_matches(1)),get_matches(2)
    local mch = regex.match(send, "^{(.+)}\s*;*\s*(.*)\s*")
    if mch == nil then
        for i=1,num do
            send_cmd(send)
        end
    else
        for i=1,tonumber(num) do
            send_cmd(mch[1])
        end
        if mch[2] ~= false then
            send_cmd(mch[2])
        end
    end
]])

alias.add("flush", [[^\s*flush\s*$]], [[
    flush_map()
    loadfile(get_script_path().."gps/template.lua")()
]])

alias.add("debug", [[^\s*debug\s+(\w+)\s*$]], [[
    verbose(get_matches(1))
]])

alias.add("gps", [[^\s*gps\s*$]], [[
    coroutine.wrap(function() locate() end)()
]])

alias.add("flyto", [[^flyto\s+(.+)$]], [[
    coroutine.wrap(function() goto(get_matches(1)) end)()
]])

alias.add("flynext", [[^\s*flynext\s*$]], [[
    coroutine.wrap(function() gonext() end)()
]])

alias.add("walkto", [[^walkto\s+(.*)$]], [[
    coroutine.wrap(function() goto(get_matches(1), "walk") end)()
]])

alias.add("walknext", [[^\s*walknext\s*$]], [[
    coroutine.wrap(function() gonext("walk") end)()
]])

alias.add("query", [[^\s*query (.*)\s*$]], [[
    show(set.tostring(parse(get_matches(1))), "pink")
]])

alias.add("auto", [[^\s*auto\s*$]], [[
    require "flow"
    coroutine.wrap(
        function ()
            load_jobs()
            if (config.jobs["门派任务"].phase or 0) < 2 then
                config.jobs["门派任务"].phase = nil
            end
            start()
        end
    )()
]])

alias.add("sync", [[^\s*sync\s*$]], [[
    require "flow"
    coroutine.wrap(
        function ()
            sync_skills()
        end
    )()
]])

alias.add("add_yun_desc", [[^\s*addyun ([-\w]+) (\w+) (\S+) (\S+)$]], [[
    add_yun_desc(get_matches(1), get_matches(2), get_matches(3), get_matches(4))
]])