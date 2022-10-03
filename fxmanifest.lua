fx_version "adamant"

games { 'gta5'}
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name         'plouffe_weapons'
author       'PlouffeLuL'
version      '1.0.0'
repository   'https://github.com/plouffelul/plouffe_weapons'
description  'Multiples weapons related features'

ui_page "ui/index.html"

files {
    'ui/*.html',
    'ui/assets/img/*.png',
    'ui/assets/css/*.css',
    'ui/assets/js/*.js',
    "data/components.json",
    "data/backup.lua"
}

client_scripts {
	'config/clientConfig.lua',
	"client/*.lua"
}

server_scripts {
	'config/serverConfig.lua',
	'server/*.lua'
}