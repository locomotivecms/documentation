---
title: Assets
order: 5
---

You will see how to add assets to your website: images, stylesheets, javascripts and fonts. These are different from the assets that end-users will upload from the back-office.

## Images

Let's say you want to add logo.jpg on your index page. Add logo.jpg to **public/images**.

{% hint style="warning" %}
**Using `<img src="/images/logo.jpg" />` will work when using the Wagon webserver**

but it won't in LocomotiveCMS after deploying to your site. Liquid filters are used to get public urls (images, javascripts, stylesheets...). Moreover, the filters are in charge of putting the right checksum at the end of the url which is needed in case you put a CDN in front of your assets. So use `theme_image_url`.
{% endhint %}


In your page, add:

{% raw %}
```liquid
<img src="{{ 'logo.jpg' | theme_image_url }}" alt="" />
```
{% endraw %}

Note that your image path is simpler, you don't need to specify the "image" folder. Still, you can create subfolders: **public/images/icons/ajax-loader.gif**

will be refered this way:

{% raw %}
```liquid
<img src="{{ 'icons/ajax-loader.gif' | theme_image_url }}" alt="" />
```
{% endraw %}

{% hint style="info" %}
**In your stylesheets, images paths in the url() function will be automatically changed to the theme image url.**

{% endhint %}


The theme_image_tag can also be used to generate the html img tag:

{% raw %}
```liquid
{{ 'icons/ajax-loader.gif' | theme_image_tag }}
```
{% endraw %}

## Javascripts

Put your javascripts in the **public/javascripts** folder then use the `javascript_tag`:

{% raw %}
```liquid
{{ 'libs/jquery-1.8.2.min' | javascript_tag }}
```
{% endraw %}

You can also use the `javascript_url` tag.

## Stylesheets

Put your stylesheets in the **public/stylesheets** folder then use the `stylesheet_tag`:

{% raw %}
```liquid
{{ 'styles.css' | stylesheet_tag: 'screen, projection' }}
```
{% endraw %}

You can also use the `stylesheet_url` tag.

Wagon automatically understands the Sass language to manage your stylesheets.

In the **public/stylesheets/** folder, you can write `.scss` and `.sass` files. It will be automatically compiled to css when developing, and automatically pushed to a Locomotive Engine when deploying.

The `wagon deploy` task will precompile and push only the files not beginning with an underscore (`_`), so prefix with `_` the SASS partials that you `@include`.

## All CSS can be vendor prefixed by autoprefixer

When enabled, [autoprefixer](https://github.com/postcss/autoprefixer) automatically takes care of the vendor prefixing in your CSS (SCSS or SASS) files. When deploying you wagon site to the engine it will run Autoprefixer. So no more worrying about different browser mismatches.

To enable it, just create the following configuration file:

{% code title="config/autoprefixer.yml" %}
```yaml
map:
  inline: true
  from: application.scss
  to: application.css
```
{% endcode %}

Autoprefixer may slow down the css compression in development, you can use NodeJS for the JS engine to make it faster :

```shell
EXECJS_RUNTIME=Node wagon serve
```

## Fonts

Put your fonts in the **public/fonts** folder. Call them directly in your css.

However, if you host your website on Heroku / Amazon S3, you need to do the following steps to make it work.

* Store all your fonts in the **public/fonts** folder
* Create a **public/fonts/all.css** and declare your fonts in it
* Load your **fonts/all.css**

{% raw %}
```liquid
{{ '/fonts/all' | stylesheet_tag }}
```
{% endraw %}

{% hint style="warning" %}
**GDPR Compliance**

In 2018, webmasters in Germany received warning letters from lawyers claiming that loading Google Fonts directly from Google servers was not in compliance with the General Data Protection Regulation. [wikipedia](https://en.m.wikipedia.org/wiki/Google_Fonts)
Fortunately [Mario Ranftl](https://mranftl.com) created this [handy website](https://google-webfonts-helper.herokuapp.com/fonts) to help with downloading and integrating Google web fonts so they can be served from your server.
{% endhint %}


## Learn more

* [theme_image_tag](/liquid-api/filters#theme_image_tag) and [theme_image_url](/liquid-api/filters#theme_image_url) documentation
* [javascript_tag](/liquid-api/filters#javascript_tag) and [javascript_url](/liquid-api/filters#javascript_url) documentation
* [stylesheet_tag](/liquid-api/filters#stylesheet_tag) and [stylesheet_url](/liquid-api/filters#stylesheet_url) documentation
