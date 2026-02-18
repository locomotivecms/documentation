---
title: Custom routes
order: 4
---

{% hint style="info" %}
**This functionality requires LocomotiveCMS v4 and Wagon v3**

It's available for LocomotiveCMS hosting clients.
{% endhint %}


By default, in LocomotiveCMS, a page can only be viewed from an unique path which is usually based on the current locale, its slug and its parent slug.
Of course, an exception is the "templatized" pages tied to content types (ex.: `/products/<slug of the content entry>`).

However, some use cases require a more dynamic approach regarding the routing mechanism. 

A simple example is the classic archived blog posts. It's relatively common to see blog posts organized by years and months. For instance, the path to posts for a specific month might be something like `/posts/2019/01`.

That's why we've developed dynamic routes.

## Define your custom routes in Wagon

Routes have to be defined in the `config/site.yml` file inside your Wagon file.

## Usage

{% code title="config/site.yml" %}
```yaml
routes:
  - "<path 1>": "<page 1 handle>"
  ...
  - "<path n>": "<page n handle>"
```
{% endcode %}

The path includes **"symbols"** (an underscored string starting with a colon) that will be used to capture the dynamic parts of your route. Each symbol represents a subdirectory.

You can have as many as symbols (subdirectories) as you want in your path.

See the examples below to understand what symbols are.

## Examples

{% code title="config/site.yml" %}
```yaml
routes:
  - "news/:year/:month": "blog_posts_list"
  - "actualites/:year/:month": "blog_posts_list"
  - "products/:category/:product_id": "product_template"
```
{% endcode %}

## Set up a template page

As per the examples above, custom routes require template pages. It should be noted that such template pages are an alternative to the default [content_type_template.liquid](/content-types/use-them-in-templates) pages set to display content entries.

For example, let's say you create a catalogues content_type to display products on your site. The default setup for this content_type might look something like this:

*mysite.com/shop/catalogues/content_type_template.liquid*

However, if you wish to display catalogue pages directly under the shop directory, e.g. mysite.com/shop/some-catalogue-slug, this isn't possible using the default setup above. Instead you will need to create a **custom template page** and store it directly in the shop directory:

*mysite.com/shop/catalogue-template*

And in your site.yml:

{% code title="config/site.yml" %}
```
routes:
  - "shop/:catalogue_slug": "catalogue-template"
```
{% endcode %}

## Use the routes in Liquid

During the rendering step, the **symbols** are extracted from the path and are made available in Liquid through the `params` Liquid variable.

## Syntax

{% raw %}
```liquid
{{ params.<symbol> }}
```
{% endraw %}

## Example

Let's say that one of our routes was `news/:year/:month` pointing to a `news_template` page. Here is what the liquid code may look like:

{% code title="news.liquid" %}
{% raw %}
```liquid
---
title: News
slug: news
handle: news_template
---
{% assign start_date = params.year | append: '-' | append: params.month | append: '-' | append: '01' | parse_date: '%Y-%m-%d' | beginning_of_month %}
{% assign end_date = start_date | end_of_month %}

{% with_scope date.gte: start_date, date.lte: end_date %}
  {% for news in contents.news %}
    {% include 'news_list_item' with news: news index: forloop.index %}
  {% endfor %}
{% endwith_scope %}
```
{% endraw %}
{% endcode %}

{% hint style="warning" %}
**There is no Liquid helper to generate the path of a custom route**

You will have to build the path manually. Ex.: `<a href="{% raw %}{{ path_to news_template }}{% endraw %}/2019/01">January 2019</a>`
{% endhint %}
