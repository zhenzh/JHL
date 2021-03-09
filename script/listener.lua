local line

function OnReceive(raw, txt)
end

function OnSend(msg)
    assert(loadstring(msg)() or true)
end

while true do
    line = io.read()
    local typ,msg = string.match(line, "^(On%w+) (.*)$")
    if typ == "OnReceive" then
        local raw,txt = string.match(msg, "^RAW (.*) TXT (.*)$")
        assert(OnReceive(raw, txt) or true)
    elseif typ == "OnSend" then
        assert(OnSend(msg) or true)
    end
end