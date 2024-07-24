fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Quantum Studios'
description 'Rollover detection script'
version '1.0.0'

server_scripts {
    'src/server.lua',
}
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
client_scripts {
    'src/client.lua'
}