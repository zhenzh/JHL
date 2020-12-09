--[[
===============
  扩展表操作模块
===============
  table.index(t)                获取表 t 中所有数字类型的键，升序生成并返回该集合
  table.value(t)                获取表 t 中所有值，生成并返回该集合
  table.delete(t,o)             从表 t 中去除所有值等于 o 的元素，元素值 o 必须是数字或字符串
  table.extend(...)             向第一个表末尾追加后续若干个表所包含的元素，重复键只保留第一个出现时所对应的值
  table.copy(t)                 复制表 t 仅包括第一层键值对，不包括子表和元表，生成新的表
  table.equal(a,b)              比较表 a 与表 b 内的所有元素是否相等
  table.intersection(...)       获取并返回若干个表的交集
  table.union(...)              获取并返回若干个表的并集
  table.complement(t,...)       返回从第一个表 t 中去除后续若干个表所包含的元素后得到的新表
  table.tostring(t)             将表 t 转换成字符串
  table.print(t)                打印表 t
--]]

table = table or {}
local _union,_complement = table.union,table.complement

function table.index(t)
    local s = {}
    for k,_ in pairs(t) do
        if type(k) == "number" then
            set.append(s, k)
        end
    end
    table.sort(s)
    return s
end

function table.value(t)
    local s = {}
    for _,v in pairs(t) do
        set.append(s, v)
    end
    return s
end

function table.delete(t,o)
    for k,v in pairs(t) do
        if v == o then
            t[k] = nil
        end
    end
end

function table.extend(...)
    local function extend(a,b)
        for k,v in pairs(b) do
            if type(k) == "number" then
                set.append(a, v)
            elseif a[k] == nil then
                a[k] = v
            end
        end
    end
    local t = select(1, ...)
    for i = 2, select("#", ...) do
        extend(t, select(i, ...))
    end
end

function table.copy(t)
    local result = {}
    for k,v in pairs(t) do
        result[k] = v
    end
    return setmetatable(result, getmetatable(t))
end

function table.equal(a,b)
    if type(a) ~= "table" then
        return false
    end
    if type(b) ~= "table" then
        return false
    end
    local t = table.copy(b)
    for k,v in pairs(a) do
        if t[k] == nil then
            return false
        end
        if type(v) == "table" then
            if not table.equal(v, t[k]) then
                return false
            end
        else
            if v ~= t[k] then
                return false
            end
        end
        t[k] = nil
    end
    if table.is_empty(t) then
        return true
    else
        return false
    end
end

function table.inter(...)
    local t = {...}
    local r = t[1]
    for i=2,#t,1 do
        r = table.intersection(r, t[i])
    end
    return table.deepcopy(r)
end

function table.union(...)
    return table.deepcopy(_union(...))
end

function table.complement(t,...)
    for _,v in ipairs({...}) do
        t = _complement(t, v)
    end
    return table.deepcopy(t)
end

function table.tostring(t)
    if t == nil then return "" end
    if type(t) == "boolean" then return tostring(t) end

    local function str(s)
        if type(s) == "table" then
           return table.tostring(s)
        elseif type(s) == "string" then
            return "\'"..s.."\'"
        else
            return tostring(s)
        end
    end
    local s = {"{"}
    local i = 1
    for k,v in pairs(t) do
        local c = ", "
        if i == 1 then c = "" end
        if k == i then
            set.extend(s, {c, str(v)})
        else
            if type(k) == 'number' or type(k) == 'string' then
                set.extend(s, {c, "[", str(k), "] = ", str(v)})
            else
                if type(k) == 'userdata' then
                    set.extend(s, {c, "*s", table.tostring(getmetatable(k)), "*e = ", str(v)})
                else
                    set.extend(s, {c, k, " = ", str(v)})
                end
            end
        end
        i = i + 1
    end
    set.append(s, "}")
    return table.concat(s, "")
end

function table.print(t)
    print(table.tostring(t))
end
