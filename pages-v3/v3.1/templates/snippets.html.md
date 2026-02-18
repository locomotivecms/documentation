---
title: Snippets
order: 4
---

A snippet is a part of a website which will be re-used in multiple pages. Snippets reduce code duplication.

## Reusable code: snippets

Let's create a sidebar snippet. Use the command line generator to create a snippet:

```shell
bundle exec wagon generate snippet sidebar
```

You will be asked if you prefer HAML template: if you're not familiar with HAML, answer 'n'.

You will also be asked if you want a localized template: answer 'n'.

A snippet file will be created.

```
+- app/views
    +- pages
        +- index.liquid
    +- snippets
        +- sidebar.liquid
```

In sidebar.liquid:

```html
<div id="sidebar">
  the sidebar
</div>
```

Including the sidebar in a template:

{% raw %}
```liquid
<html>
  <head>
    <title>Snippet example</title>
  </head>
  <body>
    <header>
    </header>
    <div id="content">
      Page content
    </div>
    {% include 'sidebar' %}
    <footer>
    </footer>
  </body>
</html>
```
{% endraw %}

{% hint style="warning" %}
**Editable elements inside snippets**

It is possible to use `editable_text` or any other editable elements inside snippets but you need to wrap them inside a block in order to make them display properly in the engine. 
In this example we would wrap the sidebar code inside the `{% raw %}{% block 'sidebar' %}{% endraw %}`.
{% endhint %}


Learn more:

* [include tag documentation](/liquid-api/tags#include)
