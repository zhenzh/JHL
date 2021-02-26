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

alias.add("reset", [[^\s*reset\s*(.*)\s*$]], [[
    automation = automation or {}   
    automation.reconnect = nil
    if matches[2] == "-f" then
        reset(true)
    else
        reset()
    end
]])

alias.add("lua", [[^/\s*(.*)\s*$]], [[
    assert(loadstring(matches[2]))()
]])

alias.add("repeat", [[^#(\d+) (.*)$]], [[
    for i = 1, tonumber(matches[2]) do
        expandAlias(string.gsub(matches[3], " %%i", " "..tostring(i)), false)
    end
]])

alias.add("flush", [[^\s*flush\s*$]], [[
    flush_map()
    assert(loadfile(get_script_path().."gps/template.lua"))()
]])

alias.add("debug", [[^\s*debug\s+(\w+)\s*$]], [[
    verbose(matches[2])
]])

alias.add("dump", [[^\s*dump\s*$]], [[
    dump()
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

alias.add("query", [[^\s*query (.*)\s*$]], [[
    show(set.tostring(parse(matches[2])), "pink")
]])

alias.add("auto", [[^\s*auto(?:\s+(-\w+)|\s*)$]], [[
    if automation.thread ~= nil then
        return
    end    
    require "flow"
    if string.match(tostring(matches[2]), "-f") then
        fresh_statistics()
        global.jid = 1
        automation.jid = nil
        automation.config = nil
    end
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

alias.add("statistics", [[^\s*stat(?:\s+([\-ls]+)\s+(\d+)|\s+([\-ls]+)|\s+(\d+)|)\s*$]], [[
    local mode,shift = (matches[2] or ''),(matches[3] or '')
    local mode_map = {
        ["-s"] = "summary",
        ["-l"] = "list"
    }
    if mode == "" then
        mode = matches[4] or ""
    end
    if mode == "" then
        shift = matches[5] or ""
    end
    if mode == "" then
        mode = "-s"
    end
    if shift == "" then
        shift = 1
    end
    statistics(mode_map[mode], tonumber(shift))
]])

alias.add("add_yun_desc", [[^\s*addyun ([-\w]+) (\w+) (\S+) (\S+)$]], [[
    add_yun_desc(matches[2], matches[3], matches[4], matches[5])
]])