--[[
===============
  扩展表操作模块
===============
  table.index(t)                获取表 t 中所有数字类型的键，升序生成并返回该集合
  table.keys(t)                 获取表 t 中所有键，生成并返回该集合
  table.values(t)               获取表 t 中所有值，生成并返回该集合
  table.is_empty(t)             判断表 t 是否为空
  table.delete(t, o)            从表 t 中去除所有值等于 o 的元素，元素值 o 必须是数字或字符串
  table.extend(...)             向第一个表末尾追加后续若干个表所包含的元素，重复键只保留第一个出现时所对应的值
  table.copy(t)                 复制表 t 仅包括第一层键值对，不包括子表和元表，生成新的表
  table.deepcopy(t)             复制表 t 所有键值对，生成新的表
  table.eq(a, b)                比较表 a 与表 b 内的所有元素是否相等
  table.inter(...)              获取并返回若干个表的交集
  table.union(...)              获取并返回若干个表的并集
  table.compl(...)              返回从第一个表 t 中去除后续若干个表所包含的元素后得到的新表
  table.tostring(t)             将表 t 转换成字符串
  table.print(t)                打印表 t
--]]

table = table or {}

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

function table.keys(t)
    local s = {}
    for k,_ in pairs(t) do
        set.append(s, k)
    end
    return s
end

function table.values(t)
    local s = {}
    for _,v in pairs(t) do
        set.append(s, v)
    end
    return s
end

function table.is_empty(t)
    if next(t) == nil then
        return true
    end
    return false
end

function table.save2(f, t)
    local file,err = io.open(f, "w")
    if err then return _,err end
    file:write("return "..table.tostring(t))
    file:close()
    return
end

function table.load2(f)
    local tbl,err = loadfile(f)()
    if err then return _,err end
    return tbl
end

-- function table.save2(filename, tbl)
--     local function exportstring(s)
-- 		s = string.format("%q", s)
-- 		s = string.gsub(s, "\\\n", "\\n")
-- 		s = string.gsub(s, "\r", "\\r")
-- 		s = string.gsub(s, string.char(26), "\"..string.char(26)..\"")
-- 		return s
--     end

--     local charS,charE = "   ","\n"
-- 	local file,err,_
-- 	if not filename then
-- 		file =  { write = function(self, newstr) self.str = self.str..newstr end, str = "" }
-- 		charS,charE = "",""
-- 	elseif filename == true or filename == 1 then
-- 		charS,charE,file = "","",io.tmpfile()
-- 	else
-- 		file,err = io.open(filename, "w")
-- 		if err then return _,err end
-- 	end
-- 	local tables,lookup = { tbl },{ [tbl] = 1 }
-- 	file:write("return {"..charE)
-- 	for idx,t in ipairs(tables) do
-- 		if filename and filename ~= true and filename ~= 1 then
-- 			file:write("-- Table: {"..idx.."}"..charE)
-- 		end
-- 		file:write("{"..charE)
-- 		local thandled = {}
-- 		for i,v in ipairs(t) do
-- 			thandled[i] = true
-- 			if type(v) ~= "userdata" then
-- 				if type(v) == "table" then
-- 					if not lookup[v] then
-- 						table.insert(tables, v)
-- 						lookup[v] = #tables
-- 					end
-- 					file:write(charS.."{"..lookup[v].."},"..charE)
-- 				elseif type(v) == "function" then
-- 					file:write(charS.."loadstring("..exportstring(string.dump( v )).."),"..charE)
-- 				else
-- 					local value = (type(v) == "string" and exportstring(v)) or tostring(v)
-- 					file:write(charS..value..","..charE)
-- 				end
-- 			end
-- 		end
-- 		for i,v in pairs(t) do
-- 			if (not thandled[i]) and type(v) ~= "userdata" then
-- 				if type(i) == "table" then
-- 					if not lookup[i] then
-- 						table.insert(tables, i)
-- 						lookup[i] = #tables
-- 					end
-- 					file:write(charS.."[{"..lookup[i].."}]=")
-- 				else
-- 					local index = (type(i) == "string" and "["..exportstring(i).."]") or string.format( "[%d]",i)
-- 					file:write(charS..index.."=")
-- 				end
-- 				if type(v) == "table" then
-- 					if not lookup[v] then
-- 						table.insert(tables, v)
-- 						lookup[v] = #tables
-- 					end
-- 					file:write("{"..lookup[v].."},"..charE)
-- 				elseif type(v) == "function" then
-- 					file:write("loadstring("..exportstring(string.dump(v)).."),"..charE)
-- 				else
-- 					local value = (type(v) == "string" and exportstring(v) ) or tostring(v)
-- 					file:write(value..","..charE)
-- 				end
-- 			end
-- 		end
-- 		file:write("},"..charE)
-- 	end
-- 	file:write("}")
-- 	if not filename then
-- 		return file.str.."--|"
-- 	elseif filename == true or filename == 1 then
-- 		file:seek ("set")
-- 		return file:read("*a").."--|"
-- 	else
-- 		file:close()
-- 		return 1
-- 	end
-- end

-- function table.load2( sfile )
-- 	local tables,err,_
-- 	-- catch marker for stringtable
-- 	if string.sub(sfile, -3, -1) == "--|" then
-- 		tables,err = loadstring(sfile)
-- 	else
-- 		tables,err = loadfile(sfile)
-- 	end
-- 	if err then return _,err
-- 	end
-- 	tables = tables()
-- 	for idx = 1,#tables do
-- 		local tolinkv,tolinki = {},{}
-- 		for i,v in pairs( tables[idx] ) do
-- 			if type( v ) == "table" and tables[v[1]] then
-- 				table.insert( tolinkv,{ i,tables[v[1]] } )
-- 			end
-- 			if type( i ) == "table" and tables[i[1]] then
-- 				table.insert( tolinki,{ i,tables[i[1]] } )
-- 			end
-- 		end
-- 		-- link values, first due to possible changes of indices
-- 		for _,v in ipairs( tolinkv ) do
-- 			tables[idx][v[1]] = v[2]
-- 		end
-- 		-- link indices
-- 		for _,v in ipairs( tolinki ) do
-- 			tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
-- 		end
-- 	end
-- 	return tables[1]
-- end

function table.delete(t, o)
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
    local copy = {}
    for k,v in pairs(t) do
        copy[k] = v
    end
    return setmetatable(copy, getmetatable(t))
end

function table.deepcopy(t)
    local orig_type = type(t)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, t, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(t)))
    else
        copy = t
    end
    return copy
end

function table.eq(a, b)
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
            if not table.eq(v, t[k]) then
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
    local t,r = {...},{}
    for k,v in pairs(t[1]) do
        for i=2,#t do
            if type(t[i][k]) ~= type(v) then
                v = nil
                break
            elseif type(v) ~= "table" then
                if t[i][k] ~= v then
                    v = nil
                    break
                end
            end
        end
        if type(v) == "table" then
            for i=2,#t do
                if table.eq(v, t[i][k]) ~= true then
                    v = nil
                    break
                end
            end
            r[k] = table.deepcopy(v)
            v = nil
        end
        if v ~= nil then
            r[k] = v
        end
    end
    return r
end

function table.union(...)
    local t = {...}
    local r = table.deepcopy(t[1])
    for i=2,#t do
        for k,v in pairs(t[i]) do
            if r[k] == nil then
                if type(v) == "table" then
                    r[k] = table.deepcopy(v)
                else
                    r[k] = v
                end
            end
        end
    end
    return r
end

function table.compl(...)
    local t,r = {...},{}
    for k,v in pairs(t[1]) do
        for i=2,#t do
            if t[i][k] ~= nil then
                v = nil
                break
            end
        end
        if type(v) == "table" then
            r[k] = table.deepcopy(v)
        else
            r[k] = v
        end
    end
    return r
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
