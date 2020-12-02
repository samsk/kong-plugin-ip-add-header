local constants = require "kong.constants"
local BasePlugin = require "kong.plugins.base_plugin"
local iputils = require "resty.iputils"

local IPAddHeaderHandler = BasePlugin:extend()

IPAddHeaderHandler.PRIORITY = 2000
IPAddHeaderHandler.VERSION = "0.1"

-- cache of parsed CIDR values
local cache = {}


local function cidr_cache(cidr_tab)
  local cidr_tab_len = #cidr_tab

  local parsed_cidrs = kong.table.new(cidr_tab_len, 0) -- table of parsed cidrs to return

  -- build a table of parsed cidr blocks based on configured
  -- cidrs, either from cache or via iputils parse
  -- TODO dont build a new table every time, just cache the final result
  -- best way to do this will require a migration (see PR details)
  for i = 1, cidr_tab_len do
    local cidr        = cidr_tab[i]
    local parsed_cidr = cache[cidr]

    if parsed_cidr then
      parsed_cidrs[i] = parsed_cidr

    else
      -- if we dont have this cidr block cached,
      -- parse it and cache the results
      local lower, upper = iputils.parse_cidr(cidr)

      cache[cidr] = { lower, upper }
      parsed_cidrs[i] = cache[cidr]
    end
  end

  return parsed_cidrs
end

function IPAddHeaderHandler:init_worker()
  local ok, err = iputils.enable_lrucache()
  if not ok then
    kong.log.err("could not enable lrucache: ", err)
  end
end

function IPAddHeaderHandler:access(conf)
  local match = false
  local binary_remote_addr = ngx.var.binary_remote_addr

  if not binary_remote_addr then
    return
  end

  if conf.ip_list and #conf.ip_list > 0 then
    match = iputils.binip_in_cidrs(binary_remote_addr, cidr_cache(conf.ip_list))
  end

  if match then
    local set_header = kong.service.request.set_header
    -- local clear_header = kong.service.request.clear_header

    set_header(conf.key_name, conf.key_value)
  end
end

return IPAddHeaderHandler
