local js = require 'js'
local dom = require 'dom'

local resumeLink = 'https://drive.google.com/file/d/17Bk3zN2aE3yDxVm-nsd9vvUJy_mEEgdt/view?usp=drive_link'

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
  updateHand('text1', seconds, 60)
end

local function newTabLink(text, href)
  return dom.svg.a {href=href, target="_blank", rel="noopener noreferrer", text}
end

return function()
  return dom.svg {
    width = '297mm',
    height = '297mm',
    viewBox = '0 0 297 297',
    version = '1.1',
    id = 'clock',

    oncreate = function(el)
      dom.setInterval(update, 1000)
      update()
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
.outlinetext {
  font-style: normal;
  font-variant: normal;
  font-weight: normal;
  font-stretch: normal;
  font-size: 25.4px;
  font-family: Arial Rounded MT Bold;
  text-align: start;
  writing-mode: lr-tb;
  direction: ltr;
  text-anchor: start;
  white-space: pre;
  shape-padding: 3.49421;
  display: inline;
  fill: #000000;
  fill-opacity: 0;
  stroke: #000000;
  stroke-width: 1.96797;
  stroke-linejoin: round;
  stroke-dasharray: none;
}
    ]]},

    dom.svg.g {
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

      dom.svg.text {
        id = 'text1',
        class = 'outlinetext hand',
        
        dom.svg.textPath {
          href='#path2',
          id="textPath2",
          'Ian Wells',
          dom.svg.tspan {
            style= {
              fontSize = '16.9333px',
            },
            id="tspan4",
            ' ... ',
            newTabLink('résumé', resumeLink),
            ' ... ',
            newTabLink('github', 'http://github.com/i-am-wells'),
            ' ... ',
            --dom.svg.a {href="http://google.com/", 'misc'},
            --' ... ',
          }
        }
      },

      dom.svg.path {
        id = 'path2',
        style = {
          fillOpacity = 0,
          stroke = '#000000',
          strokeWidth = 0,
          strokeLinejoin = 'round',
          strokeDasharray = 'none',
        },
        d = 'M 208.51786,148.5 A 60.017864,60.017864 0 0 1 148.5,208.51786 60.017864,60.017864 0 0 1 88.482136,148.5 60.017864,60.017864 0 0 1 148.5,88.482136 60.017864,60.017864 0 0 1 208.51786,148.5 Z',
      },
    },
  }
end