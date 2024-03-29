--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2022-04-02 21:54:35
]]
NewHallowsStudyWindow = NewHallowsStudyWindow or BaseClass(BaseView)

local controller = HallowsController:getInstance()
function NewHallowsStudyWindow:__init()
    self.win_type = WinType.Full
    self.res_list = {
		{path = PathTool.getPlistImgForDownLoad("hallows", "hallows"), type = ResourcesType.plist},
        -- {path = PathTool.getPlistImgForDownLoad("hallows", "new_hallows"), type = ResourcesType.plist},
		{path = PathTool.getSingleImgForDownLoad("bigbg","hl_bigbg_76"), type = ResourcesType.single},
        {path = PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_77"), type = ResourcesType.single}, --底桌
        {path = PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_78"), type = ResourcesType.single}, --圆
        {path = PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_79"), type = ResourcesType.single}, --2级背景图
        {path = PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_101"), type = ResourcesType.single},} --
    self.layout_name = "hallows/new_hallows_study_window"
end

function NewHallowsStudyWindow:configUi()

    self.background = self.root_wnd:getChildByName("background")
    self.background:setScale(display.getMaxScale())
    self.background:loadTexture(PathTool.getSingleImgForDownLoad("bigbg","hl_bigbg_76"), LOADTEXT_TYPE)

    self.layout_top = self.root_wnd:getChildByName("layout_top")
    self.layout_bottom_left = self.root_wnd:getChildByName("layout_bottom_left")
    self.layout_bottom_right = self.root_wnd:getChildByName("layout_bottom_right")


    self:playEnterAnimatianByObj(self.layout_top, 1)
    
    self.panel_effect = self.layout_top:getChildByName("panel_effect") --特效icon容器
    self.panel_star = self.layout_top:getChildByName("panel_star") --升星点亮的圆圈容器

    self.image_2 = self.layout_top:getChildByName("image_2")
    self.image_3 = self.layout_top:getChildByName("Image_3")
    self.image_4 = self.layout_top:getChildByName("image_4")
    self.image_2:setVisible(false)
    self.image_3:setVisible(false)
    -- self.image_2:loadTexture(PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_78"), LOADTEXT_TYPE)
    -- self.image_3:loadTexture(PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_77"), LOADTEXT_TYPE)
    self.image_4:loadTexture(PathTool.getSingleImgForDownLoad("hallows","hl_bigbg_101"), LOADTEXT_TYPE)

    self.sp_icon = self.layout_top:getChildByName("sp_icon")
    self.sp_icon:setVisible(false)

    self.sp_select = self.layout_bottom_right:getChildByName("sp_select") --按钮的选中图片
    self.sp_select:setVisible(false)
    self.btn_close = self.layout_bottom_left:getChildByName("btn_close")

    self.node_content = self.layout_top:getChildByName("node_content") --存放 各个功能的容器

    --顶部标签
    self.sp_top_tag = self.layout_top:getChildByName("sp_top_tag")
    local name = self.sp_top_tag:getChildByName("lbl_name")
    local des = self.sp_top_tag:getChildByName("lbl_des")
    -- self.lbl_name = name
    -- name:setString("修\n罗\n+\n10")
    -- des:setString("杀\n气\n杀\n气\n\n血\n战\n血\n战")
    name:setVisible(false)
    des:setVisible(false)

    
    self.lbl_name1 = cc.Label:createWithTTF("",TITLE_FONT,20)--createRichLabel(22,cc.c3b(98,53,43),cc.p(0.5,0.5),cc.p(53,150),nil,1,20,TITLE_FONT) --
    
    self.lbl_name1:setDimensions(20,200)
    self.lbl_name1:setTextColor(cc.c3b(98,53,43))
    self.lbl_name1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.lbl_name1:setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.lbl_name1:setPosition(53,158)
    -- self.lbl_name1:setString("修罗神装+10")
    self.lbl_des1 = createRichLabel(20,cc.c3b(129,104,65),cc.p(0,1),cc.p(7,248),-3,nil,20,TITLE_FONT)
    self.lbl_des1:setString(TI18N("杀气反杀"))
    local des1_size = self.lbl_des1:getSize()
    local next_height = des1_size.height+72
    self.lbl_des2 = createRichLabel(20,cc.c3b(129,104,65),cc.p(0,1),cc.p(7,next_height),-1,nil,20,TITLE_FONT)
    self.lbl_des2:setString(TI18N("血战到底"))
    self.sp_top_tag:addChild(self.lbl_des1)
    self.sp_top_tag:addChild(self.lbl_des2)
    self.sp_top_tag:addChild(self.lbl_name1)

    local tips_des = "注：布阵界面，神器上阵后上阵技能对队伍生效。未上阵的神器庇护技能生效。"
    self.lbl_tips_des = createRichLabel(22, cc.c3b(189,81,16),cc.p(0,1),cc.p(140,205),5,nil,450,DEFAULT_FONT)
    self.lbl_tips_des:setString(tips_des)
    self.layout_top:addChild(self.lbl_tips_des)


    self.cur_click_idx = 1
    self.node_list = {} --存放节点 （详情，强化，升星）
    self.btn_list = {}
    self.circle_list = {} -- 存放圆圈图片
    self.circle_position_list = {cc.p(170.7,114.8),cc.p(225.8,323.68),cc.p(502.68,323.68),cc.p(552.6,114)}
    for i=1,3 do
        self.btn_list[i] = self.layout_bottom_right:getChildByName(string.format("btn_%d",i))
    end
end

--创建亮的圆图片
function NewHallowsStudyWindow:createLightCircleImg()
    local res = PathTool.getResFrame("hallows","hl_artifact_0013")
    for i=1,4 do
        local node = self.circle_list[i]
        local pos = self.circle_position_list[i]
        if not node then
            local node_circle = createSprite(res,pos.x,pos.y,self.panel_star,cc.p(0.5,0.5),LOADTEXT_TYPE_PLIST)
            self.circle_list[i] = node_circle
        end
    end
end

function NewHallowsStudyWindow:register_event()
    for i=1,3 do
        registerButtonEventListener(self.btn_list[i],handler(self,self.onBtnTouched))
    end
    registerButtonEventListener(self.btn_close,function() controller:openHallowsStudyWindow(false) end)

    -- -- 更新研究的界面数据 （详情，强化，升星） HallowsEvent.HallowsStudyDataEvent
    -- self:addGlobalEvent(HallowsEvent.HallowsAdvanceEvent, function ()
    -- 	self:updateContent()
    -- end)
    --请求初始化之后的刷新（如果24101返回单条神器数据就用上面那个事件）
    self:addGlobalEvent(HallowsEvent.HallowsInitDataEvent, function ()
    	self:updateContent()
    end)
end
--处理界面ui信息
function NewHallowsStudyWindow:open_callback()
    self:configUi()
    self:createLightCircleImg()
end
--请求初始化数据 itemData点击外面的神器传过来的数据
function NewHallowsStudyWindow:openRootWnd(itemData)
    self.shallows_id = itemData.id --这个是服务器传过来的hallows_data表里的id 不是道具id
    self.item_id = itemData.item_id  --这个才是道具id
    self.itemData = itemData

    self:updateContent(itemData)
    self:updateStarCircle()
end

--更新界面内容
function NewHallowsStudyWindow:updateContent()
    local itemData = self.itemData
    -- self.hallows_data = controller:getModel():getHallowsList() --获得所有神器数据
    local data = controller:getModel():getHallowsById(self.shallows_id)  --获取当前神器的数据

    self.curHallowsData = clone(data)
    self.curHallowsData.item_id = self.item_id --这个才是道具id
    self.curHallowsData.quality = itemData.quality
    self.curHallowsData.effect = itemData.effect
    self.lbl_tips_des:setVisible(self.cur_click_idx == 1)
    self:updateBtnStatus()
    self:updateCommonData()
    self:updateNode()
end

--只有升星时候才会更新这个圆圈
function NewHallowsStudyWindow:updateStarCircle()
    local cur_star_lv = self.curHallowsData.skill_lev%5 or 0

    print("=======cur_star_lv===",cur_star_lv)
    for i=1,4 do
        self.circle_list[i]:setVisible(i<=cur_star_lv)
    end
end

--更新三个模块共同的数据"Ⅰ、Ⅱ、Ⅲ、Ⅳ、Ⅴ、Ⅵ、Ⅶ、Ⅷ、Ⅸ、Ⅹ、Ⅺ、Ⅻ、XIII、XIV、XV、XVI、XVII、XVIII、XIX、XX"
local star_enum = {"Ⅰ","Ⅱ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅸ","Ⅹ","Ⅺ","Ⅻ","XIII","XIV","XV","XVI","XVII","XVIII","XIX","XX"}
function NewHallowsStudyWindow:updateCommonData()
    --获取道具表里的icon  后面如果使用特效就直接用hallows_data里面的effect创建特效就行
    local item_data = Config.ItemData.data_get_data(self.curHallowsData.item_id)

    local hallows_info = Config.HallowsData.data_base[self.curHallowsData.id]  --hallows_data里的基本信息 (里面的effect创建特效就行)

    self.lbl_name1:setString(hallows_info.name..star_enum[self.curHallowsData.skill_lev].."+"..self.curHallowsData.step) --富文本

    -- -- 神器icon
    -- local icon = PathTool.getSkillRes(item_data.icon)
    -- self.sp_icon:loadTexture(icon,LOADTEXT_TYPE)
    -- local x,y = self.sp_icon:getPosition()
    -- self.sp_icon:setScale(2)

     --icon特效
     if not self.icon_effect then
        print("=====特效名字======",hallows_info.effect)
        local effect_name = hallows_info.effect
        local x,y = self.sp_icon:getPosition()
        local effect = createEffectSpine(effect_name,cc.p(90,-25),cc.p(0.5,0.5),true,PlayerAction.action_1)
        self.panel_effect:addChild(effect)
        self.icon_effect = effect
    end

    if self.cur_click_idx~=3 then return end --下面是刷新升星时候才会改变的圆圈图

    self:updateStarCircle()
end

--更新选中图片位置
function NewHallowsStudyWindow:updateBtnStatus()
    local node = self.btn_list[self.cur_click_idx]
    local res = PathTool.getResFrame("hallows","hl_artifact_0014") --亮

    for i=1,3 do
        local node1 = self.btn_list[i]
        node1:loadTextures(res,res,res,LOADTEXT_TYPE_PLIST)
        node1:getChildByName("Text_"..i):setTextColor(cc.c3b(239,212,174))
    end
    res = PathTool.getResFrame("hallows","hl_artifact_0015") --暗
    node:loadTextures(res,res,res,LOADTEXT_TYPE_PLIST)
    node:getChildByName("Text_"..self.cur_click_idx):setTextColor(cc.c3b(250,232,150))
    local x,y = node:getPosition()

    self.sp_select:setPosition(cc.p(x,y))
end

--更新不同节点信息数据  1 详情  2 强化  3 升星
function NewHallowsStudyWindow:updateNode()
    local node = self.node_list[self.cur_click_idx]
    -- local data =  --获取对应的节点数据
    if not node then
        if self.cur_click_idx == 1 then
            node = NewHallowsDetialNode:new()  --详情
        elseif self.cur_click_idx == 2 then
            node = NewHallowsStrengthenNode:new()  --强化
        elseif self.cur_click_idx == 3 then
            node = NewHallowUpStarNode:new()  --升星
        end
        if not node then return end
        self.node_list[self.cur_click_idx] = node
        self.node_content:addChild(node)
        node:setPosition(cc.p(115,40))
    end
    node:setVisible(true)
    node:setData(self.curHallowsData) --data
end










-------------------------------onTouched-----------------------------
function NewHallowsStudyWindow:onBtnTouched(params,sender)
    local name = sender:getName()
    local list = string.split(name,"_")
    local idx = list[2]

    self:onClickBtnByIdx(tonumber(idx))
end

function NewHallowsStudyWindow:onClickBtnByIdx(idx)
    if self.cur_click_idx == idx then return end
    local node = self.node_list[self.cur_click_idx]
    if node then node:setVisible(false) end --隐藏上一次显示的节点

    self.cur_click_idx = idx
    print("========onClickBtnByIdx===当前点击的按钮idx==",self.cur_click_idx)
    self:updateContent()
end