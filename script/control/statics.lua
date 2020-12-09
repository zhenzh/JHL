function statics_details(time_shift)
    if time_shift == nil then
        time_shift = os.time() - 3600
    elseif type(time_shift) == "number" then
        time_shite = os.time() - (3600 * time_shift)
    else
        show("统计时间不正确", "red")
        return false
    end
    show(string.format("%68s", ""), "white", "gray")
    show(string.format("%7s%-13s%8s%-8s%10s%10s%10s%2s", "", "完成时间", "", "任务名", "获得经验", "获得潜能", "用时", ""), "white", "gray")
    local font_color = "black"
    local back_color = "palegreen"
    local details_shift = {}
    for i = #details, 1, -1 do
        if os.time(details[i][1]) >= time_shift then
            set.insert(details_shift, 1, details[i])
        else
            break
        end
    end
    for _,v in ipairs(details_shift) do
        if back_color == "palegreen" then
            back_color = "#C5FFCA"
        else
            back_color = "palegreen"
        end
        show(string.format("%20s%16s%10s%10s%10s%2s", v[1]["year"].."/"..v[1]["month"].."/"..v[1]["day"].." "..v[1]["hour"]..":"..v[1]["min"]..":"..v[1]["sec"], v[2], tostring(v[3]), tostring(v[4]), tostring(v[5]), ""), font_color, back_color)
    end
end

function statics_classify()
end
