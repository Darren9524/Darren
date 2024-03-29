-- --------------------------------------------------------------------
-- @description:
--      灵身面板
-- <br/> 2018年11月20日
-- --------------------------------------------------------------------
HeroMainTabBodyPanel =
    class(
    "HeroMainTabBodyPanel",
    function()
        return ccui.Widget:create()
    end
)

local string_format = string.format
local controller = HeroController:getInstance()
local model = controller:getModel()
local table_insert = table.insert
local role_vo = RoleController:getInstance():getRoleVo()

function HeroMainTabBodyPanel:ctor()
    self:config()
    self:initData()
    self:layoutUI()
    self:registerEvents()
end

function HeroMainTabBodyPanel:config()
    --神器解锁条件
    self.artifact_lock_list = model.artifact_lock_list
end

--初始化一些数据
function HeroMainTabBodyPanel:initData()
    self.starList = {}  --星星图片数据列表

    self.lv_attr_panels = {}
    self.lv_txts= {}

    self.lv_attr_scroll = {}
    self.lv_attr_txt = {}
    self.strong_btns = {}

    self.tab_list = {}

    
    self.change = false
    self.act = false
    self.max_level=100
    self.max_star=10
end

function HeroMainTabBodyPanel:layoutUI()
    local csbPath = PathTool.getTargetCSB("hero/hero_main_tab_body_panel")
    self.root_wnd = createCSBNote(csbPath)
    self:addChild(self.root_wnd)

    --读取文件的大小
    self.size = self.root_wnd:getContentSize()
    self:setContentSize(self.size)

    self.full_lable= self.root_wnd:getChildByName("full_lable")
    self.full_lable:setString("")
    self.star_panel = self.root_wnd:getChildByName("star_panel")
    self.star_btn = self.star_panel:getChildByName("star_btn")
    self.background = self.root_wnd:getChildByName("background")

    --当前等级属性和下级属性容器
    self.lv_attr_panel = self.root_wnd:getChildByName("lev_attr_panel") 
    self.lv_attr_panels[1] = self.lv_attr_panel:getChildByName("left_back")
    self.lv_attr_panels[2] = self.lv_attr_panel:getChildByName("right_back")
    self.lv_txts[1] = self.lv_attr_panels[1]:getChildByName("name")
    self.lv_txts[2] = self.lv_attr_panels[2]:getChildByName("name")

    -- 星级图片数量显示容器
    self.starNum_panel = self.root_wnd:getChildByName("startNum_panel")

    --详情
    self.tab_panel = self.root_wnd:getChildByName("tab_panel")
    self.btn_act = self.tab_panel:getChildByName("btn_act")
    self.status_back = self.tab_panel:getChildByName("status_back")
    self.attrTitle = self.status_back:getChildByName("title")
    self.skill_back = self.root_wnd:getChildByName("skill_back")
    self.skillTitle = self.skill_back:getChildByName("title")

    self.attr_scrollview = createScrollView(650, 100, 0, 0, self.status_back, ccui.ScrollViewDir.vertical) --属性描述列表容器
    self.unAct_panel = self.skill_back:getChildByName("unAct_panel")
    self.skill_scrollview = createScrollView(650, 240, 0, 40, self.skill_back, ccui.ScrollViewDir.vertical) --技能加成列表容器

    --强化
    self.strong_panel = self.root_wnd:getChildByName("strong_panel")
    self.strong_down_panel = self.strong_panel:getChildByName("down_back")
    self.lv_lable = self.strong_down_panel:getChildByName("lv_lable")
    for i = 1, 2 do
        self.lv_attr_scroll[i] = createScrollView(226, 130, 0, 16, self.lv_attr_panels[i], ccui.ScrollViewDir.vertical)
        self.lv_attr_txt[i] = createRichLabel(22, cc.c4b(0x4a, 0x23, 0x1c, 0xff), cc.p(0, 0.5), cc.p(50, 130), 0, 0, 200)
        self.lv_attr_scroll[i]:addChild(self.lv_attr_txt[i])

        self.strong_btns[i] = self.strong_down_panel:getChildByName("strong_btn_" .. i)
    end

    -- 详情 强化 升星 页签容器
    local tab_btn_obj = self.root_wnd:getChildByName("tab_btn")
    for i = 1, 3 do
        local tab_btn = {}
        local item = tab_btn_obj:getChildByName("tab_btn_" .. i)
        tab_btn.btn = item
        tab_btn.index = i
        tab_btn.select_bg = item:getChildByName("select_img")
        tab_btn.select_bg:setVisible(false)
        tab_btn.red_point = item:getChildByName("red_point")
        tab_btn.red_point:setVisible(false)
        self.tab_list[i] = tab_btn
    end

    self.detale_RlableBgs = {}
    for i = 1, 8 do
        local x=480-(i%2)*315
        local y=200-math.ceil(i/2)*46
        self.detale_RlableBgs[i] = createScale9Sprite(PathTool.getResFrame("hero", "hl_hero_1020"),x, y, LOADTEXT_TYPE_PLIST, self.attr_scrollview)
        self.detale_RlableBgs[i]:setAnchorPoint(cc.p(0.5, 0.5))
        self.detale_RlableBgs[i]:setContentSize(cc.size(220, 26))
        self.detale_RlableBgs[i]:setName("back_" .. i)
    end

    self:changeTabType(1)
end
-- function HeroMainTabBodyPanel:creat_attrItem()
-- end

-- function HeroMainTabBodyPanel:updatePower()
--     self.fight_label:setNum(self.hero_vo.power)
-- end

-- -- 重置不同页签内容的位置和大小
-- function HeroMainTabBodyPanel:resetPanelPosAndSize(index)
--     local pos_skill_back = index==1 and cc.p(35, 512) or (index==3 and cc.p(35, 474) or cc.p())
--     local pos_unAct_panel = index==1 and cc.p(0, 40) or (index==3 and cc.p(0, 15) or cc.p())
--     local pos_skill_scrollview = index==1 and cc.p(0, 40) or (index==3 and cc.p(0, 0) or cc.p())

--     self.skill_back:setPosition(pos_skill_back)
--     self.skill_back:setContentSize(cc.size(650,363))
--     self.unAct_panel:setPosition(pos_unAct_panel)
--     self.skill_scrollview:setPosition(pos_skill_scrollview)
-- end

-- @_type 参考 HeroConst.MainInfoTab 定义
function HeroMainTabBodyPanel:changeTabType(index)
    if self.cur_tab_index == index then return end
    if index > 1 and self.act == false then
        TipsManager:getInstance():showCommonTips("激活后开启", cc.p(self.size.width * 0.5, self.size.height * 0.5), 25, 0.5, 300, true)
        return
    end

    self.cur_tab_index = index

    --隐藏上一次的页签选中背景图
    if self.cur_tab ~= nil then self.cur_tab.select_bg:setVisible(false) end 
    self.cur_tab = self.tab_list[self.cur_tab_index]
    --显示当前页签选中图
    if self.cur_tab ~= nil then self.cur_tab.select_bg:setVisible(true) end

    self.full_lable:setString("")
    self.tab_panel:setVisible(index == 1) --详情
    self.strong_panel:setVisible(index == 2) --强化
    self.star_panel:setVisible(index == 3) --升星
    self.skill_back:setVisible(index ~= 2)
    self.lv_attr_panel:setVisible(index ~= 1)

    if index == 1 then
        self:showDetail(self.hero_vo)
    elseif index == 2 then
        self:showStrong(self.hero_vo)
    elseif index == 3 then
        self:showUpStar(self.hero_vo)
    end

    --处理红点
    --self:updatePageRedPoint()
end

--事件
function HeroMainTabBodyPanel:registerEvents()
    for index, tab_btn in ipairs(self.tab_list) do
        registerButtonEventListener(
            tab_btn.btn,
            function()
                self:changeTabType(index)
            end,
            false,
            1
        )
    end

    registerButtonEventListener(
        self.btn_act,
        function()
            self:onClickActBtn()
        end,
        true
    )
    for index, btn in ipairs(self.strong_btns) do
        registerButtonEventListener(
            btn,
            function()
                self:onClickStrong_Btn(index)
            end,
            false,
            1
        )
    end
    registerButtonEventListener(
        self.star_btn,
        function()
            self:onClickStarBtn()
        end,
        true
    )
end

-- 更新一键穿戴/卸下按钮显示
function HeroMainTabBodyPanel:updateOneKeyBtnStatus()
end

-- 一键卸下
function HeroMainTabBodyPanel:onClickDischargeBtn()
    if not self.hero_vo then
        return
    end
    controller:sender11011(self.hero_vo.partner_id, 0)
end

function HeroMainTabBodyPanel:setData(hero_vo)
    if not hero_vo then
        return
    end
    self.hero_vo = hero_vo
    self:updateInfo(hero_vo)
    self:updateRedPoint()
    self:updateOneKeyBtnStatus()
end

function HeroMainTabBodyPanel:updateRedPoint()
    --按钮的红点
end

--更新每一个装备红点
function HeroMainTabBodyPanel:updateEachEquipRedPoint(equip_type)
    local equip_list = model:getHeroEquipList(self.hero_vo.partner_id)
    local item = self.equip_item_list[equip_type]
    local is_redpoint = HeroCalculate.checkSingleHeroEachPosEquipRedPoint(equip_type, equip_list[equip_type])
    item:showRedPoint(is_redpoint)
    return is_redpoint
end

function HeroMainTabBodyPanel:updateInfo(hero_vo)
    if not hero_vo then
        return
    end
    self.change = true
    self.act = hero_vo.spiritbody_level > 0  --0 未激活 否则 激活

    self.spriteId = controller:getHero_spiritbody_id(hero_vo)

    self.orignAttrConfig = Config.SpiritbodyData.data_spiritbody_init_info_fun(self.spriteId)
    if not hero_vo or self.change == false then
        return
    end
    self:setStarNum(hero_vo.spiritbody_star)

    if self.cur_tab_index == 1 then
        self:showDetail(hero_vo)
    elseif self.cur_tab_index == 2 then
        self:showStrong(hero_vo)
    else
        self:showUpStar(hero_vo)
    end
end

function HeroMainTabBodyPanel:showStrong(hero_vo)
    print("-----------------showStrongshowStrongshowStrong----------",hero_vo.spiritbody_level)
    local notFull=true
    local configs = Config.SpiritbodyData.data_spiritbody_strength_consume[self.spriteId]
    if configs and configs[hero_vo.spiritbody_level] then
        local consum = configs[hero_vo.spiritbody_level]
        if consum then
            self.strongMats=  self:addConsume(consum, self.strongMats, self.strongMatLables, self.strong_down_panel, 90, 80,130, 90)
        
        end
    end
    if not configs[hero_vo.spiritbody_level+1] then
        notFull=false
        self.full_lable:setString("已满级")
    end
    self.lv_attr_panel:setVisible(notFull)
    self.strong_down_panel:setVisible(notFull)
    if notFull==false then return end
     
    self.lv_lable:setString(string_format("等级 ：%d/100 ",hero_vo.spiritbody_level))
    self:setAttr_scroll(hero_vo, true, 1, self.lv_attr_scroll[1], 226, 0, 0)
    self:setAttr_scroll(hero_vo, false, 2, self.lv_attr_scroll[2], 226, 1, 0)
    self:setLv(hero_vo.spiritbody_level)
end

--根据升星的数量创建需要显示的星星图片
function HeroMainTabBodyPanel:setStarNum(star)
    local enableNoShow = star<1 or self.cur_tab_index==2 --如果为 true 那么不显示
    self.starNum_panel:setVisible(not enableNoShow)
    if enableNoShow then return end

    --加载星星图片资源
    local str = star>5 and "hl_common_508"  or "hl_common_507"
    local starStr=star>5 and "hl_common_1007_1" or "hl_common_1007"

    --创建 星 图片
    if not self.starSign then self.starSign=createImage(self.starNum_panel, nil, 0, 0, cc.p(0.5, 0.5), false,1,false)  end
    self.starSign:loadTexture(PathTool.getResFrame("common", str), LOADTEXT_TYPE_PLIST)
    self.starSign:setScale(0.4)

    --将创建的星星图片保存到本地数据
    local starNum= star%5 ==0 and 5 or star%5  --最大五个
    for i=1,starNum do
        if not self.starList[i] then
            self.starList[i]=createImage(self.starNum_panel, nil, i*30, 0, cc.p(0.5, 0.5), false)   
        end 
        self.starList[i]:setVisible(true)
        self.starList[i]:loadTexture(PathTool.getResFrame("common", starStr), LOADTEXT_TYPE_PLIST)
    end

    --本地数据里超过当前星星数量的不显示
    if self.starList and  #self.starList > starNum then
        for i=starNum,#self.starList[i] do 
            self.starList[i]:setVisible(false)   
        end  
    end
end
function HeroMainTabBodyPanel:setLv(lv)
    for i=1,2 do
        local num=lv-1+i
        local str=string_format("%d 级属性",num)
        self.lv_txts[i]:setString(str)  
    end
end
function HeroMainTabBodyPanel:showUpStar(hero_vo)
    self.skill_back:setPosition(cc.p(35, 474))
    self.skill_back:setContentSize(cc.size(650,260))
    self.unAct_panel:setPosition(cc.p(0, 15))
    self.skillTitle:setString("")
    self.skill_scrollview:setPosition(cc.p(0, 0))
    local notFull=true
    local configs = Config.SpiritbodyData.data_spiritbody_risingstar_consume[self.spriteId]
    if configs and configs[hero_vo.spiritbody_star] then
        local consum = configs[hero_vo.spiritbody_star]
        if consum then
            self.starMats= self:addConsume(consum, self.starMats, self.starMatLables, self.star_panel, 260, 184, 300,197)
   
        end
    end
    if not configs[hero_vo.spiritbody_star+1] then
        notFull=false
        self.full_lable:setString("已满星")
    end
    self.star_panel:setVisible(notFull)
    self.lv_attr_panel:setVisible(notFull)
    self.skill_back:setVisible(notFull)

       if notFull==false then return end

    self:setAttr_scroll(hero_vo, true, 1, self.lv_attr_scroll[1], 226, 0, 0)
    self:setAttr_scroll(hero_vo, false, 2, self.lv_attr_scroll[2], 226, 0, 1)
    self:setLv(hero_vo.spiritbody_star)
end
function HeroMainTabBodyPanel:getStrongConfig(level)
    --hero_vo.spiritbody_level
    local attr_configs = Config.SpiritbodyData.data_spiritbody_strength_attr[self.spriteId]
    if attr_configs and attr_configs[level] then
        local attr_config = attr_configs[level]
        if attr_config and attr_config[1] then
            local cConfig = attr_config[1]
            if cConfig[1] and cConfig[2] then
                local config = {}
                config[cConfig[1]] = cConfig[2]
                return config
            end
        end
    end
    return nil
end
function HeroMainTabBodyPanel:getUpstarConfig(star)
    --hero_vo.spiritbody_star
    local attr_configs = Config.SpiritbodyData.data_spiritbody_risingstar_attr[self.spriteId]
    if attr_configs and attr_configs[star] then
        local config = attr_configs[star]
        return config
    end
    return nil
end
--详情界面数据显示
function HeroMainTabBodyPanel:showDetail(hero_vo)
    self.skill_back:setPosition(cc.p(35, 512))
    self.skill_back:setContentSize(cc.size(650,363))
    self.unAct_panel:setPosition(cc.p(0, 40))
    self.skill_scrollview:setPosition(cc.p(0, 40))
    if not hero_vo or self.change == false then
        return
    end
    if hero_vo.spiritbody_level > 0 then
        self:setAttr_scroll(hero_vo, false, 0, self.attr_scrollview, 226, 0, 0)
    end
   
  self.unAct_panel:setVisible(not self.act)
    self.btn_act:setVisible(not self.act)
    self.attr_scrollview:setVisible(self.act)
    if self.act then
        self.attrTitle:setString("武魂真实属性")
        self.skillTitle:setString("真身天赋效果")
        self:setTianfu_scroll()
        self.skill_scrollview:setVisible(true)
    else
        self.attrTitle:setString("激活灵身可以获得大幅战力")
        self.skillTitle:setString("激活所需材料")
        local consum = Config.SpiritbodyData.data_spiritbody_init_consume_fun(self.spriteId)
        if consum then
            self.actMats= self:addConsume(consum, self.actMats, self.actMatLables, self.unAct_panel, 260, 200, 300, 200)
        end
        self.skill_scrollview:setVisible(false)
    end
end

--创建消耗所需道具图片和文本
function HeroMainTabBodyPanel:addConsume(consum, actMats, actMatLables, parent, x, y, x1, y1)
    if not actMats then actMats = {} end
    if not actMatLables then actMatLables = {} end

    for i = 1, #consum do
        if not actMats[i] then
            actMats[i] = createImage(parent, nil, x-200+i*200, y, cc.p(0.5, 0.5), false)
        end
        if not actMatLables[i] then
            actMatLables[i] = createRichLabel(22, cc.c3b(74, 35, 28), cc.p(0, 1), cc.p(x1-200+i*200, y1), 0, 0, 200)
            parent:addChild(actMatLables[i])
        end
    end
    controller:setExpend(consum, actMatLables, actMats)
    return actMats
end

function HeroMainTabBodyPanel:setAttr_scroll(hero_vo, isLeft, i, scroll, width, difLev, difStar)
    local attrConfig = self:getCurAttrConfig(hero_vo, difLev, difStar)
    local orignStr = ""
    local index = 0
    if attrConfig then
        for k, v in pairs(attrConfig) do
            local attr_name = Config.AttrData.data_key_to_name[k]
            if attr_name then
                local str = string_format("%s       <div fontcolor=#45A536>%d</div>  ", attr_name, v)
                if isLeft then
                    str = string_format("%s       %d  ", attr_name, v)
                end
                index = index + 1
                if self.cur_tab_index == 1 then
                    if not self.detailRLables then
                        self.detailRLables = {}
                    end
                    if not self.detailRLables[index] then
                        self.detailRLables[index] = createRichLabel(22, cc.c3b(74, 35, 28), cc.p(0, 0.5), cc.p(60, 15))
                        self.detale_RlableBgs[index]:addChild(self.detailRLables[index])
                    end
                    self.detale_RlableBgs[index]:setVisible(true)
                    self.detailRLables[index]:setString(str)
                else
                
                    orignStr =orignStr.."\n".. str
                end

              
            end
        end
    end
    if self.cur_tab_index == 1 then
        if index < #self.detale_RlableBgs then
            for i = index, #self.detale_RlableBgs do
                self.detale_RlableBgs[i]:setVisible(false)
            end
        end
        scroll:setInnerContainerSize(cc.size(width, 46 * index * 0.5))
    else
        self.lv_attr_txt[i]:setString(orignStr)
        scroll:setInnerContainerSize(cc.size(width, 30 * index))
    end

    scroll:setTouchEnabled(true)
    scroll:jumpToTop()
end
function HeroMainTabBodyPanel:getCurAttrConfig(hero_vo, difLev, difStar)
    local curConfig = deepCopy(self.orignAttrConfig)
    local strongConfig = self:getStrongConfig(hero_vo.spiritbody_level + difLev)
    curConfig = self:setAttrConfig(curConfig, strongConfig)
    local upstarConfig = self:getUpstarConfig(hero_vo.spiritbody_star + difStar)
    curConfig = self:setAttrConfig(curConfig, upstarConfig)
    return curConfig
end
function HeroMainTabBodyPanel:setAttrConfig(curConfig, otherAttrConfig)
    if otherAttrConfig then
        for k, v in pairs(otherAttrConfig) do
            if curConfig[k] then
                curConfig[k] = curConfig[k] + v
            else
                curConfig[k] = v
            end
        end
    end
    return curConfig
end
function HeroMainTabBodyPanel:createSkillItem(x, y, parent)
    local item = SkillItem.new(true, false, true, 0.8, true)
    parent:addChild(item)
    item:setPosition(x, y)
    return item
end
function HeroMainTabBodyPanel:setTianfu_scroll()
    local configs = Config.SpiritbodyData.data_spiritbody_risingstar_skill[self.spriteId]
    if configs and #configs > 3 then
        local count = 3
        for i = 1, count do
            local skillID = configs[i]
            if not self.skillItems then
                self.skillItems = {}
            end
            if not self.skillItems[i] then
                local item = {}
                item.skillItem = self:createSkillItem(100, 560 - i * 160, self.skill_scrollview)
                item.title = createLabel(22, cc.c3b(74, 35, 28), nil, 160, 560 - i * 160 + 30, "", self.skill_scrollview, nil, cc.p(0, 0.5))
                item.des = createRichLabel(20, cc.c3b(74, 35, 28), cc.p(0, 0.5), cc.p(160,560 - i * 160), 0, 0, 400)
                self.skill_scrollview:addChild(item.des)
                self.skillItems[i] = item
            end
            if self.skillItems[i] then
                local item = self.skillItems[i]

                local skill_config = Config.SkillData.data_get_skill(skillID)
                if skill_config then
                    item.des:setString(skill_config.des)
                    item.title:setString(skill_config.name)
                    item.skillItem:setData(skill_config)
                end
            end
        end
        self.skill_scrollview:setInnerContainerSize(cc.size(650, count * 150))

        self.skill_scrollview:setTouchEnabled(true)
        self.skill_scrollview:jumpToTop()
    end
end
function HeroMainTabBodyPanel:onClickActBtn()
    if not self.hero_vo then
        return
    end
    controller:sender11032(self.hero_vo.partner_id)
end
function HeroMainTabBodyPanel:onClickStrong_Btn(index)
    if not self.hero_vo then
        return
    end
    local time=0
    if index==2 then
        time=9
    end
    controller:sender11033(self.hero_vo.partner_id,time)
end
function HeroMainTabBodyPanel:onClickStarBtn()
    if not self.hero_vo then
        return
    end
    controller:sender11034(self.hero_vo.partner_id)
end
function HeroMainTabBodyPanel:setVisibleStatus(bool)
    self:setVisible(bool)
end
--移除
function HeroMainTabBodyPanel:DeleteMe()
    EventManager:getInstance():UnBind(self)
end
