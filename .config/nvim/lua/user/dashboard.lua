local home = os.getenv('HOME')
local db = require('dashboard')

db.custom_header = {
}

db.session_directory = home .. '/.config/nvim/sessions'

db.custom_center = {
    {icon = '  ',
    desc = 'Open last session                       ',
    shortcut = 'SPC s l',
    action ='SessionLoad'},
    {icon = '  ',
    desc = 'Open recent files                       ',
    action =  'Telescope oldfiles',
    shortcut = 'SPC f r'},
    {icon = '  ',
    desc = 'Find File                               ',
    action = 'Telescope find_files',
    shortcut = 'SPC f f'},
    {icon = '  ',
    desc ='File Explorer                           ',
    action =  'Telescope file_browser',
    shortcut = 'SPC f e'},
    {icon = '  ',
    desc = 'Find word                               ',
    action = 'Telescope live_grep',
    shortcut = 'SPC f w'},
    {icon = '  ',
    desc = 'Open nvim config                        ',
    action = 'Telescope find_files find_command=rg,--hidden,--files,' .. home ..'/.config/nvim',
    shortcut = 'SPC f c'},
}

