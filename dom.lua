local js = require 'js'
local window = js.global
local document = window.document

local originalIndex
local globalTagsEnabled = false
local svgNamespace = 'http://www.w3.org/2000/svg'
local pendingOnCreate = {}

local function getOrCreateMetatable(t)
  local meta = getmetatable(t)
  if meta == nil then
    meta = {}
    setmetatable(t, meta)
  end
  return meta
end

local appendContent

local function createElement(namespace, tagName, content)
  local el
  if namespace then
    el = document:createElementNS(namespace, tagName)
  else
    el = document:createElement(tagName)
  end
  local childContent = {}

  if type(content) == 'table' then
    for k, v in pairs(content) do
      if type(k) == 'number' then
        childContent[k] = v
      else
        -- Attribute
        if namespace then
          el:setAttributeNS(js.null, k, v)
        else
          el:setAttribute(k, v)
        end
      end
    end 

    for i, v in ipairs(childContent) do
      appendContent(el, v, namespace)
    end

    if content.oncreate then
      table.insert(pendingOnCreate, {el, content.oncreate})
    end

  else
    appendContent(el, content, namespace)
  end

  return el
end

appendContent = function(el, content, namespace)
  if type(content) == 'table' then
    -- A bare table is treated as a div.
    el:append(createElement(nil, 'div', content))
  elseif type(content) == 'userdata' then
    -- TODO better check
    el:append(content)
  else
    el:append(document:createTextNode(content))
  end
end

local dom = {}

--- Treat undefined global names as shorthand functions for creating DOM elements.
function dom.enableGlobalTags()
  local meta = getOrCreateMetatable(_G)

  originalIndex = meta.__index
  meta.__index = function(_, tagName)
    return function(...)
      return createElement(nil, tagName, ...)
    end
  end

  globalTagsEnabled = true
end

--- Undo the effect of enableGlobalTags.
function dom.disableGlobalTags()
  if ~globalTagsEnabled then return end
  getOrCreateMetatable(_G).__index = originalIndex
  globalTagsEnabled = false
end

function dom.mount(mountPoint, content)
  -- Clear existing children
  mountPoint:replaceChildren()
  appendContent(mountPoint, content)

  for _, elementAndOnCreate in ipairs(pendingOnCreate) do
    local el, oncreate = table.unpack(elementAndOnCreate)
    oncreate(el)
  end
  pendingOnCreate = {}
end

function dom.route(mountPoint, routes)
  local function getHashAndMount()
    -- Initial route
    hash = js.global.location.hash
    if hash then
      -- Skip initial #
      hash = hash:sub(2)
    end
    dom.mount(mountPoint, routes[hash])
  end

  getHashAndMount()  
  window:addEventListener('hashchange', getHashAndMount)
end

dom.svg = setmetatable({}, {
  __call = function(_, ...)
    return createElement(svgNamespace, 'svg', ...)
  end,

  __index = function(_, tagName)
    return function(...)
      return createElement(svgNamespace, tagName, ...)
    end
  end
})

function dom.now()
  return js.new(js.global.Date)
end

function dom.setInterval(callback, interval)
  return js.global.setInterval(js.global, callback, interval)
end

return dom