---
title: Deploy a site
order: 3
---

Once you have a working Wagon site, you probably want to see it working online, with the backoffice and everything. That's the role of the Locomotive engine.

{% hint style="info" %}
**The only requirement is to have somewhere (it can be online or locally) a running engine and an account. Check out the [engine installation guide](/get-started/getting-started-with-locomotive) for more information.**

{% endhint %}


## Usage

```shell
bundle exec wagon deploy ENV [PATH]
```

**ENV** references the name of your target platform in your **config/deploy.yml** file. 

If the target doesn't exist, the deploy command will ask you for the information about the platform you want to deploy your site to. Then, it will create the site on the Locomotive engine and will update your **config/deploy.yml** accordingly.

{% hint style="info" %}
You can have as many targets (test, …etc) as you want.
{% endhint %}


In some cases, you do not want to push the whole site. For instance, if you have just modified a single page, you do not need to push the assets too.

The available resource types are: theme_assets, snippets, content_types, content_entries, snippets and pages.

## Options

| Name | Description |
| :--- | :--- |
| -r, [--resources=one two three] | Only push the resource(s) passed in argument |
| -d, [--data], [--no-data] | Push the content entries, the editable elements and the translations (by default, they are not) |
| -v, [--verbose], [--no-verbose] | Show each resource being deployed. Display the full error stack trace if an error occurs. |


## Examples

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

```shell
bundle exec wagon deploy staging
```

```shell
bundle exec wagon deploy live -r pages -v
```

```shell
bundle exec wagon deploy live -r content_types content_entries -d
```
