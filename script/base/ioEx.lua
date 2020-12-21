--[[
========================
  扩展文件系统操作模块
========================
  io.exists(o)                  判断对象 o 是否存在
  io.is_file(o)                 判断对象 o 是否是文件
  io.is_dir(o)                  判断对象 o 是否是目录
--]]

io = io or {}

function io.exists(f)
    if type(f) ~= "string" then
        return false
    end
    return os.rename(f, f) and true or false
end

function io.is_file(o)
    if type(o) ~= "string" then
        return false
    end
    if not io.exists(o) then
        return false
    end
    local f = io.open(o)
    if f then
        f:close()
        return true
    end
    return false
end

function io.is_dir(o)
    return (io.exists(o) and not io.is_file(o))
end