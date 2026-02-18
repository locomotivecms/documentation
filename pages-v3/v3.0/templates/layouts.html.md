---
title: Layouts
order: 3
---

Layouts are a specific kind of page. They are very useful in the back-office (Locomotive UI) when you want your users to create new pages from a layout other than one used for the parent page.

## Create a layout

By convention, layouts are located under the **app/views/pages/layouts** folder. 

```
+- app/views/pages/
    +- index.liquid
    +- layouts/
        +- default.liquid
        +- simple_column.liquid
        +- double_columns.liquid
```

{% hint style="info" %}
**You can also apply page inheritance with layouts.**

In other words, a layout can inherit from another layout.
{% endhint %}


{% raw %}
```liquid
---
title: Double columns
---
{% extends layouts/default %}
{% block main %}
  <div class="left-column">
     {% block left_column %}
        {% editable_text content %}Lorem ipsum{% endeditable_text %}
     {% endblock %}
  </div>
  <div class="right-column">
     {% block right_column %}
        {% editable_text content %}Lorem ipsum{% endeditable_text %}    
     {% endblock %}
  </div>
{% endblock %}
```
{% endraw %}

In some situation, you may want a layout to be listed in the list of layouts in the back-office. Just put `is_layout: false` in the header of your layout content.

{% hint style="warning" %}
**Layouts are not listed as pages in the back-office**

However they can be chosen when creating a new page in the backoffice:
{% endhint %}


![2810](pages/layouts/7mTFHvRTRlabRIEItiZd_Screen-20Shot-202016-01-26-20at-2014.46.27.png)

## Use layouts

There is not much to do, only passing the path of the layout to the `extends` liquid tag.

{% raw %}
```liquid
---
title: My awesome page
editable_elements:
  "main/left_column/content": "<p>This is my awesome left column</p>"
  "main/right_column/content": "<p>This is my awesome right column</p>"  
---
{% extends layouts/double_columns %}
```
{% endraw %}

If you write liquid code below the extends statement and the end-user changes the layout of that page in the back-office, your code will be erased. 

If you don't want users to change the layout of a page, insert `allow_layout: false` in your page header.
