---
title: Define a content type
order: 1
---

{% description %}
entry template with link
{% enddescription %}

Locomotive allows you to create content types without imposing a specific pre-built structure. No SQL knowledge is required here.

Your content types can then be used directly in your Liquid templates.

## Generate it with Wagon

{% hint style="info" %}
**Before further reading, make sure you created a site with Wagon.**

{% endhint %}


Wagon provides you the generate command to help you to create the YAML file describing your content type.

```shell
cd ~/workspace/my_first_site
wagon generate content_type events title:string description:text event_date:date
```

It will generate 2 files:

- **app/content_types/events.yml**
- **data/events.yml**

The first one contains the content_type declaration, the second contains sample data so that you can test your site with fake data. Some random data have been added.

{% hint style="info" %}
**Use plural for your content type names.**

Examples: posts, articles, photos, success_stories, ...etc.
{% endhint %}


{% hint style="info" %}
**The available field types are**

string, text, file, select, boolean, date, date_time, tags, integer, float, belongs_to, has_many, many_to_many.
{% endhint %}


{% hint style="success" %}
**Good practice**

It is strongly advised to declare a string field type as the first entry even if it's not used.
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
| :------- | :--- | :---------- |
| name | String | Public name of the content type. Use plural. |
| slug | String | Slug of the content type. Must be plural, lowercase and snake_case (any spaces replaced with underscores). |
| description | String | Explanation displayed in the backoffice. |
| label_field_name | String | Field slug. Default field slug (generally title), it must be a string field. It is advised to not use relationship fields as it might cause issues with public entry submissions. |
| order_by | String | Changes the order of content entries in Back Office. <br/> <br/>Available values: <br/> <br/>- 'manually'<br/>- 'created_at'<br/>- 'updated_at'<br/>- the slug of any field |
| order_direction | String | Changes the order direction. <br/> <br/>Available values: <br/> <br/>- 'asc'<br/>- 'desc' |
| group_by | String | Groups entries in tabs in the Back Office. <br/> <br/>Available value: <br/> <br/>- slug of any select field |
| tree_parent_field_name | String | Slug of the field used as to organize content entries as a tree (WIP) |
| public_submission_enabled | Boolean | Activates public 'create' API (e.g for a contact form) |
| public_submission_accounts | Array | Array of email addresses to be notified of new entries made with the public API. <br/> <br/>**Note:** Works only in the Engine, not with Wagon. |
| public_submission_title_template | String | Subject of the notification email sent when a new content entry has been created. |
| display_settings | Hash | Controls the display of the following content type tabs in the Back Office. <br/> <br/>Available values: <br/> <br/>- seo: [Boolean]<br/>- advanced: [Boolean]<br/>- position: [Integer]<br/>- hidden: [Boolean] |
| entry_template | String | By default, the Back Office lists content entries using the _label property (see label_field_name) of the content entry. This can be modified by writing your own Liquid template. <br/> <br/>**Example:** `entry_template: 'Name: {% raw %}{{ entry._label }}{% endraw %}'` |
| filter_fields | Array of slugs | Enables a content entry search field in the Back Office. <br/> <br/>This property accepts an array of field slugs that will be checked for matching with user inputs. <br/> <br/>**Example:** `filter_fields: [_slug, name]` |
| fields | Hash | List of fields whose structure is described below |

## Fields types

The minimal structure:

```yaml
field_slug:
  type: <type>
  option: value
```

### Common properties of fields

| Property  | Description |                                                                                                                                                                                                               |
| :-------- | :---------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| label     | String      | Required. Label for the backoffice                                                                                                                                                                            |
| required  | Boolean     | default false                                                                                                                                                                                                 |
| hint      | String      | Displays a hint in the backoffice.                                                                                                                                                                            |
| localized | Boolean     | Default false. Makes this field localized: each language will have a different value.                                                                                                                         |
| unique    | Boolean     | Default `false`. Makes this field unique. Useful for email fields.                                                                                                                                            |
| group     | String      | Rearrange your model fields in groups/tabs in the back-office. **Do not use spaces in the string**. (Underscores will be rendered as spaces in the Back Office, e.g. my_group will be displayed as MY GROUP). |

### Depending on the field type, you can provide one or more options.

| Type | Description |
| :--- | :---------- |
| string | Standard string field |
| text | Longer field. <br/>Use with the **text_formatting** option: <br/> <br/>- html: option to display a wysiwyg editor in the backoffice<br/>- markdown<br/>- raw |
| select | Add select_options: `["value 1", "value 2"]` or for multilingual: <br/>`select_options:<br/>  en: ["Value 1", "Value 2"]<br/>  fr: ["Valeur 1", "Valeur 2"]` |
| file | No option, get the url with `product.the_photo.url` in your code. |
| integer | Integer field. No option. |
| float | Float field. No option. |
| date | Date field. No option. |
| date_time | DateTime field. No option. |
| boolean | true or false field. No option. |
| tags | Tags field. No option. |
| belongs_to | Declare a one-way relationship between two content types. <br/> <br/>**Example:** product belongs to a _category_, field 'category' in **products.yml**: `target: categories` |
| has_many | Declare a recursive relationship between two content types. <br/> <br/>**Example:** _category_ has many products (field 'products' in **categories.yml**): <br/>`target: products<br/>inverse_of: category<br/>ui_enabled: true` <br/>Notice the plurals and singulars. |
| many_to_many | Declare a many-to-many relationship between two content types. <br/> <br/>**Example:** products has and belongs to many _categories_. In **products.yml**: <br/>`target: products<br/>inverse_of: category<br/>ui_enabled: true` |

{% hint style="warning" %}
**Protected Field Names**

There are a number of protected words that cannot be used in content_type slugs or fields. They are:

- class
- destroy
- _id
- id
- send
- site
- site_id
- sites
- system
{% endhint %}
