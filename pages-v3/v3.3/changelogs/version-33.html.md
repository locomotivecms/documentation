---
title: version 3.3
order: 1
---

{% hint style="warning" %}
**Security fix**

The LocomotiveCMS engine was vulnerable to a XSS attack (only in Firefox). Long story short, the javascript code passed in the **locale** parameter was executed by the page. The following [commit](https://github.com/locomotivecms/steam/commit/ac021b95c593064badd58a37c5904c69ba0502e3) solves it.
This issue has been fixed in both LocomotiveCMS Engine v3.2.1 and v3.1.2. If you running Engine v3.0, you should consider upgrading at least to v3.1.2.
This vulnerability was reported by the awesome folks at [Bugcrowd](https://www.bugcrowd.com). Kudos to them!
{% endhint %}


## Features / Improvements

* authentication system (Devise in Liquid). Read the introduction [Introduction](doc:introduction-1) 
* new page property: display_settings. This allows to hide a page and its children from authors
* new content entry field type: JSON. It only accepts a Hash.
* add new languages: Catalan, Danish, Finnish, Italian, Japanese, Polish and Russian.
* allow 2 new theme asset extensions: .ttc and .mp4
* redesign the Wagon error page.
* better error message if an error occurs in the action tag (server side JS)
* the callAPI JS action returns now the status of the request
* use the sass and uglifier gems to minify assets
* minify assets when deploying a site with Wagon
* new liquid global variable: http_method
* new built-in JS method for the action liquid tag: redirectTo

## Issues solved

* site locales are strings only (instead of symbols or strings).
* fix issue #1196 (Required text field with markdown formatting causes validation error)
* fix issue #1195 (validation errors on redirect_url for localized sites)
* remove unlisted pages from sitemap and not visible content entries
* host liquid variable was missing from 2.5.x
* editable_elements in snippets don't break the cache anymore
