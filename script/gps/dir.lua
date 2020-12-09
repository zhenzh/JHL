show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

dir_desc = {
    ["北"] =   "north",
    ["南"] =   "south",
    ["东"] =   "east",
    ["西"] =   "west",
    ["北面"] = "northup",
    ["南面"] = "southup",
    ["东面"] = "eastup",
    ["西面"] = "westup",
    ["北方"] = "northdown",
    ["南方"] = "southdown",
    ["东方"] = "eastdown",
    ["西方"] = "westdown",
    ["东北"] = "northeast",
    ["西北"]=  "northwest",
    ["东南"] = "southeast",
    ["西南"] = "southwest",
    ["上"] =   "up",
    ["下"] =   "down",
    ["外"] =   "out",
    ["内"] =   "enter",
    ["里"] =   "in",
    ["左"] =   "left",
    ["右"] =   "right"
}

dir_l2s = {
    ["east"] =      "e",
    ["south"] =     "s",
    ["west"] =      "w",
    ["north"]  =     "n",
    ["eastup"] =    "eu",
    ["westup"] =    "wu",
    ["northup"]  =   "nu",
    ["southup"]  =   "su",
    ["southwest"]  = "sw",
    ["southeast"]  = "se",
    ["northeast"]  = "ne",
    ["northwest"]  = "nw",
    ["up"] =        "u",
    ["down"] =      "d",
    ["eastdown"]  = "ed",
    ["westdown"]  = "wd",
    ["northdown"] = "nd",
    ["southdown"]  = "sd",
    ["enter"]  =     "enter",
    ["out"]  =       "out"
}


dir_s2l = {
    ["e"] =  "east",
    ["s"] =  "south",
    ["w"] =  "west",
    ["n"]  =  "north",
    ["eu"] = "eastup",
    ["wu"] = "westup",
    ["nu"] = "northup",
    ["su"] = "southup",
    ["sw"] = "southwest",
    ["se"] = "southeast",
    ["ne"] = "northeast",
    ["nw"] = "northwest",
    ["u"]  =  "up",
    ["d"] =  "down",
    ["ed"] = "eastdown",
    ["wd"] = "westdown",
    ["nd"] = "northdown",
    ["sd"] = "southdown"
}

dir_rev = {
    ["east"] =      "west",
    ["south"] =     "north",
    ["west"] =      "east",
    ["north"]  =     "south",
    ["eastup"] =    "westdown",
    ["westup"] =    "eastdown",
    ["northup"]  =   "southdown",
    ["southup"]  =   "northdown",
    ["southwest"]  = "northeast",
    ["southeast"]  = "northwest",
    ["northeast"]  = "southwest",
    ["northwest"]  = "southeast",
    ["up"] =        "down",
    ["down"] =      "up",
    ["eastdown"]  = "westup",
    ["westdown"]  = "eastup",
    ["northdown"] = "southup",
    ["southdown"]  = "northup",
    ["enter"]  =     "out",
    ["out"]  =       "enter",
    ["left"] = "right",
    ["right"] = "left",
    ["东"] = "西",
    ["南"] = "北",
    ["西"] = "东",
    ["北"] = "南",
    ["北面"] = "南面",
    ["南面"] = "北面",
    ["东面"] = "西面",
    ["西面"] = "东面",
    ["北方"] = "南方",
    ["南方"] = "北方",
    ["东方"] = "西方",
    ["西方"] = "东方",
    ["东北"] = "西南",
    ["西北"]=  "东南",
    ["东南"] = "西北",
    ["西南"] = "东北",
    ["上"] =   "下",
    ["下"] =   "上",
    ["外"] =   "内",
    ["内"] =   "外",
    ["左"] =   "右",
    ["右"] =   "左"
}

function is_shortdir(dir)
    if dir_s2l[dir or ""] ~= nil then
        return true
    else
        return false
    end
end

function is_longdir(dir)
    if dir_l2s[dir or ""] ~= nil then
        return true
    else
        return false
    end
end

function is_dir(dir)
   if is_shortdir(dir) or is_longdir(dir) then
       return true
   else
       return false
   end
end

function get_long_dir(dir)
    if is_shortdir(dir) then
        return dir_s2l[dir]
    else
        return dir
    end
end

function get_short_dir(dir)
    if is_longdir(dir) then
        return dir_l2s[dir]
    else
        return dir
    end
end

function get_reverse_dir(dir)
    if dir == nil then
        return false
    end
    if is_dir(dir) then
        return dir_rev[get_long_dir(dir)]
    else
        return false
    end
end

show(" 已加载", "green")