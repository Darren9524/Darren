-- --------------------------------------------------------------------
-- @description:
--      弹劾面板
--
-- --------------------------------------------------------------------
GuildImpeachPostWindow = GuildImpeachPostWindow or BaseClass(BaseView)

local controller = GuildController:getInstance()

function GuildImpeachPostWindow:__init()
	self.view_tag = ViewMgrTag.DIALOGUE_TAG
	
	self.win_type = WinType.Mini
	self.set_index = 1
	self.condition_index = 1
	self.layout_name = "guild/guild_impeach_post_window"
end 

function GuildImpeachPostWindow:open_callback()
    self.background = self.root_wnd:getChildByName("background")
    self.background:setScale(display.getMaxScale()) 
    
    local container = self.root_wnd:getChildByName("container")
    
    self:playEnterAnimatianByObj(container, 2)
    container:getChildByName("title_con"):getChildByName("title_label"):setString(TI18N("管理设置"))
    self._notice = container:getChildByName("notice")
    self.close_btn = container:getChildByName("close_btn")

    self._btnImpeach = container:getChildByName("impeach_btn")              -- 弹劾帮主
    self._btnImpeach:getChildByName("label"):setString(TI18N("弹劾"))
    self._spriteDiamond = self._btnImpeach:getChildByName("spriteDiamond")
    self._textDiamond = self._btnImpeach:getChildByName("textDiamond")
    self._textDiamond:setString(50)
end

function GuildImpeachPostWindow:register_event()
    self.close_btn:addTouchEventListener(function(sender, event_type)
        if event_type == ccui.TouchEventType.ended then
            playQuitSound()
            controller:openGuildImpeachPostWindow(false)
        end
    end)
    registerButtonEventListener(self.background, function()
        controller:openGuildImpeachPostWindow(false)
    end ,false, 2)
    
    self._btnImpeach:addTouchEventListener(function(sender, event_type)
        customClickAction(sender, event_type)
        if event_type == ccui.TouchEventType.ended then
            playCommonButtonSound()
            controller:send13565()
            controller:openGuildImpeachPostWindow(false)
        end
    end)
end

function GuildImpeachPostWindow:openRootWnd()
    if self._notice then
        self._notice:setString(TI18N("该会长决心归隐田园，现急需有志之士担当公会重任。弹劾会长后，您将成为新的会长。"))
    end
    local res = string.format("resource/item/%d.png", Config.GuildData.data_const.impeach_gold.val[1][1])
    local sprite = createSprite(res, 80, 23, self._btnImpeach,cc.p(0.5,0.5),LOADTEXT_TYPE)
    sprite:setScale(0.25)

    self._textDiamond:setString(Config.GuildData.data_const.impeach_gold.val[1][2])
end

function GuildImpeachPostWindow:close_callback()
    controller:openGuildImpeachPostWindow(false)
end