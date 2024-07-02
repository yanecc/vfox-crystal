# vfox-crystal

[Crystal](https://crystal-lang.org) language plugin for [vfox](https://vfox.lhan.me).

Support Crystal ≥ 0.24.2 and Nightly Builds (≥ 1.3.0 for Windows).

## Install

After installing [vfox](https://github.com/version-fox/vfox), install the plugin by running:

``` shell
vfox add crystal
```

Next, search and select the version to install. By default, vfox keeps cache for available versions, use the `--no-cache` flag to delete the cache file.

``` shell
vfox search crystal
vfox search crystal --no-cache && vfox search crystal
```

Install the latest stable version with `latest` tag.

``` shell
vfox install crystal@latest
```

To install nightly builds, use `dev` or `nightly` tag, or use the system date tag.

``` shell
vfox install crystal@dev
vfox install crystal@nightly
vfox install crystal@20240701
```

They are the same and will install nightly builds labelled with the current date. Use it with:

``` shell
vfox use crystal@20240701
```

Some environment variables are served as following:

| Environment variables | Default value         | Description           |
| :-------------------- | :-------------------- | :-------------------- |
| GITHUB_URL            | `https://github.com/` | GitHub mirror URL     |
| GITHUB_TOKEN          |                       | personal GitHub token |

## Note

It's recommended to set the `GITHUB_TOKEN` environment variable or modify the plugin asset for efficiency. Search with `--no-cache` flag to see the changes straight away.

``` shell
sed -i 's/githubToken = os.getenv("GITHUB_TOKEN") or "",/githubToken = os.getenv("GITHUB_TOKEN") or "<YOUR_GITHUB_TOKEN>",/' ~/.version-fox/plugin/crystal/lib/util.lua
```

This will:
1. accelerate getting the latest version
2. accelerate fetching available versions
3. enable installing nightly builds **on Windows**