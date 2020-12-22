--[[
================
  集合操作模块
================
  set.insert(s, p, i)         向集合 s 中的位置 p 处插入一个元素 i，元素 i 必须是数字或字符串，允许存在重复元素
  set.append(s, a)            向集合 s 末尾追加一个元素 a，元素 a 必须是数字或字符串，允许存在重复元素
  set.remove(s, p)            从集合 s 中去除位置在 p 的元素
  set.delete(s, o)            从集合 s 中去除所有值等于 o 的元素，元素值 o 必须是数字或字符串，允许存在重复元素
  set.reverse(s)              将集合 s 中的所有元素顺序逆向排列
  set.sort(s)                 将集合 s 中的所有元素升序排列
  set.permute(s, n)           返回集合 s 中任意 n 个元素的排列
  set.combine(s, n)           返回集合 s 中任意 n 个元素的组合
  set.concat(s, p)            将集合 s 中的所有元素用连接符 p 串连接成一个字符串
  set.last(s)                 返回集合 s 的最后一个元素
  set.max(s)                  返回集合 s 中最大的元素
  set.min(s)                  返回集合 s 中最小的元素
  set.shift(s)                从集合 s 中去除第一个元素，并返回该元素
  set.pop(s)                  从集合 s 中去除最后一个元素，并返回该元素
  set.dedup(s)                对集合 s 元素进行去重
  set.extend(...)             向集合 s 末尾追加若干个集合的元素，允许存在重复元素
  set.union(...)              获取并返回若干个集合的并集，重复元素只保留一个
  set.inter(...)              获取并返回若干个集合的交集，重复元素只保留一个
  set.compl(...)              返回从第一个集合 s 中去除后续若干个集合所包含的元素后得到的新集合，重复元素只保留一个
  set.eq(a, b)                比较集合 a 和 b 中的元素是否相等，存在重复元素的集合将先去重后比较
  set.lt(a, b)                比较集合 a 是否真包含于集合 b，存在重复元素的集合将先去重后比较
  set.le(a, b)                比较集合 a 是否包含于集合 b，存在重复元素的集合将先去重后比较
  set.copy(s)                 复制集合 s 的值生成新的集合
  set.tokey(s)                生成以集合 s 的元素作为键值的表，存在重复元素的集合将被去重
  set.index_of(s, e)          获取元素 e 在集合 s 中位置
  set.has(s, e)               判断集合 s 中是否存在元素 a
  set.is_empty(s)             判断集合 s 是否为空集合
  set.count(s, a)             获取元素 a 在集合 s 中存在的个数
  set.is_set(t)               判断表 t 是否属于集合类型
  set.tostring(s)             将集合 s 转换成字符串
--]]

set = {}

function set.insert(s, p, i)
    return table.insert(s, p, i)
end

function set.append(s, a)
    s[#s+1] = a
end

function set.remove(s, p)
    return table.remove(s, p)
end

function set.delete(s, o)
    local i = #s
    while i > 0 do
        if s[i] == o then
            set.remove(s, i)
        end
        i = i - 1
    end
end

function set.reverse(s)
    local c = set.copy(s)
    for i=#c,1,-1 do
        s[#s-i+1] = c[i]
    end
end

function set.sort(s)
    return table.sort(s)
end

function set.permute(s, n)
    local t = {}
    local function _permute(a, k, r)
        if #a == k then
            set.append(r, set.copy(a))
        else
            for i=k,#a do
                a[i],a[k] = a[k],a[i]
                _permute(a, k+1, r)
                a[i],a[k] = a[k],a[i]
            end
        end
    end
    n = n or #s
    for _,v in ipairs(set.combine(s, n)) do
        _permute(v,1,t)
    end
    return t
end

function set.combine(s, n)
    s = set.copy(s)
    n = n or #s
    if n == 0 then
        return {{}}
    end
    local t = {}
    while n <= #s do
        local e = set.pop(s)
        for _,v in ipairs(set.combine(s, n-1)) do
            set.append(v, e)
            set.append(t, v)
        end
    end
    return t
end

function set.concat(s, p)
    if p == nil then
        p = ""
    end
    return table.concat(s, p)
end

function set.max(s)
    local c = set.copy(s)
    set.sort(c)
    return set.last(c)
end

function set.min(s)
    local c = set.copy(s)
    set.sort(c)
    return c[1]
end

function set.last(s)
    return s[#s]
end

function set.shift(s)
    local a = s[1]
    set.remove(s, 1)
    return a
end

function set.pop(s)
    local a = set.last(s)
    s[#s] = nil
    return a
end

function set.dedup(s)
    local t = {}
    local i = 1
    while i <= #s do
        if t[s[i]] == nil then
            t[s[i]] = true
        else
            set.remove(s, i)
            i = i - 1
        end
        i = i + 1
    end
end

function set.extend(...)
    local l = {...}
    local s = set.shift(l)
    for _,t in ipairs(l) do
        for _,v in ipairs(t) do
            set.append(s, v)
        end
    end
end

function set.inter(...)
    local s,t,r = {...},{},{}
    for _,v in ipairs(s[1]) do
        r[v] = true
    end
    for i=2,#s do
        t = r
        r = {}
        for _,v in ipairs(s[i]) do
            if t[v] ~= nil then
                t[v] = nil
                r[v] = true
            end
        end
    end
    return table.keys(r)
end

function set.union(...)
    local s = {...}
    local t,r = {},{}
    for _,v in ipairs(s) do
        for _,i in ipairs(v) do
            if t[i] == nil then
                set.append(r, i)
                t[i] = true
            end
        end
    end
    return r
end

function set.compl(...)
    local s = {...}
    local t,r = {},{}
    for i=2,#s do
        for _,v in ipairs(s[i]) do
            t[v] = true
        end
    end
    for _,v in ipairs(s[1]) do
        if t[v] == nil then
            set.append(r, v)
        end
    end
    return r
end

function set.eq(a, b)
    set.dedup(a)
    set.dedup(b)
    local s = set.tokey(a)
    for _,v in ipairs(b) do
        if s[v] == true then
            s[v] = nil
        else
            return false
        end
    end
    if #table.keys(s) + #s > 0 then
        return false
    else
        return true
    end
end

function set.lt(a, b)
    set.dedup(a)
    set.dedup(b)
    local s = set.tokey(b)
    for _,v in ipairs(a) do
        if s[v] == true then
            s[v] = nil
        else
            return false
        end
    end
    if #table.keys(s) + #s > 0 then
        return true
    else
        return false
    end
end

function set.le(a, b)
    set.dedup(a)
    set.dedup(b)
    local s = set.tokey(b)
    for _,v in ipairs(a) do
        if s[v] == true then
            s[v] = nil
        else
            return false
        end
    end
    if #table.keys(s) + #s >= 0 then
        return true
    else
        return false
    end
end

function set.copy(s)
    return table.copy(s)
end

function set.tokey(s)
    local t = {}
    for _,v in ipairs(s) do
        t[v] = true
    end
    return t
end

function set.index_of(s, e)
    for k,v in pairs(s) do
        if v == e then
            return k
        end
    end
    return 0
end

function set.has(s, e)
    for _,v in ipairs(s) do
        if v == e then
            return true
        end
    end
    return false
end

function set.is_empty(s)
    return table.is_empty(s)
end

function set.count(s, a)
    local c = 0
    for _,v in ipairs(s) do
        if v == a then
            c = c + 1
        end
    end
    return c
end

function set.is_set(t)
    local k = table.keys(t)
    if #k > 0 then
        return false
    else
        return true
    end
end

function set.tostring(s)
    if type(s) ~= "table" then return tostring(s) end
    local p = {}
    for _,v in ipairs(s) do
        if type(v) == "string" then
            set.append(p, "\'"..v.."\'")
        else
            set.append(p, v)
        end
    end
    return "{"..table.concat(p, ",").."}"
end
