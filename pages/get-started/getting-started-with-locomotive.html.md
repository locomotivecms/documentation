---
title: Install anywhere
order: 2
---

Locomotive **Engine** is the ruby on rails application that will host the sites you previously developed on your computer using its sibling application:  [**Wagon**](http://www.github.com/locomotivecms/wagon). The advantage is that you never have to put your live site in maintenance mode or take it offline while editing. Once your site is ready for production on your computer,  just deploy it with **wagon** to (one of) your **engine** instance(s) and you're live within seconds.

## Install Engine

{% hint style="info" %}
**Prerequisites:**

* MongoDB 3.4
* Ruby 2.6
* Ruby on Rails 5.2.4.1 (or any version above 5.2.0 and below 6)
* ImageMagick
* NodeJS
{% endhint %}


Create a new Ruby on Rails app:

{% hint style="warning" %}
**is Rails 6 installed on your computer?**

If so, please install Rails 5.2.4.1 (or above and below 6) and specify this version of Rails when creating the new Rails app. Here is the command: `rails _5.2.4.1_ new locomotiveapp --skip-bundle --skip-active-record`
{% endhint %}


```shell
rails new locomotiveapp --skip-bundle --skip-active-record
cd locomotiveapp
```

In case you need to force a version of ruby, run the following statement.

```shell
echo "2.6.5" > .ruby-version
```

Make sure you delete the robots.txt file from public/ otherwise any future sites' robots.txt setting won't be picked up.

Add the Mongoid and Devise gems in your Gemfile.

{% code title="Gemfile" %}
```ruby
gem 'devise', '~> 4.7.1'
gem 'mongoid', '~> 6.4.0'
```
{% endcode %}

Install them and run their setup tasks

```shell
bundle install
bundle exec rails generate mongoid:config
bundle exec rails generate devise:install
```

Update the Gemfile of the Rails application by adding the **locomotivecms** gem.

{% code title="Gemfile" %}
```ruby
 Gemfile
gem 'locomotivecms', '~> 4.0.1'
```
{% endcode %}

Run the Locomotive installation generator

```shell
bundle update
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

* **site handle** assigned to your site when you create it (peached-tsunami-433).
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

Deploy your site to the Engine

```shell
bundle exec wagon deploy local -d -v
```

Finally, go back to your site, you should see something similar to the screenshot below.

![2334](pages/getting-started-with-locomotive/3vbpcSC0R4yYj52H6ybg_fourth.png)

{% hint style="success" %}
**A quick note on the options you can pass to**

bundle exec wagon push local
* -d means "data" and allows you to deploy data that you may have added to
    site.yml under the config folder
    .yml files under the data folder
    headers of your .liquid pages
* -v means "verbose" and allows you to see what is going when deploying;
* -r means "resource" and allows you to deploy certain specific resources of your site. The available resource types are: theme_assets, snippets, content_types, content_entries and pages. You can learn more about these resources in the section entitled template.
These parameters are also available when deploying to Heroku or on the Station.
{% endhint %}
