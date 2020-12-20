config = {
    userid = "zhenth",
    passwd = "abc123",
    flood_control = 30,
    jobs = {
        "门派任务",     ["门派任务"]     = { active = false,  enable = true,  contribution = 150 },
        "斧头帮任务",   ["斧头帮任务"]   = { active = false,  enable = false, enemy = 0, confirm = {}, exclude = {} },
        "飞马镖局",     ["飞马镖局"]     = { active = true,  enable = true },
        "寻访任务",     ["寻访任务"]     = { active = false,  enable = false },
    },
    skill_prior = false,  -- 任务间隙是否自动练功
    save_pots = true,    -- 是否自动储存潜能
    job_zuanyan = false, -- 任务期间是否消耗潜能钻研
    shen = 900,          -- 需要控制的神
    job_nl = "double",   -- 任务所需内力, 可直接写具体数字
    zuanyan = {  -- 需要钻研的基本功
        "finger",  ["finger"]  = {enable = "tanzhi-shentong", place = 1653},
        "parry",  ["parry"]  = {enable = "tanzhi-shentong", place = 1653},
        "club",   ["club"]   = {enable = "wuhu-gun", place = 1653},
        "sword",  ["sword"]  = {enable = "yuxiao-jian", place = 1653},
        "dodge",  ["dodge"]  = {enable = "xiaoyaoyou", place = 1653},
        "hand",   ["hand"]   = {enable = "shexing-diaoshou", place = 1653},
        "kick",   ["kick"]   = {enable = "xuanfeng-saoye", place = 1653},
        "strike", ["strike"] = {enable = "pikong-zhang", place = 1653},
    },
--    xue = {
--        ["force"] = {master = "", place = ""},
--        ["sword"] = {master = "", place = ""},
--        ["dodge"] = {master = "", place = ""},
--        ["blade"] = {master = "", place = ""},
--        ["hammer"] = {master = "", place = ""},
--        ["strike"] = {master = "", place = ""},
--        ["staff"] = {master = "", place = ""},
--    },
    lian = {  -- 需要练习的特殊武技
        "finger",  ["finger"]  = {"tanzhi-shentong", "liumai-shenjian"},
        "dodge",  ["dodge"]  = {"xiaoyaoyou", "luoying-shenfa"},
        "strike", ["strike"] = {"pikong-zhang", "luoying-shenjian"},
        "sword",  ["sword"]  = {"yuxiao-jian", "jinshe-jianfa"},
        "club",   ["club"]   = {"wuhu-gun"},
        "hand",   ["hand"]   = {"shexing-diaoshou"},
        "kick",   ["kick"]   = {"xuanfeng-saoye"},
        
        weapon = {
            force = "",
            dodge = "",
            strike = "",
            cuff = "",
            finger = "",
            claw = "",
            kick = ""
        }
    },
    
    fight = {
        armor = "党卫军衣:nasos uniforms",  -- 战斗时所穿护甲
        ["通用"] = {  -- 任务默认战斗配置
            weapon = { "", "" }
        },
        ["门派任务"] = {  -- 门派任务战斗时的配置
            weapon    = { "", "" },  -- 战斗时使用的武器
            yuns      = { "yun yixing" },  -- 战斗时使用的内功
            performs  = { "perform zhangfeng", "perform jinglei" },  -- 战斗时使用的外功
            power = "max", energy = "max",  -- -- 战斗时所需加力/加精
        },
        ["飞马镖局"] =    {
            weapon    = { "", "" },
            yuns      = { "yun yixing" },
            performs  = { "perform zhangfeng", "perform jinglei" },
            power = "max", energy = 1,
        },
        ["斧头帮任务"] = {  -- 门派任务战斗时的配置
            weapon    = { "", "" },  -- 战斗时使用的武器
            yuns      = { "yun yixing" },  -- 战斗时使用的内功
            performs  = { "perform zhangfeng", "perform jinglei" },  -- 战斗时使用的外功
            power = "max", energy = "max",  -- -- 战斗时所需加力/加精
        },
--        ["寻访任务"] =    {
--                                weapon         = {first = "", second = ""},
--                                yuns           = {},
--                                performs       = {{pre = "", ""}, {pre = "", ""}, {pre = "", ""}},
--                                power          = "max",
--                                energy         = "max",
--                              }
    }
}