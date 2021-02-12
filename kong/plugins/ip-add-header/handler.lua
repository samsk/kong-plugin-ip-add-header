-- local constants = require "kong.constants"
local BasePlugin = require "kong.plugins.base_plugin"
local ipmatcher = require "resty.ipmatcher"

local IPAddHeaderHandler = BasePlugin:extend()

IPAddHeaderHandler.PRIORITY = 2000
IPAddHeaderHandler.VERSION = "0.2"

local function match_bin(list, binary_remote_addr)
  local ip, err = ipmatcher.new(list)
  if err then
    return error("failed to create a new ipmatcher instance: " .. err)
  end

  local is_match
  is_match, err = ip:match_bin(binary_remote_addr)
  if err then
    return error("invalid binary ip address: " .. err)
  end

  return is_match
end

function IPAddHeaderHandler:access(conf)
  local match = false
  local binary_remote_addr = ngx.var.binary_remote_addr

  if not binary_remote_addr then
    return
  end

  if conf.ip_list and #conf.ip_list > 0 then
    match = match_bin(conf.ip_list, binary_remote_addr)
  end

  if match then
    local set_header = kong.service.request.set_header
    -- local clear_header = kong.service.request.clear_header

    set_header(conf.key_name, conf.key_value)
  end
end

return IPAddHeaderHandler
