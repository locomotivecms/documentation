---
title: version 3.4
order: 2
---

## Features / Improvements

* upgrade to Rails 5.1
* upgrade gems in order to fix vulnerabilities
* add a new language: Slovenian
* remove the mongoid_session_store gem from project

## Issues solved

* fix issue #1210 (engine only consider hardcoded (site.yml) fields and not engine values)
* fix issue #1228 (Renaming related item, clears all relationships - many_to_many relationship)
* fix issue #1220 (Can't upload font license)
* fix issue #1205 (Update metafields throught the API)
* fix issue #1233 (Editing options of a select field)
* fix issue #1240 (Aws::S3::Errors::NotFound)
* fix issue #1195 (validation errors on redirect_url for localized sites)
