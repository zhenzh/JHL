--[[
========================
  扩展字符(串)操作模块
========================
  string.isen(c)                判断字符 c 是否为英文字符，只能判断一个字符。如参数传入字符串，则只对第一个字符进行判断
  string.is_empty(c)            判断字符 c 是否为空
  string.count(s, c)            统计字符串 s 中字符 c 出现的次数
  string.split(s, d)            将字符串 s 以分隔符 d 拆分
  string.trim(s)                去除字符串 s 两端的空白
  string.concat(...)            将若干个独立字符串连接成一个字符串
  string.toset(s)               将字符串 s 转换成集合
  string.totable(s)             将字符串 s 转换成表
  string.similar(a, b)          计算字符串 a 和 b 的相似度，以字符串 a 作为参照基准，返回百分比 0 ~ 100
--]]

string = string or {}

function string.isen(c)
    if string.byte(c) <= 127 then
        return true
    else
        return false
    end
end

function string.is_empty(c)
    if c == nil or c == "" then
        return true
    else
        return false
    end
end

function string.count(s, c)
    local i = 0
    for a in string.gmatch(s, c) do
        i = i + 1
    end
    return i
end

function string.split(s, d)
    local r,from = {},1
    local delim_from,delim_to = string.find(s, d, from)
    while delim_from do
        set.append(r, string.sub(s, from, delim_from-1))
        from = delim_to + 1
        delim_from,delim_to = string.find(s, d, from)
    end
    set.append(r, string.sub(s, from))
    return r
end

function string.trim(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

function string.concat(...)
    return set.concat({...}, "")
end

function string.toset(s)
    if s == "" then
        return {}
    else
        return string.split(s, "|")
    end
end

function string.totable(s)
    if s == "" then
        return {}
    elseif string.match(s, "^{.*}$") then
        return loadstring("return "..s)()
    elseif string.match(s, "|") then
        return string.split(s, "|")
    else
        return false
    end
end

function string.similar(a, b)
    if not a or not b or a == "" or b == "" then
        return 0
    end
  --[[
  a=123456789675
  b=8612345789987
    1 2 3 4 5 6 7 8 9 6 7 5
  8               8
  6           6       6
  1 1
  2   2
  3     3
  4       4
  5         5             5
  7             7
  8               8
  9                 9
  9                 9
  8               8
  7                     7
  如果相似 肯定有中间相对集中的 45度斜线 占据80% 的字数目吧
  ]]
  local L = string.len(a)
  local H = string.len(b)
  local maze = {}
  for x = 0, L+1 do
    if maze[x] == nil then maze[x] = {} end
    for y = 0, H+1 do
      if x == 0 or y == 0 or x == L+1 or y == L+1 then
        maze[x][y] = 0 --边框设置0
      else
        local ix = string.sub(a,x,x)
        local jy = string.sub(b,y,y)
        if string.byte(ix) == string.byte(jy) then
          maze[x][y] = 1
        else
          maze[x][y] = 0
        end
      end
    end
  end

  -- 去除孤点
  for x = 1, L do
    for y = 1, H do
      if maze[x][y] == 1 then
        local count = 0
        for i=x-1,x+1 do
          for j=y-1,y+1 do
            count = count + maze[i][j]
          end
          if count == 1 then
            maze[x][y] = 0 -- 周围九宫格加起来才 1
          end

        end
      end

    end
  end

  local maze45 = {}
  -- 计算45度斜线的字数
  for i = 1, L do --长度

  end
end
