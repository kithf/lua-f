--[[
  format syntax:
    f"%1:upper %2:bool %a:tab:concat('#c')" {"str",false,true,a={1,2,3}}
    --> "STR true 1,2,3"
]]
function string.parse_tbl(s,b,d)
  b=b or _G
  d=d or "%."
  local last,li=s,s:match("[^"..d.."]+$")
  for t in s:gmatch("[^"..d.."]+")do
    local n=b[t]
    if li and t==li or t==s then return n,t,b end
    last=t
    b=n
  end
  return r,last or s
end
local seek
seek=function(t,n,tp)
  local i=0
  for k,v in pairs(t)do
    if (tp and tp==type(v))and type(k)=="number"then
      i=i+1
      if i==n then
        if"function"==tp then return v()end
        return v
      end
    elseif not tp then
      if k==n then return v end
    end
  end
end
local conv={
  int="number",number="number",
  str="string",string="string",
  fun="function",["function"]="function",
  tab="table",table="table",
  bool="boolean",boolean="boolean"}
local to_val
to_val=function(v)
  if v==v:match"%d+"then return tonumber(v)end
  if v:sub(1,1)=="\""or v:sub(1,1)=="'"then return v:sub(2,#v-1):gsub("#_fc",",")end
  return tostring(v)
end
local exec
exec=function(t,f,obj)
  t=t or"string"
  local args={}
  for a in(f:match"[%w_]+%(?([^%(%)]*)%)?"or""):gmatch"[^,]+"do
    args[#args+1]=to_val(a)
  end
  local fn=f:match"([%w_]+)"
  local __=_G[t]
  local fc;if not __ then obj=tostring(obj);fc=_G.string[fn] 
  else fc=__[fn]end
  return fc(obj,args[1],args[2],args[3],args[4])
end
return function(s)
  local _f_s=function(fmt)
    local fs=s:gsub("(#?)%%([^%s]+)",function(e,cap)
      if e=="#"then return"%"..cap end
      local id,t,f=cap:match"([^:]+):?([^:]*):?(.*)"
      if not conv[t]then f=t end
      local val=id:parse_tbl(fmt,tostring(id):match"[^%w_]+")
      if id==id:match"%d+"then val=seek(fmt,tonumber(id),t~="" and conv[t])end
      if f and f~=""then return tostring(exec(conv[t],f,val))end
      return tostring(val)
    end)
    return fs
  end
  return _f_s
end
