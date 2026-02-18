---
title: Getting Started with Locomotive dev version
order: 1
---

{% description %}
This page will help you get started with Locomotive V3.
{% enddescription %}

In Locomotive V3, the rails application, also named Engine, is only dedicated to the creation/edition of content. In other words, we don't allow anymore developers to create a whole site straight from the UI or even edit the template of a page.
So, sites are exclusively coded locally using our open source tool: [Wagon](http://www.github.com/locomotivecms/wagon). 

## Installing the Engine

{% hint style="info" %}
**Prerequisites:**

* MongoDB (\~> 2.6) installed and running on your machine. 
* Ruby 2.1 (or upper)
* Ruby on Rails 4.2.1 (or higher)
{% endhint %}


Create a new Ruby on Rails app:

```shell
rails new locomotiveapp --skip-bundle --skip-active-record
cd locomotiveapp
```

Update the Gemfile of the Rails application by adding the **locomotivecms** gem.

```ruby
gem 'locomotivecms', '~> 3.0.0'
```

Run the Locomotive installation generator

```shell
bundle install
bundle exec rails generate locomotive:install
```

Finally, run the Rails server

```shell
bundle exec rails server
```

Now, open your browser at http://localhost:3000/locomotive. You should see the Locomotive Sign in page.

## Creating your first account and site

Click on **"Do not have an account?"** link at the bottom page and fill in the Sign up form in order to create your first account.

![2334](pages/getting-started/hTbejVWThKukx48bD7Gk_first.png)

On the next screen, click on the "Add a new site" button.

![2334](pages/getting-started/0zuFNPwRuayoWjo5wBtu_second.png)

Fill in the form and press "Create"

![2334](pages/getting-started/MqlStRUcTFOfNxqHZbG5_third.png)

## Pushing a site template with Wagon

{% hint style="info" %}
**Prerequisites:**

* **site handle** you assigned to your site when you created it (radioactive-fern-4299 from the screenshot in the previous chapter).
* the **email** you used to sign up
* your **API key** that you can find at this url: http://localhost:3000/locomotive/my_account/edit#api
{% endhint %}


```shell
curl -O https://wagonapp.s3.amazonaws.com/myportfolio.zip
unzip myportfolio.zip
cd My\ portfolio/
bundle install
```

Open the "My portfolio" folder with your IDE and uncomment / complete the **config/deploy.yml** file.

{% hint style="info" %}
**Upgrading Wagon**

You can upgrade it by running **bundle upgrade** at the root folder of your Wagon site.
{% endhint %}


```yaml
local:
  host: localhost:3000
  handle: <the handle property of your site>
  email: <your email>
  api_key: <your API key>
```

Push your site to the Engine

```shell
bundle exec wagon push local -d -v
```

Finally, go back to your site, you should see something similar to the screenshot below.

![2334](pages/getting-started/yFEwLWJXRik4iQX9b5iN_fourth.png)
