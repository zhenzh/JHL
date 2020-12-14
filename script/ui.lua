setBorderLeft(150)
setBorderRight(400)
setBorderTop(100)

--按钮栏背景
setAppStyleSheet([[
    QToolBar {border-image: url("]]..get_script_path()..[[image/sky.png");} 
    QToolBar QToolButton:!hover {color: black;}
    QToolBar QToolButton:hover {color: white;}
]])

--左边背景
left_wallpaper = Geyser.Label:new({
    name = "left_wallpaper",
    x = 0, y = 0,
    width = 140, height = "100%",
})

left_wallpaper:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/wallpaper.png");
    background-repeat: repeat-xy;
    background-position: top left;
    background-origin: padding;
]])

--右边背景
right_wallpaper = Geyser.Label:new({
    name = "right_wallpaper",
    x = -400, y = 0,
    width = 400, height = "100%",
})

right_wallpaper:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/wallpaper.png");
    background-repeat: repeat-xy;
    background-position: bottom right;
    background-origin: padding;
]])

--顶边背景
top_wallpaper = Geyser.Label:new({
    name = "top_wallpaper",
    x = 0, y = 0,
    width = "100%", height = 100,
})

top_wallpaper:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/wallpaper.png");
    background-repeat: repeat-xy;
    background-position: top left;
    background-origin: padding;
]])

--装饰
sky = Geyser.Label:new({
    name = "sky",
    x = 0, y = 0,
    width = window_size().width - 390, height = "100%",
}, top_wallpaper)

sky:setStyleSheet([[
    border-image: url("]]..get_script_path()..[[image/sky.png");
]])

lake_top = Geyser.Label:new({
    name = "lake_top",
    x = 0, y = 0,
    width = "100%", height = "100%",
}, top_wallpaper)

lake_top:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/lake_top.png");
    background-repeat: no-repeat;
    background-position: top right;
    background-origin: padding;
]])

lake_right = Geyser.Label:new({
    name = "lake2",
    x = 0, y = 0,
    width = "100%", height = "100%",
}, right_wallpaper)

lake_right:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/lake_right.png");
    background-repeat: no-repeat;
    background-position: top right;
    background-origin: padding;
]])

sword_man = Geyser.Label:new({
    name = "sword_man",
    x = 0, y = -350,
    width = "100%", height = 350,
}, left_wallpaper)

sword_man:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/sword_man.png");
    background-repeat: no-repeat;
    background-position: bottom right;
    background-origin: padding;
]])

banboo_left = Geyser.Label:new({
    name = "banboo_left",
    x = 0, y = 0,
    width = 175, height = 280,
}, left_wallpaper)

banboo_left:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/banboo_left.png");
    background-repeat: no-repeat;
    background-position: top left;
    background-origin: padding;
]])

banboo_top = Geyser.Label:new({
    name = "banboo_top",
    x = 0, y = 0,
    width = 460, height = "100%",
}, top_wallpaper)

banboo_top:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/banboo_top.png");
    background-repeat: no-repeat;
    background-position: top right;
    background-origin: padding;
]])

banner = Geyser.Label:new({
    name = "banner",
    x = window_size().width/2 - 300, y = 0,
    width = 340, height = "100%",
}, top_wallpaper)

banner:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/banner.png");
    background-repeat: no-repeat;
    background-position: top left;
]])

char = Geyser.Label:new({
    name = "char",
    x = 10, y = 90,
    width = 120, height = 200,
}, left_wallpaper)

char:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/map_background.png");
    border-image: url("]]..get_script_path()..[[image/char_border.png");
    border: 5px;
    border-radius: 5px;
]])

setup = Geyser.Label:new({
    name = "setup",
    x = 0, y = -50,
    width = 110, height = 36,
}, left_wallpaper)

setup:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/setup.png");
    background-position: top right;
    border: 18;
    border-radius: 18;
]])

container = container or {}

--地图栏
container.right_top = Geyser.Container:new({
    name = "container.right_top",
    x = -380, y = 15,
    width = 360, height = 337,
}, main)

map_window = Geyser.Label:new({
    name = "map_window",
    x = 0, y = 0,
    width = "100%", height = "100%",
}, container.right_top)

map_window:setStyleSheet([[
    background-image: url("]]..get_script_path()..[[image/map_background.png");
    background-repeat: repeat-xy;
    border-image: url("]]..get_script_path()..[[image/map_border.png");
]])

map_console = Geyser.Mapper:new({
    name = "map_console",
    x = 12, y = 12,
    width = 336, height = 313,
}, map_window)

--信息栏
container.right_bottom = Geyser.Container:new({
    name = "container.right_bottom",
    x = -390, y = 360,
    width = 380, height = window_size().height - 360,
}, main)

info = info or {
    tabs = {"聊天", "人物", "物品", "装备", "技能"},
}
info.current = info.current or info.tabs[1]

info.header = Geyser.HBox:new({
    name = "info.header",
    x = 0, y = 0,
    width = "100%", height = 25,
}, container.right_bottom)

info.footer = Geyser.Label:new({
    name = "info.footer",
    x = 0, y = 25,
    width = "100%", height = window_size().height - 390,
}, container.right_bottom)

info.footer:setStyleSheet([[
    border: 8px groove rgba(128,128,128,80%);
]])

for k,v in pairs(info.tabs) do
    info[v.."页"] = Geyser.Label:new({
        name = "info."..v.."页",
        message = "<center>"..v.."</center>",
    }, info.header)
    
    info[v.."页"]:setStyleSheet([[
        QLabel{
            background-color: rgba(64,64,64,80%);
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            margin-right: 1px;
        }
        QLabel::hover{
            background-color: rgba(128,128,128,80%);
        }
    ]])
    
    info[v.."页"]:setFontSize(15)
    info[v.."页"]:setFont("KaiTi")
    info[v.."页"]:setClickCallback("info.click", v)
end

for k,v in pairs({"聊天", "物品", "技能"}) do
    info[v] = Geyser.MiniConsole:new({
        name = v,
        x = 8, y = 8,
        width = 364, height = window_size().height - 406,
        autoWrap = true,
        scrollBar = true,
        fontSize = 10,
    }, info.footer)
    
    info[v]:hide()
end

for k,v in pairs({"人物", "装备"}) do
    info[v] = Geyser.Label:new({
        name = v,
        x = 8, y = 8,
        width = 364, height = window_size().height - 406,
    }, info.footer)

    info[v]:hide()
end

function info.click(tab)
    info[info.current]:hide()
    info[info.current.."页"]:setStyleSheet([[
        QLabel{
            background-color: rgba(64,64,64,80%);
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            margin-right: 1px;
        }
        QLabel::hover{
            background-color: rgba(128,128,128,80%);
        }
    ]])
    info.current = tab
    info[tab.."页"]:setStyleSheet([[
        QLabel{
            background-color: rgba(128,128,128,80%);
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            margin-right: 1px;
        }
    ]])
    info[info.current]:show()
end

container.status = Adjustable.Container:new({
    name = "container.status",
    adjLabelstyle = "background-color: rgba(0,0,0,50%); border-radius: 5px;",
    buttonstyle=[[
      QLabel{ border-radius: 7px; background-color: rgba(50,50,50,50%);}
      QLabel::hover{ background-color: rgba(160,160,160,50%);}
      ]],
    buttonFontSize = 10,
    buttonsize = 14,
    autoLoad = true,
    autoSave = true
})

container.status:setTitle("")

state.panel = Geyser.Label:new({
    name = "state.panel",
    x = 0, y = 0,
    width = "100%", height = "100%"
}, container.status)

state.panel:setStyleSheet([[
    border-image: url("]]..get_script_path()..[[image/status_border.png");
]])

local gauge_color = {
    blue = {
        current = "stop: 0 #41f0f0, stop: 0.1 #29f0f0, stop: 0.49 #00cccc, stop: 0.5 #00a3a3, stop: 1 #00cccc",
        max = "stop: 0 #33bdbd, stop: 0.1 #20bdbd, stop: 0.49 #009999, stop: 0.5 #007070, stop: 1 #009999"
    },
    green = {
        current = "stop: 0 #a7f041, stop: 0.1 #9df029, stop: 0.49 #77cc00, stop: 0.5 #5fa300, stop: 1 #77cc00",
        max = "stop: 0 #84bd33, stop: 0.1 #7cbd20, stop: 0.49 #599900, stop: 0.5 #417000, stop: 1 #599900"
    },
    yellow = {
        current = "stop: 0 #f0f041, stop: 0.1 #f0f029, stop: 0.49 #cccc00, stop: 0.5 #a3a300, stop: 1 #cccc00",
        max = "stop: 0 #bdbd33, stop: 0.1 #bdbd20, stop: 0.49 #999900, stop: 0.5 #707000, stop: 1 #999900"
    },
    red = {
        current = "stop: 0 #f04141, stop: 0.1 #f02929, stop: 0.49 #cc0000, stop: 0.5 #a30000, stop: 1 #cc0000",
        max = "stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000"
    }
}

state.bar = {
    "精神", ["精神"] = "js", js = {},
    "气血", ["气血"] = "qx", qx = {},
    "精力", ["精力"] = "jl", jl = {},
    "内力", ["内力"] = "nl", nl = {},
}

local bar_id = 0
for _,v in ipairs(state.bar) do

state.bar[state.bar[v]].bar = Geyser.Label:new({
    name = state.bar[v]..".bar",
    x = "5%", y = tostring(20*bar_id+10).."%",
    width = "90%", height = "20%",
    fgColor = "white",
    message = v.."：",
}, container.status)

state.bar[state.bar[v]].bar:setStyleSheet([[background-color: rgba(0,0,0,0%);]])
state.bar[state.bar[v]].bar:setFontSize(15)
state.bar[state.bar[v]].bar:setFont("KaiTi")

state.bar[state.bar[v]].max_gauge = Geyser.Gauge:new({
    name = state.bar[v]..".max_gauge",
    x = "15%", y = "22%",
    width = "65%", height = "56%",
}, state.bar[state.bar[v]].bar)

state.bar[state.bar[v]].max_gauge:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

state.bar[state.bar[v]].max_gauge.back:setStyleSheet([[
    background-color: rgba(128,128,128,50%);
    border-top: 3px;
    border-bottom: 3px;
    border-color: rgba(0,0,0,0%);
    border-style: solid;
    border-radius: 5px;
]])

state.bar[state.bar[v]].max_gauge.front:setStyleSheet([[
    background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color.green.max..[[);
    border-top: 3px;
    border-bottom: 3px;
    border-color: rgba(0,0,0,0%);
    border-style: solid;
    border-radius: 5px;
]])

state.bar[state.bar[v]].current_gauge = Geyser.Gauge:new({
    name = state.bar[v]..".current_gauge",
    x = 0, y = 0,
    width = "100%", height = "100%",
}, state.bar[state.bar[v]].max_gauge)

state.bar[state.bar[v]].current_gauge:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

state.bar[state.bar[v]].current_gauge.front:setStyleSheet([[
    background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color.green.current..[[);
    border-top: 2px black solid;
    border-bottom: 2px black solid;
    border-radius: 5px;
]])

state.bar[state.bar[v]].over_gauge = Geyser.Gauge:new({
    name = state.bar[v]..".over_gauge",
    x = 0, y = 0,
    width = "100%", height = "100%",
}, state.bar[state.bar[v]].current_gauge)

state.bar[state.bar[v]].over_gauge:setFontSize(13)
state.bar[state.bar[v]].over_gauge:setStyleSheet([[background-color: rgba(0,0,0,0%);]])
state.bar[state.bar[v]].over_gauge.front:setStyleSheet([[
    background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color.blue.current..[[);
    border-top: 2px black solid;
    border-bottom: 2px black solid;
    border-radius: 5px;
]])

state.bar[state.bar[v]].over_gauge:setValue(100,100,"<center>/</center>")

state.bar[state.bar[v]].max = Geyser.Label:new({
    name = state.bar[v]..".max",
    x = "-48%", y = 0,
    width = "48%", height = "100%",
    fgColor = "white",
    message = "na",
}, state.bar[state.bar[v]].current_gauge)

state.bar[state.bar[v]].max:setFontSize(13)
state.bar[state.bar[v]].max:setAlignment("left")
state.bar[state.bar[v]].max:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

state.bar[state.bar[v]].current = Geyser.Label:new({
    name = state.bar[v]..".current",
    x = 0, y = 0,
    width = "48%", height = "100%",
    fgColor = "white",
    message = "na",
}, state.bar[state.bar[v]].current_gauge)

state.bar[state.bar[v]].current:setFontSize(13)
state.bar[state.bar[v]].current:setAlignment("right")
state.bar[state.bar[v]].current:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

bar_id = bar_id + 1

end

state.bar.js.pct = Geyser.Label:new({
    name = "js.pct",
    x = 0, y = 0,
    width = "95%", height = "100%",
    fgColor = "white",
}, state.bar.js.bar)

state.bar.js.pct:setFontSize(13)
state.bar.js.pct:setAlignment("right")
state.bar.js.pct:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

state.bar.qx.pct = Geyser.Label:new({
    name = "qx.pct",
    x = 0, y = 0,
    width = "95%", height = "100%",
    fgColor = "white",
}, state.bar.qx.bar)

state.bar.qx.pct:setFontSize(13)
state.bar.qx.pct:setAlignment("right")
state.bar.qx.pct:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

state.bar.jl.energy = Geyser.Label:new({
    name = "jl.energy",
    x = "82%", y = 0,
    width = "15%", height = "100%",
    fgColor = "white",
}, state.bar.jl.bar)

state.bar.jl.energy:setFontSize(13)
state.bar.jl.energy:setAlignment("left")
state.bar.jl.energy:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

state.bar.nl.power = Geyser.Label:new({
    name = "nl.power",
    x = "82%", y = 0,
    width = "15%", height = "100%",
    fgColor = "white",
}, state.bar.nl.bar)

state.bar.nl.power:setFontSize(13)
state.bar.nl.power:setAlignment("left")
state.bar.nl.power:setStyleSheet([[background-color: rgba(0,0,0,0%);]])

function update_state_l1_gauge()
    local js_max = state.js_max*math.min(1, 100/state.js_pct)
    local color
    if state.js / js_max < 0.5 then
        color = "red"
    elseif state.js / js_max < 0.8 then
        color = "yellow"
    else
        color = "green"
    end
    
    state.bar.js.pct:echo(tostring(state.js_pct).."%")
    state.bar.js.max_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].max..[[);
        border-top: 3px;
        border-bottom: 3px;
        border-color: rgba(0,0,0,0%);
        border-style: solid;
        border-radius: 5px;
    ]])
    state.bar.js.max_gauge:setValue(state.js_pct, math.max(100, state.js_pct))
    state.bar.js.current_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].current..[[);
        border-top: 2px black solid;
        border-bottom: 2px black solid;
        border-radius: 5px;
    ]])
    state.bar.js.current_gauge:setValue(math.min(state.js, state.js_max), js_max)
    state.bar.js.over_gauge:setValue(math.max(state.js-state.js_max, 0), js_max)
    state.bar.js.max:echo(state.js_max)
    state.bar.js.current:echo(state.js)
    
    if state.jl / state.jl_max < 0.5 then
        color = "red"
    elseif state.jl / state.jl_max < 0.8 then
        color = "yellow"
    else
        color = "green"
    end
    
    state.bar.jl.energy:echo("+"..tostring(state.energy))
    state.bar.jl.max_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].max..[[);
        border-top: 3px;
        border-bottom: 3px;
        border-color: rgba(0,0,0,0%);
        border-style: solid;
        border-radius: 5px;
    ]])
    state.bar.jl.current_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].current..[[);
        border-top: 2px black solid;
        border-bottom: 2px black solid;
        border-radius: 5px;
    ]])
    state.bar.jl.current_gauge:setValue(math.min(state.jl, state.jl_max), state.jl_max)
    state.bar.jl.over_gauge:setValue(math.max(state.jl-state.jl_max, 0), state.jl_max)
    state.bar.jl.max:echo(state.jl_max)
    state.bar.jl.current:echo(state.jl)
end

function update_state_l2_gauge()
    local qx_max = state.qx_max*math.min(1, 100/state.qx_pct)
    local color
    if state.qx / qx_max < 0.5 then
        color = "red"
    elseif state.qx / qx_max < 0.8 then
        color = "yellow"
    else
        color = "green"
    end
    state.bar.qx.pct:echo(tostring(state.qx_pct).."%")
    state.bar.qx.max_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].max..[[);
        border-top: 3px;
        border-bottom: 3px;
        border-color: rgba(0,0,0,0%);
        border-style: solid;
        border-radius: 5px;
    ]])
    state.bar.qx.max_gauge:setValue(state.qx_pct, math.max(100, state.qx_pct))
    state.bar.qx.current_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].current..[[);
        border-top: 2px black solid;
        border-bottom: 2px black solid;
        border-radius: 5px;
    ]])
    state.bar.qx.current_gauge:setValue(math.min(state.qx, state.qx_max), qx_max)
    state.bar.qx.over_gauge:setValue(math.max(state.qx-state.qx_max, 0), qx_max)
    state.bar.qx.max:echo(state.qx_max)
    state.bar.qx.current:echo(state.qx)

    if state.nl / state.nl_max < 0.5 then
        color = "red"
    elseif state.nl / state.nl_max < 0.8 then
        color = "yellow"
    else
        color = "green"
    end
    state.bar.nl.power:echo("+"..tostring(state.power))
    state.bar.nl.max_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].max..[[);
        border-top: 3px;
        border-bottom: 3px;
        border-color: rgba(0,0,0,0%);
        border-style: solid;
        border-radius: 5px;
    ]])
    state.bar.nl.current_gauge.front:setStyleSheet([[
        background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, ]]..gauge_color[color].current..[[);
        border-top: 2px black solid;
        border-bottom: 2px black solid;
        border-radius: 5px;
    ]])
    state.bar.nl.current_gauge:setValue(math.min(state.nl, state.nl_max), state.nl_max)
    state.bar.nl.over_gauge:setValue(math.max(state.nl-state.nl_max, 0), state.nl_max)
    state.bar.nl.max:echo(state.nl_max)
    state.bar.nl.current:echo(state.nl)
end