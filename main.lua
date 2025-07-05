
local js = require 'js'
local dom = require 'dom'

dom.enableGlobalTags()

local clock = require 'clock'

dom.route(js.global.document.body, {
  [''] = clock(),
  about = clock 'about',
})

