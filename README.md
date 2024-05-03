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

Install the latest stable version with `latest` tag.

``` shell
vfox install crystal@latest
```

To install nightly builds, use `dev` or `nightly` tag, or use the system date tag.

``` shell
vfox install crystal@dev
vfox install crystal@nightly
vfox install crystal@20240420
```

They are the same and will install nightly builds labelled with the current date. Use it with:

``` shell
vfox use crystal@20240420
```

Some environment variables are served as following:

| Environment variables | Default value        | Description           |
| :-------------------- | :------------------- | :-------------------- |
| GITHUB_URL            | `https://github.com` | GitHub mirror URL     |
| GITHUB_TOKEN          |                      | personal GitHub token |

## Note

Since vfox-crystal 0.4.1, GitHub token is no longer a necessity, but you can still set it via the GITHUB_TOKEN environment variable or modifying the plugin asset for efficiency.

```
sed -i 's/githubToken = os.getenv("GITHUB_TOKEN") or "",/githubToken = os.getenv("GITHUB_TOKEN") or "<YOUR_GITHUB_TOKEN>",/' ~/.version-fox/plugin/crystal/lib/util.lua
```

This will:
1. accelerate getting the latest version
2. accelerate fetching available versions