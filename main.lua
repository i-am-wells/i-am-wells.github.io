
local js = require 'js'
local dom = require 'dom'

dom.enableGlobalTags()

-- Principles:
-- fill the screen
-- no free scroll, only page
-- 
local MainPage = {
  h1 'This is it',
  'Words words words ',
  a {href='#clock', 'Go to clock'}
}


-- Routes.
--  Apply on page load
--  Intercept internal nav

dom.route(js.global.document.body, {
  [''] = MainPage,
  clock = require 'clock',
})

