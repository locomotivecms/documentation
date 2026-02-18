---
title: Preview locally
order: 6
---

Wagon embeds a web server to preview your local site.

## Usage

```shell
bundle exec wagon serve [PATH]
```

If you want to enable the **live reload** feature, you have to: 

1/ Add the guard-livereload gem to your Gemfile OR uncomment the line:

```yaml
gem 'guard-livereload', '~> 2.5.1'
```

2/ Install the gem:

```shell
bundle install
```

3/ Launch Guard

```shell
bundle exec guard
```

Make sure you've got the **Guardfile** file at the root of your Wagon site.

```ruby
guard 'livereload', host: '0.0.0.0', port: ENV['WAGON_LIVERELOAD_PORT'] || 35729, grace_period: 0.5 do
  watch(%r{app/content_types/.+\.yml$})
  watch(%r{app/views/.+\.liquid})
  watch(%r{config/.+\.yml$})
  watch(%r{data/.+\.yml$})
  watch(%r{public/((stylesheets|javascripts)/(.+\.(css|js))).*}) { |m| "/#{m[1]}" }
end
```

## Options

| Name | Description |
| :--- | :--- |
| -h, [--host=HOST] | The host (address) of the Thin web server.\ Default: 0.0.0.0 |
| -p, [--port=PORT] | The port of the Thin server\ Default: 3333 |
| -d, [--daemonize], [--no-daemonize] | Run daemonized Thin server in the background |
| -l, [--live-reload-port=LIVE_RELOAD_PORT][--live-reload-port=LIVE_RELOAD_PORT] | The port the LiveReload javascript lib needs to listen for changes (35729 by default)\ Default: 35729 |
| -f, [--force] | Stop the current daemonized Thin server if found before starting a new one. |


## Examples

```shell
bundle exec wagon serve
```

```shell
bundle exec wagon serve -p 3334
```
