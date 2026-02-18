---
title: Set up a section
order: 2
---

## Create a section

Wagon embeds a section generator which we recommend using over writing sections from scratch which is more prone to errors (since it creates the liquid file for the section and adds/appends to several javascript files in the assets folder).

```shell
wagon generate section name_of_the_section
```

{% hint style="info" %}
**Name of the section**

A string consisting of lowercase letters and underscores (no spaces).
{% endhint %}


During the section setup process you will be asked a few questions. Finally, Wagon will generate a section with some example code to get you started.
All the sections are located under the `app/views/sections` folder of your Wagon site.

## Structure of a section file

A section is composed of two essential elements: 

* a YAML definition (JSON is also accepted)
* a Liquid template

All packaged inside a liquid file like this :

```liquid
---
YAML or JSON Definition
---
Liquid Template
```
