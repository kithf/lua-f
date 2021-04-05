# lua-f
String interpolation in Lua

## Interpolation

Syntax: `{expr}`

```lua
local a = 1
local b = 2
print(p"{a}+3*{b}={a+3*b}") --> 1+3*2=7
```

Escaping can be done with `#`

```lua
print(p"{#a#}") --> {a}
```

### Limitations

Interpolation can't resolve some upvalues in function due to lua reasons
```
function a(b)
 return p"{b}" --> nil or ""
end
```

## Format

Syntax: `%id:type?:function?`

```lua
print(f"%1:upper %2:bool %a:tab:concat('#c')" {"str",false,true,a={1,2,3}})
    --> "STR true 1,2,3"
```

Escaping can be done with `#`

```lua
print(f"#%1") --> %1
```
