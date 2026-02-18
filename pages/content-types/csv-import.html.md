---
title: CSV import
order: 5
---

{% hint style="warning" %}
**This functionality is only available from Locomotive v4.1 and above.**

{% endhint %}


The entries of a content type can also imported by the upload of a CSV file in the back-office.

**By default, this functionality is disabled and the editors won't see the import button in the UI.**

In order to use it, follow the instructions below.

## 1. Modify the definition of your content type.

In **your Wagon site**, modify the definition of your content type by adding a new property: `import_enabled`.

Here is an example:

{% code title="app/content_types/products.yml" %}
```yaml
name: Products
slug: products

import_enabled: true

...
fields:
   ....
...
```
{% endcode %}

Once your file is updated, deploy your changes with the `wagon deploy` command.

## 2. Test the CSV import in the back-office

Log in to the Locomotive back-office and go your content type / model from the sidebar. You will see now a new button at the top of the page listing all your content entries.

![2076](pages/csv-import/674f09e-Screen_Shot_2021-09-24_at_10.08.36_AM.png)

Click on the *CSV import* button to access the following screen. 

![2144](pages/csv-import/f09b28f-Screen_Shot_2021-09-24_at_10.12.48_AM.png)

{% hint style="warning" %}
**By default, the `col sep` is the semicolon character and the `quote char` is the double quote character.**

{% endhint %}


In the CSV file expected by Locomotive, the first line represents the names of the content type fields.

Here is an example of a working CSV file ("name" being a field of the products content type).

{% code title="products.csv" %}
```
"_slug";"name";
"product-number-1";"Product #1"
"product-number-2";"Product #2"
"product-number-3";"Product #3"
```
{% endcode %}

{% hint style="info" %}
**To avoid duplicated content entries:**

Add the `_slug` column in your CSV.
If a content entry with the same `_slug` already exists in Locomotive, the import task will perform an update instead of a create.
{% endhint %}


{% hint style="info" %}
**The import feature doesn't handle file upload.**

To bypass that constraint, we suggest to upload the assets on AWS S3 or Dropbox with a public access and then reference their URLs in the CSV file.
{% endhint %}
