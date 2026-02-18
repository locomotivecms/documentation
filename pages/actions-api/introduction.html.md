---
title: Introduction
order: 1
---

The **action** liquid tag allows LocomotiveCMS developers to run secure **javascript** code on the server side.

{% hint style="info" %}
**What's the Javascript engine powering Actions?**

No Google V8, no JavaScriptCore, no SpiderMonkey. Instead, we use [Duktape](http://duktape.org), a lightweight and portable engine with Ruby bindings.
{% endhint %}

Here is a list of its capabilities:

- read and write Liquid variables of the current context
- read and write session variables
- built-in functions to read/create/update content entries
- built-in functions to send emails

### Example:

{% code title="Hello world" %}
{% raw %}

```liquid
{% assign string = 'Hello' %}

{% action "send an email to each " %}
  var string = getProp("string");
  string += ' world!';
  setProp("string", string);
{% endaction %}

<p>{{string}}</p>
```

{% endraw %}
{% endcode %}
