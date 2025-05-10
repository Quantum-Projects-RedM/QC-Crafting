Config = {}

Config.Debug = false

Config.SmeltProps = {
	'mp005_s_posse_ammotable03x',
}

Config.SmeltOptions = {
    
    
    ["𓍯 Lasso (Obican)"] = {
		name = Lang:t('Lasso (Obican)'),
        smelttime = 200000,
        smeltitems = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_lasso"
    },
    
    ["𓍯 Lasso (Unapredjen)"] = {
		name = Lang:t('Lasso (Unapredjen)'),
        smelttime = 200000,
        smeltitems = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_lasso_reinforced"
    },
   
    ["🕸️ Bola za lov"] = {
		name = Lang:t('Bola za lov'),
        smelttime = 200000,
        smeltitems = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_thrown_bolas_hawkmoth"
    },
   
   
    ["🪓 Thrown Tomahawk"] = {
		name = Lang:t('Thrown Tomahawk'),
        smelttime = 200000,
        smeltitems = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_thrown_tomahawk"
    },
 
    ["🏹 Standardni luk"] = {
		name = Lang:t('Standardni luk'),
        smelttime = 200000,
        smeltitems = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "water", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_bow"
    },
	
    ["🏹 Unapredjeni luk"] = {
		name = Lang:t('Unapredjeni luk'),
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "wood", amount = 10 },
           -- [2] = { item = "water", amount = 1 },
           -- [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_bow_improved"
    },
    ["➶ Strela (Obicna)"] = {
		name = Lang:t('Strela (Obicna)'),
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "water", amount = 1 },
        },
        receive = "ammo_arrow"
    },
    
    ["➶ Strela (Male)"] = {
		name = Lang:t('Strela (Male)'),
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "water", amount = 1 },
        },
        receive = "AMMO_ARROW_SMALL_GAME"
    },
    
    ["➶ Strela (Otrovne)"] = {
		name = Lang:t('Strela (Otrovne)'),
        smelttime = 20000,
        smeltitems = {
            [1] = { item = "water", amount = 1 },
        },
        receive = "AMMO_ARROW_POISON"
    },

 

}
