# vfox-crystal

[Crystal](https://crystal-lang.org) language plugin for [vfox](https://vfox.lhan.me).

Support Crystal ≥ 0.24.2 and Nightly Builds (≥ 1.3.0 for Windows).

## Install

After installing [vfox](https://github.com/version-fox/vfox), install the plugin by running:

``` shell
vfox add crystal
```

Next, search and select the version to install.

``` shell
vfox search crystal
```

Install the latest stable version with the latest tag.

``` shell
vfox install crystal@latest
```

To install nightly builds, use the dev or nightly tag, or use the system date tag.

``` shell
vfox install crystal@dev
vfox install crystal@nightly
vfox install crystal@20240420
```

They are the same and will install nightly builds tagged with the current date. Use it with:

``` shell
vfox use crystal@20240420
```

Some environment variables are served as following:

| Environment variables | Default value         | Description       |
| :-------------------- | :-------------------- | :---------------- |
| GITHUB_TOKEN          | `""`                  | GitHub Token      |
| GITHUB_URL            | `https://github.com/` | GitHub mirror URL |

## Note

This plugin uses the GitHub API to retrieve available versions of Crystal. It is recommended to modify the `~/.version-fox/plugin/crystal/lib/util.lua` file to set your personal GitHub token for a higher rate limit before formal use.
https://github.com/yanecc/vfox-crystal/blob/128cc5ed1c9c5a49d89b3a6f58ce686180d0af60/lib/util.lua#L72-L73

```
sed -i 's/githubToken = os.getenv("GITHUB_TOKEN") or "",/githubToken = os.getenv("GITHUB_TOKEN") or "<YOUR_GITHUB_TOKEN>",/' ~/.version-fox/plugin/crystal/lib/util.lua
```