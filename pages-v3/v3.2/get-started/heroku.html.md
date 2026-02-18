---
title: Install on Heroku
order: 3
---

{% description %}
Here's how to set up cloud hosting with Heroku and Amazon S3.
{% enddescription %}

{% hint style="info" %}
**Locomotive on Heroku in two clicks**

If you don't want to read all the manual procedure, click on the button below. It will deploy an instance of Locomotive on Heroku!
[![Deploy](pages/heroku/button.svg)](https://heroku.com/deploy?template=https://github.com/locomotivecms/heroku-instant-deploy)
{% endhint %}


## Install the engine locally

Create a new Ruby on Rails app:

```shell
rails new locomotiveapp --skip-bundle --skip-active-record
cd locomotiveapp
```

Update the Gemfile of the Rails application by adding the locomotivecms gem.

```ruby
gem 'locomotivecms', '~> 3.2.1'
```

Run the Locomotive installation generator

```shell
bundle install
bundle exec rails generate locomotive:install --heroku
bundle install
```

## Create the Heroku app from your app folder

{% hint style="warning" %}
**Heroku toolbelt is required**

Visit [https://toolbelt.heroku.com](https://toolbelt.heroku.com) to get the installation instructions.
{% endhint %}


```shell
git init .
heroku create <YOUR APP NAME>
```

## Setup default Heroku variables

{% hint style="info" %}
**How to get your Heroku API key?**

Visit this [link](https://dashboard.heroku.com/account) and scroll down to the API KEY section.
{% endhint %}


```shell
heroku config:add BUNDLE_WITHOUT=development:test
heroku config:add HEROKU_API_KEY=<YOUR HEROKU API KEY>
heroku config:add HEROKU_APP_NAME=<YOUR HEROKU APP NAME>
```

## Set up a remote Mongodb database

There are currently 2 Heroku add-ons for storing data in MongoDB:

* [Compose](https://www.compose.io) (paid plans only)
* [Mongolab](https://mongolab.com) (free plan)

Both are really great but since it's free, we'll take Mongolab for the rest of the installation.

```shell
heroku addons:create mongolab:sandbox
```

## Set up emails

Locomotive needs to send emails and Heroku provides a nice way to send emails for free without configuring a whole mail server on your own. You can find more information [here](http://docs.heroku.com/sendgrid).

```shell
heroku addons:add sendgrid:starter
```

## Set up Amazon S3

 Heroku doesn't offer file storage that's why you need to register to [Amazon S3](https://aws.amazon.com/).

Unless you modified your **config/initializers/carrierwave.rb file**, Carrierwave should be set up for Amazon S3 in the production environment.

```shell
heroku config:add S3_KEY_ID=<YOUR S3 KEY ID>
heroku config:add S3_SECRET_KEY=<YOUR S3 SECRET KEY>
heroku config:add S3_BUCKET=<YOUR S3 BUCKET NAME>
heroku config:add S3_BUCKET_REGION=<YOUR S3 BUCKET REGION>
```

**Note**: For S3 Bucket Region var, here is address for the correspondance table between your ‘human’ bucket region name, and it’s endpoint:

[https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region](https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region)

## Pre-compile your assets

We suggest you to compile your assets locally so that if there is an issue with your assets, you will be able to debug it more easily.

It is very important that you disable the **initialize_on_precompile** option in the **config/application.rb** file of your application:

```ruby
module YourApplication
  class Application < Rails::Application
    ...
    config.assets.initialize_on_precompile = false
    ...
  end
end
```

Then, in your terminal, run the following command:

```shell
bundle exec rake assets:precompile
```

## Launch it!

In your terminal,

```shell
git add .
git commit -am "launch it"
git push heroku master
```

Then, visit your application

```shell
heroku open
```
