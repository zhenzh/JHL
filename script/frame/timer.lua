timer = timer or {}
timers = timers or {}
timers.group = timers.group or {}

function call_timer_actions(name)
    if timer.is_exist(name) == false then
        return nil
    end
    local rc = loadstring(timers[name].send)()
    if timer.is_exist(name) == true then
        if timers[name].options.OneShot == true then
            timer.delete(name)
        end
    end
    return rc
end

function timer.add(name, seconds, send, group, options)
    if name == nil or name == "" then
        name = "timer_"..unique_id()
    end
    if group == "" then
        group = nil
    end
    if group ~= nil then
        timers.group[group] = timers.group[group] or {}
    end
    options = options or {}

    timers[name] = { send = send, group = group, seconds = seconds, options = options }
    if group ~= nil then
        timers.group[group][name] = true
    end
    if options.OneShot == true then
        if options.Enable ~= false then
            AddTimer(name, "show('test1')", seconds*1000, 1)
        end
    else
        if options.Enable ~= false then
            AddTimer(name, "show('test2')", seconds*1000, 0)
        end
    end
    return name
end

function timer.delete(name)
    local rc = DelTimer(name)
    if timers[name] ~= nil and timers[name].group ~= nil then
        timers.group[timers[name].group][name] = nil
        if table.is_empty(timers.group[timers[name].group]) then
            timers.group[timers[name].group] = nil
        end
    end
    timers[name] = nil
    return rc
end

function timer.enable(name)
    if timer.is_exist(name) == false then
        return false
    end
    if timer.is_enable(name) == true then
        return true
    end
    timers[name].options.Enable = true
    if timers[name].options.OneShot == true then
        return AddTimer(name, timers[name].send, timers[name].seconds*1000, 1)
    else
        return AddTimer(name, timers[name].send, timers[name].seconds*1000, 0)
    end
end

function timer.disable(name)
    if timer.is_exist(name) == false then
        return false
    end
    DelTimer(name)
    timers[name].options.Enable = false
end

function timer.remain(name)
    return "unknown"
end

function timer.is_exist(name)
    if timers[name] == nil then
        return false
    else
        return true
    end
end

function timer.is_enable(name)
    if timer.is_exist(name) == false then
        return false
    end
    if timers[name].options.Enable == true then
        return true
    else
        return false
    end
end

function timer.enable_group(group)
    local rc = true
    for k,_ in pairs(timers.group[group] or {}) do
        rc = rc and timer.enable(k)
    end
    return rc
end

function timer.disable_group(group)
    local rc = true
    for k,_ in pairs(timers.group[group] or {}) do
        rc = rc and timer.disable(k)
    end
    return rc
end

function timer.delete_group(group)
    local rc = true
    for k,_ in pairs(timers.group[group] or {}) do
        rc = rc and timer.delete(k)
    end
    return rc
end