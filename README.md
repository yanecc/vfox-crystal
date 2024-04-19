# vfox-crystal

[Crystal](https://crystal-lang.org) language plugin for [vfox](https://vfox.lhan.me).

Supports Crystal ≥ 0.24.2 (≥ 1.3.0 for Windows).

To install Nightly Build, use the dev or nightly tag, or use the system date tag.

``` shell
vfox install crystal@dev
vfox install crystal@nightly
vfox install crystal@20240420
```

They are the same and will install Nightly Build tagged with the current date. Use it with:

``` shell
vfox use crystal@20240420
```

## Install

After installing [vfox](https://github.com/version-fox/vfox), install the plugin by running:

```bash
vfox add crystal
```

## Note

This plugin uses the GitHub API to retrieve available versions of Crystal. It is recommended to modify the `~/.version-fox/plugin/crystal/lib/util.lua` file to set your personal GitHub token for a higher rate limit before formal use. https://github.com/yanecc/vfox-crystal/blob/4a23d91b915e168b280edc4a7330d37949c56798/lib/util.lua#L59