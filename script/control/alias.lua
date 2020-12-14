show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

add_alias("reset", [[^\s*reset\s*$]], [[
    automation = automation or {}   
    automation.reconnect = nil
    reset()
]])

add_alias("lua", [[^/\s*(.*)\s*$]], [[
    display(assert(loadstring(matches[2])()))
]])

add_alias("flush", [[^\s*flush\s*$]], [[
    flush_map()
    loadfile(get_script_path().."gps/template.lua")()
]])

add_alias("debug", [[^\s*debug\s+(\w+)\s*$]], [[
    verbose(matches[2])
]])

add_alias("gps", [[^\s*gps\s*$]], [[
    coroutine.wrap(function() locate() end)()
]])

add_alias("flyto", [[^flyto\s+(.+)$]], [[
    coroutine.wrap(function() goto(matches[2]) end)()
]])

add_alias("flynext", [[^\s*flynext\s*$]], [[
    coroutine.wrap(function() gonext() end)()
]])

add_alias("walkto", [[^walkto\s+(.*)$]], [[
    coroutine.wrap(function() goto(matches[2], "walk") end)()
]])

add_alias("walknext", [[^\s*walknext\s*$]], [[
    coroutine.wrap(function() gonext("walk") end)()
]])

add_alias("repeat", [[^#(\d+) (.*)$]], [[
    for i = 1, tonumber(matches[2]) do
        expandAlias(matches[3], false)
    end
]])

add_alias("query", [[^\s*query (.*)\s*$]], [[
    show(set.tostring(parse(matches[2])), "pink")
]])

add_alias("start", [[^\s*rstart\s*$]], [[
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

add_alias("sync", [[^\s*sync\s*$]], [[
    require "flow"
    coroutine.wrap(
        function ()
            sync_skills()
        end
    )()
]])

add_alias("add_yun_desc", [[^\s*addyun ([-\w]+) (\w+) (\S+) (\S+)$]], [[
    add_yun_desc(matches[2], matches[3], matches[4], matches[5])
]])

show(" 已加载", "green")