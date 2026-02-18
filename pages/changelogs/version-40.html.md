---
title: version 4.0
order: 1
---

## Features / Improvements

* upgrade to Rails 5.2
* upgrade gems in order to fix vulnerabilities
* implement sections ([https://doc.locomotivecms.com/v4.0/docs/section-introduction](/sections/section-introduction))
* implement custom routes ([https://doc.locomotivecms.com/v4.0/docs/custom-routes](/guides/custom-routes))
* use Webpack within Wagon to manage assets (js/css) ([https://doc.locomotivecms.com/v4.0/docs/manage-js-and-css-with-webpack](/guides/manage-js-and-css-with-webpack))
* allow to group content type fields in the UI (group is a new option of a content type field)
* modify the behavior of the `wagon sync` command
* write documentation about undocumented Liquid date filters: beginning*of*`<period>`, end*of*`<period>`, adjust_date
* add Google reCAPTCHA support ([https://doc.locomotivecms.com/v4.0/docs/create-a-contact-form](/guides/create-a-contact-form))

## Issues solved

* fix issue #1210 (engine only consider hardcoded (site.yml) fields and not engine values)
* fix issue #1228 (Renaming related item, clears all relationships - many_to_many relationship)
* fix issue #1220 (Can't upload font license)
* fix issue #1205 (Update metafields throught the API)
* fix issue #1233 (Editing options of a select field)
* fix issue #1240 (Aws::S3::Errors::NotFound)
* fix issue #1195 (validation errors on redirect_url for localized sites)
