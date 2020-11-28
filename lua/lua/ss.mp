--[[
TODO:

  shallow clone in au!!!!!!!!!!!!!

  check for duplicate modules

  check line first and only activate needed modules

  have a global dict where data lives, instead of vim.b

  au: check if function exists and reference it

--]]

-- fill with 1: {}, 2: {}, etc beforehand?

__statusline = {}

global class StatusLine
  new: (generator) =>
    @actions = {}
    @events = {}

    for i, mod in ipairs generator
      if type(mod) == 'string'
        V.au 'BufEnter', '*', ->
          @save_cache(i, mod)

      elseif type(mod) == 'table'
        events, action = mod[1], mod[2]
        event_table = @unpack_events(events)
        table.insert(event_table, 'BufEnter') -- initial eval

        for _, k in ipairs event_table
          @events[k] = true

        --print vim.inspect(event_table), '@save_cache', i
        V.au event_table, '*', ->
          @save_cache(i, action!)

    @init!

  init: =>
    all_events = {}
    for k, v in pairs @events
      table.insert(all_events, k)
    table.insert(all_events, 'BufReadPost')
    --print vim.inspect(all_events), 'redraw'

    -- every event will trigger this in all buffers
    -- testing redraw shows that it doesn't?
    V.au all_events, '*', @redraw

  redraw: =>
    -- remember bufnr
    if not vim.b.bufnr
      vim.b.bufnr = vim.fn.bufnr!
    bufnr = vim.b.bufnr

    cache = __statusline[bufnr]

    if cache == nil
      vim.wo.statusline = 'no cache for bufnr ' .. bufnr
      return

    res = ''
    for _, k in ipairs cache -- change to []
      res ..= k

    vim.wo.statusline = res

  save_cache: (i, value) =>
    -- remember bufnr
    if not vim.b.bufnr
      vim.b.bufnr = vim.fn.bufnr!
    bufnr = vim.b.bufnr

    if not __statusline[bufnr]
      __statusline[bufnr] = {}
    cache = __statusline[bufnr]

    if value != nil
      cache[i] = value
    else
      cache[i] = ''

  unpack_events: (event_string) =>
    assert type(event_string) == 'string',
      'unpack_events: expected type string, got ' .. type(event_string)
    event_string ..= ','
    return [e for e in event_string\gmatch "([^,]+),%s*"]

