local api_ui = require("dbee").api.ui
local utils = require "dbee.utils"
local tools = require "dbee.layouts.tools"

--- @class Elayout
--- @field private is_opened boolean
--- @field private windows integer[]
local Elayout = {}

--- @return Elayout
function Elayout:new()
  --- @type Elayout
  local layout = {
    is_opened = false,
    windows = {},
  }
  -- setmetatable(layout, self)
  -- self.__index = self
  return layout
end

function Elayout:is_open() 
  return self.is_opened
end
function Elayout:open() end
function Elayout:reset() end
function Elayout:close() end
