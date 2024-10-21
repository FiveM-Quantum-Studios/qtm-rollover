fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Quantum Studios'
description 'Rollover detection script'
version '1.0.0'

dependencies {
    'ox_lib',
    'qtm-lib'
}

shared_scripts {
    '@qtm-lib/imports.lua',
    '@ox_lib/init.lua'
}
client_scripts {
    'config.lua',
    'src/client.lua'
}
server_scripts {
    'src/server.lua'
}
escrow_ignore {
    '**/*.*'
}