---
title: Drops
order: 3
---

{% hint style="info" %}
**Quick links**

* [Global variables](#global-variables)
* [Site](#site) 
* [Page](#page) 
* [Content Types](#content-types)
* [Content Entry](#content-entry)
* Custom Drops
{% endhint %}


## Global variables

## Example

Display the current date

{% raw %}
```text
{{ now }}
```
{% endraw %}

## List of all the global variables

| Name | Type | Description |
| :--- | :--- | :--- |
| site | Site | current site. Can not be used by itself. Please refer to the properties of the site |
| page | Page | current page. Can not be used by itself. Please refer to the properties of the page |
| wagon | Boolean | True if the page is rendered by Wagon or not (i.e. Engine). |
| session | Hash | all the variables stored in the current session |
| params | Hash | all the GET params of the current request |
| host | String | host of the server (+ port if different from 80) |
| base_url | String | scheme (http or https) + host of the server (+ port if different from 80 or 443). |
| ip_address | String | IP Address of the computer doing the request |
| path | String | HTTP request path |
| fullpath | String | HTTP request full path |
| url | String | HTTP request url |
| post? | Boolean | True if the request is a HTTP post |
| now | Time | current time (UTC) |
| today | Date | current date |
| locale | String | current locale |
| default_locale | String | default locale of the current site |
| locales | Array | all the locales handled by the current site |


## Site

## Example

Display the name of the current site

{% raw %}
```text
{{ site.name }}
```
{% endraw %}

## Attributes

| Name | Type | Description |
| :--- | :--- | :--- |
| name | String | name of the site |
| index | Page | root page of the site |
| pages | Array | all the pages including even sub pages |
| domains | Array | list of all the domains the site answers for |
| seo_title | String | alternative title for the site used for SEO purpose |
| meta_keywords | String | keywords used for SEO purpose |
| meta_description | String | description used for SEO purpose |


## Page

## Example

Display the title of the current page

{% raw %}
```text
{{ page.title }}
```
{% endraw %}

## Attributes

| Name | Type | Description |
| :--- | :--- | :--- |
| title | String | title of the page |
| fullpath | String | the complete full path |
| slug | String | unique identifier for urls, the same as a permalink |
| handle | String | unique identifier for the page (useful for link_to for example) |
| parent | Page | the parent page. Nil if the page is the root |
| children | Array | the direct children |
| breadcrumbs | Array | the parent pages and the page itself |
| depth | Integer | the depth in the tree of pages |
| redirect? | Boolean | true if the page is a redirection. |
| redirect_url | String | URL to a remote or a local page. |
| listed? | Boolean | true if the page is included in the menu |
| published? | Boolean | true if the page is published |
| seo_title | String | alternative title for the page used for SEO purpose |
| meta_keywords | String | keywords used for SEO purpose |
| meta_description | String | description used for SEO purpose |
| templatized? | Boolean | true if this page is a template |
| target_content_type | Content type | example: **\{\{page.target_content_type.count }}** |
| editable_elements | String | value of an editable element.\ syntax: **page.editable_elements.\.``**.\ example: **\ \{\{ page.editable_elements.content.main.title }}** |


## Content types

## Example

Display the number of elements of the entries stored in the Projects model.

{% raw %}
```text
{{ contents.projects.size }}
```
{% endraw %}

## Syntax

{% raw %}
```text
{{ contents.<name> }}
```
{% endraw %}

name is the slug attribute of your content type.

## Attributes

| Name | Type | Description |
| :--- | :--- | :--- |
| first | ContentEntry | First entry of the collection |
| last | ContentEntry | Last entry of the collection |
| empty | Boolean | True if the collection of entries is empty |
| any | Boolean | True if the collection of entries is NOT empty |
| size | Integer | The total number of entries |
| count | Integer | Alias for size |
| length | Integer | Alias for size |
| group*by*`` | Array | The field name is the name of a "Select" type field of the content type. The method returns an ordered Array of Hash. Each Hash stores 2 keys, name which is the name of the option and entries which is the list of the ordered entries for the option. The Array is ordered based on the order of the options set in the back-office. |
| ``_options | Array | The field name is the name of a "Select" type field of the content type. The method returns an ordered Array of available options. |


## Content entry

## Example

Display the name of the first projects. "name" being one of the custom fields described in the content type "Projects".

{% raw %}
```text
{{ contents.projects.first.name }}
```
{% endraw %}

## Attributes

| Name | Type | Description |
| :--- | :--- | :--- |
| * label | String | the label as displayed in the back-office to identify the entry |
| * permalink | String | unique identifier for urls |
| * slug | String | alias for _permalink |
| next | ContentEntry | the next entry for the parent content type based on the order defined in the back-office. Nil if no entry found |
| previous | ContentEntry | the next entry for the parent content type based on the order defined in the back-office. Nil if no entry found |
| seo_title | String | alternative title for the entry used for SEO purpose |
| meta_keywords | String | keywords used for SEO purpose |
| meta_description | String | description used for SEO purpose |
| created_at | Date | Entry creation date time (automatically set) |
