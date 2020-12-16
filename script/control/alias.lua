alias = alias or {}
aliases = aliases or {}

function alias.add(name, pattern, send)
    if name == nil or name == "" then
        name = "alias_"..unique_id()
    end
    if aliases[name] ~= nil then
        alias.delete(name)
    end
    aliases[name] = tempAlias(pattern, send)
    return name
end

function alias.delete(name)
    local rc = killAlias(aliases[name])
    aliases[name] = nil
    return rc
end

alias.add("reset", [[^\s*reset\s*$]], [[
    automation = automation or {}   
    automation.reconnect = nil
    reset()
]])

alias.add("lua", [[^/\s*(.*)\s*$]], [[
    assert(loadstring(matches[2])())
]])

alias.add("flush", [[^\s*flush\s*$]], [[
    flush_map()
    assert(loadfile(get_script_path().."gps/template.lua")())
]])

alias.add("debug", [[^\s*debug\s+(\w+)\s*$]], [[
    verbose(matches[2])
]])

alias.add("gps", [[^\s*gps\s*$]], [[
    coroutine.wrap(function() locate() end)()
]])

alias.add("flyto", [[^flyto\s+(.+)$]], [[
    coroutine.wrap(function() goto(matches[2]) end)()
]])

alias.add("flynext", [[^\s*flynext\s*$]], [[
    coroutine.wrap(function() gonext() end)()
]])

alias.add("walkto", [[^walkto\s+(.*)$]], [[
    coroutine.wrap(function() goto(matches[2], "walk") end)()
]])

alias.add("walknext", [[^\s*walknext\s*$]], [[
    coroutine.wrap(function() gonext("walk") end)()
]])

alias.add("repeat", [[^#(\d+) (.*)$]], [[
    for i = 1, tonumber(matches[2]) do
        expandAlias(matches[3], false)
    end
]])

alias.add("query", [[^\s*query (.*)\s*$]], [[
    show(set.tostring(parse(matches[2])), "pink")
]])

alias.add("start", [[^\s*rstart\s*$]], [[
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
    add_yun_desc(matches[2], matches[3], matches[4], matches[5])
]])