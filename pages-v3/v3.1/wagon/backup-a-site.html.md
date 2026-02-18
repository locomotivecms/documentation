---
title: Backup a site
order: 4
---

This command allows you to retrieve a wagon site from a hosted location (a Locomotive engine). 

## Usage

```shell
wagon backup NAME HOST
```

{% hint style="warning" %}
The backup command doesn't retrieve the HAML, SASS, SCSS, Less or Coffeescript files but only their compiled versions.
{% endhint %}


## Options

| Name | Description |
| :--- | :--- |
| -h, [--handle=HANDLE] | Handle of your site. |
| -e, [--email=EMAIL] | Email of an administrator / designer account. |
| -p, [--password=PASSWORD] | Password of an administrator / designer account (use api_key instead for security reasons). |
| -a, [--api-key=API_KEY][--api-key=API_KEY] | Api key of an administrator / designer account. |
| -v, [--verbose], [--no-verbose] | Display the full error stack trace if an error occurs. |


## Example

```shell
wagon backup mysite http://station.locomotive.works -h acme -e john@doe.net -a 373e4330e47d6875969999caa4e6b174428b9a1df
```
