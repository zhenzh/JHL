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
        options = options,
        elapsed = 0
    }

    if not options.OneShot then
        timers[name].id = "Ticker"
    else
        timers[name].id = "Delay"
    end

    if group ~= nil then
        timers.group[group][name] = timers[name].id
    end
    if options.Enable == false then
        timer.disable(name)
    else
        timer.enable(name)
    end
    return true
end

function timer.delete(name)
    if not timer.is_exist(name) then
        return false
    end
    print("Un"..string.lower(timers[name].id).." "..name)
    if timers[name] ~= nil and timers[name].group ~= nil then
        timers.group[timers[name].group][name] = nil
        if table.is_empty(timers.group[timers[name].group]) then
            timers.group[timers[name].group] = nil
        end
    end
    timers[name] = nil
    return true
end

function timer.enable(name)
    if not timer.is_exist(name) then
        return false
    end
    if timer.is_enable(name) then
        return true
    end
    local send = timers[name].send
    if timers[name].id == "Delay" then
        send = send.." timer.delete('"..name.."')"
        timers[name].seconds = math.max(0, timers[name].seconds - timers[name].elapsed)
    end
    timers[name].elapsed = 0
    print("Unticker "..name)
    print("Undelay "..name)
    print(timers[name].id.." "..name.." "..tostring(timers[name].seconds).." "..send)
    timers[name].created = time.epoch()
    timers[name].enable = true
    return true
end

function timer.disable(name)
    if not timer.is_exist(name) then
        return false
    end
    print("Un"..string.lower(timers[name].id).." "..name)
    timers[name].elapsed = (time.epoch() - (timers[name].created or time.epoch())) / 1000
    timers[name].enable = false
    return true
end

function timer.remain(name)
    if not timer.is_exist(name) then
        return 0
    end
    if timers[name].elapsed > 0 then
        return timers[name].seconds - (timers[name].elapsed / 1000)
    end
    return timers[name].seconds - ((time.epoch() - timers[name].created) / 1000)
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
    if timers[name].enable == true then
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

function timer.get(name)
    if timer.is_exist(name) == false then
        return nil
    end
    local tinfo = table.deepcopy(timers[name])
    tinfo.remain = timer.remain(name)
    return tinfo
end