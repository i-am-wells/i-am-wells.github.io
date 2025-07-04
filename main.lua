
local js = require 'js'
local dom = require 'dom'

dom.enableGlobalTags()

dom.route(js.global.document.body, {
  [''] = require 'clock',
})

