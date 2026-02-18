---
title: Pages
order: 1
---

Pages are the fundamental building blocks of your website. Below you can find out how to setup a page from scratch.

## Choose your page slug

The page slug is its name in the url, in a Wagon site it's defined by the filename without extension. It should only contains alphabetic characters, numbers and "-" or "_". The full path of a page contains its parent (and ancestors).

```
+ index
    + company
        + presentation
```

In this example, the presentation page full path will be `/company/presentation`.

## Use the command line generator

```shell
bundle exec wagon generate page <<your page slug>>
```

You will be asked 2 things:

* whether you want HAML template: answer 'no' if you're not familiar with HAML.
* whether you want a localized template: answer 'no' (multilingual is another topic...)

It will generate a file: **app/views/page/{user["your page slug"]}.liquid**.

{% hint style="info" %}
**Note: In the generate command, you can set the full path of your page:**

`bundle exec wagon generate page company/presentation`.
It will create **app/views/pages/company.liquid** and **app/views/pages/company/presentation.liquid**.
{% endhint %}


## Page header

Before the page content, there is a **header**, enclosed by "---". It contains meta-information about the page using the yaml syntax.

```yaml
---
title: Page title
published: true
listed: false
---
```

If your page extends another one, remember it should be the first instruction after the header.

Here are some possible options that can be used in the page header:

| Property | Description |
| :--- | :--- |
| title | The page title is used in the backoffice and in your template. You can use `{% raw %}{{ page.title }}{% endraw %}` to display it in your page template. |
| published | If set to false, the page won't be publicly visible once hosted in an engine. It will be visible within the Wagon webserver. |
| listed | The listed option is used to decide if the page should be listed in the menu. |
| position | Set the position among sibling pages. This is used for ordering in menus. Accepts integers (1, 2, 3, ...) |
| seo_title | Set the title for SEO, you can use it through the `{% raw %}{% seo %}{% endraw %}` tag or `{% raw %}{{ page.seo_title }}{% endraw %}` in your page template. |
| meta_description | Same as `seo_title` for the meta description. You can use `{% raw %}{{ page.meta_description }}{% endraw %}` in your page template. |
| meta_keywords | Same as `meta_description` for the SEO keywords. You can use `{% raw %}{{ page.meta_keywords }}{% endraw %}` in your page template. |
| redirect_url | Set a redirection to the given url (301). |


{% hint style="warning" %}
**Multiple child pages + a content_type_template**

Note when you have a content-type-template in a parent folder with multiple other child pages like this:
```
+ index
    + projects
        + content_type_template
        + page_1
        + page_2
        + ...
```
You have to add positions which are lower to all the child pages (page_1, page_2, ...). It is recommended to give the content-type-template a position of 99. Other pages can get a lower number (1 -> 98).
{% endhint %}
