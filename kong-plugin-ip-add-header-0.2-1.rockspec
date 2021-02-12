package = "kong-plugin-ip-add-header"
version = "0.2-1"
source = {
   url = "https://github.com/samsk/kong-plugin-ip-add-header",
   tag = "v0.2"
}
description = {
   summary = "A Kong plugin to add header for specific IPs",
   homepage = "https://github.com/samsk/kong-plugin-ip-add-header",
   license = "MIT"
}
dependencies = {
   "lua ~> 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.ip-add-header.handler"] = "handler.lua",
      ["kong.plugins.ip-add-header.schema"] = "schema.lua"
   }
}
