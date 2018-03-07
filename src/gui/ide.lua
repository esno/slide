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

function ide.createMainWindow(self, window)
  ide.main.store = {
    files = gtk.TreeStore.new({
      [IDEFILES.TYPE] = gobj.Type.BOOLEAN,
      [IDEFILES.PATH] = gobj.Type.STRING,
      [IDEFILES.NAME] = gobj.Type.STRING
    }),
  }

  ide.main.paned = gtk.Paned({
    id = 'main.paned',
    orientation = gtk.Orientation.Horizontal,
    gtk.ScrolledWindow({
      ['width-request'] = 150,
      child = gtk.TreeView({
        model = ide.main.store.files,
        ['headers-visible'] = false,
        gtk.TreeViewColumn({
          id = 'main.files.view',
          resizable = true,
          { gtk.CellRendererText({}), { text = IDEFILES.NAME } }
        })
      })
    }),
    gtk.ScrolledWindow({
      child = gtk.TextView({
        id = 'main.editor.view'
      })
    })
  })

  window.child = ide.main.paned
end

function ide.open(self, app)
  ide.main = {
    window = gtk.Window({
      type = gtk.WindowType.TOPLEVEL,
      default_width = 400,
      default_height = 300,
      application = app,
      title = 'slide'
    })
  }

  ide:createMainWindow(ide.main.window)
  ide:listDirectory(os.getenv('HOME'), ide.main.store.files)
  ide.main.window:show_all()
  return ide.main.window
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
