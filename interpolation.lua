--[[
  string interpolation syntax:
    {a+b}
    {variable}
  p"abc {123} {1+a}"
--]]
-- by leafo, slightly modified
local dynamic
dynamic=function(n)
  local l=3
  while true do
    local i=1
    while true do
      local s,fn,fv=pcall(debug.getlocal,l,i)
      if not s then return fv end
      if not fn then break end
      if fn==n then return fv end
      i=i+1
    end
    l=l+1
  end
end
return function(_p_s)
  local __p_s = _p_s:gsub("{([^{}]+)}",function(_p_r) 
    if _p_r:sub(1,1)=="#"and _p_r:sub(#_p_r,#_p_r)=="#"then
      return"{".._p_r:sub(2,#_p_r-1).."}"
    end
    if _p_r==_p_r:match"[%w_]+"then
      return _G[_p_r]or tostring(dynamic(_p_r)or"")
    else
      local _p_r_c=assert((loadstring or load)("return ".._p_r))
      if not _p_r_c then return r end
      setfenv(_p_r_c,setmetatable({},{
        __index=function(self, _p_k)
          return string[_p_k]or table[_p_k]or math[_p_k]or dynamic(_p_k)or""
        end,}))
      return tostring(_p_r_c())
    end
  end)
  return __p_s
end
