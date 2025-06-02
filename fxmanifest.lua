fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'Qzip from Quantum Projects'
description 'qc-craft inspired from indiancraft'

quantum_discord 'https://discord.gg/kJ8ZrGM8TS'
version '1.0.0'

shared_scripts {
    '@rsg-core/shared/locale.lua',
    '@ox_lib/init.lua',
    'locales/en.json',
    'config.lua',
}

client_script {
	'client/client.lua'
}

server_script {
	'server/server.lua'
}

files = {
    'locales/*.json',
}

dependency {
    'rsg-core',
    'rsg-menu',
    'ox_lib'
}

lua54 'yes'