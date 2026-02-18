---
title: Session variables
order: 3
---

## getSessionProp()

## Description

Read a session variable.

## Usage

{% code title="javascript" %}
```javascript
getSessionProp("<VARIABLE NAME>")
```
{% endcode %}

## Example: 

{% code title="liquid" %}
{% raw %}
```liquid
{% action 'how to use getSessionProp() %}
  var loggedInUsername = getSessionProp("username");
{% endaction %}
```
{% endraw %}
{% endcode %}

## setSessionProp()

## Description

Write a value into the current session. 

## Usage

{% code title="javascript" %}
```javascript
setSessionProp("<VARIABLE NAME>", <VALUE>);
```
{% endcode %}

## Example: 

{% raw %}
```liquid
{% action 'how to use setSessionProp() %}
  setSessionProp("username", "John");
{% endaction %}
```
{% endraw %}
