----------------------------------------------------
-- 此文件由数据工具生成
-- 伙伴装备配置数据--partner_field_data.xml
--------------------------------------

Config = Config or {} 
Config.PartnerFieldData = Config.PartnerFieldData or {}

-- -------------------field_const_start-------------------
Config.PartnerFieldData.data_field_const_length = 3
Config.PartnerFieldData.data_field_const = {
	["open_level"] = {code="open_level", val=30160, desc="通关剧情第100关开启助阵"},
	["field_name"] = {code="field_name", val=0, desc="合力之阵"},
	["des_text"] = {code="des_text", val=0, desc="1、所有战斗中出战的英雄都会享受助阵属性加成\n2、助阵的英雄战力越高，加成的属性越高\n3、升级助阵等级可额外百分比增加助阵属性"}
}
Config.PartnerFieldData.data_field_const_fun = function(key)
	local data=Config.PartnerFieldData.data_field_const[key]
	if DATA_DEBUG and data == nil then
		print('(Config.PartnerFieldData.data_field_const['..key..'])not found') return
	end
	return data
end
-- -------------------field_const_end---------------------


-- -------------------field_attr_start-------------------
Config.PartnerFieldData.data_field_attr_length = 6
Config.PartnerFieldData.data_field_attr = {
	[1] = {pos=1, attr_atom="atk", ratio=84, limit_lev=1, expend={}},
	[2] = {pos=2, attr_atom="hp_max", ratio=420, limit_lev=40, expend={{2,100000}}},
	[3] = {pos=3, attr_atom="def", ratio=63, limit_lev=50, expend={{2,200000}}},
	[4] = {pos=4, attr_atom="atk", ratio=84, limit_lev=60, expend={{2,300000}}},
	[5] = {pos=5, attr_atom="hp_max", ratio=420, limit_lev=70, expend={{2,400000}}},
	[6] = {pos=6, attr_atom="def", ratio=63, limit_lev=80, expend={{2,500000}}}
}
Config.PartnerFieldData.data_field_attr_fun = function(key)
	local data=Config.PartnerFieldData.data_field_attr[key]
	if DATA_DEBUG and data == nil then
		print('(Config.PartnerFieldData.data_field_attr['..key..'])not found') return
	end
	return data
end
-- -------------------field_attr_end---------------------


-- -------------------field_lev_start-------------------
Config.PartnerFieldData.data_field_lev_length = 21
Config.PartnerFieldData.data_field_lev = {
	[1] = {lev=1, add_num=0, expend={{10120,1},{2,10000}}},
	[2] = {lev=2, add_num=20, expend={{10120,2},{2,20000}}},
	[3] = {lev=3, add_num=40, expend={{10120,3},{2,30000}}},
	[4] = {lev=4, add_num=60, expend={{10120,4},{2,40000}}},
	[5] = {lev=5, add_num=80, expend={{10120,5},{2,50000}}},
	[6] = {lev=6, add_num=100, expend={{10120,6},{2,60000}}},
	[7] = {lev=7, add_num=120, expend={{10120,7},{2,70000}}},
	[8] = {lev=8, add_num=140, expend={{10120,8},{2,80000}}},
	[9] = {lev=9, add_num=160, expend={{10120,9},{2,90000}}},
	[10] = {lev=10, add_num=180, expend={{10120,10},{2,100000}}},
	[11] = {lev=11, add_num=200, expend={{10120,11},{2,110000}}},
	[12] = {lev=12, add_num=220, expend={{10120,12},{2,120000}}},
	[13] = {lev=13, add_num=240, expend={{10120,13},{2,130000}}},
	[14] = {lev=14, add_num=260, expend={{10120,14},{2,140000}}},
	[15] = {lev=15, add_num=280, expend={{10120,15},{2,150000}}},
	[16] = {lev=16, add_num=300, expend={{10120,16},{2,160000}}},
	[17] = {lev=17, add_num=320, expend={{10120,17},{2,170000}}},
	[18] = {lev=18, add_num=340, expend={{10120,18},{2,180000}}},
	[19] = {lev=19, add_num=360, expend={{10120,19},{2,190000}}},
	[20] = {lev=20, add_num=380, expend={{10120,20},{2,200000}}},
	[21] = {lev=21, add_num=400, expend={}}
}
Config.PartnerFieldData.data_field_lev_fun = function(key)
	local data=Config.PartnerFieldData.data_field_lev[key]
	if DATA_DEBUG and data == nil then
		print('(Config.PartnerFieldData.data_field_lev['..key..'])not found') return
	end
	return data
end
-- -------------------field_lev_end---------------------
