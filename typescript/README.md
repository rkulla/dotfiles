NOTE: I cna mostly just use my ts-skel skeleton for the latest working boilerplate.

## tsconfig.json

This is needed for *every* typescript project, e.g., to make sure tsserver and your IDE work properly.

At a minimum have:

```json
{
  "compilerOptions": {
    "target": "es6",
    "module": "commonjs",
    "allowJs": true
  },
  "exclude": ["node_modules" ]
}
```

Whatever files/dirs you add to "include" and "exclude" (which should contain different values to not override each other), is what `tsc` will COMPILE and `eslint .` will add any plugin rules but has nothing to do with which files eslint will ignore. For that you need to use `.eslintignore` or better yet, add the following to .eslingrc.json:
   
     "ignorePatterns": ["foo"],

## ESLint

First make sure forget to my .vim/coc-settings.json looks like:

```json
{
  "tsserver.npm": "/usr/local/bin/npm",
  "javascript.validate.enable": true,
  "typescript.validate.enable": true,
  "javascript.suggestionActions.enabled": false,
  "typescript.suggestionActions.enabled": false,
  "eslint.autoFixOnSave": true
}
```

As well and **make sure** at least `coc-eslint` and `coc-tsserver` are installed

    $ ls ~/.config/coc/extensions/node_modules  # install.sh should have installed them

Then install the following for my minimum typescript node.js dependencies to work with typescript/module imports / jest:

    # npm install to -D (DevDependencies) the following:
    eslint
    eslint-config-airbnb-base
    babel-preset-airbnb 
    typescript 
    ts-node 
    @typescript-eslint/parser 
    @typescript-eslint/eslint-plugin
    eslint-plugin-import 
    eslint-import-resolver-typescript
    jest 
    ts-jest 
    @types/jest 
    eslint-plugin-jest 

Then, add this to `jest.config.js` make jest run ts-jest or you'll get syntax errors about import statements, etc:

    module.exports = {
      preset: 'ts-jest',
      testEnvironment: 'node',
      testMatch: ['./**/*.test.ts'],
    };

If you still get errors, it's probably you're using the wrong version of node or don't need additional configuration for special circumstances. For example, if your .eslintrc.json and tsconfig are in a subdir like `lambda/foo` (which is bad practice), then either move them to the root of the project or you can do the following in .vscode/settings.json and CocConfig:

    "eslint.workingDirectories": [
      "lambda/foo"
    ]
