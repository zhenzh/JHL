function add_yun_desc(force_name, yun, valid_desc, invalid_desc)
    local valid_name,invalid_name = "valid_"..force_name.."_"..yun,"invalid_"..force_name.."_"..yun
    if is_trigger_exist(valid_name) or 
       is_trigger_exist(invalid_name) then
        show("该内功状态已存在描述记录", "orange")
    end
    local status_triggers = {}
    table.load(get_script_path().."game/status.lua", status_triggers)
    status_triggers[valid_name] = {'state.buff["'..force_name.."_"..yun..'"] = true', "状态记录", {Enable=true}, 1, valid_desc}
    status_triggers[invalid_name] = {'state.buff["'..force_name.."_"..yun..'"] = nil', "状态记录", {Enable=true}, 1, invalid_desc}
    add_trigger(valid_name, status_triggers[valid_name][1], status_triggers[valid_name][2], status_triggers[valid_name][3], status_triggers[valid_name][4], status_triggers[valid_name][5])
    add_trigger(invalid_name, status_triggers[invalid_name][1], status_triggers[invalid_name][2], status_triggers[invalid_name][3], status_triggers[invalid_name][4], status_triggers[invalid_name][5])
    if is_trigger_enable(valid_name) == true and 
       is_trigger_enable(invalid_name) == true then
        table.save(get_script_path().."game/status.lua", status_triggers)
        show("内功状态描述添加成功", "green")
    else
        del_trigger(valid_name)
        del_trigger(invalid_name)
        show("内功状态描述添加失败", "orange")
    end
    return nil
end