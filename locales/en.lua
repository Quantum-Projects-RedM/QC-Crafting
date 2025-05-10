local Translations = {
    error = {
        you_donthave_the_required_items = "Nemate potrebne predmete!",
    },
    success = {
        smelting_finished = 'prerada završena',
    },
    primary = {
        gold_smelt_deployed = 'topljenje zlata pokrenuto',
    },
    menu = {
        smelting_menu = '🏹 | Sto za preradu',
        close_menu = '❌ | Zatvori meni',
    },
    commands = {
        var = 'tekst ide ovde',
    },
    progressbar = {
        smelting_a = 'Pravljenje ',
    },
    text = {
        gold_bar = 'Zlatna poluga',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
