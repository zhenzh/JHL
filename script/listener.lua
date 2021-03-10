local line

function OnReceive(raw, txt)
end

function OnSend(msg)
    assert(loadstring(msg))()
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