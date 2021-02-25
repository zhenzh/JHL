--[[
========================
  扩展数学操作模块
========================
  math.decimal(n, d)            返回数字 n 在小数点后第 d 位作四舍五入后的结果
--]]

math = math or {}

function math.decimal(n, d)
    d = d or 2
    n = n * (10 ^ d)
    if n % 1 >= 0.5 then
        n = math.ceil(n)
    else
        n = math.floor(n)
    end
    return  n * (0.1 ^ d)
end