---
title: Liquid helpers
order: 4
---

## authorize

## Description

Protect a page by redirecting the current site visitor to another page if she/he has not been authenticated through the default authentication process. 

## Syntax

{% raw %}
```liquid
{% authorize "<content type slug>", "<page handle>" %}
```
{% endraw %}

## Example

{% raw %}
```liquid
{% authorize "accounts", "sign_in" %}

<p>This page can only be viewed by authenticated users</p>
```
{% endraw %}
