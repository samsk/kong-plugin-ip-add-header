local typedefs = require "kong.db.schema.typedefs"

return {
  name = "ip-add-header",
  fields = {
    -- { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { run_on_preflight = { type = "boolean", default = true }, },
          { ip_list = { type = "array", elements = typedefs.cidr_v4, required = true }, },
          { key_name = { type = "string", required = true }, },
          { key_value = { type = "string", required = true }, },
        },
    }, },
  },
}
