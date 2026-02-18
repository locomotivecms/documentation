---
title: Logic
order: 2
---

## case

## Description

When evaluating a large number of conditions.

## Syntax

{% raw %}
```text
{% case <condition> %}
{% when <value_1> %}
  <code>
...
{% when <value_x> %}
  <code>
{% else %}
  <code>
{% endcase %}
```
{% endraw %}

## Example

{% raw %}
```text
{% case condition %}
{% when 1 %}
  hit 1
{% when 2 %}
  hit 2
{% else %}
  hit else
{% endcase %}
```
{% endraw %}

## for

## Description

Loop over a collection.

## Syntax

{% raw %}
```text
{% for item in array %}
  {{ item }}
{% endfor %}
```
{% endraw %}

## Example

Instead of looping over an existing collection, you can define a range of numbers to loop through. The range can be defined by both literal and variable numbers:

{% raw %}
```text
# if item.quantity is 4...
{% for i in (1..item.quantity) %}
  {{ i }}
{% endfor %}
```
{% endraw %}
```html
1 2 3 4
```

## Variables

During every for loop there are following helper variables available for extra styling needs:

| Name | Type | Description |
| :--- | :--- | :--- |
| forloop.length | Integer | length of the entire for loop |
| forloop.index | Integer | index of the current iteration |
| forloop.index0 | Integer | index of the current iteration (zero based) |
| forloop.rindex | Integer | how many items are still left? |
| forloop.rindex0 | Integer | how many items are still left? (zero based) |
| forloop.first | Boolean | is this the first iteration? |
| forloop.last | Boolean | is this the last iteration? |


## if/else/unless

## Description

Boolean logic operations are available on all objects.

## Syntax

{% raw %}
```text
{% if <condition> %}
  <code>
{% else %}
  <code>
{% endif %}
```
{% endraw %}

## Example

{% raw %}
```text
{% if feature.title %}
  {{ feature.title }}
{% endif %}

{% unless feature.body %}
  feature has no content
{% else %}
  {{ feature.body }}
{% endunless %}
```
{% endraw %}
