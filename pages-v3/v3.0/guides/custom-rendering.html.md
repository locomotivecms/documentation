---
title: Custom rendering
order: 9
---

**Steam** is the rendering component in Locomotive based on the Rack middleware architecture ([http://rack.github.io](http://rack.github.io)). It's shipped with both Wagon and Locomotive Engine.

Each Locomotive "functionality" can be represented as a rack middleware piled up in a stack. For instance, detecting the locale from a request is a single rack middleware. 

So, enhancing the rendering component is a matter of adding a new middleware at the right position in the stack.

In order to achieve that, you need to create a gem which will have to be installed in both your Wagon site and your Locomotive rails application. 

{% hint style="warning" %}
**For Locomotive.works customers:**

If you need to tweak the Locomotive rendering for your site, please contact us (contact at locomotivecms dot com).
{% endhint %}


## The middleware stack in Wagon

Here is the current Steam stack when serving a site with Wagon:

* Rack::Rewrite
* Locomotive::Steam::Middlewares::Favicon
* Rack::Static
* Locomotive::Steam::Middlewares::DynamicAssets
* Dragonfly::Middleware
* Rack::LiveReload
* Locomotive::Wagon::Middlewares::ErrorPage
* Rack::Lint
* Rack::Session::Moneta
* Locomotive::Steam::Middlewares::DefaultEnv
* Locomotive::Steam::Middlewares::Site
* Locomotive::Steam::Middlewares::Logging
* Locomotive::Steam::Middlewares::UrlRedirection
* Locomotive::Steam::Middlewares::Robots
* Locomotive::Steam::Middlewares::Timezone
* Locomotive::Steam::Middlewares::EntrySubmission
* Locomotive::Steam::Middlewares::Locale
* Locomotive::Steam::Middlewares::LocaleRedirection
* Locomotive::Steam::Middlewares::PrivateAccess
* Locomotive::Steam::Middlewares::Path
* Locomotive::Steam::Middlewares::Page
* Locomotive::Steam::Middlewares::Sitemap
* Locomotive::Steam::Middlewares::TemplatizedPage

## 1. Initialize your gem

```shell
bundle gem mycustomrendering
```

## 2. Make custom Liquid drops available in your page

That's one of the enhancements you can make with the gem we're building. 

Basically, we need to:

* create a middleware to reference our drop(s)
* In the middleware, we will enhance the **env\[‘steam.liquid_assigns’]** of Steam

{% tabs %}
{% tab title="lib/mycustomrendering/liquid/drops/products.rb" %}
```ruby
module Mycustomrendering
  module Liquid
    module Drops
      class Products < ::Liquid::Drop
        
        def list
          [
            { 'name' => 'iPhone', 'price' => 42.0 }, 
            { 'name' => 'Macbook Pro', 'price' => 42.0 }
           ]
        end
        
      end
    end
  end
end
```
{% endtab %}
{% tab title="lib/mycustomrendering/middlewares/custom_drops.rb" %}
```ruby
require 'mycustomrendering/liquid/drops/products'

module Mycustomrendering
  module Middlewares
		class CustomDropsCustomDrops
       
      def initialize(app)
           @app = app
       end
      
       def call(env)
          (env['steam.liquid_assigns'] ||= {}).tap do |assigns|
            assigns['products'] = Mycustomrendering::Liquid::Drops::Products.new
          end
          @app.call(env)
       end
      
    end
  end
end
```
{% endtab %}
{% endtabs %}

## 3. Register the middleware

```ruby
require 'mycustomrendering/middlewares/custom_drops'
require 'locomotive/steam'

Locomotive::Steam.configure_extension do |config|
  config.middleware.insert_after Locomotive::Steam::Middlewares::Page, Mycustomrendering::Middlewares::CustomDrops
end
```

## 4. Use it in Wagon and Engine

{% hint style="warning" %}
**Please test your code!**

An example how to do it here: [https://github.com/did/locomotive_view_counter](https://github.com/did/locomotive_view_counter)
{% endhint %}


In the Gemfile of your **Wagon** site:

{% code title="Gemfile" %}
```ruby
...

group :misc do
  # Add your extra gems here
  # gem 'susy', require: 'susy'
  # gem 'bourbon', require: 'bourbon'
  
  # In local
  #gem 'mycustomrendering', path: '<path to your local Gemfile>', require: true
  
  # When your gem has been released on Rubygems
  gem 'mycustomrendering', require: true
end
```
{% endcode %}

In the Gemfile of your **Locomotive** Rails app

{% code title="Gemfile" %}
```ruby
...

# Add your extra gems here
# gem 'susy', require: 'susy'
# gem 'bourbon', require: 'bourbon'

# In local
#gem 'mycustomrendering', path: '<path to your local Gemfile>', require: true

# When your gem has been released on Rubygems
gem 'mycustomrendering', require: true
```
{% endcode %}

## Result

So now, in any of our liquid pages in Wagon, we have access to the products liquid drop.

{% code title="app/views/pages/products.liquid" %}
{% raw %}
```liquid
---
title: My products
---
{% extends 'layout/simple' %}

{% block main %}

<h2>Products ({{ products.size }}</h2>

<ul>
  {% for product in products %}
  <li>
    <b>{{ product.name }}<b/> {{ product.price | money }}
  </li>
  {% endfor %}
</ul>

{% endblock %}
```
{% endraw %}
{% endcode %}
