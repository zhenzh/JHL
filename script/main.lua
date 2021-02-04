global = global or { flood = 0, uid = {}, buffer = {}, regex = {} }
global.debug = { level = 0, none = 0, info = 1, trace = 2 }
automation = automation or {}
var = var or {}

function get_work_path()
    return HOME
end

function get_script_path()
    return SCRIPT
end

package.path = package.path..";"..
get_script_path().."base/?.lua;"..
get_script_path().."frame/?.lua;"..
get_script_path().."game/?.lua;"..
get_script_path().."gps/?.lua;"..
get_script_path().."control/?.lua;"..
get_script_path().."jobs/?.lua"

require "config"
require "client"
require "common"
require "gps"
require "info"
require "action"
require "admin"
require "statistics"

timer.add("decline", 1, "global.flood = math.max(0, (global.flood or 0) - 20)", nil, {Enable=true})

if io.exists(get_work_path().."char.cfg") then
    loadfile(get_work_path().."char.cfg")()
end

if io.exists(get_work_path().."log/global.tmp") then
    global.buffer = table.load(get_work_path().."log/global.tmp")
    os.remove(get_work_path().."log/global.tmp")
end

if io.exists(get_work_path().."log/automation.tmp") then
    automation = table.load(get_work_path().."log/automation.tmp")
    os.remove(get_work_path().."log/automation.tmp")
end

automation.timer = automation.timer or {}
automation.items = automation.items or {}
automation.killer = automation.killer or {}
automation.npc_killer = automation.npc_killer or {"猫也会心碎"}

if automation.timer["invalid_ask_ping"] ~= nil then
    local seconds = math.max(0.001, automation.timer["invalid_ask_ping"].remain - (time.epoch() - automation.epoch) / 1000 )
    timer.add(automation.timer["invalid_ask_ping"], seconds)
    automation.timer["invalid_ask_ping"] = nil
end
if automation.timer["invalid_ask_yuluwan"] ~= nil then
    local seconds = math.max(0.001, automation.timer["invalid_ask_yuluwan"].remain - (time.epoch() - automation.epoch) / 1000 )
    timer.add(automation.timer["invalid_ask_yuluwan"], seconds)
    automation.timer["invalid_ask_yuluwan"] = nil
end

automation.skill = nil

for k,v in pairs(automation.items) do
    items[k] = v
end

if automation.repository ~= nil then
    carryon.repository = automation.repository
    automation.repository = nil
end

global.debug.level = automation.debug or global.debug.level

automation.statistics = automation.statistics or {}
automation.statistics.date = automation.statistics.date or time.date("%Y%m%d%H")
automation.statistics.death = automation.statistics.death or {}
automation.statistics.idle = automation.statistics.idle or {}
automation.statistics.reset = automation.statistics.reset or {}
automation.statistics.connect = automation.statistics.connect or {}
automation.statistics.processing = automation.statistics.processing or {}

collectgarbage("collect")

function init()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline, "函数［ init ］")
    map_adjust("门派接引", "启用", "过河", "大圣", "丐帮密道", "启用", "南阳城", "关闭", "南阳城郊", "关闭", "黑龙江栈道", "禁用", "少林山门", "开放", "北京城门", "开放", "泉州新门", "开放", "古墓水道", "禁用")
    trigger.add("init_hide_ga", "", nil, {Enable=true, Gag=true, StopEval=true}, 40, "^> $|^设定完毕。$|^从现在起你用\\S+点内力伤敌。$")
    if wait_line("jiali max;jiajin max;score;hp;skills;enable;prepare;set;jiajin 1;jiali none", 30, nil, 10, "^从现在起你用零点内力伤敌。$", "^> $") ~= false then
        if run_i() < 0 then
            return -1
        end
        trigger.delete("init_hide_ga")
        if locate() >= 0 then
            if wait_line("set 初始化完成", 30, nil, 10, "^你目前还没有任何为 初始化完成 的变量设定。$", "^> $") ~= false then
                show("初始化成功", "green")
                return 0
            end
        end
    end
    trigger.delete("init_hide_ga")
    show("初始化失败", "red")
    return -1
end

function login()
    if automation.thread ~= nil then
        return
    end
    coroutine.wrap(
        function ()
            automation.thread = coroutine.running()
            init()
            automation.thread = nil
        end
    )()
end

function load_jobs()
    if automation.config_jobs ~= nil then
        for k,v in pairs(automation.config_jobs) do
            if config.jobs[k] ~= nil then
                for i,j in pairs(v) do
                    if i ~= "enable" then
                        config.jobs[k].i = j
                    end
                end
            end
        end
        automation.config_jobs = nil
    end
    for _,v in ipairs(config.jobs) do
        if config.jobs[v].enable == true then
            loadstring("require '"..config.jobs[v].name.."'")()
            if config.jobs[v].efunc ~= nil then
                config.jobs[v].efunc() 
            end
        else
            if config.jobs[v].dfunc ~= nil then
                config.jobs[v].dfunc()
            end
        end
    end
end

if automation.reconnect == nil then
    if #global.buffer == 0 or 
       get_lines(-1)[1] == "请输入您的英文ID：" or 
       get_lines(-1)[1] == "请重新输入您的ID：" or 
       set.has(get_lines(-3), "英文ID识别( 新玩家请输入 new 进入人物建立单元 )") then
        show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
    else
        local login = true
        for _,v in ipairs(get_lines(-3)) do
            if string.match(v, "^「江湖路」：您本次") then
                login = false
                break
            end
        end
        show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
        if login == true then
            coroutine.wrap(
                function ()
                    automation.thread = coroutine.running()
                    init()
                    automation.thread = nil
                end
            )()
        end
    end
else
    show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")
    require "flow"
    coroutine.wrap(
        function ()
            automation.thread = coroutine.running()
            loadstring(automation.reconnect)()
            if init() < 0 then
                return -1
            end
            load_jobs()
            start()
        end
    )()
end