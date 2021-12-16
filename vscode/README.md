## VSCode notes

#### Extensions I use

- `Fix VSCode Checksums` (if getting errors about a corrupt installation)
- `Settings Cycler`
- `Vim`
- `GitLens`
- `ESLint`
- `Markdownlint` 
- `JavaScript (ES6) code snippets in StandardJS style` (`JavaScript (ES6) code snippets` if i want semi-colons)
- `Jest`
- `Jest Snippets`
- `Jest Runner`
- `Bookmarks`
- `Code Spell Checker`
- `Code Runner`
- `Explorer Exclude`
- `Reload`
- `Todo Tree`
- `Import Cost`
- `Stackoverflow Instant Search`
- `Prettier - Code formatter` (work only)
- `StandardJS` (work only)
- `SwaggerHub for VS Code` (work only)
- `Live Share` (work only)

#### Notes

-To make Vim mode more responsive, run these commands in the terminal and restart Code:

    $ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    $ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
    $ defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
    $ defaults delete -g ApplePressAndHoldEnabled

Then increase Key Repeat and Delay Until Repeat settings in `System Preferences -> Keyboard`. Slide Key Repeat all the way to the right (Fast) and slide Delay Until Repeat all to the right (Short)

