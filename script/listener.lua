local line

function OnReceiveRAW(msg)
    return true
end

function OnReceiveTXT(msg)
    return true
end

function OnSend(msg)
    local rc,trc = xpcall(loadstring(msg), debug.traceback)
    if rc ~= true then
        print("Debug "..trc)
        return false
    end
    return true
end

while true do
    line = io.read()
    local typ,msg = string.match(line, "^(On%w+) (.*)$")
    if typ == "OnReceiveTXT" then
        OnReceiveTXT(msg)
    elseif typ == "OnSend" then
        OnSend(msg)
    end
end