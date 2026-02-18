---
title: Install Locomotive Engine
order: 2
---

{% description %}
This page will help you get started with Locomotive on your machine (*nix systems).
{% enddescription %}

Locomotive, the Ruby on Rails application, also named Engine, is only dedicated to the creation / editing of content. In other words, we don't allow anymore developers to create a whole site straight from the UI or even edit the template of a page.

So, sites are exclusively coded locally using our open source tool: [Wagon](http://www.github.com/locomotivecms/wagon). 

## Installing the Engine

{% hint style="info" %}
**Prerequisites:**

* MongoDB 3.x installed and running on your machine. 
* Ruby 2.2 (or higher)
* Ruby on Rails 4.2.6 (or any version below 4.3.0)
{% endhint %}


Create a new Ruby on Rails app:

```shell
rails _4.2.6_ new locomotiveapp --skip-bundle --skip-active-record
cd locomotiveapp
```

Update the Gemfile of the Rails application by adding the **locomotivecms** gem.

```ruby
gem 'locomotivecms', '~> 3.2.0'
```

In case you are using rbenv:

```shell
echo "2.3.3" > .ruby-version
```

Run the Locomotive installation generator

```shell
bundle install
bundle exec rails generate locomotive:install
```

The installation adds the **puma** gem to the Rails application's Gemfile. An additional bundle install is required:

```shell
bundle install
```

Finally, run the Rails server

```shell
bundle exec rails server
```

Now, open your browser at http://localhost:3000/locomotive. You should see the Locomotive Sign in page.

## Creating your first account and site

Click on **"Do not have an account?"** link at the bottom page and fill in the Sign up form in order to create your first account.

![2334](pages/getting-started-with-locomotive/BxpXRFrMQTijfnsevHOV_first.png)

On the next screen, click on the "Add a new site" button.

![2334](pages/getting-started-with-locomotive/7yrcsBUvQtGFDYR4jvld_second.png)

Fill in the form and press "Create site"

![2334](pages/getting-started-with-locomotive/QFcbDU2SSzun8TMF1pfy_third.png)

## Pushing a site template with Wagon

{% hint style="info" %}
**Prerequisites:**

* **site handle** you assigned to your site when you created it (radioactive-fern-4299 from the screenshot in the previous chapter).
* the **email** you used to sign up
* your **API key** that you can find at this url: http://localhost:3000/locomotive/my_account/edit#api
{% endhint %}


If you have not installed Wagon, do:

```shell
curl -O https://wagonapp.s3.amazonaws.com/myportfolio.zip
unzip myportfolio.zip
cd My\ portfolio/
bundle install
```

{% hint style="info" %}
**Upgrading Wagon**

You can upgrade it by running **bundle upgrade** at the root folder of your Wagon site.
{% endhint %}


Otherwise, if you have followed on the [quick start page](/get-started/quick-start), go to the folder where you created your portfolio app.

If you have not followed the tutorial on the quick start page, do:

```shell
mkdir -p ~/Sites/Wagon
cd ~/Sites/Wagon
wagon init MyPortfolio -t bootstrap
cd MyPortfolio
bundle install
```

In all three cases, uncomment / complete the **config/deploy.yml** file.

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

![2334](pages/getting-started-with-locomotive/3vbpcSC0R4yYj52H6ybg_fourth.png)

{% hint style="success" %}
**A quick note on the options you can pass to**

bundle exec wagon push local
* -d allows you to deploy data that you may have added (i) to .yml files under the data folder of your site on the Wagon or (ii) in the header of your file, under the editable_elements section;
* -v means verbose and allows you to see what is going when deploying;
* -r allows you to deploy only certain specific resources of your site. The available resource types are: theme_assets, snippets, content_types and pages. You can learn more about these ressources in the section entitled template.
These parameters are also available when deploying to Heroku or on the Station.
{% endhint %}
