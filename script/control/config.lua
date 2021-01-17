config = {
    userid      = nil,          -- 用户 ID
    passwd      = nil,          -- 登录密码
    flood       = 30,           -- 单次传输指令数上限
    skill_prior = false,        -- 是否提升技能优先于获取经验
    save_pots   = true,         -- 是否自动储存潜能
    job_zuanyan = false,        -- 任务期间是否消耗潜能钻研
    mole_limit  = 0,            -- 控制神上限
    job_nl      = "double",     -- 任务所需内力, 可直接写具体数字
    jobs = {
        "门派任务",     ["门派任务"]     = { name = "family_job", active = false, enable = true, echoose = {}, contribution = 150 },
        "寻访任务",     ["寻访任务"]     = { name = "visit_job", active = false, enable = false },
        "斧头帮任务",   ["斧头帮任务"]    = { name = "ftb_job", active = true, enable = true, enemy = 0, confirm = {}, exclude = {} },
        "嵩山任务",     ["嵩山任务"]     = { name = "songshan_job", active = true, enable = true, limit = 5000 },
        "飞马镖局",     ["飞马镖局"]     = { name = "feima_job", active = true, enable = true },
    },
    zuanyan = {     -- 钻研技能
        "parry",    ["parry"]   = { enable = "", place = 1653 },
        "dodge",    ["dodge"]   = { enable = "", place = 1653 },
        "strike",   ["strike"]  = { enable = "", place = 1653 },
        "cuff",     ["cuff"]    = { enable = "", place = 1653 },
        "hand",     ["hand"]    = { enable = "", place = 1653 },
        "finger",   ["finger"]  = { enable = "", place = 1653 },
        "claw",     ["claw"]    = { enable = "", place = 1653 },
        "kick",     ["kick"]    = { enable = "", place = 1653 },
        "sword",    ["sword"]   = { enable = "", place = 1653 },
        "blade",    ["blade"]   = { enable = "", place = 1653 },
        "club",     ["club"]    = { enable = "", place = 1653 },
        "stick",    ["stick"]   = { enable = "", place = 1653 },
        "hammer",   ["hammer"]  = { enable = "", place = 1653 },
        "pike",     ["pike"]    = { enable = "", place = 1653 },
        "staff",    ["staff"]   = { enable = "", place = 1653 },
        "whip",     ["whip"]    = { enable = "", place = 1653 },
        "stroke",   ["stroke"]  = { enable = "", place = 1653 },
        "hook",     ["hook"]    = { enable = "", place = 1653 },
        "axe",      ["axe"]     = { enable = "", place = 1653 },
        "force",    ["force"]   = { enable = "", place = 1653 },
    },
    xue = {
        "parry",    ["parry"]   = { master = "", place = "" },
        "dodge",    ["dodge"]   = { master = "", place = "" },
        "strike",   ["strike"]  = { master = "", place = "" },
        "cuff",     ["cuff"]    = { master = "", place = "" },
        "hand",     ["hand"]    = { master = "", place = "" },
        "finger",   ["finger"]  = { master = "", place = "" },
        "claw",     ["claw"]    = { master = "", place = "" },
        "kick",     ["kick"]    = { master = "", place = "" },
        "sword",    ["sword"]   = { master = "", place = "" },
        "blade",    ["blade"]   = { master = "", place = "" },
        "club",     ["club"]    = { master = "", place = "" },
        "stick",    ["stick"]   = { master = "", place = "" },
        "hammer",   ["hammer"]  = { master = "", place = "" },
        "pike",     ["pike"]    = { master = "", place = "" },
        "staff",    ["staff"]   = { master = "", place = "" },
        "whip",     ["whip"]    = { master = "", place = "" },
        "stroke",   ["stroke"]  = { master = "", place = "" },
        "hook",     ["hook"]    = { master = "", place = "" },
        "axe",      ["axe"]     = { master = "", place = "" },
        "force",    ["force"]   = { master = "", place = "" },
    },
    lian = {        -- 练习技能
        "finger",   ["finger"]  = { "", "" },
        "dodge",    ["dodge"]   = { "", "" },
        "strike",   ["strike"]  = { "", "" },
        "sword",    ["sword"]   = { "", "" },
        "club",     ["club"]    = { "", "" },
        "hand",     ["hand"]    = { "", "" },
        "kick",     ["kick"]    = { "", "" },
        weapon = {  -- 配合武器
            force   = "",
            dodge   = "",
            strike  = "",
            cuff    = "",
            hand    = "",
            finger  = "",
            claw    = "",
            kick    = ""
        }
    },
    fight = {       -- 战斗配置
        armor = "党卫军衣:nasos uniforms",   -- 装备护甲
        ["通用"] = {        -- 默认设置
            weapon = { "", "" },            -- 装备武器
            yuns = { "" },                  -- 内功技能
            performs = { "", "" },          -- 外功技能
            power = "max", energy = "max",  -- 加力/加精
        },
        ["门派任务"] = {    -- 独立设置
        },
        ["斧头帮任务"] = {
        },
        ["嵩山任务"] = {
        },
        ["飞马镖局"] = {
            energy = 1,
        },
        ["寻访任务"] = {
        }
    }
}