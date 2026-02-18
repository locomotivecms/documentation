---
title: Manage JS and CSS with Webpack
order: 2
---

{% hint style="info" %}
**This functionality requires Wagon v3**

{% endhint %}


For a long time, Wagon had been using [Sprockets](https://github.com/rails/sprockets) to process and compile CSS (Sass, Less, ...etc) and Javascript (CoffeeScript, ES6) assets.
One of the nice things about Sprockets is its super easy installation. Nothing to setup, it just works out of the box. Assets were gzipped without any weird configuration.

Things have changed a lot in the Javascript world. Sites now embed a lot of Javascript code in charge of handling animations and building complex UI components. Those Javascript libraries or packages are managed through a central repository (npm) dealing with dependencies and libs versioning.
However, in top of that, frontend developers must use a tool to compile all the package assets required by their sites. To achieve this, developers came up with tools.

One of the most popular is [Webpack](https://webpack.js.org). This is an incredible tool which, unfortunately, can be a burden to set up correctly.

Since the philosophy behind LocomotiveCMS is to remove the painful tasks involved in creating websites, we decided to integrate Webpack inside Wagon so that spinning up a new project takes as little time as possible.

Regarding the [sections](/sections/section-introduction) and more specifically the javascript events as described [here](/sections/events), we also made the integration with Webpack easier. It means that when you generate a new section, we'll create the associated javascript file with all its lifecycle methods and we'll do all the plumbery for you.

{% hint style="warning" %}
**Webpack requires the installation of NodeJS and YARN (or NPM)**

[https://nodejs.org/en/download/package-manager/](https://nodejs.org/en/download/package-manager/)
[https://yarnpkg.com/lang/en/docs/install](https://yarnpkg.com/lang/en/docs/install)
{% endhint %}


## Installation

There is almost nothing to do. Creating a new site will automatically generate all the files we need to start using Webpack. Those files will go under the `app/assets` folder of your Wagon site.
The `package.json` file is located at the root of the Wagon site.

{% hint style="warning" %}
**Avoid build error**

In this file you will need to edit the node_sass dependency version according to your node version following [this chart](https://github.com/sass/node-sass#node-version-support-policy) in order to avoid a build error.
{% endhint %}


{% hint style="info" %}
**Want to add Webpack to a site built with Wagon v3?**

At the root of your site, type the following command: `bundle exec wagon generate webpack` then modify the "name" value in the generated package.json file to match your site's root folder name.
{% endhint %}


You just have to download and install the packages which can be done in one statement in the console.

```shell
yarn
```

## Usage in development

All you have to do is to run the following statement. 

```shell
yarn start
```

**Note:** You will probably need 2 terminals. One for `wagon serve` and the other one for **Webpack**.

Once launched, the command outputs logs about the compilation of 2 files: `bundle.css` and `bundle.js`.

By default, we included the live reload functionality thanks to the **[webpack-livereload-plugin](https://www.npmjs.com/package/webpack-livereload-plugin)** package. So, if you try to modify one of your JS/CSS assets in `app/assets`, the browser will automatically reload the `bundle.css` or the `bundle.js` files.
If you want your browser to reload on **any** file change follow the instructions in [this discussion](https://doc.locomotivecms.com/discuss/61ebdea5dedbd20010cbd7f2).

## Prepare assets for deployment

Assets generated through the `yarn start` command are not optimized for production. For instance, they're not minified.

So, before you deploy your theme assets to your production environment, you'll have to generate optimized assets. This can be achieved with the following command:

```shell
yarn build:prod
```

## How to use Webpack with Bulma

[Bulma](https://bulma.io/) is an open source CSS framework based on Flexbox and lighter than Bootstrap. Some of its benefits: 100% responsive, modular, pure CSS (no javascript).

In your terminal, run this statement:

```shell
yarn add bulma
```

**Note:** Don't forget to stop and re-start, `yarn start`

Next, let's modify the `app/assets/stylesheets/app.scss` file by adding the following code:

{% code title="app/stylesheets/app.scss" %}
```scss
// Bulma
@import '~bulma/bulma.sass';
@import './bulma_variables';
```
{% endcode %}

Then, create a file overriding the Bulma default configuration. This file is named `bulma_variables.scss` and it has to be located in the `app/assets/stylesheets` folder.
Here is a sample:

{% code title="app/assets/stylesheets/bulma_variables.scss" %}
```scss
$family-sans-serif: 'Roboto Condensed', sans-serif;

// Colors
$lighter-blue: #bdd1e4;
$light-blue: #8aacd4;
$dark-blue: #224261;
$dark-grey: #636466;
$light-grey: #a7a9ac;
$brown-orange: #E3A346;

$primary: $dark-blue;
$warning: $brown-orange;

// Navbar
$navbar-height: 7.25rem !default;
```
{% endcode %}
