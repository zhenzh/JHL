function alias_reset(opt)
    automation = automation or {}
    automation.reconnect = nil
    config.jobs["门派任务"].active = true
    if opt == "-f" then
        reset(true)
    else
        reset()
    end
end

function alias_flush()
    flush_map()
    loadfile(get_script_path().."gps/template.lua")()
end

function alias_debug(lvl)
    verbose(lvl)
end

function alias_dump()
    dump()
end

function alias_gps()
    coroutine.wrap(function() locate() end)()
end

function alias_flyto(tgt)
    coroutine.wrap(function() goto(tgt) end)()
end

function flynext()
    coroutine.wrap(function() gonext() end)()
end

function alias_walkto(tgt)
    coroutine.wrap(function() goto(tgt, "walk") end)()
end

function walknext()
    coroutine.wrap(function() gonext("walk") end)()
end

function alias_query(tgt)
    show(set.tostring(parse(tgt)), "pink")
end

function alias_auto(opt)
    if automation.thread ~= nil then
        return
    end
    require "flow"
    if string.match(tostring(opt), "-f") then
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
end

function alias_sync()
    require "flow"
    coroutine.wrap(
        function ()
            sync_skills()
        end
    )()
end

function alias_statistics(opt1, opt2, opt3, opt4)
    local mode,shift = (opt1 or ''),(opt2 or '')
    local mode_map = {
        ["-s"] = "summary",
        ["-l"] = "list"
    }
    if mode == "" then
        mode = opt3 or ""
    end
    if mode == "" then
        shift = opt4 or ""
    end
    if mode == "" then
        mode = "-s"
    end
    if shift == "" then
        shift = 1
    end
    statistics(mode_map[mode], tonumber(shift))
end

function alias_add_yun_desc(force_name, yun, valid_desc, invalid_desc)
    add_yun_desc(force_name, yun, valid_desc, invalid_desc)
end