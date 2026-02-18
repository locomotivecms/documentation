---
title: Synchronize content
order: 4
---

{% hint style="warning" %}
**This command has now a different behavior than in Wagon v2.x**

{% endhint %}


It can be very convenient to get locally in Wagon the content the editors added from the Locomotive back-office. 

## Usage

The following command will fetch all the content (sections, content entries and translations) from a remote LocomotiveCMS environment.

{% hint style="warning" %}
**This command won't erase your local content unlike the previous version of the command**

{% endhint %}


```shell
wagon sync ENV
```

To see locally the content fetched from the env, you need to pass the env to the `wagon serve` command like this:

```shell
wagon serve -e ENV
```

## Options

| Name | Description |
| :--- | :--- |
| -r, [--resources=one two three] | Only pull the resource(s) passed (pages, content_entries, translations) in argument |
| -v, [--verbose], [--no-verbose] | Display the full error stack trace if an error occurs |
| --no-verbose | Display no error if an error occurs |


## Examples

```shell
wagon sync live
wagon serve -e live
```

```shell
wagon sync staging -r content_entries translations -v
wagon serve -e staging
```
