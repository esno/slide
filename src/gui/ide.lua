local lgi = require('lgi')
local gtk = lgi.require('Gtk', '3.0')
local gobj = lgi.GObject
local lfs = require('lfs')

local ide = {}

local IDEFILES = {
  TYPE = 1,
  PATH = 2,
  NAME = 3
}

function ide.open(self, app)
  ide.store = {
    main = {
      files = gtk.TreeStore.new({
        [IDEFILES.TYPE] = gobj.Type.BOOLEAN,
        [IDEFILES.PATH] = gobj.Type.STRING,
        [IDEFILES.NAME] = gobj.Type.STRING
      })
    }
  }

  ide.gui = {
    main = {
      window = gtk.Window({
        type = gtk.WindowType.TOPLEVEL,
        default_width = 400,
        default_height = 300,
        application = app,
        title = 'lua-ide',
        child = gtk.Grid({
          orientation = gtk.Orientation.Horizontal,
          column_homogeneous = false,
          gtk.ScrolledWindow({
            hexpand = true,
            gtk.TreeView({
              model = ide.store.main.files,
              ['headers-visible'] = false,
              gtk.TreeViewColumn({
                resizable = true,
                { gtk.CellRendererText({}), { text = IDEFILES.NAME } }
              })
            })
          }),
          gtk.ScrolledWindow({
            hexpand = true,
            vexpand = true,
            gtk.TextView({ id = 'editor', expand = true })
          })
        })
      })
    }
  }

  ide:listDirectory(os.getenv('HOME'), ide.store.main.files)
  ide.gui.main.window:show_all()
  return ide.gui.main.window
end

function ide.listDirectory(self, directory, store)
  for file in lfs.dir(directory) do
    if file ~= '.' and file ~= '..' then
      local f = directory .. '/' .. file
      local attr = lfs.attributes(f)
      local ft = nil
      if type(addr) == 'table' and attr.mode == 'directory' then
        ft = true
      else
        ft =false
      end
      store:append(nil, {
        [IDEFILES.TYPE] = ft,
        [IDEFILES.PATH] = directory,
        [IDEFILES.NAME] = file
      })
    end
  end
end

return ide
