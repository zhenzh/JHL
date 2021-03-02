local line

function OnReceive(msg)
end

function OnSend(msg)
    print("Send "..msg)
end

while true do
    line = io.read()
    local typ,msg = string.match(line, "^((?:OnSend|OnReceive)) (.*)$")
    if typ == "OnReceive" then
        OnReceive(msg)
    elseif typ == "OnSend" then
        OnSend(msg)
    end
end