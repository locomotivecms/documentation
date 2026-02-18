---
title: Synchronize content
order: 4
---

It can be very convenient to get locally in Wagon the content the editors added from the Locomotive back-office. 

## Usage

```shell
bundle exec wagon sync ENV [PATH]
```

Only the editable elements (text, file and control types), content entries and translations can be fetched from a Locomotive engine.

## Options

| Name | Description |
| :--- | :--- |
| -r, [--resources=one two three] | Only pull the resource(s) passed (pages, content_entries, translations) in argument |
| -v, [--verbose], [--no-verbose] | Display the full error stack trace if an error occurs |


## Examples

```shell
bundle exec wagon sync live
```

```shell
bundle exec wagon sync staging -r content_entries translations -v
```
