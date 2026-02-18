---
title: Create a site
order: 7
---

Generate a Wagon site on your machine. It generates all the different folders and files needed to build a Wagon site.

## Usage

{% code title="shell" %}
```
wagon init NAME [PATH] [GENERATOR_OPTIONS]
```
{% endcode %}

## Options

| Name | Argument |
| :--- | :--- |
| -t, [--template=TEMPLATE] | instead of building from a blank site, you can also have a pre-fetched site from a template (type `wagon list_templates `)\ Default: **blank** |
| [--skip-bundle], [--no-skip-bundle] | Don't run bundle install |
| [--verbose], [--no-verbose] | Display the full error stack trace if an error occurs |


## Example

Generate a site with the Bootstrap framework.

{% code title="shell" %}
```
wagon init myportfolio -t bootstrap
```
{% endcode %}
