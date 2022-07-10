fx_version "adamant"

games { 'gta5'}
lua54 'yes'
use_fxv2_oal 'yes'

ui_page "ui/index.html"

files {
    'ui/*.html',
    'ui/assets/img/*.png',
    'ui/assets/css/*.css',
    'ui/assets/js/*.js'
}


client_scripts {
	'config/clientConfig.lua',
	"client/*.lua"
}

server_scripts {
	'config/serverConfig.lua',
	'server/*.lua'
}

server_exports {
	"GetWeaponsInfo",
	"GetWeaponInfo"
}