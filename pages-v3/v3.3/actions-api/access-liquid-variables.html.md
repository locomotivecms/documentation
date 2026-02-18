---
title: Liquid variables
order: 2
---

## getProp()

## Description

Read a Liquid variable from the current context. The supported types are: string, array, number and hash.

## Usage

{% code title="javascript" %}
```javascript
getProp("<VARIABLE NAME>")
```
{% endcode %}

## Example: 

{% code title="liquid" %}
{% raw %}
```liquid
{% assign my_liquid_variable_name = "Hello world" %}

{% action 'how to use getProp()' %}
  var string = getProp("my_liquid_variable_name");
{% endaction %}
```
{% endraw %}
{% endcode %}

## setProp()

## Description

Write a value into a Liquid variable. The supported types are: string, array, number and hash.

## Usage

{% code title="javascript" %}
```javascript
setProp("<VARIABLE NAME>", <VALUE>);
```
{% endcode %}

## Example: 

{% raw %}
```liquid
{% action 'how to use setProp'() %}
  setProp("my_liquid_variable_name", 42);
{% endaction %}

<p>{{my_liquid_variable_name}}</p>
```
{% endraw %}
