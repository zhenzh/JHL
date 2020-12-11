require "tableEx"
require "set"
require "stringEx"
require "timeEx"

triggers = triggers or { update = true}
triggers.group = triggers.group or {}
triggers.pended = triggers.pended or {}
triggers.fire = triggers.fire or {}
if #triggers.fire == 0 then
    for i=1,100 do
        set.append(triggers.fire, {})
    end
end

function trigger_process(text)
    while #global.buffer >= 100 do
        set.remove(global.buffer, 1)
    end
    set.append(global.buffer, text)
    for k,v in ipairs(triggers.fire) do
        triggers.update = false
        for i,_ in pairs(v) do
            if trigger_process_exec(i) == true then
                triggers.update = true
                trigger_process_pending()
                return true
            end
        end
        triggers.update = true
        trigger_process_pending()
    end
    return true
end

function trigger_process_pending()
    for _,v in ipairs(triggers.pended) do
        v[1](v[2], v[3], v[4], v[5], v[6], v[7])
    end
    triggers.pended = {}
end

function trigger_process_exec(name)
    if is_trigger_exist(name) == false then
        return
    end

    if trigger_regex(name) == false then
        return
    end

    if triggers[name].options.Gag == true then
        gag()
    end

    if triggers[name].options.OneShot == true then
        del_trigger(name)
    end

    loadstring(triggers[name].send)()

    if triggers[name].options.StopEval == true then
        return true
    end
    return
end

function unique_id()
    local id = time.epoch()
    if global.uid[1] ~= id then
        global.uid = { id }
        id = tostring(id)
    else
        id = tostring(id)..tostring(#global.uid)
        set.append(global.uid, 0)
    end
    return id
end

function add_trigger(name, send, group, options, order, pattern)
    if name == "group" or 
       name == "fire" or 
       name == "pended" or 
       name == "update" then
        print("invalid name: "..name)
        return nil
    end
    if name == nil or name == "" then
        name = "trigger_"..unique_id()
    end

    options = options or {}
    if options.Enable == nil then
        options.Enable = true
    end
    order = order or 100

    if triggers.update == false then
        set.append(triggers.pended, {add_trigger, name, send, group, options, order, pattern})
        return nil
    end

    if is_trigger_exist(name) == true then
        del_trigger(name)
    end

    triggers[name] = {
        pattern = pattern,
        send = send,
        options = options,
        group = group,
        order = order
    }

    if options.Multi ~= nil then
        triggers[name].multilines = #string.split(pattern, "\\n")
    end

    if group ~= nil then
        triggers.group[group] = triggers.group[group] or {}
        triggers.group[group][name] = true
    end

    if options.Enable == true then
        triggers.fire[order][name] = true
    end

    return name
end

function del_trigger(name)
    if triggers.update == false then
        set.append(triggers.pended, {del_trigger, name})
        return nil
    end

    if is_trigger_exist(name) == false then
        return false
    end

    disable_trigger(name)
    if triggers[name].group ~= nil then
        triggers.group[triggers[name].group][name] = nil
    end
    triggers[name] = nil
    return true
end

function enable_trigger(name)
    if triggers.update == false then
        set.append(triggers.pended, {enable_trigger, name})
        return nil
    end

    if is_trigger_exist(name) == false then
        return false
    end

    if is_trigger_enable(name) == true then
        return true
    end

    triggers.fire[triggers[name].order][name] = true
    return true
end

function disable_trigger(name)
    if triggers.update == false then
        set.append(triggers.pended, {disable_trigger, name})
        return nil
    end

    if is_trigger_exist(name) == false then
        return false
    end

    if is_trigger_enable(name) == false then
        return true
    end

    triggers.fire[triggers[name].order][name] = nil
    return true
end

function is_trigger_exist(name)
    if triggers[name] == nil then
        return false
    else
        return true
    end
end

function is_trigger_enable(name)
    if is_trigger_exist(name) == false then
        return false
    end

    if triggers.fire[triggers[name].order][name] == nil then
        return false
    else
        return true
    end
end

function enable_trigger_group(group)
    if triggers.group[group] == nil then
        return false
    end

    for k,_ in pairs(triggers.group[group]) do
        enable_trigger(k)
    end
    return true
end

function disable_trigger_group(group)
    if triggers.group[group] == nil then
        return false
    end

    for k,_ in pairs(triggers.group[group]) do
        disable_trigger(k)
    end
    return true
end

function del_trigger_group(group)
    if triggers.group[group] == nil then
        return false
    end

    for k,_ in pairs(triggers.group[group]) do
        del_trigger(k)
    end
    return true
end