---
title: Filter and Paginate
order: 4
---

When listing content entries in a page, you might want to filter entries or create a pagination system. Here's how to do that.

{% hint style="warning" %}
**We consider that you have created an event content type**

as described [here](/content-types/define-a-content-type).
{% endhint %}


## Add a category field to the event content type

In your **app/content_types/events.yml**, add a block:

```yaml
- category:
    label: Category
    type: string
    required: true
```

Edit **data/events.yml** and add a field category for each entry.

```yaml
- "Sample 1":
    description: "Quam repellat repudiandae harum impedit natus. Quos vel rem vitae error qui culpa est. Eveniet reprehenderit sed ipsum quibusdam eos ab nihil."
    event_date: 2013/21/19 # YYYY/MM/DD
    category: "foo"
```

## Filter the entries on "foo" category

You will use \``with_scope` liquid tag to filter the entries.

In a page, type:

{% raw %}
```liquid
<ul>
{% with_scope category: 'foo' %}
{% for event in contents.events %}
  <li>{{ event.title }}</li>
{% endfor %}
{% endwith_scope %}
</ul>
```
{% endraw %}

## Listing another content type inside the with_scope tag

More often that not, you will probably want to relate your filtered content type to another related content type.

Building up on the previous exemple, let's say that you have defined the events content type and the speakers content type and that each event has many speakers. Check [here](/content-types/relate-two-content-types) for more details on how to create such a relationship between two content types.

{% raw %}
```liquid
<ul>
{% with_scope category: 'foo' %}
{% for event in contents.events %}
  <li>
    <h1>{{ event.title }}</h1>
    <p>Event speakers:</p>
    <ul>
      {% for speaker in event.speakers %}
      <li>{{ speaker }}</li>
    </ul>
  </li>
{% endfor %}
{% endwith_scope %}
</ul>
```
{% endraw %}

{% hint style="warning" %}
**Previous versions of Locomotive**

Please note that for the code proposed in this section to work, you need to have a version of steam above version with commit [dfa638b38d7579ab0193341e20a4ef3345846e51](https://github.com/locomotivecms/steam/commit/dfa638b38d7579ab0193341e20a4ef3345846e51) installed.
{% endhint %}


## Reverse the entries

Add the reversed option to the for tag:

{% raw %}
```liquid
<ul>
{% for event in contents.events reversed %}
  <li>{{ event.title }}</li>
{% endfor %}
</ul>
```
{% endraw %}

## Pagination

You can easily create a navigation with page number, and previous or next button.

{% raw %}
```liquid
{% paginate contents.events by 2 %}
<ul>
{% for event in paginate.collection %}
  <li>{{ event.title }}</li>
{% endfor %}
</ul>
<div class="pagination">
  {% if paginate.previous_page %}<a href="?page={{paginate.previous_page}}">Previous</a>{% endif %}
  {% if paginate.next %}<a href="?page={{ paginate.next_page }}">Next</a>{% endif %}
</div>
{% endpaginate %}
```
{% endraw %}

You also can use the paginate filter instead of the pagination div:

{% raw %}
```liquid
{{ paginate | default_pagination }}
```
{% endraw %}

Learn more:

* [with_scope tag documentation](/liquid-api/tags#with_scope)
* [paginate tag documentation](/liquid-api/tags#paginate)
