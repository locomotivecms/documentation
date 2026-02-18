---
title: Define a content type
order: 1
---

Locomotive allows you to create content types without imposing a specific pre-built structure. No SQL knowledge is required here.

Your content types can then be used directly in your Liquid templates.

## Generate it with Wagon

{% hint style="info" %}
**Before further reading, make sure you created a site with Wagon.**

{% endhint %}


Wagon provides you the generate command to help you to create the YAML file describing your content type.

```shell
cd ~/workspace/my_first_site
bundle exec wagon generate content_type events title:string description:text event_date:date
```

It will generate 2 files:

* **app/content_types/events.yml**
* **data/events.yml**

The first one contains the content_type declaration, the second contains sample data so that you can test your site with fake data. Some random data have been added.

{% hint style="info" %}
**Use plural for your content type names.**

Examples: posts, articles, photos, success_stories, ...etc.
{% endhint %}


{% hint style="info" %}
**The available field types are**

string, text, file, select, boolean, date, date_time, tags, integer, float, belongs_to, has_many, many_to_many.
{% endhint %}


## Description of the YAML file

Here are the properties you can use on **app/content_types/\*.yml files**. All the content types should be plural filenames.

Example of an Article content type:

```yaml
name: Articles
description: Just a simple blog module
order_by: posted_at
order_direction: desc
slug: articles
label_field_name: title
fields:
- title:
    label: Title
    type: string
    hint: The title of the article
- posted_at:
    label: Posted at
    type: date
    hint: The date when the article has been or will be posted.
- body:
    label: Body
    type: text
    text_formatting: html
    hint: The body of the article
```

| Property | Type | Description |
| :--- | :--- | :--- |
| name | String | Public name of the content type. Use plural. |
| slug | String | Internal name of the content type. Use plural and lower case, no space. |
| description | String | Explanation displayed in the backoffice. |
| label_field_name | String | Field slug. Default field slug (generally title), it must be a string field. It is advised to not use relationship fields as it might cause issues with public entry submissions. |
| order_by | String | Any field slug or 'manually' or 'created_at'. Changes the order of content entries in backoffice and content entries. |
| order_direction | String | 'asc' or 'desc' |
| group_by | String | Field slug. Display entries grouped by the given field in the backoffice. |
| public_submission_enabled | Boolean | Activate public 'create' API (e.g for a contact form) |
| public_submission_accounts | Array | Array of emails to be notified of new entries made with the public API. Works only in the Engine, not with Wagon. |
| display_settings | Hash | Control the display of the content type in the back-office. Possible values: * seo: [Boolean] * advanced: [Boolean] * position: [Integer] * hidden: [Boolean] |
| entry_template | String | By default, the back-office displays the _label property (see label_field_name) of the content entry. This can be modified by writing your own Liquid template.\ Example: \{\{ entry._label }} |
| fields | Hash | List of fields whose structure is described below |


## Fields types

The minimal structure:

```yaml
field_slug:
  type: <type>
  option: value
```

### Common properties of fields

| Property | Description |  |
| :--- | :--- | :--- |
| label | String | Required. Label for the backoffice |
| required | Boolean | default false |
| hint | String | Displays a hint in the backoffice. |
| localized | Boolean | Default false. Makes this field localized: each language will have a different value. |
| unique | Boolean | Default `false`. Makes this field unique. Useful for email fields. |


### Depending on the field type, you can provide one or more options.

| Type | Description |
| :--- | :--- |
| string | Standard string field |
| text | Longer field.\ Use with the **text_formatting** option: * html: option to display a wysiwyg editor in the backoffice * markdown * raw |
| select | Add select_options: `["value 1", "value 2"]` or for multilingual: ``` select_options: en: ["Value 1", "Value 2"] fr: ["Valeur 1", "Valeur 2"] ``` |
| file | No option, get the url with `product.the_photo.url` in your code. |
| integer | Integer field. No option. |
| float | Float field. No option. |
| date | Date field. No option. |
| date_time | DateTime field. No option. |
| boolean | true or false field. No option. |
| tags | Tags field. No option. |
| belongs_to | Example with product belongs to a *category*, field 'category' in **products.yml**: `class_name: categories` |
| has_many | Declare a relationship between 2 content types. Example with *category* has many products (field 'products' in **categories.yml**): ``` class_name: products inverse_of: category ui_enabled: true ``` Notice the plurals and singulars. |
| many_to_many | Example with products has and belongs to many *categories*. In **products.yml**: ``` class_name: products inverse_of: category ui_enabled: true ``` |
