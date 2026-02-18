---
title: Filters
order: 5
---

{% hint style="info" %}
**Quick Links**

* [auto_discovery_link_tag](#auto_discovery_link_tag)
* [concat](#concat)
* [dasherize](#dasherize)
* [default](#default)
* [default_pagination](#default_pagination)
* [distance_of_time_in_words](#distance_of_time_in_words)
* [encode](#encode)
* [first](#first)
* [flash_tag](#flash_tag)
* [format_date](#format_date)
* [image_tag](#image_tag)
* [javascript_tag](#javascript_tag)
* [javascript_url](#javascript_url)
* [last](#last)
* [localized_date](#localized_date)
* [markdown](#markdown)
* [money](#money)
* [multi_line](#multi_line)
* [parse_date](#parse_date)
* [parse_date_time](#parse_date_time)
* [random](#random)
* [resize](#resize)
* [shuffle](#shuffle)
* [str_modulo](#str_modulo)
* [stylesheet_tag](#stylesheet_tag)
* [stylesheet_url](#stylesheet_url)
* [textile](#textile)
* [theme_image_tag](#theme_image_tag)
* [theme_image_url](#theme_image_url)
* [translate](#translate)
* [underscore](#underscore)
{% endhint %}


## auto_discovery_link_tag

## Description

Return a link tag that browsers and news readers can use to auto-detect an RSS or ATOM feed.

## Syntax

{% raw %}
```text
{{ <url> | auto_discovey_link_tag: <options> }}
```
{% endraw %}

## Example

{% code title="Liquid" %}
{% raw %}
```
{{ '/projects/atom' | auto_discovery_link_tag: 'rel:alternate', 'type:application/atom+xml', 'title:A title' }}
```
{% endraw %}
{% endcode %}
```html
<link rel="alternate" type="application/atom+xml" title="A title" href="/projects/atom" />
```

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| title | String | By default, its value is 'RSS' |
| rel | String | By default, its value is 'alternate' |
| type | String | By default, its value is 'application/rss+xml' |


## concat

## Description

Append strings passed in args to the input.

## Syntax

{% raw %}
```text
{{ <string> | concat: <array of strings> }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'hello' | concat: 'world', 'yeah' }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
helloworldyeah
```
{% endtab %}
{% endtabs %}

## dasherize

## Description

Replace underscores and spaces with dashes in the string.

## Syntax

{% raw %}
```liquid
{{ <string> | dasherize }}
```
{% endraw %}

## Example

{% code title="Liquid" %}
{% raw %}
```liquid
{{ 'hello_world' | dasherize }}
```
{% endraw %}
{% endcode %}
```html
hello-world
```

## default

## Description

Return the value parameter if the input is either null or empty.

## Syntax

{% raw %}
```liquid
{{ <object> | default: <value> }}
```
{% endraw %}

## Example

(if the value of params.author is null)

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ params.author | default: 'John Doe' }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
John Doe
```
{% endtab %}
{% endtabs %}

## default_pagination

## Description

Render the navigation for a paginated collection. Input is the variable returned by the paginate tag

## Syntax

{% code title="Liquid" %}
{% raw %}
```
{{ <paginate object> | default_pagination: <options> }}
```
{% endraw %}
{% endcode %}

## Example

{% code title="Liquid" %}
{% raw %}
```
{{ paginate | default_pagination: next: 'Next entries', previous: 'Previous entries' }}
```
{% endraw %}
{% endcode %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| previous | String | Label of the previous link. By default, the value of I18n.t('pagination.previous') is used. |
| next | String | Label of the next link. By default, the value of I18n.t('pagination.previous') is used. |


## distance_of_time_in_words

## Description

The distance_of_time_in_words filter uses Rails' built-in distance_of_time_in_words helper to measure the difference between two dates and return a representation of that difference in words.

## Syntax

{% raw %}
```text
{{ <date> | distance_of_time_in_words: <date_or_string> }}
```
{% endraw %}

The filter takes a date as input and another date as the first argument. The order of the dates doesn't matter; the earlier date can be either the input or the argument.

## Examples

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ "2013/04/05" | distance_of_time_in_words:  "2007/06/29" }}
{{ "1776-07-04" | distance_of_time_in_words: "1789-07-14" }}
{{ "20/01/2013" | distance_of_time_in_words: "01/05/2014" }}
{{ "May 1, 2010" | distance_of_time_in_words: "June 5, 2010" }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
almost 6 years
about 13 years
over 1 year
about 1 month
```
{% endtab %}
{% endtabs %}

## Localization

The filter's output is automatically localized to the current locale. These localizations can be customized in the Rails locale files for your Locomotive Engine. Please use the below sample as a guide.

{% hint style="info" %}
**Locomotive comes with default translations for this filter for some languages. However, if you receive a "translation missing" error, you will need to add translations to the locale file of your locomotive engine.**

{% endhint %}


```yaml
en:
  datetime:
    distance_in_words:
      about_x_hours:
        one: about 1 hour
        other: about %{count} hours
      about_x_months:
        one: about 1 month
        other: about %{count} months
      about_x_years:
        one: about 1 year
        other: about %{count} years
      almost_x_years:
        one: almost 1 year
        other: almost %{count} years
      half_a_minute: half a minute
      less_than_x_minutes:
        one: less than a minute
        other: less than %{count} minutes
      less_than_x_seconds:
        one: less than 1 second
        other: less than %{count} seconds
      over_x_years:
        one: over 1 year
        other: over %{count} years
      x_days:
        one: 1 day
        other: ! '%{count} days'
      x_minutes:
        one: 1 minute
        other: ! '%{count} minutes'
      x_months:
        one: 1 month
        other: ! '%{count} months'
      x_seconds:
        one: 1 second
        other: ! '%{count} seconds'
```

## encode

## Description

Escape an URI. Useful when using Liquid to generate a JSON response.

## Syntax

{% raw %}
```text
{{ <URI> | encode }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ "http:://www.example.com?key=hello world" | encode }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
http%3A%3A%2F%2Fwww.example.com%3Fkey%3Dhello+world
```
{% endtab %}
{% endtabs %}

## first

## Description

Return the first occurrence of the input object. If the object is a String, it returns the first letter. If it is an Array, the first entry is returned. If the input is a collection, the first method is called on that collection.

## Syntax

{% raw %}
```text
{{ <string_or_array_or_collection> | first }}
```
{% endraw %}

## Examples

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ [42, 0] | first }}
{{ 'Hello World' | first }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
42
H
```
{% endtab %}
{% endtabs %}

## flash_tag

## Description

Embed a flash movie into a page.

## Syntax

{% raw %}
```text
{{ <url> | flash_tag: <options> }}
```
{% endraw %}

## Example

{% raw %}
```text
{{ 'http://youtube.com?...' | flash_tag: width: '100px', height: '50px' }}
```
{% endraw %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| width | String | pixel or % |
| height | String | pixel or % |


## format_date

## Description

alias for localized_date.

## Syntax

{% raw %}
```text
{{ <date> | format_date: <locale> }}
```
{% endraw %}

## image_tag

## Description

Build the HTML img tag.

## Syntax

{% raw %}
```text
{{ <url> | image_tag: <options> }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'http://placehold.it/350x150' | image_tag: 'alt:hello world' }}
outputs
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
<img src="http://placehold.it/350x150" alt="hello world" />
```
{% endtab %}
{% endtabs %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| alt | String |  |
| title | String |  |


## javascript_tag

## Description

Build the link tag of a theme stylesheet.

## Syntax

{% raw %}
```text
{{ <path_to_a_theme_asset_or_url> | javascript_tag }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'application.js' | javascript_tag }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
<script src="/sites/<site_id>javascripts/application.js" type="text/javascript"></script>
```
{% endtab %}
{% endtabs %}

## javascript_url

## Description

Return the url of a theme asset javascript.

## Syntax

{% raw %}
```text
{{ <path_to_a_theme_asset> | javascript_url }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'application.js' | javascript_url }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
/sites/<site_id>/theme/javascripts/application.js
```
{% endtab %}
{% endtabs %}

## last

## Description

Return the last occurrence of the input object. If the object is a String, it returns the last letter. If it is an Array, the last entry is returned. If the input is a collection, the last method is called on that collection.

## Syntax

{% raw %}
```text
{{ <string_or_array_or_collection> | last }}
```
{% endraw %}

## Examples

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ [42, 0] | last }}
{{ 'Hello World' | last }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
0
d
```
{% endtab %}
{% endtabs %}

## localized_date

## Description

Pretty print a date.

## Syntax

{% raw %}
```text
{{ <date> | localized_date: <format>(, <locale>) }}
```
{% endraw %}

## Examples

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ today | localized_date: '%d %B' }}
{{ today | localized_date: '%d %B', 'fr' }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
01 September
01 septembre
```
{% endtab %}
{% endtabs %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| format | String | It depends on the current locale. For the 'en' locale, it is "%m/%d/%Y". Read the [syntax reference](http://liquid.rubyforge.org/classes/Liquid/StandardFilters.html#M000012). |
| locale | String | Optional. By default, it is the current locale. |


## markdown

## Description

The markdown filter converts text formatted with Markdown to HTML using the ruby gem Redcarpet. For a complete explanation of markdown syntax, please visit the Markdown Syntax.

## Syntax

{% raw %}
```text
{{ <markdown_code> | markdown }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ '# Header' | markdown }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
<h1>Header</h1>
```
{% endtab %}
{% endtabs %}

## money

## Description

Formats a number into a currency string (e.g., $13.65). You can customize the format in the options hash.

## Examples

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```liquid
{{ product.price | money }}
```
{% endraw %}
{% endtab %}
{% tab title="With options" %}
{% raw %}
```liquid
{{ product.price | money: unit: "€", format: "%n %u" }}
```
{% endraw %}
{% endtab %}
{% endtabs %}

## multi_line

## Description

Insert a <br /> tag in front of every \n linebreak character.

## Syntax

{% raw %}
```text
{{ <string> | multi_line }}
```
{% endraw %}

## Example

outputs

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ "hello\nworld" | multi_line }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
hello<br/>world
```
{% endtab %}
{% endtabs %}

## parse_date

## Description

Parse the given representation of date, and create a date object. 

## Syntax

{% code title="Liquid" %}
{% raw %}
```liquid
{{ '2015-09-26' | parse_date }}
```
{% endraw %}
{% endcode %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| format | String | By default, it uses a localized format. For instance, in English, that will be: **"%m/%d/%Y"**. You're free to use any format you want. |


## parse_date_time

## Description

Parse the given representation of date time, and create a date time object. 

## Syntax

{% raw %}
```liquid
{{ '2015-09-26 10:42pm' | parse_date_time }}
```
{% endraw %}

## Options

|  |  |  |
| :--- | :--- | :--- |
| format | String | By default, it uses a localized format. For instance, in English, that will be: **"%m/%d/%Y %H:%M"**. You're free to use any format you want. |


## random

## Description

Get a randomly number greater than or equal to 0 and strictly less than the max number passed in parameter.

## Syntax

{% raw %}
```text
{{ <max_integer> | random }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 10 | random }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
4
```
{% endtab %}
{% endtabs %}

(or any numbers between 0 and 9.)

## resize

## Description

Resize any image on the fly by calling behind the scene the DragonFly gem. The url to the dynamically resized image is returned. The processing relies on ImageMagick.

## Syntax

{% raw %}
```text
{{ <string> | resize: <resize_string> }}
```
{% endraw %}

## Examples

{% raw %}
```text
{{ project.screenshot | resize: '100x100' }}
{{ 'http://example.com/images/banner.png' | resize: '300x50#' }}
```
{% endraw %}

By default, the Rack::Cache middleware is called for the caching. If you host your LocomotiveCMS on Heroku please visit this page for setup instructions.

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| resize_string | String | The ImageMagick geometry string. See the following [link](https://markevans.github.io/dragonfly/imagemagick/#processors) for examples. |


## shuffle

## Description

Randomly sort an array. It also works with content entries if you've got a couple of them.

## Examples

{% tabs %}
{% tab title="Simple" %}
{% raw %}
```liquid
{% assign products = ['Product 1', 'Product 2', 'Product 3'] %}
{% assign random_products = products | shuffle %}
```
{% endraw %}
{% endtab %}
{% tab title="Content type" %}
{% raw %}
```liquid
{% comment %}Take 5 random products{% endcomment %}
{% assign random_products = contents.products.all | shuffle | slice: 0, 5 %}
```
{% endraw %}
{% endtab %}
{% endtabs %}

## str_modulo

## Description

Print the input string every modulo occurences.

## Syntax

{% raw %}
```text
{{ <string> | str_modulo: <index>, <modulo> }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'odd' | str_modulo: 1, 2 }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
odd
```
{% endtab %}
{% endtabs %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| index | Integer | The counter. Usually, the index variable within a for loop |
| modulo | Integer | By default, it is the current locale |


## stylesheet_tag

## Description

Return the link tag of a theme stylesheet.

## Syntax

{% raw %}
```text
{{ <path_to_a_theme_asset_or_url> | stylesheet_tag(: <media>) }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'application.css' | stylesheet_tag }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
<link href="/sites/<site_id>/theme/stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />
```
{% endtab %}
{% endtabs %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| media | String | By default, its value is 'screen' |


## stylesheet_url

## Description

Return the url of a theme asset stylesheet.

## Syntax

{% raw %}
```text
{{ <path_to_a_theme_asset> | stylesheet_url(: <media>) }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'application.css' | stylesheet_url }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
"/sites/<site_id>/theme/stylesheets/application.css"
```
{% endtab %}
{% endtabs %}

## textile

## Description

The textile filter converts text formatted with Textile to HTML using the popular ruby gem RedCloth. For a complete explanation of textile syntax, please visit the Textile Reference Manual for RedCloth.

## Syntax

{% raw %}
```text
{{ <string> | textile }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'h3. Header' | textile }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
<h3>Header</h3>
```
{% endtab %}
{% endtabs %}

## theme_image_tag

## Description

Return the image tag of a theme image.

## Syntax

{% raw %}
```text
{{ <path_to_a_theme_image> | theme_image_tag(: <options>) }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'banner.png' | theme_image_tag: 'alt:hello world' }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
<img src="/sites/<site_id>/theme/images/banner.png" alt="hello world" />
```
{% endtab %}
{% endtabs %}

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| alt | String |  |
| title | String |  |


## theme_image_url

## Description

Return the url of a theme image.

## Syntax

{% raw %}
```text
{{ <path_to_a_theme_image> | theme_image_url }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```
{{ 'banner.png' | theme_image_url }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
/sites/<site_id >/theme/images/banner.png
```
{% endtab %}
{% endtabs %}

## translate

## Description

When your site is localized, hard-coded static strings are not permitted. That's why you need to use translations (see the [localization guide)](/guides/localization)).

## Syntax

{% raw %}
```liquid
{{ <string> | translate(: <options>) }}
```
{% endraw %}

## Options

| Name | Type |  |
| :--- | :--- | :--- |
| locale | String |  |


## Examples

{% raw %}
```liquid
{{ 'hello_world' | translate }}
{{ 'hello_world' | translate: locale: 'fr' }}
```
{% endraw %}

Assuming that in the **config/translations.yml**, the following entry exists

{% raw %}
```yaml
post_count_zero: 
  en: "{{ name }} has no posts"
  fr: "{{ name }} n'a aucun artucle"
post_count_one: 
  en: "{{ name }} has one post"
  fr: "{{ name }} a un seul article"
post_count_two:
  en: "{{ name }} has two posts"
  fr: "{{ name }} a deux articles"
post_count_other: 
  en: "{{ name }} has {{ count }} posts"
  fr: "{{ name }} a {{ count }} articles"
```
{% endraw %}

{% raw %}
```liquid
{{ 'post_count' | translate: count: posts.count, name: 'John' }}
```
{% endraw %}

## underscore

## Description

Make an underscored, lowercase form from the expression in the string.

## Syntax

{% raw %}
```liquid
{{ <string> | underscore }}
```
{% endraw %}

## Example

{% tabs %}
{% tab title="Liquid" %}
{% raw %}
```liquid
{{ 'FooBar' | underscore }}
```
{% endraw %}
{% endtab %}
{% tab title="HTML" %}
```
foo_bar
```
{% endtab %}
{% endtabs %}
