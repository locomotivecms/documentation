---
title: Deploy a site
order: 3
---

Once you have a working Wagon site, you probably want to see it working online, with the back-office and everything. That's the role of the Locomotive engine.

{% hint style="info" %}
**The only requirement is to have somewhere (it can be online or locally) a running engine and an account. Check out the [engine installation guide](/get-started/getting-started-with-locomotive) for more information.**

{% endhint %}


## Usage

```shell
wagon deploy ENV [PATH]
```

**ENV** references the target platform in your **config/deploy.yml** file. 

If the target doesn't exist, the deploy command will ask you for the information about the platform you want to deploy your site to. Then, it will create the site on the Locomotive engine and will update your **config/deploy.yml** accordingly.

{% hint style="info" %}
You can have as many targets (test, …etc) as you want.
{% endhint %}


<br/>
<hr/>

### Options

| Name | Description |
| :--- | :--- |
| -r one, [--resources=one two three] | Deploy the resource(s) passed in argument |
| -d, [--data], [--no-data] | Deploy the data associated with editable elements, e.g. sections, content entries, the editable elements and the translations (by default, they are not) |
| -f filename, [--filter=filename] | Filter the resource(s) to be deployed by their filename and extension. Must be used in conjunction with the '-r' option. |
| -e, [--env=ENV] | Deploy data previously synced from a remote LocomotiveCMS engine. Use `-e` in conjunction with the environment to be deployed. |
| -v, [--verbose], [--no-verbose] | Show each resource being deployed. Display the full error stack trace if an error occurs. |


<br/>
<hr/>

### Resource Types

In some cases, you may not wish to deploy the entire site. For instance, if the site is already deployed and you have modified a number of snippets or a single page.

To deploy a particular resource, use the resource option (`-r`) and specify one or more resource(s).

| Name | Usage | Description |
| :--- | :--- | :--- |
| site | `wagon deploy ENV -r site` | Deploys **metafields_schema.yml**. May be used in conjunction with the data option (`-d`) to deploy the contents of **site.yml**. |
| pages | `wagon deploy ENV -r pages` | Deploys all pages. |
| snippets | `wagon deploy ENV -r snippets` | Deploys all snippets. |
| theme_assets | `wagon deploy ENV -r theme_assets` | Deploys all theme_assets (everything contained within the /public folder, i.e. fonts, images, javascripts, samples, stylesheets). |
| content_types | `wagon deploy ENV -r content_types` | Deploys all content_types. |
| content_entries | `wagon deploy ENV -r content_entries -d` | Deploys all content_entries. Must be used in conjunction with the data option (`-d`). |


 Additionally, some resources may be deployed invididually by using the filename option (`-f`).

| Name | Usage | Description |
| :--- | :--- | :--- |
| pages | `wagon deploy ENV -r pages -f page-slug.liquid` | Deploys the specified page. |
| theme_assets | `wagon deploy ENV -r theme_assets -f filename.extension` | Deploys the specified asset. |
| content_entries | `wagon deploy ENV -r content_entries -f content_type_slug -d` | Deploys the content_entries of the specified content_type. |


<br/>
<hr/>

### Further Examples

Given the below /config/deploy.yml file,

{% code title="deploy.yml" %}
```yaml
staging:
  host: station.locomotive.works
  handle: my-site-staging
  email: john@doe.net
  api_key: 373e4330e47d30456221caa4e6b174428b9a1de

live:
  host: station.locomotive.works
  handle: my-site-live
  email: john@doe.net
  api_key: 373e4330e47d30456221caa4e6b174428b9a1de
```
{% endcode %}

The following command deploys the entire site (without data) to the staging platform.

```shell
wagon deploy staging
```

The following command deploys all pages to the live platform.

```shell
wagon deploy live -r pages -v
```

The following command deploys all content_types with content_entries to the live platform.

```shell
wagon deploy live -r content_types content_entries -d
```

The following command deploys the entire site (including data synced from the staging platform) to the live platform. The verbose option has been included to display the full error stack trace if it occurs.

```shell
wagon deploy live -d -e staging -v
```

👍 Thanks to greyskin for this cheatsheet:

{% hint style="info" %}
****Deploying****

*Single:* `bundle exec wagon deploy [env] –r [pages, theme_assets, site] –f [path/filename.extension] –v`
*Multiple:* `bundle exec wagon deploy [env] –r [pages, sections, snippets, content_types, theme_assets, site] –v`
Requirements:
* resource must be plural (even for single deployment)
* file must include extension
* no single option for content_types, sections, snippets
**Content Entries**
*Single:* `bundle exec wagon deploy [env] –r content_entries –f [content_type] -d –v`
*All:* `bundle exec wagon deploy [env] –r content_entries -d –v`
**Deleting**
*Single:* `bundle exec wagon delete [env] [page, section, snippet, content_type, site] [path/filename]`
*Multiple:* `bundle exec wagon delete [env] [pages, sections, snippets, content_types, theme_assets, site]`
Requirements:
* no extensions
* no file extensions
{% endhint %}
