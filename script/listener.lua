local line

function OnReceive(msg)
end

function OnSend(msg)
    loadstring(msg)()
end

while true do
    line = io.read()
    local typ,msg = string.match(line, "^(On%w+) %s*(.*)%s*$")
    if typ == "OnReceive" then
        OnReceive(msg)
    elseif typ == "OnSend" then
        OnSend(msg)
    end
end