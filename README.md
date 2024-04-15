# vfox-crystal
[Crystal](https://crystal-lang.org/) language plugin for [vfox](https://vfox.lhan.me/).

Supports Crystal >= 1.2.0 (>=1.3.0 for Windows).

## Install

After installing [vfox](https://github.com/version-fox/vfox), install the plugin by running:

```bash
vfox add crystal
```

## Note

This plugin uses the GitHub API to retrieve available versions of Crystal. It is recommended to modify the `~/.version-fox/plugin/crystal/hooks/available.lua` file to set your personal GitHub token for a higher rate limit before formal use.