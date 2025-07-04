local js = require 'js'
local dom = require 'dom'

local function makeCircle(id, cx, cy, r)
  return dom.svg.circle {
    id = id,
    class = 'shape',
    cx = cx,
    cy = cy,
    r = r
  }
end

local function rotate(angle)
  return ('rotate(%d)'):format(angle)
end

local function bigNumber(id, x, y, angle)
  return dom.svg.rect {
    id = id,
    class = 'shape',
    width = 13.777444,
    height = 46.239368,
    x = x,
    y = y,
    ry = 6.8887219,
    transform = rotate(angle),
  }
end

local function smallNumber(id, x, y, angle)
  return dom.svg.rect {
    id = id,
    class = 'shape',
    width = 7.7789779,
    height = 27.532955,
    x = x,
    y = y,
    ry = 3.8894889,
    transform = rotate(angle)
  }
end

local function updateHand(id, value, max)
  local angle = value / max * 360      
  js.global.document
    :getElementById(id)
    :setAttribute('style', ('transform: rotate(%fdeg)'):format(angle))
end

local function update()
  local date = dom.now()

  local seconds = date:getSeconds()
  local minutes = date:getMinutes() + (seconds / 60)
  local hours = date:getHours() + (minutes / 60)

  updateHand('hour', hours, 12)
  updateHand('minute', minutes, 60)
end

local function makeClock()
  return dom.svg {
    width = '297mm',
    height = '297mm',
    viewBox = '0 0 297 297',
    version = '1.1',
    id = 'clock',

    oncreate = function(el)
      dom.setInterval(update, 1000)
    end,

    dom.svg.style {[[
svg {
  width: 100vw;
  height: 100vh;
}
.shape {
  fill: #000000;
  fill-opacity: 0;
  stroke: #000000;
  stroke-width: 1.968;
  stroke-dasharray: none;
  stroke-opacity: 1;
}
.hand {
  transform-origin: 50% 50%;
}
    ]]},

    dom.svg.g {
      id = 'layer1',

      makeCircle('face', 148.5, 148.5, 147.451),
      makeCircle('center', 148.5, 148.5, 2.3),

      bigNumber('num-6', 141.61128, 239.64572, 0),
      bigNumber('num-9', 141.61127, -57.354279, 90),
      bigNumber('num-3', 141.61128, -285.8851, 90),
      bigNumber('num-12', 141.61128, 11.114912, 0),

      smallNumber('num-2', 198.96527, -190.99893, 60),
      smallNumber('num-1', 198.96527, -82.28933, 30),
      smallNumber('num-11', 50.465305, 66.210663, -30),
      smallNumber('num-10', -58.244263, 66.210663, -60),
      smallNumber('num-8', -206.74426, -82.289352, -120),
      smallNumber('num-7', -206.74426, -190.99887, -150),
      smallNumber('num-5', -58.244244, -339.4989, 150),
      smallNumber('num-4', 50.465256, -339.49887, 120),

      dom.svg.rect {
        id = 'minute',
        class = 'shape hand',
        width = 9.154892,
        height= 139.56088,
        x= 143.92256,
        y= 13.650056,
        ry= 4.7802553,
      },

      dom.svg.rect {
        id = 'hour',
        class = 'shape hand',
        width = 9.154892,
        height = 78.081001,
        x = 143.92256,
        y = 75.174149,
        ry= 4.7802553,
      },
    },
  }
end

return makeClock()