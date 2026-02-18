---
title: Delete resources
order: 6
---

This command deletes a resource from a remote Locomotive site described in the **config/deploy.yml** file of a Wagon site.

## Usage

```shell
bundle exec wagon delete ENV RESOURCE [SLUG] [PATH]
```

You can delete the following types of resource: site, page, content_type, snippet, theme_asset or translation.

It can also delete all the items of a resource if you pass: content_types, snippets, theme_assets or translations as the **RESOURCE**.

If you need to delete the whole site for the current **ENV**, just pass site as the **RESOURCE**.

## Examples

```shell
bundle exec wagon delete staging page about-us
```

```shell
bundle exec wagon delete staging content_type articles
```

```shell
bundle exec wagon delete live translations
```

```shell
bundle exec wagon delete staging site
```
