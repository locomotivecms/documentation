---
title: Preview locally
order: 7
---

Wagon embeds a web server to preview your local site.

## Usage

```shell
bundle exec wagon serve [PATH]
```

## Options

| Name | Description |
| :--- | :--- |
| -h, [--host=HOST] | The host (address) of the Thin web server.\ Default: 127.0.0.1 (localhost) |
| -p, [--port=PORT] | The port of the Thin server\ Default: 3333 |
| -d, [--daemonize], [--no-daemonize] | Run daemonized Thin server in the background |
| -l, [--live-reload-port=LIVE_RELOAD_PORT][--live-reload-port=LIVE_RELOAD_PORT] | The port the LiveReload javascript lib needs to listen for changes (35729 by default)\ Default: 35729 |
| -f, [--force] | Stop the current daemonized Thin server if found before starting a new one. |
| -e, [--env=ENV] | If you synced the content from a remote LocomotiveCMS engine, you can use this content locally. |


## Examples

```shell
bundle exec wagon serve
```

```shell
bundle exec wagon serve -p 3334
```
