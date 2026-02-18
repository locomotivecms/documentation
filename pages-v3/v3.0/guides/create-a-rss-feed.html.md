---
title: Create a RSS feed
order: 6
---

You can create a page which will be used as a RSS feed for your blog.

**Assumptions**:

* an "articles" page was created as well as a templatized page for an article.
* an "article" model was also created.

In order to create that kind of page, follow these steps:

## 1. Generate a new page

Use Wagon to generate your page:

```text
bundle exec wagon generate page rss
```

## 2. Modify the page

Open your **app/views/pages/rss.liquid** template and modify it like this:

{% raw %}
```xml
---
title: RSS feed
published: true
listed: false
response_type: application/rss+xml
---
<rss version="2.0"
xmlns:content="http://purl.org/rss/1.0/modules/content/"
xmlns:wfw="http://wellformedweb.org/CommentAPI/"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:atom="http://www.w3.org/2005/Atom"
xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
xmlns:slash="http://purl.org/rss/1.0/modules/slash/">
  <channel>
    <title>{{ site.seo_title }}</title>
    <description>{{ site.meta_description }}</description>
    <link>http://www.example.com</link>
    <language>en</language>
    <copyright>Example</copyright>
    <ttl>30</ttl>
    <atom:link href="http://www.example.com/articles/rss.xml" rel="self" type="application/rss+xml" />
    {% for article in contents.articles %}
      <item>
        <title>{{ article.title }}</title>
        <description>{{ article.excerpt }}</description>
        <content:encoded>{{ article.body }}></content:encoded>
        <link>http://www.example.com/articles/{{ article._permalink }}</link>
        <guid isPermaLink="true">http://www.example.com/articles/{{ article._permalink }}</guid>
        <pubDate>{{ article.posted_at | localized_date: '%a, %d %b %Y %H:%M:%S %z' }}</pubDate>
        <source url="http://www.example.com/">example.com</source>
      </item>
    {% endfor %}
  </channel>
</rss>
```
{% endraw %}

## 3. RSS feed auto-detection

If you want the browsers and news readers to auto-detect your RSS feed, add the following statement within the "head" tag of your template (or layout if you use one).

{% raw %}
```liquid
{{ '/articles/rss.xml' | auto_discovery_link_tag }}
```
{% endraw %}
