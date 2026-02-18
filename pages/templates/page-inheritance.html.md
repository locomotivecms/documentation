---
title: Page inheritance
order: 2
---

You can use any page as the template for another page. Inheritance consists of a ([Liquid tag](/liquid-api/tags#extends)), which must be written on the first line of a page underneath the metadata (`---`).

Let's assume you have a created a blank site with the default 'index' page. Now create a new page, **app/views/pages/page2.liquid**, containing:

{% raw %}
```liquid
{% extends 'index' %}
```
{% endraw %}

In this case, 'page2' will inherit from the 'index' page. Which means it will have the same content as the index page. When you defined `block` tag(s) inside your index page you can edit these parts inside the new page.

A block tag inside your index page looks like this:

{% raw %}
```liquid
{% block 'main' %}This is the content for the homepage{% endblock %}
```
{% endraw %}

In page2, you can override the 'main' block writing:

{% raw %}
```liquid
{% block 'main' %}This is the content for the page 2{% endblock %}
```
{% endraw %}

By extending index, page2 re-uses all of its content, except the content inside the \{% raw %}{% block %}{% endraw %} tag which is overwritten.

You can have as many `{% raw %}{% block %}{% endraw %}` tags as you want, everywhere in the layout, as long as the name of each block is unique.

{% hint style="info" %}
**Blocks can have any name, but you should avoid making changes to them in the future because content data will be attached to this name.**

{% endhint %}


## Several levels of inheritance

The principle of page inheritance can be applied to every page. The index page is always the root page: you can either use `{% raw %}{% extends 'index' %}{% endraw %}` or `{% raw %}{% extends 'parent' %}{% endraw %}`.

A page generally inherits from index, but you can also make it inherit from any other page by using its slug, or its parent page.

Consider the following page hierarchy:

```
+- index
    +- first page
        +- child of first page
    +- second page
```

In a Wagon site, you will use folders to reflect the pages hierarchy. Create a folder and a template page with the same name: the template will become the parent of any page in the folder.

```
+- app/views/pages/
    +- index.liquid
    +- first-page.liquid
    +- first-page/
        +- child-of-first-page.liquid
    +- second-page.liquid
```

'first-page' can either extend 'parent' or 'index'. 'child-of-first-page.liquid' can either extend 'first-page' or 'parent'.

This is very useful when you need a generic template, and a specific template for a group of pages (ex: same left column).

## Inherit from a page other than the parent

When you extend the parent's layout, you use the tag `{% raw %}{% extends parent %}{% endraw %}`, but what if you would like to extend a page which isn't a direct parent?

For example, how would you make 'first-page' extend from 'second-page'?

```
+- Pages
    +- index
        +- first-page
        +- second-page
```

Add `{% raw %}{% extends 'second_page' %}{% endraw %}` inside your "first page".

Learn more:

* [extend tag documentation](/liquid-api/tags#extends).
* [block tag documentation](/liquid-api/tags#block).
