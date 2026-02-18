---
title: Localization
order: 5
---

Locomotive is designed to support multiple languages out of the box. It's packed with options and tools to help you easily build complex multilingual sites.

## Multiple locales

First off, you have to declare the set of locales in **config/site.yml**:

```yaml
locales: [en, fr]
```

{% hint style="warning" %}
**Make sure to update the locales as well in the back-office if the site has already been created.**

(in the same order, the first being default)
{% endhint %}


## Helpers

Once you've declared the list of locales you're going to support, the site will add their codes at the beginning of the url, otherwise it will use the default one. So any visitor who knows which locales are supported can see the site in the desired locale just by placing its code in front of the url. Hmm... Not really convenient, right? There should be some way to explicitly give the user informations on available locales. And there is:

Meet the `locale_switcher`! This is a helper that produces the set of links to the current page for all supported locales:

{% raw %}
```liquid
{% locale_switcher %}
```
{% endraw %}

Turns into...

```html
<div id="locale-switcher">
  <a href="/features" class="current en">en</a>
  |
  <a href="/fr/fonctionnalites" class="fr">fr</a>
</div>
```

There are some options available:

| Option | Values | Description |
| :--- | :--- | :--- |
| label | iso | locale | title | * **iso**: Locale code as set in settings: de, fr, en, ...etc. * **locale**: Fancy name of locale: Deutsch, Français, English, ...etc * **title**: The page title translated to the target locale |
| sep | String ("|" by default) | String to separate links |


The customized call might look like...

{% raw %}
```liquid
{% locale_switcher label: 'locale', sep: ' - ' %}
```
{% endraw %}

## URLs

A localized URL in Locomotive will follow this format:

```
/<locale>/<fullpath>
```

{% hint style="info" %}
**The URLs in the the default locale don't include the locale.**

(unless you choose to force prefix it in the back-office)
{% endhint %}


Example:  

```
/about-us/our-company
/fr/a-notre-sujet/notre-compagnie
```

If you use the `{% raw %}{% path_to <page_handle_or_page_or_content_entry> %}{% endraw %}` liquid tag to print the fullpath of a page in your template, then you're all set. 

The \``path_to` tag takes care about the locale and the kind of resource you're asking for.

## Translation of Strings

If you need to translate some strings in a template, the translate filter comes in handy. It just substitutes the key with the associated translation according to the current locale. Use it as follows in the template:

{% raw %}
```liquid
{{ 'some_meaningful_key' | translate }}
```
{% endraw %}

The place where you store the translations is **config/translations.yml**:

```yaml
some_meaningful_key:
  en: I'm the translated string, hurray!
  fr: Je suis la ligne traduite, hourra!
```

If your current locale is **en**, it will show as "*I'm the translated string, hurray*!" on the page.

## Translation of Content

Locomotive's approach to translation of content is amazing. It's really transparent. Every field can be translated, even files, which is extremely useful if you store images with captions or documents in different locales. You may choose whether to translate fields or not on content-types creation using the localize option.

Once your content-type is setup, it's really easy to manage translated strings in the back-office. But you may want to see them during development. If that's the case, just use locale codes as sub-keys as we did before. Say you have a content-type `things` with a localized field `description`, it will look like this in **data/things.yml**:

```yaml
- "First thing":
     description:
       en: Something
       fr: Quelque chose
```

## Site wide SEO parameters

In the config/site.yml file, you will find three keys that define site wide SEO optimization parameters:

* seo_title
* meta_keywords
* meta_descriptions

Each of these parameters can be localized.

If your site is not internationalized, you would write there:

```yaml
seo_title: "My great website"
meta_keywords: "Me, myself and I"
meta_description: "My great website about me, myself and I"
```

And you could then access these parameters in your .liquid files as follows:

{% raw %}
```liquid
<meta name="keywords" content="{{ site.meta_keywords | escape }}">
<meta name="description" content="{{ site.meta_description | escape }}">
<title>
  {{ site.seo_title | escape }}
</title>
```
{% endraw %}

{% hint style="info" %}
**Where to insert the preceding code snippet**

A good idea would be to insert the preceding code snippet in the <head></head> section of your default.liquid layout (provided that such default.liquid layout is then extended by all the other layout and pages.
This way, the site wide SEO parameters will be automatically fed into all the pages of your website.
To learn more about page inheritance and layouts, check [page inheritance](/templates/page-inheritance) and [layouts](/templates/layouts).
{% endhint %}


If you want to localize such parameters, modify your config/site.yml as follows:

```yaml
seo_title: 
  en: "My great website"
  fr: "Mon super site web"
meta_keywords:
  en: "Me, myself, I"
  fr: "Moi, moi, moi"
meta_description:
  en: "My great website about me, myself and I"
  fr: "Mon super site web à propos de moi, moi et moi"
```

If you want to access your parameters in your .liquid files, you have to create localized versions of your .liquid files. To do so, create a new file in the same directory as the original page and name it \<name_of_initial_page>.`<locale>`.liquid.

For instance, if you have an `index.liquid` page that you want to localize, create a `index.fr.liquid`page in the app/views/pages folder.

Then, duplicate the original file's header (the zone included between the two sets of "---") in the new file and modify it to match locale parameters.

For instance, if you have an index.liquid file with the following YAML header:

```yaml
---
title: Home
published: true
listed: true
handle: home
position: 0
---
```

and want to have an index.fr.liquid file, the YAML header of this file should look like this:

```text
---
title: Accueil
published: true
listed: true
handle: home
position: 0
---
```

Now, if you have created a new site using Wagon, open app/views/layout/default.yml. Your file should look like that:

{% raw %}
```liquid
--
title: Default layout
is_layout: false
---
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{ site.name }}</title>

    <link rel="shortcut icon" href="{{ 'favicon.png' | theme_image_url }}">

    {{ 'bootstrap.css' | stylesheet_tag }}
    {{ 'application.css' | stylesheet_tag }}
  </head>
  <body>
    {% include 'nav' %}

    {% block content %}
    {% endblock %}

    {% include 'footer' %}

    {{ 'jquery.min.js' | javascript_tag }}
    {{ 'bootstrap.min.js' | javascript_tag }}
    {{ 'application.js' | javascript_tag }}
  </body>
</html>
```
{% endraw %}

Replace line 12 by the following lines:

{% raw %}
```liquid
<meta name="keywords" content="{{ site.meta_keywords | escape }}">
  <meta name="description" content="{{ site.meta_description | escape }}">
    <title>
      {{ site.seo_title | escape }}
    </title>
```
{% endraw %}

Save this file.

Now create a new default.fr.liquid empty file in the same directory as the default.liquid file (in our case, this should be in app/views/layouts). Add the following code to your new file:

```text
--
title: Modèle par défaut
is_layout: false
---
```

Save this file.

Create a new simple.liquid empty file and add the following snippet of code:

```text
---
title: Simple
is_layout: true
---
```

Save this file.

Now, if you have the Wagon server on, browse to http://localhost:3333. Inspect the file and you should see your SEO parameters rendered in your original language.

Following our example, if you browse to http://localhost:3333/fr and inspect the file, you should see your SEO parameters rendered in your target language (French in our exemple).

{% hint style="warning" %}
**Localization of layouts**

If any of your localized page extends another page or a layout, you need to duplicate all the pages and layouts that your localized page extends in your target language.
{% endhint %}


Note that each of these site wide SEO parameters will be accessible to the editors of the site in the back-office of the Engine for them to personalize.

## Page SEO parameters

You have the opportunity to set the same SEO parameters for each page.

To do so, first add the following keys to the YAML header (the section between the two sets of "---") of any of your .liquid pages.

```yaml
meta_keywords: "Homepage, wonderfull"
meta_description: "This is the home page of my wonderfull website about me, myself and I"
seo_title: "Homepage of my wonderfull website about me, myself and I"
```

This will set page-wide seo parameters. You can then access these parameters using:

{% raw %}
```liquid
{{ page.meta_keywords }}
{{ page.meta_description }}
{{ page.seo_title }}
```
{% endraw %}

You also have access to the page title as follows:

{% raw %}
```liquid
{{ page.title }}
```
{% endraw %}

Now, if, as mentioned [above](/guides/localization#site-wide-seo-parameters), you have duplicated this page (and all its underlying layouts) for localization purposes, in the YAML header of the localized duplicated page, you can define your localized SEO parameters.

Building up on the exemple proposed [above](/guides/localization#site-wide-seo-parameters), your index.liquid YAML header would look like that:

```yaml
---
title: Home
published: true
listed: true
handle: home
position: 0
meta_keywords: "Homepage, wonderfull"
meta_description: "The home page of my wonderfull website about me, myself and I"
---
```

and your index.fr.liquid YAML header would look like that:

```yaml
---
title: Accueil
published: true
listed: true
handle: home
position: 0
meta_keywords: "Page d'accueil, merveilleux"
meta_description: "La page d'accueil de mon merveilleux site à propos de moi, moi et moi"
---
```

Open your default.liquid layout. If your followed the instructions in the section entitled Site wide SEO parameters [above](/guides/localization#site-wide-seo-parameters), it should look like that:

{% raw %}
```liquid
--
title: Default layout
is_layout: false
---
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

		<meta name="keywords" content="{{ site.meta_keywords | escape }}">
		<meta name="description" content="{{ site.meta_description | escape }}">
    <title>
      {{ site.seo_title | escape }}
    </title>

    <link rel="shortcut icon" href="{{ 'favicon.png' | theme_image_url }}">

    {{ 'bootstrap.css' | stylesheet_tag }}
    {{ 'application.css' | stylesheet_tag }}
  </head>
  <body>
    {% include 'nav' %}

    {% block content %}
    {% endblock %}

    {% include 'footer' %}

    {{ 'jquery.min.js' | javascript_tag }}
    {{ 'bootstrap.min.js' | javascript_tag }}
    {{ 'application.js' | javascript_tag }}
  </body>
</html>
```
{% endraw %}

Replace line 12 to 16 with the following snippet of code:

{% raw %}
```liquid
<meta name="keywords" content="{{ site.meta_keywords | escape }} {{ page.meta_keywords | escape }}">
    {% if page.meta_description %}
      <meta name="description" content="{{ page.meta_description | escape }}">
    {% else %}
      <meta name="description" content="{{ site.meta_description | escape }}">
    {% endif %}

    <title>
      {{ page.title | escape }} |
      {% if page.seo_title %}
        {{ page.seo_title | escape }}
      {% else %}
        {{ site.seo_title | escape }}
      {% endif %}
    </title>
```
{% endraw %}

As you can see in the code, for each page, you then have access to four parameters which are defined in the YAML headers of your localized pages:

* page.meta_description
* page.meta_keywords
* page.title
* page.seo_title

These parameters will be available in the back-office under the advanced settings section for each page.

## TimeZones

Finally you may want to setup the timezone in **config/site.yml**:

```yaml
timezone: Paris
```

{% hint style="warning" %}
**Select your timezone directly in the back-office if your site has been created already.**

{% endhint %}


# How locales support works

As you may find out, not all languages are supported.
The community works on adding them one by one, depending on real needs.

All the UI translations can be found in the [engine](https://github.com/locomotivecms/engine) in the `config/locales` folder.

## Adding support for a new locale, the clean way

Fork the engine, duplicate then translate the required `.yml` files.
You also have to register the locale code within `lib/locomotive/configuration.rb` to the `@@default_locales`.
Finally, make a pull request, so the community can merge it to code base.

## After adding a language / pulling a new version, I still don't have the locale visible in the UI ...

Locales are cached.
Check `app/helpers/locomotive/sites_helper.rb` for more details.
You can clear this specific key big running the following code in your rails console :

```
key = [Locomotive::VERSION, :en, 'locales']
Rails.cache.delete(key)
```

## Adding support the fast & dirty way

You may need to deploy quickly a locale support, to release pages for this locales, but without carrying about the UI being translated.
In that case, you can, within you app hosting the engine, you can edit within `config/initializers/locomotive.rb` the `config.site_locales`.
Then restart your application, and clear the cache as above, to be able to push your pages.
