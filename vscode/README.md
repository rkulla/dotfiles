## VSCode notes

Note: I don't symlink my vscode settings to a dotfile. So make sure to adjust those settings manually for each machine after
copy/pasting my generic settings.json. E.g., editor.zoomLevel and editor.fontSize and vim stuff.

#### Extensions I use

- `Fix VSCode Checksums` (if getting errors about a corrupt installation)
- `Settings Cycler`
- `Vim`
- [GitLens](https://github.com/gitkraken/vscode-gitlens)
- [ESLint](https://github.com/Microsoft/vscode-eslint)
- `Markdownlint`
- [Jest](https://github.com/jest-community/vscode-jest)
- `Jest Runner` (don't need unless I truly need to run individual tests and can't get vscode-jest to)
- `Bookmarks`
- `Code Spell Checker`
- `Code Runner`
- [Copy GitHub URL](https://marketplace.visualstudio.com/items?itemName=mattlott.copy-github-url) Keyboard shortcuts conflict with Vim extension but can still right-click > Copy As.
- `Explorer Exclude`
- `Mirrord` (work only)
- [Quit Control for VSCode](https://marketplace.visualstudio.com/items?itemName=artdiniz.quitcontrol-vscode)
- `Reload`
- `Todo Tree`
- `Import Cost`
- `Stackoverflow Instant Search`
- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) (work only)
- `StandardJS` (work only IF required, since I don't like this)
- `SwaggerHub for VS Code` (work only)
- [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
- `Live Share` (work only)

#### Notes

-To make Vim mode more responsive, run these commands in the terminal and restart Code:

    $ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    $ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
    $ defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
    $ defaults delete -g ApplePressAndHoldEnabled

Then increase Key Repeat and Delay Until Repeat settings in `System Preferences -> Keyboard`. Slide Key Repeat all the way to the right (Fast) and slide Delay Until Repeat all to the right (Short)
