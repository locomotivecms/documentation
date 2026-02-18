---
title: version 3.1
order: 3
---

Find all the commits here:

* **ENGINE**: [https://github.com/locomotivecms/engine/commits/v3.1.x](https://github.com/locomotivecms/engine/commits/v3.1.x)
* **WAGON**: [https://github.com/locomotivecms/wagon/commits/v2.1.x](https://github.com/locomotivecms/wagon/commits/v2.1.x)
* **STEAM**: [https://github.com/locomotivecms/steam/commits/v1.1.x](https://github.com/locomotivecms/steam/commits/v1.1.x)

## Features / Improvements

* site metafields (See our [guide](/guides/site-metafields) about it)
* the site handle property can be modified in the back-office (only for administrators)
* warn editors before leaving a page / form with unsaved changes
* new UI for the sidebar
* default value for a content type field (github issue [here](https://github.com/locomotivecms/engine/issues/1014))
* new translations for the back-office: Chinese, Russian, Lithuanian, Brazilian and French.
* new editable_text option: inline which forces the RTE to use P tags for new lines if the inline parameter is false (more information [here](https://github.com/locomotivecms/engine/commit/8692d34b00bb9c3cfd80904242b14feabb85c0d5))
* localization of site seo fields
* the path_to liquid tag accepts variables in the options
* new liquid filters: shuffle (randomly sort an array), human_size (format nicely the size of a file)
* allow content entry file field type to access the size of the file
* render the site from any bound hostname (WAGON)

## Design

* sidebar and navigation revamped with improved models and pages
* moved page editor to left side

## Issues solved

* fix a couple of bugs about the RTE component
* remove media from the list of static folders
* fix the bug preventing the group*by*`{select name}` method of the content entry liquid drop to work
* select_options of a content type field were not liquified
* do not apply locale_redirection if sitemap.xml is requested
* fix the previous next feature for content entries
* page wouldn't render if nav tag used with snippet option
* Wagon doesn't stop the whole site deployment if a JS/CSS can't be minified.
* fix a bunch of issues when pulling a site
* create log folder for each new site (WAGON)
