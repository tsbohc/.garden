-- https://github.com/bungle/lua-resty-tags/blob/master/lib/resty/tags.lua

local type = type
local table = table
local unpack = table.unpack or unpack
local concat = table.concat
local setmetatable = setmetatable
local getmetatable = getmetatable
local tostring = tostring
local setfenv = setfenv
local select = select
local ipairs = ipairs
local pairs = pairs
local gsub = string.gsub
local ngx = ngx
local null = type(ngx) == "table" and ngx.null
local _G = _G
local voids    = {
    area       = true,
    base       = true,
    br         = true,
    col        = true,
    command    = true,
    embed      = true,
    hr         = true,
    img        = true,
    input      = true,
    keygen     = true,
    link       = true,
    meta       = true,
    param      = true,
    source     = true,
    track      = true,
    wbr        = true
}
local elements = {
    a          = true,
    abbr       = true,
    address    = true,
    area       = true,
    article    = true,
    aside      = true,
    audio      = true,
    b          = true,
    base       = true,
    bdi        = true,
    bdo        = true,
    blockquote = true,
    body       = true,
    br         = true,
    button     = true,
    canvas     = true,
    caption    = true,
    cite       = true,
    code       = true,
    col        = true,
    colgroup   = true,
    command    = true,
    data       = true,
    datalist   = true,
    dd         = true,
    del        = true,
    details    = true,
    dfn        = true,
    div        = true,
    dl         = true,
    dt         = true,
    em         = true,
    embed      = true,
    fieldset   = true,
    figcaption = true,
    figure     = true,
    footer     = true,
    form       = true,
    h1         = true,
    h2         = true,
    h3         = true,
    h4         = true,
    h5         = true,
    h6         = true,
    head       = true,
    header     = true,
    hgroup     = true,
    hr         = true,
    html       = true,
    i          = true,
    iframe     = true,
    img        = true,
    input      = true,
    ins        = true,
    kbd        = true,
    keygen     = true,
    label      = true,
    legend     = true,
    li         = true,
    link       = true,
    main       = true,
    map        = true,
    mark       = true,
    menu       = true,
    meta       = true,
    meter      = true,
    nav        = true,
    noscript   = true,
    object     = true,
    ol         = true,
    optgroup   = true,
    option     = true,
    output     = true,
    p          = true,
    param      = true,
    pre        = true,
    progress   = true,
    q          = true,
    rb         = true,
    rp         = true,
    rt         = true,
    rtc        = true,
    ruby       = true,
    s          = true,
    samp       = true,
    script     = true,
    section    = true,
    select     = true,
    small      = true,
    source     = true,
    span       = true,
    strong     = true,
    style      = true,
    sub        = true,
    summary    = true,
    sup        = true,
    table      = true,
    tbody      = true,
    td         = true,
    template   = true,
    textarea   = true,
    tfoot      = true,
    th         = true,
    thead      = true,
    time       = true,
    title      = true,
    tr         = true,
    track      = true,
    u          = true,
    ul         = true,
    var        = true,
    video      = true,
    wbr        = true
}
local escape = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
}
local function output(s)
    if s == nil or s == null then return "" end
    return tostring(s)
end
local function html(s)
    if type(s) == "string" then
        return gsub(s, "[\">/<'&]", escape)
    end
    return output(s)
end
local function attr(s)
    if type(s) == "string" then
        return gsub(s, '["><&]', escape)
    end
    return output(s)
end
local function none(s)
    return s
end
local escapers = {
    script = none,
    style  = none
}
local function copy(s)
    local n = #s
    local d = {}
    for i=1, n do
        d[i] = s[i]
    end
    return d
end
local tag = {}
function tag.new(opts)
    return setmetatable(opts, tag)
end
function tag:__tostring()
    local n, c, a = self.name, self.childs, self.attributes
    if #c == 0 then
        return voids[n] and concat{ "<", n, a or "", ">" } or concat{ "<", n, a or "", "></", n, ">" }
    end
    return concat{ "<", n, a or "", ">", concat(c), "</", n, ">" }
end
function tag:__call(...)
    local n = select("#", ...)
    local c, a = self.copy and {} or self.childs, self.attributes
    local s = #c
    for i=1, n do
        local v = select(i, ...)
        if type(v) == "table" then
            if getmetatable(v) == tag then
                c[s+i] = tostring(v)
            elseif s == 0 and n == 1 and not a then
                local r = {}
                local i = 1
                for k, v in pairs(v) do
                    if type(k) ~= "number" then
                        r[i]=" "
                        r[i+1] = k
                        r[i+2] = '="'
                        r[i+3] = attr(v)
                        r[i+4] = '"'
                        i=i+5
                    end
                end
                for _, v in ipairs(v) do
                    r[i]=" "
                    r[i+1]=attr(v)
                    i=i+2
                end
                a = concat(r)
            else
                c[s+i] = (escapers[self.name] or html)(v)
            end
        else
            c[s+i] = (escapers[self.name] or html)(v)
        end
    end
    if self.copy then
        return tag.new{
            name       = self.name,
            childs     = copy(c),
            attributes = a
        }
    end
    self.attributes = a
    return self
end
local mt = {}
function mt:__index(k)
    -- TODO: should we have special handling for table and select (the built-in Lua functions)?
    if not elements[k] and _G[k] then
        return _G[k]
    else
        return tag.new{
            name   = k,
            childs = {}
        }
    end
end
local context = setmetatable({}, mt)
return function(...)
    local argc = select("#", ...)
    local r = {}
    for i=1, argc do
        local v = select(i, ...)
        if type(v) == "function" then
            r[i] = setfenv(v, context)
        else
            r[i] = tag.new{
                name   = v,
                childs = {},
                copy   = true
            }
        end
    end
    return unpack(r)
end
