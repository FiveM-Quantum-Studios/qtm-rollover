fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '1OSaft'
description 'Rollover detection script'
version '1.0.0'

dependencies {'es_extended'}



server_scripts {
    'server.lua',
}
client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}