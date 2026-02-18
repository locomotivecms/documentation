---
title: Session variables
order: 3
---

## getSessionProp()

### Description

Read a session variable.

### Usage

```javascript
getSessionProp("<VARIABLE NAME>")
```

### Example: 

{% raw %}
```liquid
{% action 'how to use getSessionProp() %}
  var loggedInUsername = getSessionProp("username");
{% endaction %}
```
{% endraw %}

## setSessionProp()

### Description

Write a value into the current session. 

### Usage

```javascript
setSessionProp("<VARIABLE NAME>", <VALUE>);
```

### Example: 

{% raw %}
```liquid
{% action 'how to use setSessionProp() %}
  setSessionProp("username", "John");
{% endaction %}
```
{% endraw %}
