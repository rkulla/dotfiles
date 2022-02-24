## VSCode notes

#### Extensions I use

- `Fix VSCode Checksums` (if getting errors about a corrupt installation)
- `Settings Cycler`
- `Vim`
- `GitLens`
- [ESLint](https://github.com/Microsoft/vscode-eslint)
- `Markdownlint` 
- `JavaScript (ES6) code snippets in StandardJS style` (`JavaScript (ES6) code snippets` if i want semi-colons)
- [Jest](https://github.com/jest-community/vscode-jest)
- `Jest Runner` (don't need unless I truly need to run individual tests and can't get vscode-jest to)
- [Jest Snippets](https://github.com/andys8/vscode-jest-snippets)
- `Bookmarks`
- `Code Spell Checker`
- `Code Runner`
- [Copy GitHub URL](https://marketplace.visualstudio.com/items?itemName=mattlott.copy-github-url) Keyboard shortcuts conflict with Vim extension but can still right-click > Copy As.
- `Explorer Exclude`
- `Reload`
- `Todo Tree`
- `Import Cost`
- `Stackoverflow Instant Search`
- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) (work only)
- `StandardJS` (work only IF required, since I don't like this)
- `SwaggerHub for VS Code` (work only)
- `Live Share` (work only)

#### Notes

-To make Vim mode more responsive, run these commands in the terminal and restart Code:

    $ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    $ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
    $ defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
    $ defaults delete -g ApplePressAndHoldEnabled

Then increase Key Repeat and Delay Until Repeat settings in `System Preferences -> Keyboard`. Slide Key Repeat all the way to the right (Fast) and slide Delay Until Repeat all to the right (Short)

