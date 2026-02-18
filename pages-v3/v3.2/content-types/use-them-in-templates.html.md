---
title: Use them in templates
order: 3
---

Content types are like models. Let's say you want to display and manage events on your site, each event having a title, a description and a date.

## 1. Declare the "events" content type

```shell
cd ~/workspace/my_first_site
bundle exec wagon generate content_type events title:string description:text event_date:date
```

## 2. List events on a page

Content type entries can be accessed with `contents.<<content_type slug>>`. Open **app/views/index.liquid** and add in the 'main' block:

{% raw %}
```liquid
<ul>
{% for event in contents.events %}
  <li>{{ event.title }}</li>
{% endfor %}
</ul>
```
{% endraw %}

Test your code [http://0.0.0.0:3333](http://0.0.0.0:3333). You should see the event list.

## 3. Add an "event page"

You want to display details about each event on a seperate page. Url will be **/events/{user["event slug"]}**. We will use an event template page.

```text
mkdir app/views/pages/events
vi app/views/pages/events/content_type_template.liquid
```

{% hint style="info" %}
**Use your own code Editor**

You could replace **vi** by your preferred code editor (SublimeText, TextMate, ...etc).
{% endhint %}


Note that the page filename should be **content_type_template**.

Add this code (we assume your index page contains a 'main' block):

{% raw %}
```liquid
---
title: Event template page
content_type: events
---
{% extends 'index' %}
{% block main %}
<h1>{{ event.title }} on {{ event.event_date | localized_date: '%m/%d/%Y' }}</h1>
<p>{{ event.description }}</p>
{% endblock %}
```
{% endraw %}

OK, now let's change the index page to add a link on each event entry:

{% raw %}
```liquid
<ul>
{% for event in contents.events %}
  <li><a href="{% path_to event %}">{{ event.title }}</a></li>
{% endfor %}
</ul>
```
{% endraw %}

If you want the editors to have a link to the list of events when they edit the index page, you need to wrap your code with the **editable_model** liquid tag like this way:

{% raw %}
```liquid
{% editable_model events, hint: 'some text' %}
  <ul>
  {% for event in contents.events %}
    <li><a href="{% path_to event %}">{{ event.title }}</a></li>
  {% endfor %}
  </ul>
{% endeditable_model %}
```
{% endraw %}

So, when your editors edit the index page, they will see a shortlink to the list of events.

![1100](pages/use-them-in-templates/YOpBLxj3SLGYe79q4HJJ_Screen-20Shot-202015-10-27-20at-202.27.23-20PM.png)
