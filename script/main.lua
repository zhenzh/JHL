HOME="/Users/ibm/go-mud"
package.path = package.path..";"..
HOME.."/script/base/?.lua;"..
HOME.."/script/game/?.lua;"..
HOME.."/script/gps/?.lua;"..
HOME.."/script/control/?.lua;"..
HOME.."/script/jobs/?.lua"

global = global or { flood = 0, uid = {}, buffer = { "" }, regex = {}, output = true }
automation = automation or {}
automation.items = automation.items or {}
statics = statics or {}
config = config or {}
var = var or {}
require "gomud"
-- require "alias"
-- require "common"
-- require "gps"
-- require "info"
-- require "action"
-- require "update"

-- show(string.format("%-.30s", string.match(debug.getinfo(1).source, "script/(.*lua)$").." ............................."), "peru", nil, "")

-- global.debug = { level = 0, none = 0, info = 1, trace = 2 }
-- global.debug.level = global.debug["debug"] or 0

-- add_timer("idle", 1, "global.flood = math.max(0, (global.flood or 0) - 20)", nil, {Enable=true})

-- if io.exists(get_work_path().."log/global.tmp") then
--     table.load(get_work_path().."log/global.tmp", global.buffer)
--     table.save(get_work_path().."log/global.tmp", {})
-- end

-- if io.exists(get_work_path().."log/automation.tmp") then
--     table.load(get_work_path().."log/automation.tmp", automation)
--     table.save(get_work_path().."log/automation.tmp", {})
-- end
-- if table.is_empty(automation) then
--     automation.killer = {}
--     automation.npc_killer = {"猫也会心碎"}
-- end

-- automation.skill = nil
-- config = automation.config
-- automation.config = nil
-- if config == nil or table.is_empty(config) then
--     require "config"
-- end

-- for k,v in pairs(automation.items) do
--     items[k] = v
-- end

-- if automation.repository ~= nil then
--     carryon.repository = automation.repository
--     automation.repository = nil
-- end

-- ui = automation.ui
-- --if ui == nil then
-- --    require "ui"
-- --end

-- statics.date = time.date("yyyyMMdd")
-- if io.exists(get_work_path().."log/statics."..statics.date) then
--     table.load(get_work_path().."log/statics."..statics.date, statics)
-- end

-- collectgarbage("collect")

-- function init()
--     map_adjust("门派接引", "启用", "过河", "大圣", "丐帮密道", "启用", "南阳城", "关闭", "南阳城郊", "关闭", "黑龙江栈道", "禁用", "少林山门", "开放", "北京城门", "开放", "泉州新门", "开放")
--     add_trigger("init_hide_ga", "", nil, {Enable=true, Gag=true, StopEval=true}, 40, "^> $|^设定完毕。$|^从现在起你用\\S+点内力伤敌。$")
--     if wait_line("jiali max;jiajin max;score;hp;skills;enable;prepare;set;jiajin 1;jiali none", 30, nil, 10, "^从现在起你用零点内力伤敌。$", "^> $") ~= false then
--         if run_i() < 0 then
--             return -1
--         end
--         del_trigger("init_hide_ga")
--         if locate() >= 0 then
--             if wait_line("set 初始化完成", 30, nil, 10, "^你目前还没有任何为 初始化完成 的变量设定。$", "^> $") ~= false then
--                 show("初始化成功", "green")
--                 return 0
--             end
--         end
--     end
--     del_trigger("init_hide_ga")
--     show("初始化失败", "red")
--     return -1
-- end

-- function login()
--     if automation.thread ~= nil then
--         return
--     end
--     coroutine.wrap(
--         function ()
--             automation.thread = coroutine.running()
--             init()
--             automation.thread = nil
--         end
--     )()
-- end

-- function load_jobs()
--     require "family_job"
--     require "feima_job"
--     for _,v in ipairs(config.jobs) do
--         if config.jobs[v].enable == true then
--             config.jobs[v].efunc()
--         else
--             if config.jobs[v].dfunc ~= nil then
--                 config.jobs[v].dfunc()
--             end
--         end
--     end
-- end

-- if automation.reconnect == nil then
--     if get_lines(-1)[1] == "请输入您的英文ID：" or 
--        get_lines(-1)[1] == "请重新输入您的ID：" or 
--         set.has(get_lines(-3), "英文ID识别( 新玩家请输入 new 进入人物建立单元 )") then
--         show(" 已加载", "green")
--     else
--         local login = true
--         for _,v in ipairs(get_lines(-3)) do
--             if string.match(v, "^「江湖路」：您本次") then
--                 login = false
--                 break
--             end
--         end
--         show(" 已加载", "green")
--         if login == true then
--             coroutine.wrap(
--                 function ()
--                     automation.thread = coroutine.running()
--                     init()
--                     automation.thread = nil
--                 end
--             )()
--         end
--     end
-- else
--     show(" 已加载", "green")
--     require "flow"
--     coroutine.wrap(
--         function ()
--             automation.thread = coroutine.running()
--             loadstring(automation.reconnect)()
--             if init() < 0 then
--                 return -1
--             end
--             load_jobs()
--             start()
--         end
--     )()
-- end