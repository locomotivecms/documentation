---
title: version 3.0
order: 6
---

## Features / Improvements

* Rails 4.2.x!
* brand new content editing experience. AlohaEditor and TinyMCE were dropped an replaced by [Wysihtml](http://wysihtml.com) with a new system to edit the content and see the changes in live.
* new caching system.
* introduce layouts for pages. If an editor wants to create a page, he/she can choose among layouts defined by the developer of the site.
* site dashboard tracking the activities of all the editors of a site.
* the subject of the notification email sent when a content entry is created in the public site can be modified.
* markdown editor for editable text elements in a page and text fields of a content entry.
* allow defining url 301 redirections per site.
* implement the color custom field for content entries.
* support for MongoDB 3.0.
* manage translations of the back-office via Transifex.
* option to redirect domains to the first main domain.
* new Locomotive Ruby API client lib named [Coal](http://github.com/locomotivecms/coal).
* developer tab per site describing how to use Wagon and the Restful API for the site.
* protect a whole site by a password.
* the editable_file liquid tag accepts now a resize option for resizing/cropping images.
* the translate liquid tag supports interpolation and pluralization.

## Refactoring

* brand new UI/UX
* the back-office UI relies on [Bootstrap](http://getbootstrap.com), the most popular and powerful HTML/CSS framework.
* upgrade to the last versions of the main gems: **Rails** (4.2.5), **Mongoid** (5.0.1), **Devise**, **SimpleForm**, **Carrierwave**, ...etc.
* do not rely on subdomains anymore for the multi-sites functionality. Format of the url for the back-office of a site: http://myengine/locomotive/&lt;site handle&gt;.
* the page rendering engine has been extracted to its own gem: [Steam](http://github.com/locomotivecms/steam). Both Wagon and Engine uses Steam.
* drop CanCan and replace it by [Pundit](https://github.com/elabs/pundit)
* replace HAML by SLIM for the back-office views for performance

## Issues solved

You can find most of them here: [Github issues](https://github.com/locomotivecms/engine/issues?q=milestone%3A3.0+is%3Aclosed+is%3Aissue)
