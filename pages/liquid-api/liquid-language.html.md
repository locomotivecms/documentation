---
title: Introduction
order: 1
---

LocomotiveCMS uses the exact same template engine as for Shopify, one of the best hosted e-commerce solution. The name of that open source template engine is Liquid.

{% hint style="info" %}
**You can find the source of the Liquid template engine on [github](https://github.com/Shopify/liquid). However, we used an [enhanced version](https://github.com/locomotivecms/liquid) of the original engine.**

{% endhint %}

There are 3 types of markup: Objects, Filters and Tags.

## Objects

When writing a liquid template, you will have access to objects representing things such as; the current site, page, logged in account as well as collections such as your custom content types. We also call them **drops** in case you meet this word further in the documentation.

{% raw %}

```handlebars
{{page.title}}
```

{% endraw %}

**Example**: it displays the title of the current page.

{% hint style="info" %}
**Note: matched pairs of curly brackets are used to output the value of an object**.

{% endhint %}

## Filters

You can modify the output by using filters that you can chain. Filters are simple methods. The first parameter is always the output of the left side of the filter. The return value of the filter will be the new left value when the next filter is run. When there are no more filters, the template will receive the resulting string.

{% raw %}

```handlebars
{{ page.title | upcase | pluralize }}
```

{% endraw %}

**Example**: This displays the title of the current page and applies 2 transformations: upcase + pluralization

## Tags

Tags are used for the logic in the templates making them very dynamic. Thus, you can loop through a collection with the **for** tag, test a variable with the classical **if/else**. We also added, to the original Liquid tags, our own tags in order to build pages more elegantly and more efficiently.

{% raw %}

```handlebars
{% if contents.projects.size == 0 %}
<p>No project</p>
{% endif %}
```

{% endraw %}

**Example**: Check if our custom content type representing projects has entries or not.

{% raw %}

```handlebars
{% nav %}
```

{% endraw %}

**Example**: it displays the main menu of the current site with the UL/LI html tags.

{% hint style="info" %} **Note: matched pairs of curly brackets and percent signs are used to call a tag.**

{% endhint %}
