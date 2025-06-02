Config = {}

Config.Debug = false

Config.Item = 'craftingtable'

Config.CraftingProps = {
	'mp005_s_posse_ammotable03x',
}

Config.CraftingOptions = {
    ["𓍯 Lasso (Obican)"] = {
    
        crafttimer = 10000,
        required = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_lasso"
    },
    
    ["𓍯 Lasso (Unapredjen)"] = {

        crafttimer = 10000,
        required = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_lasso_reinforced"
    },
   
    ["🕸️ Bola za lov"] = {
        crafttimer = 10000,
        required = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_thrown_bolas_hawkmoth"
    },
   
   
    ["🪓 Thrown Tomahawk"] = {
        crafttimer = 10000,
        required = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "iron", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_thrown_tomahawk"
    },
 
    ["🏹 Standardni luk"] = {
        crafttimer = 10000,
        required = {
            [1] = { item = "wood", amount = 10 },
            [2] = { item = "water", amount = 1 },
            [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_bow"
    },
	
    ["🏹 Unapredjeni luk"] = {
        crafttimer = 100000,
        required = {
            [1] = { item = "wood", amount = 10 },
           -- [2] = { item = "water", amount = 1 },
           -- [3] = { item = "water", amount = 1 },
        },
        receive = "weapon_bow_improved"
    },
    ["➶ Strela (Obicna)"] = {
        crafttimer = 100000,
        required = {
            [1] = { item = "water", amount = 1 },
        },
        receive = "ammo_arrow"
    },
    
    ["➶ Strela (Male)"] = {
        crafttimer = 100000,
        required = {
            [1] = { item = "water", amount = 1 },
        },
        receive = "AMMO_ARROW_SMALL_GAME"
    },
    
    ["➶ Strela (Otrovne)"] = {
        crafttimer = 100000,
        required = {
            [1] = { item = "water", amount = 1 },
        },
        receive = "AMMO_ARROW_POISON"
    },

 

}
