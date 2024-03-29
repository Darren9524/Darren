---------------------------------
-- @description: 区场景建筑
---------------------------------
local _leagueexplore_ctrl = LeagueExploreController:getInstance()
local _string_format = string.format

BattleNationalWarQiZhiItem = BattleNationalWarQiZhiItem or BaseClass()

function BattleNationalWarQiZhiItem:__init(data, area_type)
	self.data = data or {}
	self.area_type = 1
	self.can_click = false
	self.is_build = true
	self:createRootwnd()
end

function BattleNationalWarQiZhiItem:createRootwnd()
    self.size = cc.size(50, 50)
	self.root = ccui.Widget:create()
	self.root:setAnchorPoint(0.5, 0.5)
	self.root:setContentSize(self.size)
    
	local offset_x = self.data.name_x or 0
	local offset_y = self.data.name_y or 0
	self.qizhi_bg = createImage(self.root, PathTool.getResFrame("nationalwar", "hl_national_war_0022"), offset_x, offset_y, cc.p(0.5, 0.5), true, 9, true)
	self.qizhi_bg:setContentSize(cc.size(65, 65))
	self.qizhi_bg:setTouchEnabled(true)
	registerButtonEventListener(self.qizhi_bg, handler(self, self.onClickBuild), true)

    
	
end



function BattleNationalWarQiZhiItem:onClickBuild()
	local role_vo = RoleController:getInstance():getRoleVo()


end

function BattleNationalWarQiZhiItem:setParentWnd(parent)
	if tolua.isnull(parent) then return end
	self.parent_wnd = parent
	if self.data ~= nil then
		self.root:setPosition(self.data.x, self.data.y)
		self.parent_wnd:addChild(self.root, 1)
	end
end




function BattleNationalWarQiZhiItem:setBaseData(data)
	print("------------self.bid ------",self.bid)

    local res = PathTool.getResFrame("nationalwar", "hl_national_war_0021") -- 红
	if self.bid <=3 then 
		res = PathTool.getResFrame("nationalwar", "hl_national_war_0021")
	elseif self.bid>3 and self.bid <=6 then 
		res = PathTool.getResFrame("nationalwar", "hl_national_war_0022")
	else
		res = PathTool.getResFrame("nationalwar", "hl_national_war_0023") --蓝
	end

	self.qizhi_bg:loadTexture(res,LOADTEXT_TYPE_PLIST)


end

function BattleNationalWarQiZhiItem:getData()
	return self.data
end

function BattleNationalWarQiZhiItem:getRoot()
	return self.root
end

function BattleNationalWarQiZhiItem:__delete()
    if self.build_load then
        self.build_load:DeleteMe()
        self.build_load = nil
	end
	if self.effect then
		self.effect:setVisible(false)
		self.effect:clearTracks()
		self.effect:runAction(cc.RemoveSelf:create(true))
	end
	if self.root:getParent() then
		self.root:removeAllChildren()
		self.root:removeFromParent()
	end
end