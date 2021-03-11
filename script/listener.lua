local line

function OnReceive(raw, txt)
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
    if typ == "OnReceive" then
        local raw,txt = string.match(msg, "^RAW (.*) TXT (.*)$")
        OnReceive(raw, txt)
    elseif typ == "OnSend" then
        OnSend(msg)
    end
end