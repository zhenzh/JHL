-- 房间信息
env = {room = {}, current = {}, nextto = {}}
env.current = {id = {}, name = "", desc = {}, exits = "", zone = {}, objs = {}}
env.nextto = {id = {}, name = "", desc = {}, exits = "", zone = {}, objs = {}}
env.room = env.current

local skip_info = {
    ["夜幕笼罩著大地。"] = "",
    ["夜幕低垂，满天繁星。"] = "",
    ["太阳正高挂在西方的天空中。"] = "",
    ["太阳正高挂在东方的天空中。"] = "",
    ["太阳刚从东方的地平线升起。"] = "",
    ["东方的天空已逐渐发白。"] = "",
    ["一轮火红的夕阳正徘徊在西方的地平线上。"] = "",
    ["现在是正午时分，太阳高挂在你的头顶正上方。"] = "",
    ["　　金顶云海，迷迷茫茫，笼罩四野，远接天际。云海轻荡时，你在金顶，脚"] = "",
    ["踏白云，大有飘飘欲仙之感；当云涛迅猛涌来时，整个金顶都似在向前浮动，"] = "",
    ["令人有乘舟欲风之意。"] = "",
    ["　　日丽风静，云海平铺，美丽以极。阳光从你背面斜射下来，在舍身崖下形"] = "",
    ["成彩色光环，你见到自己的身影清晰地出现在银色世界上。『光环随人动，人"] = "",
    ["影在环中』，这就是奇妙的　※※※※※※※佛光※※※※※※※　。"] = "",
    ["　　这里有一种使人献身的超人力量，令你不禁想要在此投身云海，摆脱人世"] = "",
    ["的俗累，与天相接。"] = "",
    ["　　初见金顶下黑黝黝一片，忽而闪现出一点、两点带蓝色的亮光，这种亮点"] = "",
    ["越来越多，转眼便布满山谷，有的如流萤飘飞，有的如繁星闪烁。"] = "",
    ["启明星刚刚升起，一道道微白的光在东方云层闪现，一轮红日托地跳出，"] = "",
    ["大千世界顿时在彩阳映照下呈现出无限生机。"] = "",
    ["天空中彤云密布，只有几只海鸥还在奋力展翅，海船左右摇晃不已，你感到有"] = "",
    ["点立足不稳。"] = "",
    ["四周是辽阔的海面，海风在你耳边轻轻吹过，海浪一个接一个向船泼打过来。"] = "",
    ["海面汹涌澎湃，几丈高的巨浪排山倒海似得压来，随时都有可能将船掀翻，你"] = "",
    ["时而不得不紧紧抱住船杆，以免落海。"] = "",
    ["在这里输入idle可以进入发呆涨exp的模式哦。"] = ""
}

-- 显示过滤
trigger.add("hide_busy", "", "显示过滤", {Enable=false, Gag=true}, 1, "^你正忙着呢，先忍忍吧。$|^你还在忙着呢。$|^你身上没有 busy 这样食物。$|^你现在很忙，停不下来。$")
trigger.add("hide_set_value", "", "显示过滤", {Enable=true, Gag=true}, 1, "^你目前还没有任何为 .+ 的变量设定。$")
trigger.add("hide_npc_faint", "", "显示过滤", {Enable=true, Gag=true}, 1, "^对方还没有完全昏迷，先等等吧。$")
trigger.add("hide_force_busy", "", "显示过滤", {Enable=true, Gag=true}, 1, "^\\( 你上一个动作还没有完成，不能施用内功。\\)$")
trigger.add("hide_action_busy", "", "显示过滤", {Enable=true, Gag=true}, 1, "^\\( 你上一个动作还没有完成，不能施用外功。\\)$")
trigger.add("hide_carryon", "", "显示过滤", {Enable=false, Gag=true}, 1, "^你\\(你\\)身上携带物品的别称如下\\(右方\\)：$|"..
                                                                        "^\\S+\\s+= [ \\w]+[, \\w]*$|^\\S+\\([ \\w]+\\)$|"..
                                                                        "^一只用细竹编织成的食盒。$|"..
                                                                        "^这是一条皮质的宽腰带，夹层透空，可以放各种软兵刃。$|"..
                                                                        "^一只用粗麻布织成的袋子，身上所带布袋的多少，是丐帮弟子江湖地位的标志。$|"..
                                                                        "^里面有：$|^\\s+\\S+\\([ \\w]+\\)$|"..
                                                                        "^里面装(?:满了|了(?:七、八分满|五、六分满|少许)的)\\S+。$|"..
                                                                        "^一个用来装香雪酒的酒瓶。此酒又被称为“封缸酒”，酒质甘甜淳厚。$|"..
                                                                        "^一个用来装竹叶青的酒瓶。此酒据说源于 “杏花村”，酒色青绿，晶莹透明。$|"..
                                                                        "^酒质呈琥玻，甘甜醇后，风格独特。$|"..
                                                                        "^一个用来装米酒的大酒袋，大概装得八、九升的酒。$|"..
                                                                        "^一个不知道用什么动物的皮制成的水壶。$|"..
                                                                        "^一个用来装高级花雕酒的大酒袋。$|"..
                                                                        "^一个用来装状元红的酒瓶。据说此酒后劲颇大。$|"..
                                                                        "^一个蓝边粗磁大碗。$|"..
                                                                        "^一碗新鲜野菜做的汤。$|"..
                                                                        "^一个用葫芦制成的水壶。$|"..
                                                                        "^世世代代由丐帮的帮主执掌，就好像皇帝的玉玺、做官的金印一般。$|"..
                                                                        "^一个用来装龙岩酒的酒瓶。此酒不加糖而甜，不着色而颜红，不调香而芬芳。$|"..
                                                                        "^一个用来装女儿红的酒瓶。绍兴人家生了女儿，大多会酿上几坛好酒埋在地下，等$|"..
                                                                        "^到女儿出嫁那天才起出，所以酒味醇厚。据说后劲也特别大。$|"..
                                                                        "^一个用来装花雕酒的酒瓶。黄酒中的上品半干类，酒质厚浓，风味优良，可长久$|"..
                                                                        "^贮藏。$")
trigger.add("hide_i", "", "显示过滤", {Enable=false, Gag=true}, 1, "^你身上带着\\S+件物品\\(负重\\s*\\d+%\\)：$|"..
                                                                  "^(?:□|\\s+)\\S+\\([ \\w]+\\)$|"..
                                                                  "^目前你身上没有任何东西。$")
trigger.add("hide_score", "", "显示过滤", {Enable=false, Gag=true}, 1, "^(?:│|┌|└).*(?:│|┐|┘)$")
trigger.add("hide_hp", "", "显示过滤", {Enable=false, Gag=true}, 1, "^ (?:精神|气血|食物|饮水)：\\s*[-\\d]+/.+$")
trigger.add("hide_skills", "", "显示过滤", {Enable=false, Gag=true}, 1, "^你目前所学过的技能：（共\\S+项技能）[　]+$|"..
                                                                       "^(?:│|┌|└).*(?:│|┐|┘)$|"..
                                                                       "^\\s*$")
trigger.add("hide_enable", "", "显示过滤", {Enable=false, Gag=true}, 1, "^以下是你目前使用中的特殊技能。$|"..
                                                                       "^\\s+(?:轻功|内功|招架|(?:掌|指|手|爪|拳|腿|剑|刀|棒|棍|枪|斧|锤|鞭|笔|钩|杖)法) \\(\\w+\\)\\s+： \\S+\\s+有效等级：\\s*\\d+$")
trigger.add("hide_prepare", "", "显示过滤", {Enable=false, Gag=true}, 1, "^以下是你目前组合中的特殊拳术技能。$|"..
                                                                        "^你现在没有组合任何特殊拳术技能。$|"..
                                                                        "^\\S+ \\(\\w+\\)\\s+\\S+$")
trigger.add("hide_list", "", "显示过滤", {Enable=false, Gag=true}, 1, "^你保存的物品如下:$|"..
                                                                     "^-+$|"..
                                                                     "^\\d+\\s+\\S+\\s+：\\s+\\d+$")
trigger.add("hide_set", "", "显示过滤", {Enable=false, Gag=true}, 1, "^你目前设定的环境变量有：$|"..
                                                                    "^\\s+\\S+ -> .*$")
trigger.add("hide_buy", "", "显示过滤", {Enable=false, Gag=true}, 1, "^哟，抱歉啊，我这儿正忙着呢……您请稍候。$")
trigger.add("others_come", "", "显示过滤", {Enable=false, Gag=true}, 1, "^\\S+走了过来。$|"..
                                                                       "^\\S+窜了出来，警惕地四周张望着。$")
trigger.add("others_leave", "", "显示过滤", {Enable=false, Gag=true}, 1, "^\\S+往\\S+离开。$|"..
                                                                        "^\\S+奔了过去。$")

-- 状态记录
local status_triggers = table.load(get_script_path().."game/status.lua")
for k,v in pairs(status_triggers) do
    trigger.add(k, v[1], v[2], v[3], v[4], v[5])
end
status_triggers = nil

trigger.add("invalid_fu_qixuedanyao", "invalid_fu_qixuedanyao()", "状态记录", {Enable=true}, 2, "^你吃下一颗丹药，觉得自己的气息更加悠长。$")
trigger.add("invalid_fu_jingshendanyao", "invalid_fu_jingshendanyao()", "状态记录", {Enable=true}, 2, "^你吃下一颗丹药，觉得自己的精神抖擞。$")
trigger.add("invalid_fu_yuluwan", "invalid_fu_yuluwan()", "状态记录", {Enable=true}, 2, "^你吃下一粒九花玉露丸，(?:一股清香之气直透丹田，只觉得精神健旺，气血充盈，体内真力源源滋生，将疲乏一扫而空! |只觉得头重脚轻，摇摇欲倒，原来服食太急太多，药效适得其反！)$")
trigger.add("invalid_fu_sanhuangwan", "invalid_fu_sanhuangwan()", "状态记录", {Enable=true}, 2, "^你服下一颗三黄宝蜡丸，(?:只觉通体舒泰，精神焕发，伤势大有好转。|觉得体内真气逆行，内力大损。原来服食)$")
trigger.add("invalid_fu_daxueteng", "invalid_fu_daxueteng()", "状态记录", {Enable=true}, 2, "^你吃下一棵大血藤，(?:顿时血气翻涌血脉膨胀，气力大长。|只觉得肝肠寸断，五脏欲裂，原来服食太多药物，药效适得其反！)$")
trigger.add("invalid_fu_renshenguo", "invalid_fu_renshenguo()", "状态记录", {Enable=true}, 2, "^你吃下一枚人参果，(?:只觉得精神健旺，气血充盈，体内真力源源滋生，将疲乏饥渴一扫而空! |只觉得头重脚轻，摇摇欲倒，原来服食太急太多，药效适得其反！)$")
trigger.add("invalid_fu_xuelian", "invalid_fu_xuelian()", "状态记录", {Enable=true}, 2, "^你吃下一支雪莲，(?:一股秋菊似的幽香沁入心肺，顿觉神清气爽。|只觉得头重脚轻，摇摇欲倒，原来服食太急太多，药效适得其反！)$")

-- 信息采集
trigger.add("get_room_objs", "get_room_objs(get_matches(1))", "信息采集", {Enable=false}, 3, "^  ((?:\\S+ \\S+|\\S+)(?:\\((?:\\w+ \\w+|\\w+)\\)|))(?:| <\\S+>)$")
trigger.add("get_room_exits", "get_room_exits(get_matches(1))", "信息采集", {Enable=true}, 3, "^\\s+这里(?:明显|唯一)的出口是 (.*)。$|"..
                                                                                             "^\\s+这里没有任何明显的出路。$")
trigger.add("get_room_end", "get_room_end()", "信息采集", {Enable=false}, 3, "^> $")
trigger.add("get_room_desc", "get_room_desc(get_matches(1))", "信息采集", {Enable=false}, 4, "^\\s*(.+)\\s*$")
trigger.add("get_room_name", "get_room_name(get_matches(1))", "信息采集", {Enable=true}, 5, "^(\\S+)\\s+- $")
trigger.add("get_room_abst", "get_room_abst(get_matches(1), get_matches(2))", "信息采集", {Enable=true}, 5, "^(\\S+)\\s+- ([、a-z0-9]+)$")
trigger.add("mud_time", "env.mud_time = {get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5)}", "信息采集", {Enable=true}, 5, "^现在泥潭时间是(\\S+)年(\\S+)月(\\S+)日(\\S+)时(\\S+)。$")
trigger.add("war_start", "map_adjust('南阳城', '关闭')", "信息采集", {Enable=true}, 5, "^【闲聊】太守\\(Tai shou\\)：蒙古大军即将入境，多亏\\S+几位江湖豪杰愿为我大宋效力抵抗蒙古。在下先行谢过。$")
trigger.add("war_end", "map_adjust('南阳城', '开放')", "信息采集", {Enable=true}, 5, "^【闲聊】诏示天下：蒙古元帅被已被\\S+消灭，蒙古鞑子撤退啦！$")
trigger.add("war_finish", "map_adjust('南阳城郊', '关闭')", "信息采集", {Enable=true}, 5, "^几个宋兵把城外的吊桥缓缓升起，大门随之紧闭，断绝了对外的通道。$")
trigger.add("songhua", "map_adjust('松花江', '渡船')", "信息采集", {Enable=true}, 5, "^松花江化冻了，你喊\\(yell\\)条船过江吧。$")
trigger.add("shaolin_close", "map_adjust('少林山门', '关闭')", "信息采集", {Enable=true}, 5, "^壮年僧人说道：这位施主请回罢，本寺不接待俗人。$")
trigger.add("shaolin_open", "map_adjust('少林山门', '开放')", "信息采集", {Enable=true}, 5, "^壮年僧人急忙躬身道：原来是闯过罗汉大阵的大英雄驾到，请进！$")
trigger.add("layman", "map_adjust('门派', '少林俗家')", "信息采集", {Enable=true}, 5, "^壮年僧人说道：对不起，俗家弟子不得入寺修行。$")
trigger.add("weather_before_dawn", "weather_before_dawn()", "信息采集", {Enable=true}, 5, "^\\s+东方的天空已逐渐发白。$")
trigger.add("time_before_dawn", "time_before_dawn()", "信息采集", {Enable=true}, 5, "^东方的天空中开始出现一丝微曦。$")
trigger.add("weather_early_morning", "weather_early_morning()", "信息采集", {Enable=true}, 5, "^\\s+太阳刚从东方的地平线升起。$")
trigger.add("time_early_morning", "time_early_morning()", "信息采集", {Enable=true}, 5, "^太阳从东方的地平线升起了。$")
trigger.add("weather_morning", "weather_morning()", "信息采集", {Enable=true}, 5, "^\\s+太阳正高挂在东方的天空中。$")
trigger.add("time_morning", "time_morning()", "信息采集", {Enable=true}, 5, "^太阳已经高高地挂在东方的天空中。$")
trigger.add("weather_noon", "weather_noon()", "信息采集", {Enable=true}, 5, "^\\s+现在是正午时分，太阳高挂在你的头顶正上方。$")
trigger.add("time_noon", "time_noon()", "信息采集", {Enable=true}, 5, "^已经是正午了，太阳从你正上方照耀著大地。$")
trigger.add("weather_afternoon", "weather_afternoon()", "信息采集", {Enable=true}, 5, "^\\s+太阳正高挂在西方的天空中。$")
trigger.add("time_afternoon", "time_afternoon()", "信息采集", {Enable=true}, 5, "^太阳开始从西方的天空中慢慢西沉。$")
trigger.add("weather_evening", "weather_evening()", "信息采集", {Enable=true}, 5, "^\\s+一轮火红的夕阳正徘徊在西方的地平线上。$")
trigger.add("time_evening", "time_evening()", "信息采集", {Enable=true}, 5, "^傍晚了，太阳的馀晖将西方的天空映成一片火红。$")
trigger.add("weather_night", "weather_night()", "信息采集", {Enable=true}, 5, "^\\s+夜幕笼罩著大地。$")
trigger.add("time_night", "time_night()", "信息采集", {Enable=true}, 5, "^夜晚降临了。$")
trigger.add("weather_mid_night", "weather_mid_night()", "信息采集", {Enable=true}, 5, "^\\s+夜幕低垂，满天繁星。$")
trigger.add("time_mid_night", "time_mid_night()", "信息采集", {Enable=true}, 5, "^已经是午夜了。$")
trigger.add("get_port", "get_port(get_matches(1))", "信息采集", {Enable=true}, 5, "^船夫说：“(\\S+)到啦，上岸吧”。$")
trigger.add("exit_out", "env.current.exits = {'out'}", "信息采集", {Enable=true}, 5, "^艄公说“到啦，上岸吧”，随即把一块踏脚板搭上堤岸。$|"..
                                                                                    "^(?:终于到了(?:岸|小岛)边，|)船夫把小舟靠在岸边，快下船吧。$|"..
                                                                                    "^船还没开呢。$|"..
                                                                                    "^过了良久，竹篓(?:停止下降，|)已经到达崖(?:顶|底)，快(?:上|下)去吧。$")
trigger.add("no_exit", "env.current.exits = {}", "信息采集", {Enable=true}, 5, "^(?:艄公|船夫)把踏脚板收起来，说了一声“坐稳喽”，竹篙一点，扁舟向$|"..
                                                                              "^只听见绞盘声响，大竹篓开始(?:慢慢上升|缓缓下降)。$|"..
                                                                              "^你大喝一声“开船”，于是船便离了岸。$")
trigger.add("exit_change", "env.current.exits = ''", "信息采集", {Enable=true}, 5, "^(?:艄公|船夫)把踏脚板收起来，把扁舟驶向(?:江|湖)(?:中|心)。$|"..
                                                                                  "^渔船离了岸，驶向茫茫的大海。$|"..
                                                                                  "^竹篓上的人只感觉到竹篓一震，已经离开了原位。$")
trigger.add("get_state_l1", "get_state_l1(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5), get_matches(6))", "信息采集", {Enable=true}, 5, "^\\s+精神：\\s+([-\\d]+)/\\s+([-\\d]+)\\s+\\(\\s*(\\d+)%\\)\\s+精力：\\s+([-\\d]+)\\s+/\\s+(\\d+)\\s+\\(\\+(\\d+)\\)$")
trigger.add("get_state_l2", "get_state_l2(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5), get_matches(6))", "信息采集", {Enable=true}, 5, "^\\s+气血：\\s+([-\\d]+)/\\s+([-\\d]+)\\s+\\(\\s*(\\d+)%\\)\\s+内力：\\s+([-\\d]+)\\s+/\\s+(\\d+)\\s+\\(\\+(\\d+)\\)$")
trigger.add("get_state_l3", "get_state_l3(get_matches(1), get_matches(2), get_matches(3), get_matches(4))", "信息采集", {Enable=true}, 5, "^\\s+食物：\\s+(\\d+)/\\s+(\\d+)\\s+潜能：\\s+([-\\d]+)\\s+/\\s+(\\d+)$")
trigger.add("get_state_l4", "get_state_l4(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=true}, 5, "^\\s+饮水：\\s+(\\d+)/\\s+(\\d+)\\s+经验：\\s+([-\\d]+)$")
trigger.add("get_profile_l1", "get_profile_l1(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=true}, 5, "^│姓  名：(\\S+)\\s+臂力：\\s*(\\d+)/\\s+(\\d+)\\s+悟性：\\s*([-\\d]+)/\\s+(\\d+)\\s+│$")
trigger.add("get_profile_l2", "get_profile_l2(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=true}, 5, "^│英文ID：(\\S+)\\s+根骨：\\s*(\\d+)/\\s+(\\d+)\\s+身法：\\s*(\\d+)/\\s+(\\d+)\\s+│$")
trigger.add("get_profile_l3", "get_profile_l3(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=true}, 5, "^│性  别：(\\S+)性人类\\s+容貌：\\s*(\\d+)/\\s+(\\d+)\\s+运气：\\s*(\\d+)/\\s+(\\d+)\\s+│$")
trigger.add("get_profile_l4", "get_profile_l4(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=true}, 5, "^│年  龄：(\\S+)岁(?:正|又(\\S+)个月)\\s+体内食物：\\s+(\\d+)\\s+\\(\\d+%\\)\\s+│$")
trigger.add("get_profile_l5", "get_profile_l5(get_matches(1), get_matches(2))", "信息采集", {Enable=true}, 5, "^│头  衔：【\\s*(\\S+\\s*\\S+)\\s*】\\s+体内饮水：\\s+(\\d+)\\s+\\(\\d+%\\)\\s+│$")
trigger.add("get_profile_l6", "get_profile_l6(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=true}, 5, "^│体  重：(\\S+)斤(?:多|)\\s+钱庄盈余：(?:亏空无余|([一二三四五六七八九十百千万亿]+)(?:多|)两黄金(?:多|正|)|(很少))\\s+│$")
trigger.add("get_profile_l7", "get_profile_l7(get_matches(1))", "信息采集", {Enable=true}, 5, "^│\\s+在线时间：(\\S*)(?:整|多|钟|秒|钟多)\\s+│$")
trigger.add("get_profile_l8", "get_profile_l8(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=true}, 5, "^│(\\S+)：(\\d+)\\s*(?:|经验(?:增加|减少)：([-\\d]+))\\s+│$")
trigger.add("get_profile_l9", "get_profile_l9(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=true}, 5, "^│格斗经验：([,\\d]+)\\s+等级限制：\\s*(\\d+)\\s+\\(\\+差\\s*(\\d+)\\s*\\)\\s*│$")
trigger.add("get_profile_l10", "get_profile_l10(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=true}, 5, "^│江湖贡献：(\\d+)\\s+江湖潜力：\\s+(\\d+)\\s+\\(\\+存\\s+(\\d+(?:|万))\\s*\\)\\s*│$")
trigger.add("get_profile_l11", "get_profile_l11(get_matches(1), get_matches(2))", "信息采集", {Enable=true}, 5, "^│江湖伴侣：(\\S+)\\s+含恨入土：\\s+(\\d+)\\s+\\(\\+真\\s+\\d+\\s*\\)\\s*│$")
trigger.add("get_profile_l12", "get_profile_l12(get_matches(1), get_matches(2))", "信息采集", {Enable=true}, 5, "^│江湖门派：(\\S+)\\s+手下冤魂：\\s+(\\d+)\\s+\\(\\+敌\\s+\\d+\\s*\\)\\s*│$")
trigger.add("get_profile_l13", "get_profile_l13(get_matches(1))", "信息采集", {Enable=true}, 5, "^│授业师父：(\\S+)\\s+前生仇敌：(?:|\\S+\\([ \\w]+\\))\\s*│$")
trigger.add("get_carryon_empty", "get_carryon_empty()", "信息采集", {Enable=true}, 5, "^目前你身上没有任何东西。$")
trigger.add("get_carryon_summary", "get_carryon_summary(get_matches(1), get_matches(2))", "信息采集", {Enable=true}, 5, "^你身上带着(\\S+)件物品\\(负重\\s*(\\d+)%\\)：$")
trigger.add("get_carryon_item", "get_carryon_item(get_matches(1))", "信息采集", {Enable=false}, 5, "^(?:\\s+|□|\\s+\\S+ )(\\S+\\([ \\w]+\\))")
trigger.add("get_carryon_wield", "get_carryon_wield(get_matches(1), get_matches(2))", "信息采集", {Enable=false}, 5, "^□(\\S+)\\(([ \\w]+)\\)$")
trigger.add("get_carryon_detail", "get_carryon_detail()", "信息采集", {Enable=false}, 5, "^你\\(你\\)身上携带物品的别称如下\\(右方\\)：$")
trigger.add("get_carryon_list", "get_carryon_list(get_matches(1), get_matches(2))", "信息采集", {Enable=false}, 5, "^(\\S+)\\s+=\\s+([, \\w]+)$")
trigger.add("get_carryon_list_end", "get_carryon_list_end()", "信息采集", {Enable=false}, 5, "^> $")
trigger.add("get_item_container", "get_item_container(get_matches(1))", "信息采集", {Enable=false}, 5, "^\\s+(\\S+\\([ \\w]+\\))$")
trigger.add("get_water_container", "get_water_container(get_matches(1), get_matches(2))", "信息采集", {Enable=false}, 5, "^里面装((?:了(?:(?:五、六|七、八|)分满|少许)的|满了))\\S*((?:水|酒|女儿红|状元红|野菜汤|竹叶清))。$")
trigger.add("get_repository", "get_repository()", "信息采集", {Enable=true}, 5, "^你保存的物品如下:$")
trigger.add("get_repository_list", "get_repository_list(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=false}, 5, "^(\\d+)\\s+(\\S+)\\s+：\\s+(\\d+)$")
trigger.add("get_repository_end", "get_repository_end()", "信息采集", {Enable=false}, 5, "^> $")
trigger.add("get_personal_weapon_name", "get_personal_weapon_name(get_matches(1))", "信息采集", {Enable=true}, 5, '^\\s+name -> "(.*)"$')
trigger.add("get_personal_weapon_wield_msg", "get_personal_weapon_wield_msg(get_matches(1))", "信息采集", {Enable=true}, 5, '^\\s+wieldMsg -> "(.*)"$')
trigger.add("get_personal_weapon_unwield_msg", "get_personal_weapon_unwield_msg(get_matches(1))", "信息采集", {Enable=true}, 5, '^\\s+unwieldMsg -> "(.*)"$')
trigger.add("update_coin-", "update_coin('-'..get_matches(1))", "信息采集", {Enable=true}, 5, "^你拿出(?:的|)(\\S+)文铜钱\\S+。$")
trigger.add("update_silver-", "update_silver('-'..get_matches(1))", "信息采集", {Enable=true}, 5, "^你拿出(?:的|)(\\S+)两白银\\S+。$")
trigger.add("update_gold-", "update_gold('-'..get_matches(1))", "信息采集", {Enable=true}, 5, "^你拿出(?:的|)(\\S+)两黄金\\S+。$")
trigger.add("update_coin+", "update_coin(get_matches(1))", "信息采集", {Enable=true}, 5, "^(?:你|掌柜的点点头，)从\\S+出(\\S+)文铜板\\S*。$")
trigger.add("update_silver+", "update_silver(get_matches(1))", "信息采集", {Enable=true}, 5, "^(?:你|掌柜的点点头，)从\\S+出(\\S+)两白银\\S*。$")
trigger.add("update_gold+", "update_gold(get_matches(1))", "信息采集", {Enable=true}, 5, "^(?:你|掌柜的点点头，)从\\S+出(\\S+)两黄金\\S*。$")
trigger.add("convert_currency", "convert_currency(get_matches(1), get_matches(2), get_matches(3), get_matches(4))", "信息采集", {Enable=true}, 5, "^掌柜的点点头，将你从身上取出的(\\S+)(?:文|两)(\\S+)换成了(\\S+)(?:文|两)(\\S+)。$")
trigger.add("get_skills", "get_skills()", "信息采集", {Enable=true}, 5, "^你目前所学过的技能：（共\\S+项技能）[　]+$")
trigger.add("get_knowledge", "get_knowledge()", "信息采集", {Enable=false}, 5, "^┌\\s+\\S+项知识\\s+[─]+┐$")
trigger.add("get_theory", "get_theory()", "信息采集", {Enable=false}, 5, "^┌\\s+\\S+种心法\\s+[─]+┐$")
trigger.add("get_method", "get_method()", "信息采集", {Enable=false}, 5, "^┌\\s+\\S+项技能\\s+[─]+┐$")
trigger.add("get_basic", "get_basic()", "信息采集", {Enable=false}, 5, "^┌\\s+\\S+套基本功\\s+[─]+┐$")
trigger.add("get_special", "get_special()", "信息采集", {Enable=false}, 5, "^┌\\s+\\S+套武技\\s+[─]+┐$")
trigger.add("get_knowledge_skills", "get_knowledge_skills(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=false}, 5, "^│　(\\S+) \\((\\S+)\\)\\s+- (\\S+)\\s+(\\d+)/\\s*(\\d+)│$")
trigger.add("get_theory_skills", "get_theory_skills(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=false}, 5, "^│　(\\S+) \\((\\S+)\\)\\s+- (\\S+)\\s+(\\d+)/\\s*(\\d+)│$")
trigger.add("get_method_skills", "get_method_skills(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=false}, 5, "^│　(\\S+) \\((\\S+)\\)\\s+- (\\S+)\\s+(\\d+)/\\s*(\\d+)│$")
trigger.add("get_basic_skills", "get_basic_skills(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=false}, 5, "^│　(\\S+) \\((\\S+)\\)\\s+- (\\S+)\\s+(\\d+)/\\s*(\\d+)│$")
trigger.add("get_special_skills", "get_special_skills(get_matches(1), get_matches(2), get_matches(3), get_matches(4), get_matches(5))", "信息采集", {Enable=false}, 5, "^│(?:　|□)(\\S+) \\((\\S+)\\)\\s+- (\\S+)\\s+(\\d+)/\\s*(\\d+)│$")
trigger.add("get_skills_end", "get_skills_end()", "信息采集", {Enable=false}, 5, "^> $")
trigger.add("get_enables", "get_enables()", "信息采集", {Enable=true}, 5, "^以下是你目前使用中的特殊技能。$")
trigger.add("get_enable_skills", "get_enable_skills(get_matches(1), get_matches(2), get_matches(3))", "信息采集", {Enable=false}, 5, "^\\s+\\S+ \\((\\w+)\\)\\s+： (\\S+)\\s+有效等级：\\s*(\\d+)$")
trigger.add("get_prepares", "get_prepares()", "信息采集", {Enable=true}, 5, "^以下是你目前组合中的特殊拳术技能。$")
trigger.add("get_prepare_skills", "get_prepare_skills(get_matches(1), get_matches(2))", "信息采集", {Enable=false}, 5, "^\\S+ \\((\\w+)\\)\\s+(\\S+)$")
trigger.add("change_enable", "change_enable(get_matches(1), get_matches(2))", "信息采集", {Enable=true}, 5, "^你从现在起用(\\S+)作为基本(\\S+)的特殊技能。$")
trigger.add("no_prepare", "skills.prepare = {}", "信息采集", {Enable=true}, 5, "^你现在没有组合任何特殊拳术技能。$|^取消全部技能准备。$")
trigger.add("skill_upgrade", "skill_upgrade(get_matches(1))", "信息采集", {Enable=true}, 5, "^你的「(\\S+)」进步了！$")
trigger.add("login", "login()", "信息采集", {Enable=true, StopEval=true}, 6, "^您目前的权限是：.*，您设定为.*显示。$|^重新连线完毕。$")
trigger.add("get_carryon_item_end", "get_carryon_item_end()", "信息采集", {Enable=false, Gag=true, StopEval=true}, 6, "^> $")
trigger.add("get_container_end", "get_container_end()", "信息采集", {Enable=false}, 7, "^> $")

function get_room_name(name)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_room_name ］参数：name = "..tostring(name))
    trigger.enable("get_room_end")
    trigger.enable("get_room_desc")
    trigger.enable("get_room_objs")
    env.room.name = name
    env.room.desc = {}
    env.room.exits = ""
    env.room.objs = {}
    env.room.id = {}
    env.room.zone = {}
end

function get_room_desc(desc)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_room_desc ］参数：desc = "..tostring(desc))
    desc = string.trim(desc)
    desc = skip_info[desc] or desc
    set.append(env.room.desc, desc)
end

function get_room_exits(exits)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_room_exits ］参数：exits = "..tostring(exits))
    trigger.disable("get_room_desc")
    if exits == "" or exits == false then
        exits = {}
    end
    env.room.exits = exits
end

function get_room_objs(obj)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_room_objs ］参数：obj = "..tostring(obj))
    trigger.disable("get_room_desc")
    set.append(env.room.objs, obj)
end

function get_room_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_room_end ］")
    trigger.disable("get_room_end")
    trigger.disable("get_room_desc")
    trigger.disable("get_room_objs")
end

function get_room_abst(name, exits)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_room_abst ］参数：name = "..tostring(name)..", exits = "..tostring(exits))
    trigger.enable("get_room_end")
    trigger.enable("get_room_objs")
    env.room.name = name
    env.room.exits = exits
    env.room.desc = {}
    env.room.objs = {}
    env.room.id = {}
    env.room.zone = {}
end

function weather_before_dawn()
    trigger.disable("get_room_desc")
    env.weather_time = "凌晨"
    map_adjust("北京城门", "开放", "泉州新门", "关闭")
end

function time_before_dawn()
    env.weather_time = "凌晨"
    map_adjust("泉州新门", "关闭")
    timer.add(nil, 10, "map_adjust('北京城门', '开放')", nil, {Enable=true, OneShot=true})
end

function weather_early_morning()
    trigger.disable("get_room_desc")
    env.weather_time = "早晨"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function time_early_morning()
    env.weather_time = "早晨"
    map_adjust("北京城门", "开放")
    timer.add(nil, 10, "map_adjust('泉州新门', '开放')", nil, {Enable=true, OneShot=true})
end

function weather_morning()
    trigger.disable("get_room_desc")
    env.weather_time = "上午"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function time_morning()
    env.weather_time = "上午"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function weather_noon()
    trigger.disable("get_room_desc")
    env.weather_time = "正午"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function time_noon()
    env.weather_time = "正午"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function weather_afternoon()
    trigger.disable("get_room_desc")
    env.weather_time = "下午"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function time_afternoon()
    env.weather_time = "下午"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function weather_evening()
    trigger.disable("get_room_desc")
    env.weather_time = "傍晚"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
    map_attr.cost["west53"] = 10000
end

function time_evening()
    env.weather_time = "傍晚"
    map_adjust("北京城门", "开放", "泉州新门", "开放")
end

function weather_night()
    trigger.disable("get_room_desc")
    env.weather_time = "夜晚"
    map_adjust("北京城门", "关闭", "泉州新门", "关闭")
end

function time_night()
    env.weather_time = "夜晚"
    timer.add(nil, 10, "map_adjust('北京城门', '关闭', '泉州新门', '关闭')", nil, {Enable=true, OneShot=true})
end

function weather_mid_night()
    trigger.disable("get_room_desc")
    env.weather_time = "午夜"
    map_adjust("北京城门", "关闭", "泉州新门", "关闭")
end

function time_mid_night()
    env.weather_time = "午夜"
    map_adjust("北京城门", "关闭", "泉州新门", "关闭")
end

function get_port(port)
    local zone = {
        ["舟山"]   = "嘉兴",
        ["塘沽口"] = "关外长白山",
        ["安海港"] = "福建泉州",
        ["永宁港"] = "福建泉州",
        ["桃花岛"] = "东海桃花岛",
        ["神龙岛"] = "辽东神龙岛",
        ["冰火岛"] = "海外冰火岛",
        ["灵蛇岛"] = "东海灵蛇岛",
        ["王盘山"] = "海外"
    }
    env.current.exits = { "out" }
    env.current.zone = {zone[port]}
end

-- 人物信息
--[[
============================================================ 人物信息采集 ============================================================
变量定义：
    profile.name         名字      |  profile.family     门派      |  profile.contribute    江湖贡献
    profile.id           ID        |  profile.master     师父      |  profile.pot      存储潜能
    profile.sex          性别      |  profile.spouse     配偶      |  profile.death         死亡次数
    profile.title        头衔      |  profile.mole       神        |  profile.kill          杀人数量
    profile.year     年龄岁数  |  profile.level      等级上限  |  profile.energy        加精最大值
    profile.month    年龄月份  |  profile.balance    账户存款  |  profile.power         加力最大值
    profile.weight       体重      |  profile.online     在线时间  |

    profile.talent.str       后天臂力  |  profile.talent.con       后天根骨
    profile.talent.str_in    先天臂力  |  profile.talent.con_in    先天根骨
    profile.talent.int       后天悟性  |  profile.talent.dex       后天身法
    profile.talent.int_in    先天悟性  |  profile.talent.dex_in    先天身法

    state.js        当前精神        |  state.qx        当前气血        |  state.food         当前食物
    state.js_max    最大精神        |  state.qx_max    最大气血        |  state.food_max     最大食物
    state.js_pct    最大精神百分比   |  state.qx_pct    最大气血百分比   |  state.drink        当前饮水
    state.jl        当前精力        |  state.nl        当前内力        |  state.drink_max    最大饮水
    state.jl_max    最大精力        |  state.nl_max    最大内力        |  state.pot          当前潜能
    state.energy    当前加精        |  state.power     当前加力        |  state.pot_max      最大潜能
    state.exp       当前经验        |  state.buff      当前增益        |  state.debuff       当前减益
======================================================================================================================================
--]]

profile = {
    name = "", id = "", sex = "", year = "", month = "", title = "", activity = "",
    weight = 0, balance = 0, mole = 0, level = 0, contribute = 0, pot = 0, dazuo = 10,
    family = "", master = "", spouse = "", death = 0, kill = 0, energy = 0, power = 0,
    online = {year = 1970, month = 0, day = 0, hour = 0, minute = 0, second = 0},
    state = {}, talent = {}, drug = {}
}
profile.talent = {
    str = 0, str_in = 0, int = 0, int_in = 0,
    con = 0, con_in = 0, dex = 0, dex_in = 0,
    app = 0, app_in = 0, luc = 0, luc_in = 0
}
state = {
    js = 0, js_max = 0, js_pct = 0, jl = 0, jl_max = 0, energy = 1,
    qx = 0, qx_max = 0, qx_pct = 0, nl = 0, nl_max = 0, power = 0,
    food = 0, food_max = 0, pot = 0, pot_max = 0,
    drink = 0, drink_max = 0, exp = 0, buff = {}
}

function get_state_l1(js, js_max, js_pct, jl, jl_max, energy)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_state_l1 ］参数：js = "..tostring(js)..", js_max = "..tostring(js_max)..", js_pct = "..tostring(js_pct)..", jl = "..tostring(jl)..", jl_max = "..tostring(jl_max)..", energy = "..tostring(energy))
    state.js = tonumber(js)
    state.js_max = tonumber(js_max)
    state.js_pct = tonumber(js_pct)
    state.jl = tonumber(jl)
    state.jl_max = tonumber(jl_max)
    state.energy = tonumber(energy)
    if state.energy > (profile.energy or 0) then
        profile.energy = state.energy
    end
end

function get_state_l2(qx, qx_max, qx_pct, nl, nl_max, power)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_state_l2 ］参数：qx = "..tostring(qx)..", qx_max = "..tostring(qx_max)..", qx_pct = "..tostring(qx_pct)..", nl = "..tostring(nl)..", nl_max = "..tostring(nl_max)..", power = "..tostring(power))
    state.qx = tonumber(qx)
    state.qx_max = tonumber(qx_max)
    state.qx_pct = tonumber(qx_pct)
    state.nl = tonumber(nl)
    state.nl_max = tonumber(nl_max)
    state.power = tonumber(power)
    if state.power > (profile.power or 0) then
        profile.power = state.power
    end
end

function get_state_l3(food, food_max, pot, pot_max)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_state_l3 ］参数：food = "..tostring(food)..", food_max = "..tostring(food_max)..", pot = "..tostring(pot)..", pot_max = "..tostring(pot_max))
    state.food = tonumber(food)
    state.food_max = tonumber(food_max)
    state.pot = tonumber(pot)
    state.pot_max = tonumber(pot_max)
end

function get_state_l4(drink, drink_max, exp)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_state_l4 ］参数：drink = "..tostring(drink)..", drink_max = "..tostring(drink_max)..", exp = "..tostring(exp))
    state.drink = tonumber(drink)
    state.drink_max = tonumber(drink_max)
    state.exp = tonumber(exp)
end

function get_profile_l1(name, str, str_in, int, int_in)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l1 ］参数：name = "..tostring(name)..", str = "..tostring(str)..", str_in = "..tostring(str_in)..", int = "..tostring(int)..", int_in = "..tostring(int_in))
    profile.name = name
    profile.talent.str = tonumber(str)
    profile.talent.str_in = tonumber(str_in)
    profile.talent.int = tonumber(int)
    profile.talent.int_in = tonumber(int_in)
    if profile.talent.str_in < 35 then
        map_adjust("古墓入口", "禁用")
    else
        map_adjust("古墓入口", "启用")
    end
end

function get_profile_l2(id, con, con_in, dex, dex_in)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l2 ］参数：id = "..tostring(id)..", con = "..tostring(con)..", con_in = "..tostring(con_in)..", dex = "..tostring(dex)..", dex_in = "..tostring(dex_in))
    profile.id = id
    profile.talent.con = tonumber(con)
    profile.talent.con_in = tonumber(con_in)
    profile.talent.dex = tonumber(dex)
    profile.talent.dex_in = tonumber(dex_in)
end

function get_profile_l3(sex, app, app_in, luc, luc_in)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l3 ］参数：sex = "..tostring(sex)..", app = "..tostring(app)..", app_in = "..tostring(app_in)..", luc = "..tostring(luc)..", luc_in = "..tostring(luc_in))
    profile.sex = sex
    profile.talent.app = tonumber(app)
    profile.talent.app_in = tonumber(app_in)
    profile.talent.luc = tonumber(luc)
    profile.talent.luc_in = tonumber(luc_in)
    map_adjust("性别", profile.sex)
end

function get_profile_l4(year, month, food)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l4 ］参数：year = "..tostring(year)..", month = "..tostring(month)..", food = "..tostring(food))
    profile.year = chs2num(year)
    profile.month = chs2num(month)
    state.food = tonumber(food)
end

function get_profile_l5(title, drink)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l5 ］参数：title = "..tostring(title)..", drink = "..tostring(drink))
    profile.title = title
    state.drink = tonumber(drink)
end

function get_profile_l6(weight, balance, change)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l6 ］参数：weight = "..tostring(weight)..", balance = "..tostring(balance)..", change = "..tostring(change))
    profile.weight = chs2num(weight)
    if change == "很少" then
        if profile.balance == 0 or profile.balance >= 10000 then
            profile.balance = 9900
        end
    else
        profile.balance = (chs2num(balance) or 0) * 10000
    end
    if profile.weight > 133 then
        map_adjust("黑龙江栈道", "禁用")
    else
        map_adjust("黑龙江栈道", "启用")
    end
end

function get_profile_l7(online)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l7 ］参数：online = "..tostring(online))
    profile.online = online
end

function get_profile_l8(mole_type, mole, expadd)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l8 ］参数：mole_type = "..tostring(mole_type)..", mole = "..tostring(mole)..", expadd = "..tostring(expadd))
    profile.mole = tonumber(mole)
    profile.expadd = tonumber(expadd) or 0
    if mole_type == "妖魔孽气" then
        profile.mole = profile.mole * -1
    end
end

function get_profile_l9(exp, level, expgap)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l9 ］参数：exp = "..tostring(exp)..", level = "..tostring(level)..", expgap = "..tostring(expgap))
    state.exp = tonumber((string.gsub(exp, ",", "")))
    profile.level = tonumber(level)
    profile.expgap = tonumber(expgap)
end

function get_profile_l10(contribute, pot, spot)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l10 ］参数：contribute = "..tostring(contribute)..", pot = "..tostring(pot)..", spot = "..tostring(spot))
    profile.contribute = tonumber(contribute)
    state.pot = tonumber(pot)
    profile.pot = chs2num(spot)
end

function get_profile_l11(spouse, death)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l11 ］参数：spouse = "..tostring(spouse)..", death = "..tostring(death))
    profile.spouse = spouse
    profile.death = tonumber(death)
end

function get_profile_l12(family, kill)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l12 ］参数：family = "..tostring(family)..", kill = "..tostring(kill))
    profile.family = family
    profile.kill = tonumber(kill)
    if profile.family == "少林派" and not set.has({"小沙弥", "僧　人", "神　僧", "长　老"}, profile.title) then
        map_adjust("门派", "少林俗家")
    else
        map_adjust("门派", profile.family)
    end
end

function get_profile_l13(master)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_profile_l13 ］参数：master = "..tostring(master))
    profile.master = master
    map_adjust("师父", profile.master)
end

function get_longxiang_level(level)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_longxiang_level ］参数：level = "..tostring(level))
    profile.longxiang.level = chs2num(level)
    if profile.longxiang.level > 10 then
        if timer.is_exist("longxiang_pozhang_cd") == true then
            timer.add("longxiang_pozhang_cd", (10800 - timer.remain("longxiang_pozhang_cd")), "longxiang_pozhang_active()", "longxiang_pozhang", {Enable=true, OneShot=true})
        end
        profile.longxiang.cd = 10800
    else
        profile.longxiang.cd = 3600
    end
end

function get_longxiang_status(progress, need)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_longxiang_status ］参数：progress = "..tostring(progress)..", need = "..tostring(need))
    profile.longxiang.progress = tonumber(progress)
    profile.longxiang.target = profile.longxiang.progress + tonumber(need)
    if profile.longxiang.level == nil then
        local level_progress = {
            ["32"]    = 1,
            ["162"]   = 2,
            ["512"]   = 3,
            ["1250"]  = 4,
            ["2592"]  = 5,
            ["4802"]  = 6,
            ["8192"]  = 7,
            ["13122"] = 8,
            ["20000"] = 9,
            ["43923"] = 10,
            ["62208"] = 11,
            ["85683"] = 12,
            ["115248"] = 13
        }
        profile.longxiang.level = level_progress[tostring(profile.longxiang.target)]
        if profile.longxiang.level > 10 then
            if timer.is_exist("longxiang_pozhang_cd") == true then
                timer.add("longxiang_pozhang_cd", (10800 - timer.remain("longxiang_pozhang_cd")), "longxiang_pozhang_active()", "longxiang_pozhang", {Enable=true, OneShot=true})
            end
            profile.longxiang.cd = 10800
            trigger.delete("get_longxiang_level")
        end
    end
    if profile.longxiang.progress >= profile.longxiang.target then
        trigger.delete("get_longxiang_progress")
        trigger.delete("get_longxiang_pozhang")
        if timer.is_exist("longxiang_pozhang_cd") == false then
            config.jobs["龙象破障"].active = true
        end
    else
        timer.delete("longxiang_pozhang_cd")
        config.jobs["龙象破障"].active = false
    end
end

function get_longxiang_progress()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_longxiang_progress ］")
    profile.longxiang.progress = profile.longxiang.progress + 1
    if profile.longxiang.progress == profile.longxiang.target then
        trigger.delete("get_longxiang_progress")
        trigger.delete("get_longxiang_pozhang")
        if trigger.is_exist("longxiang_pozhang_cd") == false then
            config.jobs["龙象破障"].active = true
        end
    end
end

function get_longxiang_pozhang()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_longxiang_pozhang ］")
    profile.longxiang.progress = (profile.longxiang.target or 0)
    trigger.delete("get_longxiang_progress")
    if trigger.is_exist("longxiang_pozhang_cd") == false then
        config.jobs["龙象破障"].active = true
    end
end

-- 物品信息
carryon = {count = 0, weight = 0, money = 0, inventory = {}, container = {}, repository = {}, weapon = {}}
carryon.weapon = {name = "",wield = "0", unwield = "0"}
carryon.wield = {"", ""}

function get_carryon_empty()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_empty ］")
    carryon.count = 0
    carryon.weight = 0
    carryon.money = 0
    carryon.inventory = {}
    carryon.container = {}
end

function get_carryon_summary(count, weight)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_summary ］参数：count = "..tostring(count)..", weight = "..tostring(weight))
    trigger.enable("get_carryon_item")
    trigger.enable("get_carryon_item_end")
    trigger.enable("get_carryon_wield")
    trigger.enable("get_carryon_detail")
    var.wield = {}
    carryon.count = chs2num(count)
    carryon.weight = chs2num(weight)
    carryon.money = 0
    carryon.inventory = {}
    carryon.container = {}
    run("id")
end

function get_carryon_item(item)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_item ］参数：item = "..tostring(item))
    local count, name, id
    count,item,name,id = obj_analysis(item)
    carryon.inventory[item] = carryon.inventory[item] or {name = name, id = id, count = 0, seq = {}}
    carryon.inventory[item].count  = carryon.inventory[item].count + count
end

function get_carryon_item_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_item_end ］")
    trigger.disable("get_carryon_item")
    trigger.disable("get_carryon_item_end")
    trigger.disable("get_carryon_wield")
    trigger.enable("hide_carryon")
    if #var.wield == 0 then
        carryon.wield = {"", ""}
    elseif #var.wield == 1 then
        carryon.wield = {var.wield[1], ""}
    else
        if set.eq(carryon.wield, var.wield) == false then
            carryon.wield = {"未知", "未知"}
        end
    end
    var.wield = nil
    carryon.money = ((carryon.inventory["黄金:gold"] or {}).count or 0) * 10000 +
                    ((carryon.inventory["白银:silver"] or {}).count or 0) * 100 +
                    ((carryon.inventory["铜钱:coin"] or {}).count or 0)
end

function get_carryon_wield(name, id)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_wield ］参数：name = "..tostring(name)..", id = "..tostring(id))
    local weapon = name..":"..string.lower(id)
    if items[weapon] ~= nil and items[weapon].group == "weapon" then
        set.append(var.wield, weapon)
    end
end

function get_carryon_detail()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_detail ］")
    trigger.enable("get_carryon_list")
    trigger.enable("get_carryon_list_end")
    trigger.add("get_carryon_end", "get_carryon_end()", "信息采集", {Enable=true, OneShot=true, Gag=true, StopEval=true}, 6, "^> $")
    var.item = {}
end

function get_carryon_list(name, ids)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_list ］参数：name = "..tostring(name)..", ids = "..tostring(ids))
    set.append(var.item, {name = name, ids = string.split(string.lower(ids), ", ")})
end

function get_carryon_list_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_list_end ］")
    trigger.disable("get_carryon_detail")
    trigger.disable("get_carryon_list")
    trigger.disable("get_carryon_list_end")
    local ids = {}
    var.container = {}
    for i = #var.item, 1, -1 do
        for _,v in ipairs(var.item[i].ids) do
            ids[v] = (ids[v] or 0) + 1
        end
        local item = var.item[i].name..":"..var.item[i].ids[1]
        set.append(carryon.inventory[item].seq, tostring(ids[var.item[i].ids[1]]))
        if set.has(containers, var.item[i].name) == true then
            set.append(var.container, carryon.inventory[item].id.." "..set.last(carryon.inventory[item].seq))
        end
    end
    var.item = nil
    trigger.enable("get_item_container")
    trigger.enable("get_water_container")
    trigger.enable("get_container_end")
    look_container()
end

function look_container()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ look_container ］")
    if #var.container == 0 then
        trigger.disable("get_container_end")
        trigger.disable("get_item_container")
        trigger.disable("get_water_container")
        trigger.disable("hide_carryon")
        trigger.delete("get_carryon_end")
        var.container = nil
        if carryon.inventory["饱腹玉:baofu yu"] ~= nil then
            map_adjust("南疆沙漠", "开放")
        else
            map_adjust("南疆沙漠", "关闭")
        end
        if var.unpack ~= nil then
            run(set.concat(var.unpack, ";"))
            var.unpack = nil
        end
        if true then
            return -1
        end
    else
        carryon.container[set.last(var.container)] = {water = false, stage = 0}
        run("look "..set.last(var.container))
    end
end

function get_container_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_container_end ］")
    set.pop(var.container)
    look_container()
end

function get_item_container(contents)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_item_container ］参数：contents = "..tostring(contents))
    local count,_,name,id = obj_analysis(contents)
    local item = name..":"..id
    carryon.container[set.last(var.container)].water = nil
    carryon.container[set.last(var.container)].stage = nil
    if set.has({"gold", "silver", "coin"}, id) then
        var.unpack = var.unpack or {}
        set.append(var.unpack, "get "..id.." from "..set.last(var.container))
    elseif set.has({"tie bagua", "baofu yu"}, id) then
        if carryon.inventory[item] == nil then
            carryon.inventory[item] = {name = name, id =id, count = 1, seq = {"1"}}
        else
            carryon.inventory[item].count = carryon.inventory[item].count + count
            set.append(carryon.inventory[item].seq, tostring(carryon.inventory[item].count))
        end
        var.unpack = var.unpack or {}
        set.append(var.unpack, "get "..id.." from "..set.last(var.container))
    else
        carryon.container[set.last(var.container)][item] = carryon.container[set.last(var.container)][item] or {name = name, id =id, count = 0}
        carryon.container[set.last(var.container)][item].count = carryon.container[set.last(var.container)][item].count + count
    end
end

function get_water_container(stage, solid)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_water_container ］参数：stage = "..tostring(stage)..", solid = "..tostring(solid))
    local stage_sample = {
        ["满了"] = 10,
        ["了七、八分满的"] = 5,
        ["了五、六分满的"] = 3,
        ["了少许的"] = 1,
    }
    local solid_sample = {
        ["水"] = true,
        ["野菜汤"] = true
    }
    carryon.container[set.last(var.container)].water = solid_sample[solid] or false
    carryon.container[set.last(var.container)].stage = stage_sample[stage] or 0
end

function get_carryon_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_carryon_end ］")
    trigger.add("get_carryon_end", "", "信息采集", {Enable=true, Gag=true, StopEval=true}, 8, "^> $")
end

function update_coin(coin)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ update_coin ］参数：coin = "..tostring(coin))
    local money = chs2num(coin)
    carryon.money = carryon.money + money
    carryon.inventory["铜钱:coin"] = carryon.inventory["铜钱:coin"] or {name = "铜钱", id = "coin", count = 0, seq = {"1"}}
    carryon.inventory["铜钱:coin"].count = math.max(carryon.inventory["铜钱:coin"].count + money, 0)
    if carryon.inventory["铜钱:coin"].count == 0 then
        carryon.inventory["铜钱:coin"] = nil
    end
end

function update_silver(silver)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ update_silver ］参数：silver = "..tostring(silver))
    local money = chs2num(silver)
    carryon.money = carryon.money + (money * 100)
    carryon.inventory["白银:silver"] = carryon.inventory["白银:silver"] or {name = "白银", id = "silver", count = 0, seq = {"1"}}
    carryon.inventory["白银:silver"].count = math.max(carryon.inventory["白银:silver"].count + money, 0)
    if carryon.inventory["白银:silver"].count == 0 then
        carryon.inventory["白银:silver"] = nil
    end
end

function update_gold(gold)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ update_gold ］参数：gold = "..tostring(gold))
    local money = chs2num(gold)
    carryon.money = carryon.money + (money * 10000)
    carryon.inventory["黄金:gold"] = carryon.inventory["黄金:gold"] or {name = "黄金", id = "gold", count = 0, seq = {"1"}}
    carryon.inventory["黄金:gold"].count = math.max(carryon.inventory["黄金:gold"].count + money, 0)
    if carryon.inventory["黄金:gold"].count == 0 then
        carryon.inventory["黄金:gold"] = nil
    end
end

function convert_currency(src_money, src_currency, dst_money, dst_currency)
    local item = {["铜钱"] = "铜钱:coin", ["白银"] = "白银:silver", ["黄金"] = "黄金:gold"}
    carryon.inventory[item[src_currency]] = carryon.inventory[item[src_currency]] or { name = src_currency, id = string.split(item[src_currency], ":")[2], count = 0, seq = {"1"} }
    carryon.inventory[item[src_currency]].count = math.max(0, carryon.inventory[item[src_currency]].count - chs2num(src_money))
    carryon.inventory[item[dst_currency]] = carryon.inventory[item[dst_currency]] or { name = dst_currency, id = string.split(item[dst_currency], ":")[2], count = 0, seq = {"1"} }
    carryon.inventory[item[dst_currency]].count = math.max(0, carryon.inventory[item[dst_currency]].count - chs2num(dst_money))
    if carryon.inventory[item[src_currency]].count == 0 then
        carryon.inventory[item[src_currency]] = nil
    end
    if carryon.inventory[item[dst_currency]].count == 0 then
        carryon.inventory[item[dst_currency]] = nil
    end
end

function get_personal_weapon_name(name)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_personal_weapon_name ］参数：name = "..tostring(name))
    name = string.gsub(name, "%$%u+%$?", "")
    local weapon_type = {
        ["斧"] = "axe",
        ["枪"] = "pike",
        ["钩"] = "hook",
        ["鞭"] = "whip",
        ["棍"] = "club",
        ["剑"] = "sword",
        ["刀"] = "blade",
        ["棒"] = "stick",
        ["锤"] = "hammer",
        ["笔"] = "stroke",
        ["杖"] = "staff"
    }
    if carryon.weapon.name ~= name then
        carryon.weapon.name = name
        for k,v in pairs(weapon_type) do
            items["自铸之"..k..":personal "..v].name = carryon.weapon.name
            items[carryon.weapon.name..":personal "..v] = items["自铸之"..k..":personal "..v]
            items["自铸之"..k..":personal "..v] = nil
            automation.items[carryon.weapon.name..":personal "..v] = items[carryon.weapon.name..":personal "..v]
        end
    end
end

function get_personal_weapon_wield_msg(msg)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_personal_weapon_wield_msg ］参数：msg = "..tostring(msg))
    carryon.weapon.wield = string.gsub(string.gsub(string.gsub(msg, "%$%u%u%u%$", ""), "%$N", "你"), "%$n", carryon.weapon.name)
end

function get_personal_weapon_unwield_msg(msg)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_personal_weapon_unwield_msg ］参数：msg = "..tostring(msg))
    carryon.weapon.unwield = string.gsub(string.gsub(string.gsub(msg, "%$%u%u%u%$", ""), "%$N", "你"), "%$n", carryon.weapon.name)
end

function get_repository()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_repository ］")
    trigger.enable("get_repository_list")
    trigger.enable("get_repository_end")
    carryon.repository = {}
end

function get_repository_list(index, name, count)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_repository_list ］参数：index = "..tostring(index)..", name = "..tostring(name)..", count = "..tostring(count))
    carryon.repository[name] = carryon.repository[name] or {index = {}, count = 0}
    set.append(carryon.repository[name].index, index)
    carryon.repository[name].count = carryon.repository[name].count + tonumber(count)
end

function get_repository_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_repository_end ］")
    trigger.disable("get_repository_list")
    trigger.disable("get_repository_end")
    if carryon.repository["《玄门内功心法》"] ~= nil then
        if items["《玄门内功心法》:xuanmen xinfa"].get[1] ~= "qu" then
            set.insert(items["《玄门内功心法》:xuanmen xinfa"].price, 1, 0)
            set.insert(items["《玄门内功心法》:xuanmen xinfa"].place, 1, 290)
            set.insert(items["《玄门内功心法》:xuanmen xinfa"].get, 1, "qu")
            automation.items["《玄门内功心法》:xuanmen xinfa"] = items["《玄门内功心法》:xuanmen xinfa"]
        end
    elseif items["《玄门内功心法》:xuanmen xinfa"].get[1] == "qu" then
        set.remove(items["《玄门内功心法》:xuanmen xinfa"].price, 1)
        set.remove(items["《玄门内功心法》:xuanmen xinfa"].place, 1)
        set.remove(items["《玄门内功心法》:xuanmen xinfa"].get, 1)
        automation.items["《玄门内功心法》:xuanmen xinfa"] = nil
    end
    if carryon.repository["铁八卦"] ~= nil then
        if items["铁八卦:tie bagua"].get[1] ~= "qu" then
            set.insert(items["铁八卦:tie bagua"].price, 1, 0)
            set.insert(items["铁八卦:tie bagua"].place, 1, 290)
            set.insert(items["铁八卦:tie bagua"].get, 1, "qu")
            automation.items["铁八卦:tie bagua"] = items["铁八卦:tie bagua"]
        end
    elseif items["铁八卦:tie bagua"].get[1] == "qu" then
        set.remove(items["铁八卦:tie bagua"].price, 1)
        set.remove(items["铁八卦:tie bagua"].place, 1)
        set.remove(items["铁八卦:tie bagua"].get, 1)
        automation.items["铁八卦:tie bagua"] = nil
    end
    for _,v in ipairs({"《持世陀罗尼经》:shu", "纯阳神通功秘诀:shentong mijue", "百战余生:baizhan yusheng", "鸠摩智的武学笔记:wuxue biji",
                       "饱腹玉:baofu yu", "炼心石:lianxin shi",
                       "百草丹:baicao dan", "九花玉露丸:yulu wan", "续命八丹:xuming badan", "养精丹:yangjing dan",
                       "首乌精:shouwu jing", "大血藤:da xueteng", "气血丹药:qixue danyao", "精神丹药:jingshen danyao", "精力丹药:jingli danyao", }) do
        if carryon.repository[items[v].name] ~= nil then
            if set.last(items[v].get) ~= "qu" then
                set.append(items[v].price, 0)
                set.append(items[v].place, 290)
                set.append(items[v].get, "qu")
                automation.items[v] = items[v]
            end
        elseif set.last(items[v].get) == "qu" then
            set.pop(items[v].price)
            set.pop(items[v].place)
            set.pop(items[v].get)
            automation.items[v] = nil
        end
    end
end

-- 技能信息
skills = {theory = {}, knowledge = {}, method = {}, basic = {}, special = {}, enable = {}, prepare = {}, id = {}}

function get_skills()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_skills ］")
    trigger.enable("get_knowledge")
    trigger.enable("get_theory")
    trigger.enable("get_basic")
    trigger.enable("get_method")
    trigger.enable("get_special")
    trigger.enable("get_skills_end")
    skills.theory = {}
    skills.knowledge = {}
    skills.method = {}
    skills.basic = {}
    skills.special = {}
end

function get_knowledge()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_knowledge ］")
    trigger.enable("get_knowledge_skills")
    trigger.disable("get_theory_skills")
    trigger.disable("get_method_skills")
    trigger.disable("get_basic_skills")
    trigger.disable("get_special_skills")
end

function get_theory()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_theory ］")
    trigger.enable("get_theory_skills")
    trigger.disable("get_knowledge_skills")
    trigger.disable("get_method_skills")
    trigger.disable("get_basic_skills")
    trigger.disable("get_special_skills")
end

function get_method()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_method ］")
    trigger.enable("get_method_skills")
    trigger.disable("get_theory_skills")
    trigger.disable("get_knowledge_skills")
    trigger.disable("get_basic_skills")
    trigger.disable("get_special_skills")
end

function get_basic()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_basic ］")
    trigger.enable("get_basic_skills")
    trigger.disable("get_knowledge_skills")
    trigger.disable("get_method_skills")
    trigger.disable("get_theory_skills")
    trigger.disable("get_special_skills")
end

function get_special()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_special ］")
    trigger.enable("get_special_skills")
    trigger.disable("get_knowledge_skills")
    trigger.disable("get_method_skills")
    trigger.disable("get_theory_skills")
    trigger.disable("get_basic_skills")
end

function get_knowledge_skills(name, id, desc, level, prof)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_knowledge_skills ］参数：name = "..tostring(name)..", id = "..tostring(id)..", desc = "..tostring(desc)..", level = "..tostring(level)..", prof = "..tostring(prof))
    skills.knowledge[id] = {
        name = name,
        desc = desc,
        level = tonumber(level),
        prof = tonumber(prof)
    }
    skills.id[name] = id
end

function get_theory_skills(name, id, desc, level, prof)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_theory_skills ］参数：name = "..tostring(name)..", id = "..tostring(id)..", desc = "..tostring(desc)..", level = "..tostring(level)..", prof = "..tostring(prof))
    skills.theory[id] = {
        name = name,
        desc = desc,
        level = tonumber(level),
        prof = tonumber(prof)
    }
    skills.id[name] = id
    if skills.theory["lamaism"] and skills.theory["lamaism"].level >= 150 then
        map_adjust("天龙殿壁画", "启用")
    else
        map_adjust("天龙殿壁画", "禁用")
    end
end

function get_method_skills(name, id, desc, level, prof)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_method_skills ］参数：name = "..tostring(name)..", id = "..tostring(id)..", desc = "..tostring(desc)..", level = "..tostring(level)..", prof = "..tostring(prof))
    skills.method[id] = {
        name = name,
        desc = desc,
        level = tonumber(level),
        prof = tonumber(prof)
    }
    skills.id[name] = id
    if skills.method["swimming"] and skills.method["swimming"].level >= 10 then
        map_adjust("古墓水道", "启用")
    else
        map_adjust("古墓水道", "禁用")
    end
end

function get_basic_skills(name, id, desc, level, prof)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_basic_skills ］参数：name = "..tostring(name)..", id = "..tostring(id)..", desc = "..tostring(desc)..", level = "..tostring(level)..", prof = "..tostring(prof))
    skills.basic[id] = {
        name = name,
        desc = desc,
        level = tonumber(level),
        prof = tonumber(prof)
    }
    skills.id[name] = id
    if profile.family == "华山派" and
       skills.basic["dodge"] and skills.basic["dodge"].level >= 100 then
        map_adjust("华山悬崖", "开放")
    else
        map_adjust("华山悬崖", "关闭")
    end
end

function get_special_skills(name, id, desc, level, prof)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_special_skills ］参数：name = "..tostring(name)..", id = "..tostring(id)..", desc = "..tostring(desc)..", level = "..tostring(level)..", prof = "..tostring(prof))
    skills.special[id] = {
        name = name,
        desc = desc,
        level = tonumber(level),
        prof = tonumber(prof)
    }
    skills.id[name] = id
    if skills.special["murong-shenfa"] ~= nil and 
       skills.special["murong-shenfa"].level >= 120 and 
       skills.special["douzhuan-xingyi"] ~= nil and 
       skills.special["douzhuan-xingyi"].level >= 120 then
        map_adjust("燕子坞", "轻功")
    else
        map_adjust("燕子坞", "客船")
    end
    if skills.special["jinshe-jianfa"] ~= nil then
        map_adjust("金蛇密洞", "开放")
    else
        map_adjust("金蛇密洞", "关闭")
    end
end

function get_skills_end()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_skills_end ］")
    trigger.disable("get_knowledge")
    trigger.disable("get_theory")
    trigger.disable("get_method")
    trigger.disable("get_basic")
    trigger.disable("get_special")
    trigger.disable("get_knowledge_skills")
    trigger.disable("get_theory_skills")
    trigger.disable("get_basic_skills")
    trigger.disable("get_special_skills")
    trigger.disable("get_skills_end")
end

function get_enables()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_enables ］")
    trigger.enable("get_enable_skills")
    trigger.add(nil, "trigger.disable('get_enable_skills')", "信息采集", {Enable=true, OneShot=true}, 6, "^> $")
    skills.enable = {}
end

function get_enable_skills(id, name, level)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_enable_skills ］参数：id = "..tostring(id)..", name = "..tostring(name)..", level = "..tostring(level))
    skills.enable[id] = {
        name = name,
        level = tonumber(level)
    }
    if id == "force" then
        profile.dazuo = math.modf(profile.talent.con_in * level / 100)
    end
    if id == "dodge" then
        if skills.enable[id].level >= 450 then
            map_adjust("北京城墙", "开放")
        else
            map_adjust("北京城墙", "关闭")
        end
        if skills.enable[id].level >= 120 then
            map_adjust("全真悬崖", "开放")
        else
            map_adjust("全真悬崖", "关闭")
        end
        if skills.enable[id].level >= 120 then
            map_adjust("灵鹫索桥", "启用")
        else
            map_adjust("灵鹫索桥", "禁用")
        end
    end
end

function get_prepares()
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_prepares ］")
    trigger.enable("get_prepare_skills")
    trigger.add(nil, "trigger.disable('get_prepare_skills')", "信息采集", {Enable=true, OneShot=true}, 6, "^> $")
    skills.prepare = {}
end

function get_prepare_skills(basic, special)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ get_prepare_skills ］参数：basic = "..tostring(basic)..", special = "..tostring(special))
    skills.prepare[basic] = special
end

function change_enable(special, basic)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ change_enable ］参数：special = "..tostring(special)..", basic = "..tostring(basic))
    basic = skills.id["基本"..basic]
    local special_id = skills.id[special]
    if basic ~= nil and special_id ~= nil then
        skills.enable[basic] = {name = special, level = math.modf(skills.basic[basic].level / 2) + skills.special[special_id].level}
        skills.prepare[basic] = nil
        if basic == "dodge" then
            if skills.enable["dodge"].level >= 450 then
                map_adjust("北京城墙", "开放")
            else
                map_adjust("北京城墙", "关闭")
            end
            if skills.enable["dodge"].level >= 120 then
                map_adjust("全真悬崖", "开放")
            else
                map_adjust("全真悬崖", "关闭")
            end
        end
    end
end

function skill_upgrade(skill)
    message("trace", debug.getinfo(1).source, debug.getinfo(1).currentline,
            "函数［ skill_upgrade ］参数：skill = "..tostring(skill))
    if string.match(skill, "基本") then
        local skill_id = skills.id[skill]
        if skill_id ~= nil then
            skills.basic[skill_id].level = skills.basic[skill_id].level + 1
            skills.basic[skill_id].prof = 0
            if skills.enable[skill_id] ~= nil then
                if skills.id[skills.enable[skill_id].name] ~= nil then
                    skills.enable[skill_id].level = math.modf(skills.basic[skill_id].level / 2) + skills.special[skills.id[skills.enable[skill_id].name]].level
                end
            end
            if profile.family == "华山派" and skill == "基本轻功" then
                if skills.basic["dodge"] and skills.basic["dodge"].level >= 100 then
                    map_adjust("华山悬崖", "开放")
                end
            end  
        end
    else
        local skill_id = skills.id[skill]
        if skills.special[skill_id] ~= nil then
            skills.special[skill_id].level = skills.special[skill_id].level + 1
            skills.special[skill_id].prof = 0
            for k,v in pairs(skills.enable) do
                if v.name == skill then
                    v.level = math.modf(skills.basic[k].level / 2) + skills.special[skill_id].level
                end
                if k == "dodge" then
                    if skills.enable["dodge"].level >= 450 then
                        map_adjust("北京城墙", "开放")
                    end
                    if skills.enable["dodge"].level >= 120 then
                        map_adjust("全真悬崖", "开放")
                    end
                end
            end 
            if skill == "慕容身法" and 
               skills.special["douzhuan-xingyi"] ~= nil and 
               skills.special["douzhuan-xingyi"].level >= 120 then
                if skills.special["murong-shenfa"].level >= 120 then
                    map_adjust("燕子坞", "轻功")
                end
            end
            if skill == "斗转星移" and 
               skills.special["murong-shenfa"] ~= nil and 
               skills.special["murong-shenfa"].level >= 120 then
                if skills.special["douzhuan-xingyi"].level >= 120 then
                    map_adjust("燕子坞", "轻功")
                end
            end
        elseif skills.theory[skill_id] ~= nil then
            skills.theory[skill_id].level = skills.theory[skill_id].level + 1
            skills.theory[skill_id].prof = 0
            if skills.theory["lamaism"] and skills.theory["lamaism"].level >= 150 then
                map_adjust("天龙殿壁画", "启用")
            end
        elseif skills.knowledge[skill_id] ~= nil then
            skills.knowledge[skill_id].level = skills.knowledge[skill_id].level + 1
            skills.knowledge[skill_id].prof = 0
        elseif skills.method[skill_id] ~= nil then
            skills.method[skill_id].level = skills.method[skill_id].level + 1
            skills.method[skill_id].prof = 0
            if skills.method["swimming"] and skills.method["swimming"].level >= 10 then
                map_adjust("古墓水道", "启用")
            end
        end
    end
end

-- 状态更新
local unknown_force_yun = {
    ["北冥神功"] = "beiming-shengong_shield",
    ["混天气功"] = "huntian-qigong_powerup",
    ["毒龙大法"] = "dulong-dafa_powerup",
    ["玄天无极"] = "xuantian-wuji_wuji",
    ["冷月神功"] = "lengyue-shengong_yue",
    ["沙场点兵"] = "shachang-dianbing_powerup"
}

function invalid_ask_ping()
    state.buff.ask_ping = false
    if not trigger.is_exist("invalid_ask_ping") then
        timer.add("invalid_ask_ping", 1800, "state.buff.ask_ping = nil", "state", {Enable=true, OneShot=true})
    end
end

function valid_force_yun()
    if unknown_force_yun[skills.enable.force.name] ~= nil then
        state.buff[unknown_force_yun[skills.enable.force.name]] = true
    end
end

function invalid_ask_yuluwan()
    if items["九花玉露丸:yulu wan"].place[1] == 1470 then
        set.remove(items["九花玉露丸:yulu wan"].price, 1)
        set.remove(items["九花玉露丸:yulu wan"].place, 1)
        set.remove(items["九花玉露丸:yulu wan"].get, 1)
    end
    timer.add("invalid_ask_yuluwan", 1800, "valid_ask_yuluwan()", "state", {Enable=true, OneShot=true})
end

function valid_ask_yuluwan()
    if profile.family == "桃花岛" then
        set.insert(items["九花玉露丸:yulu wan"].price, 1, 0)
        set.insert(items["九花玉露丸:yulu wan"].place, 1, 1470)
        set.insert(items["九花玉露丸:yulu wan"].get, 1, "ask lu chengfeng about 九花玉露丸")
    end
end

function invalid_fu_qixuedanyao()
    state.buff["气血丹药:qixue danyao"] = false
end

function invalid_fu_jingshendanyao()
    state.buff["精神丹药:jingshen danyao"] = false
end

function invalid_fu_yuluwan()
    state.buff["九花玉露丸:yulu wan"] = false
    timer.add("invalid_fu_yuluwan", 1800, "state.buff['九花玉露丸:yulu wan'] = true", "state", {Enable=true, OneShot=true})
end

function invalid_fu_sanhuangwan()
    state.buff["三黄宝蜡丸:sanhuang wan"] = false
    timer.add("invalid_fu_sanhuangwan", 1800, "state.buff['三黄宝蜡丸:sanhuang wan'] = true", "state", {Enable=true, OneShot=true})
end

function invalid_fu_daxueteng()
    state.buff["大血藤:da xueteng"] = false
    timer.add("invalid_fu_daxueteng", 1800, "state.buff['大血藤:da xueteng'] = true", "state", {Enable=true, OneShot=true})
end

function invalid_fu_renshenguo()
    state.buff["人参果:renshen guo"] = false
    timer.add("invalid_fu_renshenguo", 1800, "state.buff['人参果:renshen guo'] = true", "state", {Enable=true, OneShot=true})
end

function invalid_fu_xuelian()
    state.buff["雪莲:xuelian"] = false
    timer.add("invalid_fu_xuelian", 1800, "state.buff['雪莲:xuelian'] = true", "state", {Enable=true, OneShot=true})
end

show(string.format("%-.40s%-1s", "加载 "..string.match(debug.getinfo(1).source, "script/(.*lua)$").." ..............................", " 成功"), "chartreuse")