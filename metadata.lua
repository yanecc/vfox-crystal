--- !!! DO NOT EDIT OR RENAME !!!
PLUGIN = {}

--- !!! MUST BE SET !!!
--- Plugin name
PLUGIN.name = "crystal"
--- Plugin version
PLUGIN.version = "0.3.2"
--- Plugin homepage
PLUGIN.homepage = "https://github.com/yanecc/vfox-crystal"
--- Plugin license, please choose a correct license according to your needs.
PLUGIN.license = "Apache 2.0"
--- Plugin description
PLUGIN.description = "Crystal language plugin, https://crystal-lang.org/"


--- !!! OPTIONAL !!!
--[[
NOTE:
    Minimum compatible vfox version.
    If the plugin is not compatible with the current vfox version,
    vfox will not load the plugin and prompt the user to upgrade vfox.
    --]]
PLUGIN.minRuntimeVersion = "0.3.0"
--[[
NOTE:
    If configured, vfox will check for updates to the plugin at this address,
    otherwise it will check for updates at the global registry.

    If you want use the global registry to distribute your plugin, you can remove this field.

    If you develop a plugin based on the template, which will automatically generate a manifest file by CI,
    you can set this address to the manifest file address, so that the plugin can be updated automatically.

    --]]
PLUGIN.manifestUrl = "https://github.com/yanecc/vfox-crystal/releases/download/manifest/manifest.json"
-- Some things that need user to be attention!
PLUGIN.notes = {
    "For Windows, Microsoft Visual Studio build tools need to be downloaded at one of the following locations:",
    "https://aka.ms/vs/17/release/vs_BuildTools.exe",
    "https://visualstudio.microsoft.com/downloads/ (includes Visual Studio IDE)",
    "Either the “Desktop development with C++” workload or the “MSVC v143 - VS 2022 C++ x64/x86 build tools” components should be selected.",
    "No restrictions for unix-like.",
    "",
    "vfox-crystal supports Crystal >= 0.24.2 (>=1.3.0 for Windows)"
}