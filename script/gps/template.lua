map = map or {}
if #map == 0 then
    if io.exists(get_script_path().."gps/map.lua") then
        map = table.load(get_script_path().."gps/map.lua")
    else
        flush_map()
    end
end

----戈壁临时调整
map[2991].links["north"] = 3013
map[3013].links["south"] = 2991

map_attr = map_attr or { mode = {} }
map_attr.cost = map_attr.cost or {
    ["yell boat;enter"] = 15,              ["kill nv lang;northdown"] = 4,        ["kill jielv seng;north"] = 4,
    ["knock lou;enter"] = 12,              ["kill jiading;westup"] = 4,           ["kill yideng shiwei;north"] = 4,
    ["qu murong"] = 19,                    ["kill lao denuo;west"] = 4,           ["kill caihua zi;enter"] = 4,
    ["qu mantuo"] = 15,                    ["kill lao denuo;south"] = 4,          ["kill gongsun zhi;north"] = 4,
    ["qu matou"] = 10,                     ["kill shuo bude;up"] = 4,             ["kill fan yiweng;north"] = 4,
    ["qu xiaozhu"] = 10,                   ["kill jiaozhong;north"] = 4,          ["kill qiu shanfeng;enter"] = 4,
    ["tan qin"] = 10,                      ["kill wugen daoren;northup"] = 4,     ["kill zhang zhiguang;westup"] = 4,
    ["look boat;jump boat"] = 12,          ["kill shou wei;north"] = 4,           ["kill huangshan nuzi;west"] = 4,
    ["tui boat;jump boat"] = 12,           ["kill jian zhanglao;east"] = 4,       ["kill zhuang han;enter"] = 4,
    ["yell chuan;enter"] = 10,             ["kill xiao lan;east"] = 4,            ["kill hu laoye;east"] = 4,
    ["yell chuan3033"] = 36,               ["kill xiao lan;west"] = 4,            ["kill huangshan nuzi;east"] = 4,
    ["out1546"] = 20,                      ["kill wang furen;up"] = 4,            ["kill situ heng;north"] = 4,
    ["north2990"] = 4,                     ["kill yue lingshan;west"] = 4,        ["kill ge lunbu;north"] = 4,
    ["west1827"] = 4,                      ["kill xihua zi;south"] = 4,           ["kill shi daizi;west"] = 4,
    ["south2989"] = 3,                     ["kill zhang songxi;east"] = 4,        ["kill shihou zi;west"] = 4,
    ["south2990"] = 3,                     ["kill zhang songxi;south"] = 4,       ["kill shihou zi;northdown"] = 4,
    ["go1299"] = 3,                        ["kill zhang songxi;west"] = 4,        ["kill gao genming;northup"] = 4,
    ["go1301"] = 3,                        ["kill xiao wei;south"] = 4,           ["kill yin jin;north"] = 4,
    ["go1302"] = 3,                        ["kill du dajin;enter"] = 4,           ["kill ouyang feng;open door;down"] = 4,
    ["go1432"] = 3,                        ["kill binu;westup"] = 4,              ["kill qingguan biqiu;open door;north"] = 4,
    ["go1433"] = 3,                        ["kill lu dayou;south"] = 4,           ["kill ning zhongze;south"] = 4,
    ["go1434"] = 3,                        ["kill shi sao;north"] = 4,            ["kill ning zhongze;east"] = 4,
    ["kneel"] = 6,                         ["kill ning zhongze;west"] = 4,        ["kill wu shi;open door;west"] = 4,
    ["strike wall;out"] = 3,               ["kill ya huan;east"] = 4,             ["kill wei shi;open door;west"] = 4,
    ["tui wall;down"] = 2,                 ["kill jia ding;east"] = 4,            ["kill huikong zunzhe;northup"] = 4,
    ["open door;southwest"] = 3,           ["kill gongye qian;enter"] = 4,        ["kill changle bangzhong;east"] = 4,
    ["open door;northeast"] = 3,           ["kill liang fa;east"] = 4,            ["kill menggu junguan;southeast"] = 4,
    ["open door;north"] = 3,               ["kill wu shi;north"] = 4,             ["kill qingle biqiu;north"] = 4,
    ["open gate;south"] = 3,               ["kill tan chuduan;up"] = 4,           ["kill xuming;kill xutong;eastup"] = 4,
    ["push men;south"] = 3,                ["northeast387"] = 3,                  ["hit ping si;north"] = 8,
    ["open door;up"] = 3,                  ["eastdown388"] = 3,                   ["hit guan bing;north"] = 8,
    ["open east;east"] = 3,                ["westup387"] = 3,                     ["hit ya yi;south"] = 8,
    ["open door;south"] = 3,               ["northeast389"] = 3,                  ["hit ming ku;hit ming nan;enter"] = 8,
    ["push dashi;northdown"] = 3,          ["southwest388"] = 3,                  ["hit song bing;north"] = 8,
    ["an stone;down"] = 3,                 ["eastdown390"] = 3,                   ["hit yideng shiwei;west"] = 8,
    ["open west;west"] = 3,                ["westup389"] = 3,                     ["hit yideng shiwei;south"] = 8,
    ["open door;east"] = 3,                ["southwest390"] = 3,                  ["hit yideng shiwei;east"] = 8,
    ["open door;west"] = 3,                ["look 崖;jump qiaobi"] = 3,           ["hit fu sigui;south"] = 8,
    ["open door;north760"] = 4,            ["south;south;south"] = 3,             ["hit ling tuisi;west"] = 8,
    ["say 天堂有路你不走呀;down"] = 3,      ["pa xia"] = 2,                        ["hit wu jiang;hit guan bing;north"] = 8,
    ["jump wall"] = 12,                    ["climb wall"] = 2,                    ["hit wu jiang;hit guan bing;south"] = 8,
    ["jump valley"] = 3,                   ["dlyidengsite-slw"] = 10,             ["give 10 silver to yu zu;south"] = 5,
    ["climb up"] = 3,                      ["north;north;north"] = 3,             ["hit wu jiang;hit guan bing;northeast"] = 8,
    ["zha song;climb down"] = 2,           ["jump up"] = 3,                       ["ask jiang baisheng about 上山;northup"] = 2,
    ["bang tree;climb"] = 2,               ["pa shang"] = 2,                      ["south;south;south;south;south"] = 5,
    ["chop shuzhi"] = 2,                   ["pa up"] = 2,                         ["out;out;out;out;out;out;out;out;out;out;out"] = 10,
    ["swim up"] = 3,                       ["get eluan shi;jump tan"] = 3,        ["ask sha gu about 玩;agree;enter"] = 4,
    ["swim down"] = 3,                     ["mianbi;strike wall;enter"] = 5,      ["kneel cave;enter;use fire;kneel grave;out;west"] = 5,
    ["drop eluan shi;swim up"] = 3,        ["drop eluan shi;swim light"] = 3,     ["north;north;north;north;north;north"] = 6,
    ["wield jian;strike wall;out"] = 3,    ["say 青衫磊落险峰行;northeast"] = 2,   ["south;south;south;south;south;south"] = 6,
    ["yell boat"] = 15,
    ["push left;push left;push left;push right;push right;push right;push front;enter"] = 8,
    ["southwest;southeast;north;south;west;east;west;east;east;south;west;north;northwest;north"] = 14,
}

map_attr.zone = {
    ["藏边大雪山"] = "藏边大雪山",    ["太湖边"]     = "太湖边",        ["昆仑山"]     = "昆仑山",
    ["福建泉州"]   = "福建泉州",      ["太湖"]       = "太湖边",        ["祈连山"]     = "祈连山",
    ["泉州"]       = "福建泉州",      ["西夏"]       = "西夏",          ["祁连山"]     = "祈连山",
    ["关外长白山"] = "关外长白山",    ["西域"]       = "西域",          ["山东泰山"]   = "山东泰山",
    ["广东佛山"]   = "广东佛山",      ["嘉兴"]       = "嘉兴",          ["泰山"]       = "山东泰山",
    ["佛山"]       = "广东佛山",      ["扬州"]       = "扬州",          ["黄河边"]     = "黄河边",
    ["湖北武当山"] = "湖北武当山",    ["云南大理"]   = "云南大理",      ["黄河流域"]   = "黄河边",
    ["湖北武当"]   = "湖北武当山",    ["大理城"]     = "云南大理",      ["四川峨嵋"]   = "四川峨嵋",
    ["武当山"]     = "湖北武当山",    ["大理"]       = "云南大理",      ["嵩山少林寺"] = "嵩山少林",
    ["华山村"]     = "华山村",        ["终南山"]     = "终南山",        ["嵩山少林"]   = "嵩山少林",
    ["华山"]       = "华山",          ["扬州郊外"]   = "扬州郊外",      ["少林寺"]     = "嵩山少林",
    ["杭州"]       = "杭州",          ["襄阳"]       = "湖北襄阳",      ["河南洛阳"]   = "河南洛阳",
    ["海外"]       = "海外",          ["湖北襄阳"]   = "湖北襄阳",      ["北岳恒山"]   = "北岳恒山",
    ["黑木崖"]     = "黑木崖",        ["中岳嵩山"]   = "中岳嵩山",      ["长安城"]     = "长安城",
    ["姑苏燕子坞"] = "姑苏燕子坞",    ["东海灵蛇岛"] = "东海灵蛇岛",    ["长安"]       = "长安城",
    ["慕容山庄"]   = "姑苏燕子坞",    ["灵蛇岛"]     = "东海灵蛇岛",    ["南阳"]       = "南阳",
    ["东海桃花岛"] = "东海桃花岛",    ["辽东神龙岛"] = "辽东神龙岛",    ["蜀中成都"]   = "蜀中成都",
    ["桃花岛"]     = "东海桃花岛",    ["神龙岛"]     = "辽东神龙岛",    ["成都"]       = "蜀中成都",
    ["洛阳"]       = "河南洛阳",      ["海外冰火岛"] = "海外冰火岛",    ["丐帮所在地"] = "丐帮所在地"
}

calibration = {
    ["性别"] = {
        ["男"] = function()
            map_attr.cost["east1246"] = nil
            map_attr.cost["east803"] = nil
            map_attr.cost["open door;south2037"] = nil
            map_attr.cost["open east;east"] = 3
            map_attr.cost["west287"] = nil
            map_attr.cost["west561"] = nil
            map_attr.cost["north2822"] = nil
            map_attr.cost["west2687"] = nil
            map_attr.cost["south1245"] = 10000
            map_attr.cost["north800"] = 10000
            map_attr.cost["open door;south2038"] = 10000
            map_attr.cost["open west;west"] = 10000
            map_attr.cost["east291"] = 10000
            map_attr.cost["south562"] = 10000
            map_attr.cost["north27"] = 10000
            map_attr.cost["open door;south3099"] = 10000
            map_attr.cost["south2821"] = 10000
            map_attr.cost["east2686"] = 10000
            calibration["性别"][1] = "男"
        end,
        ["女"] = function()
            map_attr.cost["east1246"] = 10000
            map_attr.cost["east803"] = 10000
            map_attr.cost["open door;south2037"] = 10000
            map_attr.cost["open east;east"] = 10000
            map_attr.cost["west287"] = 10000
            map_attr.cost["west561"] = 10000
            map_attr.cost["north2822"] = 10000
            map_attr.cost["west2687"] = 10000
            map_attr.cost["south1245"] = nil
            map_attr.cost["north800"] = nil
            map_attr.cost["open door;south2038"] = 3
            map_attr.cost["open west;west"] = 3
            map_attr.cost["east291"] = nil
            map_attr.cost["south562"] = nil
            map_attr.cost["north27"] = nil
            map_attr.cost["open door;south3099"] = nil
            map_attr.cost["south2821"] = nil
            map_attr.cost["east2686"] = nil
            calibration["性别"][1] = "女"
        end,
        ["无"] = function()
            map_attr.cost["east1246"] = nil
            map_attr.cost["east803"] = nil
            map_attr.cost["open door;south2037"] = nil
            map_attr.cost["open east;east"] = 3
            map_attr.cost["west287"] = nil
            map_attr.cost["west561"] = nil
            map_attr.cost["north2822"] = nil
            map_attr.cost["west2687"] = nil
            map_attr.cost["south1245"] = nil
            map_attr.cost["north800"] = nil
            map_attr.cost["open door;south2038"] = nil
            map_attr.cost["open west;west"] = 3
            map_attr.cost["east291"] = nil
            map_attr.cost["south562"] = nil
            map_attr.cost["north27"] = nil
            map_attr.cost["open door;south3099"] = nil
            map_attr.cost["south2821"] = nil
            map_attr.cost["east2686"] = nil
            calibration["性别"][1] = "无"
        end,
    },

    ["过河"] = {
        ["大圣"] = function()
            map[1528].links["yell 大圣"] = 1048
            map[1048].links["yell 大圣"] = 1528
            map[1526].links["yell 大圣"] = 1049
            map[1049].links["yell 大圣"] = 1526
            map[1531].links["yell 大圣"] = 1708
            map[1708].links["yell 大圣"] = 1531
            map[1365].links["yell 大圣"] = 1554
            map[1554].links["yell 大圣"] = 1365
            map[2750].links["yell 大圣"] = 2751
            map[2751].links["yell 大圣"] = 2750
            map[1091].links["yell 大圣"] = 1460
            map[1460].links["yell 大圣"] = 1091
            map_attr.cost["yell boat;enter1964"] = 10000
            map_attr.cost["yell boat;enter1965"] = 10000
            map_attr.cost["yell boat;enter2018"] = 10000
            map_attr.cost["yell boat;enter3037"] = 10000
            map_attr.cost["yell boat;enter3101"] = 10000
            map_attr.cost["yell boat;enter2207"] = 10000
            if calibration["松花江"] == "渡船" then
                map[1508].links["yell 大圣"] = 1507
                map[1507].links["yell 大圣"] = 1508
                map_attr.cost["yell boat;enter1963"] = 10000
            end
            calibration["过河"][1] = "大圣"
        end,
        ["渡船"] = function()
            map[1528].links["yell 大圣"] = nil
            map[1048].links["yell 大圣"] = nil
            map[1526].links["yell 大圣"] = nil
            map[1049].links["yell 大圣"] = nil
            map[1531].links["yell 大圣"] = nil
            map[1708].links["yell 大圣"] = nil
            map[1365].links["yell 大圣"] = nil
            map[1554].links["yell 大圣"] = nil
            map[2750].links["yell 大圣"] = nil
            map[2751].links["yell 大圣"] = nil
            map[1091].links["yell 大圣"] = nil
            map[1460].links["yell 大圣"] = nil
            map[1508].links["yell 大圣"] = nil
            map[1507].links["yell 大圣"] = nil
            map_attr.cost["yell boat;enter1964"] = nil
            map_attr.cost["yell boat;enter1965"] = nil
            map_attr.cost["yell boat;enter2018"] = nil
            map_attr.cost["yell boat;enter3037"] = nil
            map_attr.cost["yell boat;enter3101"] = nil
            map_attr.cost["yell boat;enter2207"] = nil
            map_attr.cost["yell boat;enter1963"] = nil
            calibration["过河"][1] = "渡船"
        end,
    },

    ["丐帮密道"] = {
        ["启用"] = function()
            map[1983].links["say 天堂有路你不走呀;down"] = 3039
            calibration["丐帮密道"][1] = "启用"
        end,
        ["禁用"] = function()
            if profile.family ~= "丐帮" then
                map[1983].links["say 天堂有路你不走呀;down"] = nil
                calibration["丐帮密道"][1] = "禁用"
            end
        end,
    },

    ["门派接引"] = {
        ["启用"] = function()
            map[955].links["ask guider about 白驼"] = 925
            map[955].links["ask guider about 峨嵋"] = 403
            map[955].links["ask guider about 雪山"] = 421
            map[955].links["ask guider about 全真"] = 722
            map[955].links["ask guider about 武当"] = 649
            map[955].links["ask guider about 华山"] = 874
            map[955].links["ask guider about 明教"] = 472
            map[955].links["ask guider about 丐帮"] = 1116
            map[955].links["ask guider about 昆仑"] = 2893
            map[955].links["ask guider about 古墓"] = 2374
            map[955].links["ask guider about 日月"] = 2391
            map[955].links["ask guider about 嵩山"] = 2462
            map[955].links["ask guider about 少林"] = 1552
            map[955].links["ask guider about 桃花"] = 1470
            map[955].links["ask guider about 灵鹫"] = 2161
            map[955].links["ask guider about 星宿"] = 1435
            map[955].links["ask guider about 慕容"] = 2050
            map[955].links["ask guider about 万兽"] = 2731
            map[955].links["ask guider about 神龙"] = 2221
            calibration["门派接引"][1] = "启用"
        end,
        ["禁用"] = function()
            map[955].links["ask guider about 白驼"] = nil
            map[955].links["ask guider about 峨嵋"] = nil
            map[955].links["ask guider about 雪山"] = nil
            map[955].links["ask guider about 全真"] = nil
            map[955].links["ask guider about 武当"] = nil
            map[955].links["ask guider about 华山"] = nil
            map[955].links["ask guider about 明教"] = nil
            map[955].links["ask guider about 丐帮"] = nil
            map[955].links["ask guider about 昆仑"] = nil
            map[955].links["ask guider about 古墓"] = nil
            map[955].links["ask guider about 日月"] = nil
            map[955].links["ask guider about 嵩山"] = nil
            map[955].links["ask guider about 少林"] = nil
            map[955].links["ask guider about 桃花"] = nil
            map[955].links["ask guider about 灵鹫"] = nil
            map[955].links["ask guider about 星宿"] = nil
            map[955].links["ask guider about 慕容"] = nil
            map[955].links["ask guider about 万兽"] = nil
            map[955].links["ask guider about 神龙"] = nil
            calibration["门派接引"][1] = "禁用"
        end,
    },

    ["师父"] = {
        ["还原"] = "自学贯通",
        ["自学贯通"] = function()
            map[386].links["yell 有侣乎"] = nil
            map[1278].links["ask qu about 学艺"] = nil
            map[914].links["feng"] = nil
            map[2917].links["play qin"] = nil
            map[1801].links["open door;down"] = nil
            map[1801].links["kill ouyang feng;open door;down"] = 2041
            calibration["师父"][1] = "自学贯通"
        end,
        ["周芷若"] = function()
            map[386].links["yell 有侣乎"] = 1987
            calibration["师父"][1] = "周芷若"
        end,
        ["曲灵风"] = function()
            map[1278].links["ask qu about 学艺"] = 3136
            calibration["师父"][1] = "曲灵风"
        end,
        ["风清扬"] =    function()
            map[914].links["feng"] = 2718
            calibration["师父"][1] = "风清扬"
        end,
        ["何足道"] =    function()
            map[2917].links["play qin"] = 2918
            calibration["师父"][1] = "何足道"
        end,
        ["欧阳锋"] =    function()
            map[1801].links["kill ouyang feng;open door;down"] = nil
            map[1801].links["open door;down"] = 2041
            calibration["师父"][1] = "欧阳锋"
        end,
    },

    ["门派"] = {
        ["无门无派"] = function()
            if calibration["少林山门"][1] ~= "关闭" then
                map_attr.cost["knock gate;north"] = nil
            end

            map[1650].links["north"] = nil
            map[1667].links["northup"] = nil
            map[1656].links["open door;north"] = nil
            map[1553].links["eastup"] = nil
            map[1650].links["kill qingle biqiu;north"] = 1651
            map[1667].links["kill huikong zunzhe;northup"] = 1627
            map[1656].links["kill qingguan biqiu;open door;north"] = 1789
            map[1553].links["kill xuming;kill xutong;eastup"] = 1548
            map_attr.cost["northup1693"] = 10000
            map_attr.cost["enter1682"] = 10000

            map[872].links["south"] = nil
            map[872].links["west"] = nil
            map[879].links["south"] = nil
            map[876].links["west"] = nil
            map[883].links["west"] = nil
            map[883].links["south"] = nil
            map[883].links["east"] = nil
            map[870].links["west"] = nil
            map[893].links["northup"] = nil
            map[872].links["kill lao denuo;south"] = 874
            map[872].links["kill lao denuo;west"] = 873
            map[879].links["kill lu dayou;south"] = 880
            map[876].links["kill yue lingshan;west"] = 877
            map[883].links["kill ning zhongze;west"] = 884
            map[883].links["kill ning zhongze;south"] = 885
            map[883].links["kill ning zhongze;east"] = 886
            map[870].links["kill shi daizi;west"] = 871
            map[893].links["kill gao genming;northup"] = 894

            if calibration["丐帮密道"][1] == "禁用" then
                map[1983].links["say 天堂有路你不走呀;down"] = nil
            end
            map[1117].links["east"] = nil
            map[813].links["enter gudui"] = nil
            map[1116].links["enter dong"] = nil
            map[1520].links["enter dong"] = nil
            map[1327].links["push shibei"] = nil
            map[633].links["enter dong"] = nil
            map[80].links["enter dong"] = nil
            map[615].links["move mugai"] = nil
            map[2008].links["enter"] = nil
            if items["百草丹:baicao dan"].place[1] == 3039 then
                set.remove(items["百草丹:baicao dan"].price, 1)
                set.remove(items["百草丹:baicao dan"].place, 1)
                set.remove(items["百草丹:baicao dan"].get, 1)
            end

            map[365].links["south"] = nil
            map[365].links["kill jing xin;south"] = 367
            set.pop(items["《九阳神功残篇》:jiuyang canpian"].place)
            set.pop(items["《九阳神功残篇》:jiuyang canpian"].get)

            map[2782].links["knock lou;enter"] = 3103
            map[2783].links["knock lou;enter"] = 3103
            map[2782].links["knock lou"] = nil
            map[2783].links["knock lou"] = nil
            map[1179].links["ask jia ding about 梅庄"] = nil

            map[1461].links["enter"] = nil
            map[1461].links["kill jia ding;enter"] = 1462
            map_attr.cost["north1460"] = 10000
            map_attr.cost["south1091"] = 10000
            if items["九花玉露丸:yulu wan"].place[1] == 1470 then
                set.remove(items["九花玉露丸:yulu wan"].price, 1)
                set.remove(items["九花玉露丸:yulu wan"].place, 1)
                set.remove(items["九花玉露丸:yulu wan"].get, 1)
            end
            if set.last(items["铁八卦:tie bagua"].place) == 1470 then
                set.pop(items["铁八卦:tie bagua"].price)
                set.pop(items["铁八卦:tie bagua"].place)
                set.pop(items["铁八卦:tie bagua"].get)
            end

            map[2878].links["south"] = nil
            map[2878].links["kill xihua zi;south"] = 2883

            map[285].links["south"] = nil
            map[285].links["hit fu sigui;south"] = 286

            map[556].links["up"] = nil
            map[1216].links["north"] = nil
            map[556].links["kill shuo bude;up"] = 557
            map[1216].links["kill shou wei;north"] = 1217

            map[420].links["north"] = nil
            map[420].links["kill ge lunbu;north"] = 421
            if items["《持世陀罗尼经》:shu"].place[1] == 438 then
                set.remove(items["《持世陀罗尼经》:shu"].price, 1)
                set.remove(items["《持世陀罗尼经》:shu"].place, 1)
                set.remove(items["《持世陀罗尼经》:shu"].get, 1)
            end
            if items["《八埋茶刹罗经》:shu"].place[1] == 438 then
                set.remove(items["《八埋茶刹罗经》:shu"].price, 1)
                set.remove(items["《八埋茶刹罗经》:shu"].place, 1)
                set.remove(items["《八埋茶刹罗经》:shu"].get, 1)
                set.remove(items["《八埋茶刹罗经》:shu"].price, 1)
                set.remove(items["《八埋茶刹罗经》:shu"].place, 1)
                set.remove(items["《八埋茶刹罗经》:shu"].get, 1)
            end

            map[1444].links["northdown"] = nil
            map[1444].links["kill shihou zi;northdown"] = 1435

            map[1959].links["northdown"] = nil
            map[1959].links["kill nv lang;northdown"] = 1960

            map[2374].links["west"] = nil
            map[2374].links["east"] = nil
            map[2374].links["kill huangshan nuzi;west"] = 2372
            map[2374].links["kill huangshan nuzi;east"] = 2376

            map[665].links["west"] = nil
            map[665].links["south"] = nil
            map[665].links["east"] = nil
            map[665].links["kill zhang songxi;west"] = 666
            map[665].links["kill zhang songxi;south"] = 672
            map[665].links["kill zhang songxi;east"] = 679

            map[1811].links["westup"] = nil
            map[1811].links["kill jiading;westup"] = 1797

            map[722].links["knock door;north"] = nil
            map[784].links["westup"] = nil
            map[784].links["kill zhang zhiguang;westup"] = 785
            if set.last(items["《玄门内功心法》:xuanmen xinfa"].place) == 775 then
                set.pop(items["《玄门内功心法》:xuanmen xinfa"].price)
                set.pop(items["《玄门内功心法》:xuanmen xinfa"].place)
                set.pop(items["《玄门内功心法》:xuanmen xinfa"].get)
            end

            map[2221].links["kill wugen daoren;northup"] = 2222
            map[2232].links["kill jiaozhong;north"] = 2233
            map[2236].links["kill yin jin;north"] = 2237
            map[1546].links["say 神龙教主仙福永享"] = nil
            map[2208].links["say 神龙教主仙福永享"] = nil
            map[2221].links["northup"] = nil
            map[2232].links["north"] = nil
            map[2236].links["north"] = nil

            map[2050].links["kill gongye qian;enter"] = 2051
            map[2102].links["kill wang furen;up"] = 2103
            map[2109].links["kill jia ding;east"] = 2112
            map[2050].links["enter"] = nil
            map[2102].links["up"] = nil
            map[2109].links["east"] = nil

            map[2728].links["north"] = 1967
            map[2729].links["south"] = 1967

            map[3188].links["hit ping si;north"] = 3189
            map[3188].links["north"] = nil

            map_attr.cost["north2323"] = 12
            map_attr.cost["north2324"] = 12
            map_attr.cost["west2324"] = 12
            map_attr.cost["west2306"] = 12
            map_attr.cost["west2304"] = 12
            map_attr.cost["west2290"] = 12
            map_attr.cost["south2403"] = 12
            map_attr.cost["southeast2294"] = 12
            map_attr.cost["east2294"] = 12
            map_attr.cost["east2336"] = 12
            map_attr.cost["east2331"] = 12
            map_attr.cost["east2313"] = 12
            map_attr.cost["north2314"] = 12
            calibration["门派"][1] = "无门无派"
        end,
        ["少林俗家"] = function()
            map_attr.cost["knock gate;north"] = 10000
            calibration["门派"][1] = "少林俗家"
        end,
        ["少林派"] = function()
            map[1650].links["kill qingle biqiu;north"] = nil
            map[1667].links["kill huikong zunzhe;northup"] = nil
            map[1656].links["kill qingguan biqiu;open door;north"] = nil
            map[1553].links["kill xuming;kill xutong;eastup"] = nil
            map[1650].links["north"] = 1651
            map[1667].links["northup"] = 1627
            map[1656].links["open door;north"] = 1789
            map[1553].links["eastup"] = 1548
            map_attr.cost["knock gate;north"] = nil
            map_attr.cost["northup1693"] = nil
            map_attr.cost["enter1682"] = nil
            calibration["门派"][1] = "少林派"
        end,
        ["华山派"] = function()
            map[872].links["kill lao denuo;south"] = nil
            map[872].links["kill lao denuo;west"] = nil
            map[879].links["kill lu dayou;south"] = nil
            map[876].links["kill yue lingshan;west"] = nil
            map[883].links["kill ning zhongze;west"] = nil
            map[883].links["kill ning zhongze;south"] = nil
            map[883].links["kill ning zhongze;east"] = nil
            map[870].links["kill shi daizi;west"] = nil
            map[893].links["kill gao genming;northup"] = nil
            map[872].links["south"] = 874
            map[872].links["west"] = 873
            map[879].links["south"] = 880
            map[876].links["west"] = 877
            map[883].links["west"] = 884
            map[883].links["south"] = 885
            map[883].links["east"] = 886
            map[870].links["west"] = 871
            map[893].links["northup"] = 894
            calibration["门派"][1] = "华山派"
        end,
        ["丐帮"] = function()
            map[1117].links["kill jian zhanglao;east"] = nil
            map[1983].links["say 天堂有路你不走呀;down"] = 3039
            map[813].links["enter gudui"] = 3062
            map[1116].links["enter dong"] = 3059
            map[1520].links["enter dong"] = 3056
            map[1327].links["push shibei"] = 3053
            map[633].links["enter dong"] = 3050
            map[80].links["enter dong"] = 3047
            map[615].links["move mugai"] = 3044
            map[2008].links["enter"] = 3041
            map[1117].links["east"] = 1118
            set.insert(items["百草丹:baicao dan"].price, 1, 0)
            set.insert(items["百草丹:baicao dan"].place, 1, 3039)
            set.insert(items["百草丹:baicao dan"].get, 1, "ask liang zhanglao about 百草丹")
            calibration["门派"][1] = "丐帮"
        end,
        ["峨嵋派"] = function()
            map[365].links["kill jing xin;south"] = nil
            map[365].links["south"] = 367
            set.append(items["《九阳神功残篇》:jiuyang canpian"].place, 372)
            set.append(items["《九阳神功残篇》:jiuyang canpian"].get, "ask miejue shitai about 峨嵋九阳功")
            calibration["门派"][1] = "峨嵋派"
        end,
        ["日月神教"] = function()
            map[2782].links["knock lou;enter"] = nil
            map[2783].links["knock lou;enter"] = nil
            map[2782].links["knock lou"] = 2783
            map[2783].links["knock lou"] = 2782
            map[1179].links["ask jia ding about 梅庄"] = 2786
            calibration["门派"][1] = "日月神教"
        end,
        ["桃花岛"] = function()
            map[1461].links["kill jia ding;enter"] = nil
            map[1461].links["enter"] = 1462
            map_attr.cost["north1460"] = nil
            map_attr.cost["south1091"] = nil
            set.insert(items["九花玉露丸:yulu wan"].price, 1, 0)
            set.insert(items["九花玉露丸:yulu wan"].place, 1, 1470)
            set.insert(items["九花玉露丸:yulu wan"].get, 1, "ask lu chengfeng about 九花玉露丸")
            set.append(items["铁八卦:tie bagua"].price, 0)
            set.append(items["铁八卦:tie bagua"].place, 1470)
            set.append(items["铁八卦:tie bagua"].get, "ask lu chengfeng about 桃花岛")
            calibration["门派"][1] = "桃花岛"
        end,
        ["昆仑派"] = function()
            map[2878].links["kill xihua zi;south"] = nil
            map[2878].links["south"] = 2883
            calibration["门派"][1] = "昆仑派"
        end,
        ["大理段家"] = function()
            map[285].links["hit fu sigui;south"] = nil
            map[285].links["south"] = 286
            calibration["门派"][1] = "大理段家"
        end,
        ["明教"] = function()
            map[556].links["kill shuo bude;up"] = nil
            map[1216].links["kill shou wei;north"] = nil
            map[556].links["up"] = 557
            map[1216].links["north"] = 1217
            calibration["门派"][1] = "明教"
        end,
        ["雪山派"] =      function()
            map[420].links["kill ge lunbu;north"] = nil
            map[420].links["north"] = 421
            set.insert(items["《持世陀罗尼经》:shu"].price, 1, 0)
            set.insert(items["《持世陀罗尼经》:shu"].place, 1, 438)
            set.insert(items["《持世陀罗尼经》:shu"].get, 1, "ask lazhang huofo about 密宗心法")
            set.insert(items["《八埋茶刹罗经》:shu"].price, 1, 400)
            set.insert(items["《八埋茶刹罗经》:shu"].place, 1, 438)
            set.insert(items["《八埋茶刹罗经》:shu"].get, 1, "buy")
            set.insert(items["《八埋茶刹罗经》:shu"].price, 1, 0)
            set.insert(items["《八埋茶刹罗经》:shu"].place, 1, 438)
            set.insert(items["《八埋茶刹罗经》:shu"].get, 1, "ask lazhang huofo about 降伏法")
            calibration["门派"][1] = "雪山派"
        end,
        ["血刀门"] =    function()
            map[420].links["kill ge lunbu;north"] = nil
            map[420].links["north"] = 421
            set.insert(items["《持世陀罗尼经》:shu"].price, 1, 0)
            set.insert(items["《持世陀罗尼经》:shu"].place, 1, 438)
            set.insert(items["《持世陀罗尼经》:shu"].get, 1, "ask lazhang huofo about 密宗心法")
            set.insert(items["《八埋茶刹罗经》:shu"].price, 1, 400)
            set.insert(items["《八埋茶刹罗经》:shu"].place, 1, 438)
            set.insert(items["《八埋茶刹罗经》:shu"].get, 1, "buy")
            set.insert(items["《八埋茶刹罗经》:shu"].price, 1, 0)
            set.insert(items["《八埋茶刹罗经》:shu"].place, 1, 438)
            set.insert(items["《八埋茶刹罗经》:shu"].get, 1, "ask lazhang huofo about 降伏法")
            calibration["门派"][1] = "血刀门"
        end,
        ["星宿派"] = function()
            map[1444].links["kill shihou zi;northdown"] = nil
            map[1444].links["northdown"] = 1435
            calibration["门派"][1] = "星宿派"
        end,
        ["灵鹫宫"] = function()
            map[1959].links["kill nv lang;northdown"] = nil
            map[1959].links["northdown"] = 1960
            calibration["门派"][1] = "灵鹫宫"
        end,
        ["古墓派"] = function()
            map[2374].links["kill huangshan nuzi;west"] = nil
            map[2374].links["kill huangshan nuzi;east"] = nil
            map[2374].links["west"] = 2372
            map[2374].links["east"] = 2376
            calibration["门派"][1] = "古墓派"
        end,
        ["武当派"] = function()
            map[665].links["kill zhang songxi;west"] = nil
            map[665].links["kill zhang songxi;south"] = nil
            map[665].links["kill zhang songxi;east"] = nil
            map[665].links["west"] = 666
            map[665].links["south"] = 667
            map[665].links["east"] = 679
            set.append(items["《九阳神功残篇》:jiuyang canpian"].place, 677)
            set.append(items["《九阳神功残篇》:jiuyang canpian"].get, "ask zhang sanfeng about 九阳神功")
            calibration["门派"][1] = "武当派"
        end,
        ["白驼山"] = function()
            map[1811].links["kill jiading;westup"] = nil
            map[1811].links["westup"] = 1797
            calibration["门派"][1] = "白驼山"
        end,
        ["全真教"] = function()
            map[784].links["kill zhang zhiguang;westup"] = nil
            map[722].links["knock door;north"] = 773
            map[784].links["westup"] = 785
            set.append(items["《玄门内功心法》:xuanmen xinfa"].price, 0)
            set.append(items["《玄门内功心法》:xuanmen xinfa"].place, 775)
            set.append(items["《玄门内功心法》:xuanmen xinfa"].get, "ask wang chuyi about miji")
            calibration["门派"][1] = "全真教"
        end,
        ["神龙教"] = function()
            map[2221].links["kill wugen daoren;northup"] = nil
            map[2232].links["kill jiaozhong;north"] = nil
            map[2236].links["kill yin jin;north"] = nil
            map[1546].links["say 神龙教主仙福永享"] = 2208
            map[2208].links["say 神龙教主仙福永享"] = 1546
            map[2221].links["northup"] = 2222
            map[2232].links["north"] = 2233
            map[2236].links["north"] = 2237
            calibration["门派"][1] = "神龙教"
        end,
        ["姑苏慕容"] = function()
            map[2050].links["kill gongye qian;enter"] = nil
            map[2102].links["kill wang furen;up"] = nil
            map[2109].links["kill jia ding;east"] = nil
            map[2050].links["enter"] = 2051
            map[2102].links["up"] = 2103
            map[2109].links["east"] = 2112
            calibration["门派"][1] = "姑苏慕容"
        end,
        ["万兽山庄"] = function()
            map[2728].links["north"] = 2729
            map[2729].links["south"] = 2728
            calibration["门派"][1] = "万兽山庄"
        end,
        ["关外胡家"] = function()
            map[3188].links["hit ping si;north"] = nil
            map[3188].links["north"] = 3189
            calibration["门派"][1] = "关外胡家"
        end,
        ["御林军"] = function()
            map_attr.cost["north2323"] = nil
            map_attr.cost["north2324"] = nil
            map_attr.cost["west2324"] = nil
            map_attr.cost["west2306"] = nil
            map_attr.cost["west2304"] = nil
            map_attr.cost["west2290"] = nil
            map_attr.cost["south2403"] = nil
            map_attr.cost["southeast2294"] = nil
            map_attr.cost["east2294"] = nil
            map_attr.cost["east2336"] = nil
            map_attr.cost["east2331"] = nil
            map_attr.cost["east2313"] = nil
            map_attr.cost["north2314"] = nil
            calibration["门派"][1] = "御林军"
        end,
    },

    ["北京城门"] = {
        ["开放"] = function()
             map[2254].links["west"] = 2306
             map[2257].links["west"] = 2324
             map[2248].links["west"] = 2290
             map[2251].links["west"] = 2304
             map[2260].links["north"] = 2324
             map[2263].links["north"] = 2323
             map[2266].links["north"] = 2314
             map[2269].links["east"] = 2313
             map[2272].links["east"] = 2331
             map[2275].links["east"] = 2336
             map[2278].links["east"] = 2294
             map[2281].links["southeast"] = 2294
             map[2284].links["south"] = 2403
             map[2306].links["east"] = 2254
             map[2331].links["west"] = 2272
             map[2324].links["east"] = 2257
             map[2290].links["east"] = 2248
             map[2304].links["east"] = 2251
             map[2324].links["south"] = 2260
             map[2323].links["south"] = 2263
             --map[2314].links["south"] = 2266   地图bug
             map[2313].links["west"] = 2269
             map[2336].links["west"] = 2275
             map[2294].links["west"] = 2278
             map[2294].links["northwest"] = 2281
             map[2403].links["north"] = 2284
             calibration["北京城门"][1] = "开放"
        end,
        ["关闭"] = function()
            map[2254].links["west"] = nil
            map[2257].links["west"] = nil
            map[2248].links["west"] = nil
            map[2251].links["west"] = nil
            map[2260].links["north"] = nil
            map[2263].links["north"] = nil
            map[2266].links["north"] = nil
            map[2269].links["east"] = nil
            map[2272].links["east"] = nil
            map[2275].links["east"] = nil
            map[2278].links["east"] = nil
            map[2281].links["southeast"] = nil
            map[2284].links["south"] = nil
            map[2306].links["east"] = nil
            map[2331].links["west"] = nil
            map[2324].links["east"] = nil
            map[2290].links["east"] = nil
            map[2304].links["east"] = nil
            map[2324].links["south"] = nil
            map[2323].links["south"] = nil
            map[2314].links["south"] = nil
            map[2313].links["west"] = nil
            map[2336].links["west"] = nil
            map[2294].links["west"] = nil
            map[2294].links["northwest"] = nil
            map[2403].links["north"] = nil
            calibration["北京城门"][1] = "关闭"
        end,
    },

    ["北京城墙"] = {
        ["开放"] = function()
            map[2248].links["jump wall"] = 2290
            map[2251].links["jump wall"] = 2304
            map[2254].links["jump wall"] = 2306
            map[2257].links["jump wall"] = 2324
            map[2260].links["jump wall"] = 2324
            map[2263].links["jump wall"] = 2323
            map[2266].links["jump wall"] = 2314
            map[2269].links["jump wall"] = 2313
            map[2272].links["jump wall"] = 2331
            map[2275].links["jump wall"] = 2336
            map[2278].links["jump wall"] = 2294
            map[2281].links["jump wall"] = 2294
            map[2284].links["jump wall"] = 2403
            map[2297].links["jump wall"] = 2263
            map[2306].links["jump wall"] = 2263
            map[2310].links["jump wall"] = 2263
            map[2331].links["jump wall"] = 2263
            calibration["北京城墙"][1] = "开放"
        end,
        ["关闭"] = function()
            map[2248].links["jump wall"] = nil
            map[2251].links["jump wall"] = nil
            map[2254].links["jump wall"] = nil
            map[2257].links["jump wall"] = nil
            map[2260].links["jump wall"] = nil
            map[2263].links["jump wall"] = nil
            map[2266].links["jump wall"] = nil
            map[2269].links["jump wall"] = nil
            map[2272].links["jump wall"] = nil
            map[2275].links["jump wall"] = nil
            map[2278].links["jump wall"] = nil
            map[2281].links["jump wall"] = nil
            map[2284].links["jump wall"] = nil
            map[2297].links["jump wall"] = nil
            map[2306].links["jump wall"] = nil
            map[2310].links["jump wall"] = nil
            map[2331].links["jump wall"] = nil
            calibration["北京城墙"][1] = "关闭"
        end,
    },

    ["泉州新门"] = {
        ["开放"] = function()
            map[52].links["west"] = 53
            map[53].links["east"] = 52
            calibration["泉州新门"][1] = "开放"
        end,
        ["关闭"] = function()
            map[52].links["west"] = nil
            map[53].links["east"] = nil
            calibration["泉州新门"][1] = "关闭"
        end,
    },

    ["松花江"] = {
        ["冰面"] = function()
            map[1508].links["east"] = nil
            map[1507].links["west"] = nil
            map[1508].links["yell boat;enter"] = 1963
            map[1507].links["yell boat;enter"] = 1963
            if calibration["过河"][1] == "大圣" then
                map[1508].links["yell 大圣"] = 1507
                map[1507].links["yell 大圣"] = 1508
                map_attr.cost["yell boat;enter1963"] = 10000
            end
            calibration["松花江"][1] = "冰面"
        end,
        ["渡船"] = function()
            map[1508].links["east"] = 3036
            map[1507].links["west"] = 3036
            map[1508].links["yell boat;enter"] = nil
            map[1507].links["yell boat;enter"] = nil
            map[1508].links["yell 大圣"] = nil
            map[1507].links["yell 大圣"] = nil
            map_attr.cost["yell boat;enter1963"] = nil
            calibration["松花江"][1] = "渡船"
        end,
    },

    ["少林山门"] = {
        ["开放"] = function()
            map_attr.cost["knock gate;north"] = nil
            calibration["少林山门"][1] = "开放"
        end,
        ["关闭"] = function()
            map_attr.cost["knock gate;north"] = 10000
            calibration["少林山门"][1] = "关闭"
        end,
    },

    ["古墓水道"] = {
        ["启用"] = function()
            map_attr.cost["westdown2365"] = nil
            calibration["古墓水道"][1] = "启用"
        end,
        ["禁用"] =  function()
            map_attr.cost["westdown2365"] = 10000
            calibration["古墓水道"][1] = "禁用"
        end,
    },

    ["古墓入口"] = {
        ["启用"] = function()
            map[741].links["move shi;enter"] = 2381
            calibration["古墓入口"][1] = "启用"
        end,
        ["禁用"] = function()
            map[741].links["move shi;enter"] = nil
            calibration["古墓入口"][1] = "禁用"
        end,
    },

    ["黑龙江栈道"] = {
        ["启用"] = function()
             map_attr.cost["south392"] = nil
             map_attr.cost["north407"] = nil
             calibration["黑龙江栈道"][1] = "启用"
        end,
        ["禁用"] = function()
            map_attr.cost["south392"] = 10000
            map_attr.cost["north407"] = 10000
            calibration["黑龙江栈道"][1] = "禁用"
        end,
    },

    ["南阳城"] = {
         ["开放"] = function()
            map_attr.cost["enter1942"] = nil
            map_attr.cost["north2401"] = nil
            calibration["南阳城"][1] = "开放"
        end,
        ["关闭"] = function()
            map_attr.cost["enter1942"] = 10000
            map_attr.cost["north2401"] = 10000
            calibration["南阳城"][1] = "关闭"
        end,
    },

    ["南阳城郊"] = {
        ["开放"] = function()
            map[1858].links["west"] = 2958
            map[1933].links["north"] = 2948
            map[1916].links["east"] = 2964
            calibration["南阳城郊"][1] = "开放"
        end,
       ["关闭"] = function()
            map[1858].links["west"] = nil
            map[1933].links["north"] = nil
            map[1916].links["east"] = nil
            calibration["南阳城郊"][1] = "关闭"
        end,
    },

    ["灵鹫索桥"] = {
        ["启用"] = function()
            map[2160].links["zou tiesuo"] = 2161
            map[2161].links["zou tiesuo"] = 2160
            calibration["灵鹫索桥"][1] = "启用"
        end,
        ["禁用"] = function()
            map[2160].links["zou tiesuo"] = 2157
            map[2161].links["zou tiesuo"] = 2157
            calibration["灵鹫索桥"][1] = "禁用"
        end,
    },

    ["天龙殿壁画"] = {
        ["启用"] = function()
            map[434].links["enter picture"] = 1854
            calibration["灵鹫索桥"][1] = "禁用"
        end,
        ["禁用"] = function()
             map[434].links["enter picture"] = nil
             calibration["灵鹫索桥"][1] = "禁用"
        end,
    },

    ["燕子坞"] = {
        ["轻功"] = function()
            map[2048].links["qu murong"] = 2049
            map[2049].links["yell boat"] = 2048
            map[2049].links["yell boat;enter"] = nil
            map[2048].links["qu mantuo"] = 2074
            map_attr.cost["qu murong"] = 3
            map_attr.cost["qu mantuo"] = 2
            map_attr.cost["tan qin"] = 2
            calibration["燕子坞"][1] = "轻功"
        end,
        ["客船"] = function()
            map[2048].links["qu murong"] = 2526
            map[2049].links["yell boat"] = nil
            map[2049].links["yell boat;enter"] = 2343
            map[2048].links["qu mantuo"] = 3031
            map_attr.cost["qu murong"] = 19
            map_attr.cost["qu mantuo"] = 15
            map_attr.cost["tan qin"] = 10
            calibration["燕子坞"][1] = "客船"
        end,
    },

    ["南疆沙漠"] = {
        ["开放"] = function()
            map_attr.cost["northeast1979"] = 3
            map_attr.cost["southwest1979"] = 3
            map_attr.cost["south3010"] = 3
            map_attr.cost["northwest3006"] = 3
            map_attr.cost["northeast1328"] = 3
            map_attr.cost["southwest3007"] = 3
            map_attr.cost["southeast3008"] = 3
            map_attr.cost["northeast3009"] = 3
            calibration["南疆沙漠"][1] = "开放"
        end,
        ["关闭"] =  function()
            map_attr.cost["northeast1979"] = 10000
            map_attr.cost["southwest1979"] = 10000
            map_attr.cost["south3010"] = 15
            map_attr.cost["northwest3006"] = 15
            map_attr.cost["northeast1328"] = 15
            map_attr.cost["southwest3007"] = 15
            map_attr.cost["southeast3008"] = 15
            map_attr.cost["northeast3009"] = 15
            calibration["南疆沙漠"][1] = "关闭"
        end,
    },

    ["金蛇密洞"] = {
        ["开放"] = function()
            map[906].links["bang tree;climb"] = 3184
            calibration["金蛇密洞"][1] = "开放"
        end,
        ["关闭"] =  function()
            map[906].links["bang tree;climb"] = nil
            calibration["金蛇密洞"][1] = "关闭"
        end,
    },

    ["华山悬崖"] = {
        ["开放"] = function()
            map[889].links["zha stone;climb down"] = 2722
            calibration["华山悬崖"][1] = "开放"
        end,
        ["关闭"] = function()
            map[889].links["zha stone;climb down"] = nil
            calibration["华山悬崖"][1] = "关闭"
        end,
    },

    ["全真悬崖"] = {
        ["开放"] = function()
            map[3003].links["climb up"] = 3244
            map[3244].links["climb up"] = 1422
            calibration["全真悬崖"][1] = "开放"
        end,
        ["关闭"] = function()
            map[3003].links["climb up"] = nil
            map[3244].links["climb up"] = nil
            calibration["全真悬崖"][1] = "关闭"
        end,
    },
}

function map_adjust(...)
    local input = {...}
    for i = 1, #input, 2 do
        if calibration[input[i]][1] ~= input[i+1] then
            local do_update = calibration[input[i]][input[i+1]] or function() end
            if input[i] == "门派" and input[i+1] ~= "无门无派" then
                calibration["门派"]["无门无派"]()
            end
            do_update()
        end
    end
end