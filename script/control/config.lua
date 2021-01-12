config = {
    userid      = "zhenth",     -- 用户 ID
    passwd      = "abc123",     -- 登录密码
    flood       = 30,           -- 单次传输指令数上限
    skill_prior = false,        -- 是否提升技能优先于获取经验
    save_pots   = true,         -- 是否自动储存潜能
    job_zuanyan = false,        -- 任务期间是否消耗潜能钻研
    mole_limit  = 900,          -- 控制神上限
    job_nl      = "double",     -- 任务所需内力, 可直接写具体数字
    jobs = {
        "门派任务",     ["门派任务"]     = { active = false,  enable = true,  contribution = 150 },
        "寻访任务",     ["寻访任务"]     = { active = false,  enable = false },
        "斧头帮任务",   ["斧头帮任务"]    = { active = true,  enable = true, enemy = 0, confirm = {}, exclude = {} },
        "嵩山任务",     ["嵩山任务"]     = { active = true,  enable = true, limit = 5000 },
        "飞马镖局",     ["飞马镖局"]     = { active = true,  enable = true },
    },
    zuanyan = {     -- 钻研技能
        "finger",   ["finger"]  = { enable = "tanzhi-shentong", place = 1653 },
        "parry",    ["parry"]   = { enable = "tanzhi-shentong", place = 1653 },
        "club",     ["club"]    = { enable = "wuhu-gun", place = 1653 },
        "sword",    ["sword"]   = { enable = "yuxiao-jian", place = 1653 },
        "dodge",    ["dodge"]   = { enable = "xiaoyaoyou", place = 1653 },
        "hand",     ["hand"]    = { enable = "shexing-diaoshou", place = 1653 },
        "kick",     ["kick"]    = { enable = "xuanfeng-saoye", place = 1653 },
        "strike",   ["strike"]  = { enable = "pikong-zhang", place = 1653 },
    },
    xue = {
        ["force"]    = { master = "", place = "" },
        ["sword"]    = { master = "", place = "" },
        ["dodge"]    = { master = "", place = "" },
        ["blade"]    = { master = "", place = "" },
        ["hammer"]   = { master = "", place = "" },
        ["strike"]   = { master = "", place = "" },
        ["staff"]    = { master = "", place = "" },
    },
    lian = {        -- 练习技能
        "finger",   ["finger"]  = { "tanzhi-shentong", "liumai-shenjian" },
        "dodge",    ["dodge"]   = { "xiaoyaoyou", "luoying-shenfa" },
        "strike",   ["strike"]  = { "pikong-zhang", "luoying-shenjian" },
        "sword",    ["sword"]   = { "yuxiao-jian", "jinshe-jianfa" },
        "club",     ["club"]    = { "wuhu-gun" },
        "hand",     ["hand"]    = { "shexing-diaoshou" },
        "kick",     ["kick"]    = { "xuanfeng-saoye" },
        weapon = {  -- 配合武器
            force   = "",
            dodge   = "",
            strike  = "",
            cuff    = "",
            finger  = "",
            claw    = "",
            kick    = ""
        }
    },
    fight = {       -- 战斗配置
        armor = "党卫军衣:nasos uniforms",                             -- 装备护甲
        ["通用"] = {        -- 默认设置
            weapon = { "", "" },                                      -- 装备武器
            yuns = { "yun yixing" },                                  -- 内功技能
            performs = { "perform zhangfeng", "perform jinglei" },    -- 外功技能
            power = "max", energy = "max",                            -- 加力/加精
        },
        ["门派任务"] = {    -- 独立设置
            weapon = { "", "" },
            yuns = { "yun yixing" },
            performs = { "perform zhangfeng", "perform jinglei" },
            power = "max", energy = "max",
        },
        ["斧头帮任务"] = {                                              -- 留空配置项采用通用配置
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