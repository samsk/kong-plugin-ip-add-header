package = "kong-plugin-ip-add-header"
version = "0.1-1"
source = {
   url = "https://github.com/samsk/kong-plugin-ip-add-header",
   tag = "v0.1"
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
      ["kong.plugins.ip-auth.handler"] = "handler.lua",
      ["kong.plugins.ip-auth.schema"] = "schema.lua"
   }
}
