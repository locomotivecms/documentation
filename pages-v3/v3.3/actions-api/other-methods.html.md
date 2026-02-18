---
title: Other methods
order: 7
---

## redirectTo

## Description

Stop the rendering of the current page and redirect the user to another Locomotive page. This page is specified by its handle. 

## Usage

```javascript
redirectTo(<page handle>, <locale>);
```

Note: the locale argument is optional.

## Example

{% raw %}
```javascript
{% action 'Basic redirection' %}

if (params.confirmed)
  redirectTo('home');

{% endaction %}
```
{% endraw %}
