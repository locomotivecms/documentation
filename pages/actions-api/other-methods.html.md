---
title: Other methods
order: 7
---

## redirectTo

### Description

Stop the rendering of the current page and redirect the user to another Locomotive page. This page is specified by its handle. 

### Usage

```javascript
redirectTo(<page handle>, <locale>);
```

Note: the locale argument is optional.

### Example

{% raw %}
```javascript
{% action 'Basic redirection' %}

if (params.confirmed) {
  redirectTo('home');
}

{% endaction %}
```
{% endraw %}

## Logging

### Description

When using actions, you might want to print out some of your requests, responses or simply print out statements, to see if your code is being executed.
The way to do that is by using the Log function.

```javascript
const val1 = 'foo';
log('three values: ' + val1);
```
{% code title="Terminal Output" %}
```
2019-05-15T12:01:54.762Z: three values: foo
```
{% endcode %}
