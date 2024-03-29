--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2022-04-18 14:45:21
]] -- arena_loop_match_window1
ArenaLoopMatchWindow1 = ArenaLoopMatchWindow1 or BaseClass(BaseView)


local controller = ArenaController:getInstance() 
local model = ArenaController:getInstance():getModel()

function ArenaLoopMatchWindow1:__init()

    self.win_type = WinType.Full
    self.default_type = 0

    self.title_str = TI18N("竞技场")

    --结算跳转回来这里的用途 
    self.check_class_name = "ArenaLoopMatchWindow1" 
    self.layout_name = "arena/arena_loop_match_window1"
    self.panel_list = {}
    self.tab_btn_list = {}
    self.res_list = {
        {path = PathTool.getPlistImgForDownLoad("arena", "arenaloop"), type = ResourcesType.plist},
        {path = PathTool.getPlistImgForDownLoad("common", "common"), type = ResourcesType.plist},
    }

    self.tab_info_list = {
        -- {label = TI18N("邀请帖"), index = ArenaConst.loop_index.challenge, status = true,no_show = true},
        {label = TI18N("排行榜"),index = ArenaConst.loop_index.rank, status = RankController:getInstance():checkRankIsShow(), notice = string.format(TI18N("%d级开启"), RankConstant.limit_open_lev)},
        {label = TI18N("赛季奖"),index = ArenaConst.loop_index.awards, status = true},--TI18N("日常\n奖励")
        {label = TI18N("每日奖"),index = ArenaConst.loop_index.activity, status = true},--TI18N("排名\n奖励")
        {label = TI18N("记录"),index = ArenaConst.loop_index.record, status = true},
    }

    self.background_path = "resource/bigbg/hl_bigbg_54.png"

end

function ArenaLoopMatchWindow1:open_callback()
    self.background = self.root_wnd:getChildByName("background")
    self.background:setScale( display.getMaxScale())

    self.main_container = self.root_wnd:getChildByName("main_container")
    self:playEnterAnimatianByObj(self.main_container , 1)
    self.main_panel = self.main_container:getChildByName("main_panel")
    self.panel_content = self.root_wnd:getChildByName("panel_content")

    self.layout_bottom = self.root_wnd:getChildByName("layout_bottom") --底部适配容器
    self.layout_right = self.root_wnd:getChildByName("layout_right") --右边适配
    self.layout_top = self.root_wnd:getChildByName("layout_top") --顶部适配

    self.tab_container = self.layout_top:getChildByName("tab_container")

    self.close_btn = self.layout_bottom:getChildByName("close_btn")
    self.challenge_shop = self.layout_right:getChildByName("challenge_shop")
    self.protect_btn = self.layout_right:getChildByName("protect_btn")

    self:initAllTabs()
    self:initChallagePanel()
end

function ArenaLoopMatchWindow1:getRecordStatus()
    --获取记录状态 是否显示
    local status = model:getLoopMatchRedStatus(ArenaConst.red_type.loop_log)
    return status
end

function ArenaLoopMatchWindow1:openRootWnd(type)
    -- 判断活跃宝箱标签是否要显示红点
    self:checkActivityStstus()
end

--该界面调整为常驻
function ArenaLoopMatchWindow1:initChallagePanel()
    local panel = ArenaLoopChallengePanel1.new()
    panel:addToParent()
    panel:setNodeVisible(true)
    panel:updatePanelInfo(false)
    self.panel_challange = panel
    self.main_panel:addChild(panel)
end

function ArenaLoopMatchWindow1:selectedTabCallBack(index)
    self:changeTabPanel(index)
end
-- =========================测试用=======================-------------
function ArenaLoopMatchWindow1:changeTabPanel(index)
    if self.cur_panel ~= nil then
        self.cur_panel:setNodeVisible(false)
        self.cur_panel = nil
    end
    self.cur_type  = index
    self.cur_panel = self.panel_list[index]
    if self.cur_panel == nil then
        if index == ArenaConst.loop_index.activity then
            self.cur_panel = ArenaLoopActivityPanel.new()
        elseif index == ArenaConst.loop_index.rank then
            self.cur_panel = ArenaLoopRankPanel.new()
        elseif index == ArenaConst.loop_index.awards then
            self.cur_panel = ArenaLoopAwardsPanel.new()
        elseif index == ArenaConst.loop_index.record then
            self.cur_panel = ArenaLoopMyLogWindow1.new()
        end
        self.panel_list[index] = self.cur_panel
        self.panel_content:addChild(self.cur_panel)
        if self.cur_panel.addToParent then
            self.cur_panel:addToParent()
        end
    end
    self:enableShowCurPanel(true)
    -- if self.cur_panel ~= nil then
    --     self.cur_panel:setNodeVisible(true)
    --     if self.cur_panel.updatePanelInfo then
    --         self.cur_panel:updatePanelInfo(false)
    --     end
    -- end
    
    -- self:setNodeVisible()
end

function ArenaLoopMatchWindow1:enableShowCurPanel(enable)

    if self.cur_panel == nil then return end

    self.cur_panel:setNodeVisible(enable)
    if not enable then return end

    if self.cur_panel.updatePanelInfo then
        self.cur_panel:updatePanelInfo(false)
    end
    
end
-- =========================非layer end=========================-------------




-- function ArenaLoopMatchWindow1:changeTabPanel(index)
--     if index == ArenaConst.loop_index.activity then
--         controller:openArenaLoopActivityWindow(true)
--     elseif index == ArenaConst.loop_index.rank then
--         controller:openArenaLoopRankWindow(true)
--     elseif index == ArenaConst.loop_index.awards then
--         controller:openArenaLoopAwardWindow(true)
--     elseif index == ArenaConst.loop_index.record then
--         controller:openArenaLoopMyLogWindow(true)
--         model:updateArenaLoopLogStatus(FALSE)
--     end
-- end

--[[
@desc:针对需要根据自身信息做更新的面板
author:{author}
time:2018-05-14 21:43:04
--@key:
--@value: 
return
]]
function ArenaLoopMatchWindow1:updateMyInfoData()
    --重置 页签点击状态  一个都不选中
    self:setSelecteTab(self.default_type)
    self:enableShowCurPanel(false)
end

--[[
@desc:添加宝箱标签页红点，以及如果是当前标签，则更新相关数据的
author:{author}
time:2018-05-14 21:43:19
return
]]

function ArenaLoopMatchWindow1:checkActivityStstus(type, status)
    if type == nil then
        local red_status = model:getLoopMatchRedStatus(ArenaConst.red_type.loop_artivity)
        self:setTabTips(red_status, ArenaConst.loop_index.activity)
    else
        if type == ArenaConst.red_type.loop_challenge then

        elseif type == ArenaConst.red_type.loop_artivity then
            self:setTabTips(status, ArenaConst.loop_index.activity)
        end
    end
end

function ArenaLoopMatchWindow1:beforeClose()
    controller:openArenaEnterWindow(true)
end

function ArenaLoopMatchWindow1:close_callback()
    -- 还原ui战斗类型
    MainuiController:getInstance():resetUIFightType()
    EventManager:getInstance():UnBind(self)
    if self.panel_challange then
        self.panel_challange:DeleteMe()
        self.panel_challange = nil
    end
end













function ArenaLoopMatchWindow1:register_event()
    EventManager:getInstance():Bind(ArenaEvent.UpdateLoopTabStatus,self, function(key, value)
            self:updateMyInfoData(key, value)
        end)
    EventManager:getInstance():Bind(ArenaEvent.UpdateArenaRedStatus,self, function(type, status)
            self:checkActivityStstus(type, status)
        end)


    registerButtonEventListener(self.protect_btn, function()
            HeroController:getInstance():openFormMainWindow(true, PartnerConst.Fun_Form.Arena)
        end,true, 1)

    registerButtonEventListener(self.challenge_shop, function()
            MallController:getInstance():openMallPanel(true, MallConst.MallType.ArenaShop)
        end,true, 1)

    registerButtonEventListener(self.close_btn, function() self:close() end, true, 2)
end

function ArenaLoopMatchWindow1:initAllTabs()
    for i=1,4 do
        local btn_tab = self.tab_container:getChildByName("tab_btn_"..i)
        local info = self.tab_info_list[i]
        btn_tab:setName("tab_btn_" .. i)
        btn_tab.tips = btn_tab:getChildByName("tab_tips")
        btn_tab.red_num = btn_tab:getChildByName("red_num")  --要显示出红点跟次数
        btn_tab.select_bg = btn_tab:getChildByName("select_bg")
        btn_tab.unselect_bg = btn_tab:getChildByName("unselect_bg")

        btn_tab.notice = info.notice or ""
        btn_tab.label = btn_tab:getChildByName("title")
        btn_tab.label_un = btn_tab:getChildByName("title_1")
        btn_tab.label:setString(info.label)

        btn_tab.index = info.index

        btn_tab.select_bg:setVisible(false)
        btn_tab.unselect_bg:setVisible(true)

        if btn_tab.label_un then
            btn_tab.label_un:setString(info.label)
            btn_tab.label:setVisible(false)
            btn_tab.label_un:setVisible(true)
        end

        btn_tab.tips:setVisible(false)
        if btn_tab.red_num then
            btn_tab.red_num:setVisible(false)
        end

        btn_tab.can_touch = info.status
        -- 如果不可点击,就灰掉吧
        if info.status == false then
            setChildUnEnabled(true, btn_tab, Config.ColorData.data_color4[1])
        end
        -- 添加注册监听事件
        btn_tab:addTouchEventListener(function(sender, event_type)
            if event_type == ccui.TouchEventType.ended then
                playTabButtonSound()
                if sender.can_touch == false then
                    message(sender.notice)
                else
                    self:setSelecteTab(sender.index)
                end
            end
        end)
        self.tab_btn_list[i] = btn_tab
    end
end