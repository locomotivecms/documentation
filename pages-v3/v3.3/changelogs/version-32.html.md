---
title: version 3.2
order: 2
---

Find all the commits here:

* **ENGINE**: [https://github.com/locomotivecms/engine/commits/v3.2.x](https://github.com/locomotivecms/engine/commits/v3.2.x)
* **WAGON**: [https://github.com/locomotivecms/wagon/commits/v2.2.x](https://github.com/locomotivecms/wagon/commits/v2.2.x)
* **STEAM**: [https://github.com/locomotivecms/steam/commits/v1.2.x](https://github.com/locomotivecms/steam/commits/v1.2.x)

## Features / Improvements

* Actions API. Documentation [here](/actions-api/introduction)
* [Steam] Public forms handle file inputs
* [RTE] allow the editors to add an alt attribute for an image
* [RTE] Allow custom id and class attributes to main html tags
* add new languages: Spanish, Swedish and Ukrainian
* the with_scope liquid tag accepts a slug if querying a belongs_to field
* improve resize syntax. Commit [here](https://github.com/locomotivecms/steam/commit/a6916f0b98d7ca2e43d0e7ec0d0775001c0d7b3d)
* add request referer to global drop. PR [here](https://github.com/locomotivecms/steam/commit/d16d1f907df3b2f5afa9b3107559423b1570a4ce)
* add option for Authorization header in consume tag. PR [here](https://github.com/locomotivecms/steam/commit/de73d6afa7158087cda1acec191133eef81fcb20)

## Issues solved

* can empty url redirections from the back-office
* Unable to pull/sync due to undefined method 'force_encoding' for hash datatype. [#305](https://github.com/locomotivecms/wagon/issues/305) 
* [Security] the title of pages is vulnerable to Stored XSS [#1163](https://github.com/locomotivecms/engine/issues/1163)
* [RTE] content of iframe cleared. [#1153](https://github.com/locomotivecms/engine/issues/1153)
* the sidebar was not correctly cached
* do not enable live_editing when previewing a json or xml page
* do not remove orphaned editable elements anymore
* unpublished pages were still visible. [#1155](https://github.com/locomotivecms/engine/issues/1155)
* Sitemap.xml is returning elements that are not translated. [#71](https://github.com/locomotivecms/steam/issues/71)
* select fields were not playing well with localization [#1151](https://github.com/locomotivecms/engine/issues/1151)
