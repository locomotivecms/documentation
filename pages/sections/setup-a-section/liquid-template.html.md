---
title: Liquid template
order: 2
---

Sections use the same Liquid syntax as the rest of the LocomotiveCMS framework. 

The `section` liquid drop is available inside the Liquid template of the section. It contains all the content filled by the user in the back-office.

### Example

{% code title="section" %}
{% raw %}
```liquid
<section id="{{ section.anchor_id }}" {{ section.locomotive_attributes }}>
  <h2>{{ section.settings.greeting_word }}</h2>

  {% for block in section.blocks %}
    <div {{ block.locomotive_attributes }}>
      Here is a <strong>{{ block.type }}</strong> block. 
      Name: {{ block.settings.name }}
    </div>
  {% endfor %}
</section>
```
{% endraw %}
{% endcode %}

{% hint style="warning" %}
**Always wrap your section with a HTML tag.**

It can be any valid DOM element like a **DIV**, **SECTION**, **NAV**, ...etc.
The only requirement is to put `{% raw %}{{ section.locomotive_attributes }}{% endraw %}` in the opening tag.
{% endhint %}


## Settings

You can call settings like this:

{% raw %}
```
{{ section.settings.<setting id> }}
```
{% endraw %}

For instance, if the `id` of the setting is `title` and you want to display it, you'll have to write the following statement: `{% raw %}{{ section.settings.title }}{% endraw %}`.

`{% raw %}{{ section.type }}{% endraw %}` will return the name of the section.

{% hint style="warning" %}
**Wrap text type settings alone within a tag**

It helps our editor UI to refresh the content in the most efficient way. Otherwise, the whole section will be rendered when the content will be updated which is not optimal.
{% endhint %}


**Url type fields** come with extra methods. Given the setting with `my_link` as its id, you will write the following Liquid code to display a HTML link:

{% raw %}
```liquid
<a href="{{ section.settings.my_link }}"  {{ section.settings.my_link.new_window_attribute }}>
  My link
</a>

<a href="{{ section.settings.my_link }}"  {% if section.settings.my_link.new_window %}target="_blank"{% endif %}>
  My link
</a>
```
{% endraw %}

## Blocks

The blocks of your section are stored in an array and can be iterated through with
`{% raw %}{% for block in section.blocks %}{% endraw %}`. 

The provided block object contains all the settings through the `settings` key.
Example: `{% raw %}{{ block.settings.name }}{% endraw %}`

If you want to have a difference output based on the type of the block, just check the `type` attribute.
Example: `{% raw %}{% if block.type == 'video' %}{% endraw %}...{% raw %}{% endif %}{% endraw %}`

{% hint style="warning" %}
**Wrap the block within a tag**

In order to avoid unnecessary calls to the server to re-render the whole section when modifying a simple text setting, we strongly recommend to wrap the block within a tag like this:
{% raw %}
```
<TAG ... {{ block.locomotive_attributes }}>
```
{% endraw %}
where TAG can be any HTML5 tag.
{% endhint %}
