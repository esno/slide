#! /usr/bin/env lua

local lgi = require('lgi')
local gtk = lgi.require('Gtk', '3.0')
local ide = require('gui.ide')

local app = gtk.Application({ application_id = 'orangenpizza.ide' })

function app:on_activate()
   ide:open(app)
end

return app:run {arg[0], ...}
