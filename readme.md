# GOG-Galaxy-Export

This tool can be used to scape your local GoG Galaxy installation for a html-view of all your available games across all integrated platforms.

The core is a [powershell-script](./export.ps1) to orchestrate usage of [AB1908/GOG-Galaxy-Export-Script](https://github.com/AB1908/GOG-Galaxy-Export-Script) and [Varstahl/GOG-Galaxy-HTML5-exporter](https://github.com/Varstahl/GOG-Galaxy-HTML5-exporter) to a most easy output.

Just use `git submodule init && git submodule update && git submodule status` to install the submodules (if running on python 3.8.5 implement my syntax fix for [Varstahl/GOG-Galaxy-HTML5-exporter PR #2](https://github.com/Varstahl/GOG-Galaxy-HTML5-exporter/pull/2) manually) and start the [export.ps1](./export.ps1).

It should do all, that is needed for a neat output in the subdirectory called `output`, which can be copied anywhere, incl. your private web server.