--------------------------------------------
-- @description    : 
-- 天梯主界面单个英雄
---------------------------------
LadderRoleItem = class("LadderRoleItem", function()
        return ccui.Widget:create()
    end)

LadderRoleItem.Width = 243
LadderRoleItem.Height = 280

local controller = LadderController:getInstance()
local model = controller:getModel()

function LadderRoleItem:ctor(root_wnd)
    self:configUI(root_wnd)
    self:register_event()
end

function LadderRoleItem:configUI( root_wnd )
    self.size = cc.size(LadderRoleItem.Width, LadderRoleItem.Height)
    self:setContentSize(self.size)
    self:setAnchorPoint(cc.p(0.5, 0))


    --这里直接设置外边的layer
    local container = root_wnd
    self.container = root_wnd


    self.image_line = container:getChildByName("image_line")
    self.rank_label = container:getChildByName("rank_label")
    self.name_label = container:getChildByName("name_label")
    self.attk_label = container:getChildByName("attk_label")
    self.atk_icon = container:getChildByName("atk_icon")
    self.pos_role = container:getChildByName("pos_role")
    self.attk_image = container:getChildByName("attk_image")
    self.rank_bg = container:getChildByName("rank_bg")
end

function LadderRoleItem:register_event(  )
    registerButtonEventListener(self.pos_role, handler(self, self._onClickBtnContainer))
end

function LadderRoleItem:_onClickBtnContainer(  )
    local is_open = model:getLadderIsOpen()
    if is_open then
        controller:openLadderRoleInfoWindow(true, self.data)
    else
        local txt_cfg = Config.SkyLadderData.data_const["close_text"]
        if txt_cfg then
            message(string.format(TI18N("每%s天梯争霸"), txt_cfg.desc))
        end
    end
end

function LadderRoleItem:setData( data )
    self.data = data or {}

    local is_open = model:getLadderIsOpen()

    if not data.rank or data.rank == 0 then

        self.rank_label:setString(StringUtil.branchStr(TI18N("未上榜")))
    else

        self.rank_label:setString(StringUtil.branchStr(string.format(TI18N("%d"), data.rank)))
    end

    if is_open then
        self.name_label:setString(transformNameByServ(data.name, data.srv_id))
        self.attk_label:setString(data.power or 0)
        local label_size = self.attk_label:getContentSize()
        self.attk_image:setVisible(true)
        self.atk_icon:setVisible(true)
    else
        self.name_label:setString(TI18N("虚位以待"))
        local txt_cfg = Config.SkyLadderData.data_const["close_text"]
        if txt_cfg then
            self.attk_label:setString(txt_cfg.desc)
        end
        self.attk_image:setVisible(false)
        self.atk_icon:setVisible(false)
    end

    if self.role_pic then
        self.role_pic:removeFromParent()
        self.role_pic = nil
    end
    if data.look then
        local bid = 10101
        local look_config  = Config.LooksData.data_data[data.look]
        if look_config then
            bid = look_config.partner_id
        end
        local res_id = PathTool.getPlistImgForDownLoad("bigbg/partnercard", "partnercard_" .. bid)
        self.role_pic = createSprite(res_id,60,160,self.pos_role,cc.p(0.5,1),LOADTEXT_TYPE,100)
        self.role_pic:setScale(self.pos_role:getContentSize().width/self.role_pic:getContentSize().width)

    end

    -- 设置底框
    local res_path = self:getRoleBoxResPath(data.rank)
    if res_path then
        self.image_line:loadTexture(res_path, LOADTEXT_TYPE_PLIST)
        self.image_line:setVisible(true)
    else
        self.image_line:setVisible(false)
    end
end

function LadderRoleItem:getRoleBoxResPath( rank )
    local res_path
    local box_config = Config.SkyLadderData.data_const.role_box
    local index = 0
    if box_config and box_config.val then
        for k,v in pairs(box_config.val) do
            if rank >= v[1] and (rank <= v[2] or v[2] == 0) then
                index = k
            end
        end
    end
    if index == 1 then
        res_path = PathTool.getResFrame("common", "hl_common_2000")
    elseif index == 2 then
        res_path = PathTool.getResFrame("common", "hl_common_2001")
    elseif index == 3 then
        res_path = PathTool.getResFrame("common", "hl_common_2002")
    end

    return res_path
end

function LadderRoleItem:DeleteMe(  )

end