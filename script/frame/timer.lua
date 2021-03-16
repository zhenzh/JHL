timer = timer or {}
timers = timers or {}
timers.group = timers.group or {}

function timer.add(...)
    local name,seconds,send,group,options
    if type(select(1, ...)) == "table" then
        local tinfo = select(1, ...)
        name = tinfo.name
        send = tinfo.send
        group = tinfo.group
        options = tinfo.options
        seconds = select(2, ...) or tinfo.seconds
    else
        name,seconds,send,group,options = ...
    end

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

    timers[name] = {
        name = name,
        send = send,
        group = group,
        seconds = seconds,
        options = options
    }

    if not options.OneShot then
        timers[name].id = tempTimer(seconds, send, true)
    else
        send = send.." timer.delete('"..name.."')"
        timers[name].id = tempTimer(seconds, send)
    end
    if group ~= nil then
        timers.group[group][name] = timers[name].id
    end
    if options.Enable == false then
        timer.disable(name)
    else
        timer.enable(name)
    end
    return name
end

function timer.delete(name)
    if not timer.is_exist(name) then
        return false
    end
    local rc = killTimer(timers[name].id)
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
    if not timer.is_exist(name) then
        return false
    end
    local rc = enableTimer(timers[name].id)
    if rc == true then
        timers[name].enable = true
        return true
    else
        timers[name].enable = false
        return false
    end
end

function timer.disable(name)
    if not timer.is_exist(name) then
        return false
    end
    local rc = disableTimer(timers[name].id)
    if rc == true then
        timers[name].enable = false
        return true
    else
        timers[name].enable = true
        return false
    end
end

function timer.remain(name)
    if not timer.is_exist(name) then
        return 0
    end
    return remainingTime(timers[name].id)
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
    if isActive(timers[name].id, "timer") == 0 then
        return false
    else
        return true
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

function timer.get(name)
    if timer.is_exist(name) == false then
        return nil
    end
    local tinfo = table.deepcopy(timers[name])
    tinfo.remain = timer.remain(name)
    return tinfo
end