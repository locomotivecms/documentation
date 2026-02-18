---
title: Quick start
order: 1
---

Before starting, you need to make sure your system has Ruby 2.1 (or higher) installed. If it is not the case, please follow the **first two steps** of the **[following tutorial](https://gorails.com/setup/osx/10.9-mavericks)**.

## 1. Install Wagon

Wagon is a command line tool that let's you develop for Locomotive right on your local machine.

With Wagon, you can generate the scaffolding for a new Locomotive site and start adding the content types and templates you need using any text editor. And thanks to Wagon's built-in web server, you can preview the site with your computer's web browser.

Wagon can also deploy sites to any Locomotive Engine using the wagon **deploy** command. Your changes will immediately be reflected on that site without restarting or making any changes to the Engine server app.

To help you work faster, Wagon comes with support for tools like SASS, HAML, and CoffeeScript. It also works well with source version control systems like git and svn.

```shell
gem install locomotivecms_wagon
```

Make sure it has installed the very last version of Wagon **2.2.0** by typing the following command in your terminal.

{% code title="Shell" %}
```
wagon version
```
{% endcode %}

{% hint style="warning" %}
**"The program 'wagon' is currently not installed" error**

If you use **rbenv** to manage your ruby installations, you need to run `rbenv rehash`.
{% endhint %}


{% hint style="info" %}
**For advanced users: install it with Devstep and Docker**

We wrote a guide describing all the steps. It can be found [here](/guides/install-wagon-using-devstep-and-docker)
{% endhint %}


{% hint style="info" %}
**The Locomotive.works platform**

We offer Locomotive site hosting services with a limited free plan. Check out [our site](http://locomotive.works#pricing) for more information.
{% endhint %}


For practical reasons, we will use [Locomotive.works](http://locomotive.works) as our deployment target but you're absolutely free to use your own Engine on EC2, Digital Ocean, Engine Yard, Linodes, Heroku or your own server. Don't forget, everything is open source here.

```shell
wagon auth
```

If you don't have an account, it will create one for you.

## 2. Create a new Wagon site

We start with our built-in Bootstrap site template which embeds the last version of [Bootstrap](http://getbootstrap.com), the popular HTML/CSS framework.

{% raw %}
```shell
mkdir -p ~/Sites/Wagon
cd ~/Sites/Wagon
wagon init MyPortfolio -t bootstrap
# Use y or n when questions are promted
{% description %}
Create a simple portfolio site and its back-office interface in 5 minutes
{% enddescription %}

cd MyPortfolio
bundle install
```
{% endraw %}

Now, let's launch the Wagon preview server.

```shell
bundle exec wagon serve
```

Open your browser at this address **http://localhost:3333/**, you should see a minimal [Bootstrap](http://getbootstrap.com) site.

## 3. Define a content type

One essential feature of any CMS is the ability to manage structured content. Fortunately, this is one of Locomotive's strongest points.

For our portfolio site, let's say we want to manage a list of our client projects. Those projects are defined by a name, a client name, a description and an image.

**Wagon** includes a number of built-in generators, "content_type" is one of them.

```shell
bundle exec wagon generate content_type projects name:string client:string description:text image:file
```

This command generates 2 files:

* **app/content_types/projects.yml**: It defines the content type.
* **data/projects.yml**: Auto-generated list of project samples.

## 4. Build the page listing the projects

**Liquid** is our powerful templating language. Among a lot of functionalities, it has access to the content types.

First, let's generate our page.

```shell
bundle exec wagon generate page projects
```

Open the **app/views/pages/projects.liquid** page in your code editor and replace the liquid code below the second **"---"** (line 24) with the following code which lists all the projects in Liquid.

{% raw %}
```liquid
{% extends 'layouts/simple' %}

{% block content/main, short_name: true %}

{% editable_model projects %}
<div class="row">
  <div class="col-sm-12">
    {% for project in contents.projects %}
    <div class="media">
      <div class="media-left">
        <img class="media-object" src="{{ project.image.url | default: 'http://loremflickr.com/100/100' | resize: '100x100#' }}" alt="{{ project.name }}">
      </div>
      <div class="media-body">
        <h4 class="media-heading">{{ project.name }}</h4>
        <p><strong>Client:</strong> {{ project.client }}
        <div>
          {{ project.description }}
        </div>
      </div>
    </div>
    {% endfor %}
  </div>
</div>
{% endeditable_model %}

{% endblock %}
```
{% endraw %}

If you refresh your browser, you will notice that a new link ("Projects") appeared at the top right corner of the page.
Click on it and you will see all our samples defined in **data/projects.yml**.

## 5. Deploy the site

Now we have a working Wagon site, we want to see it working online, with the backoffice and everything. That's the role of the Locomotive engine.

Now, let's deploy our site!

```text
bundle exec wagon deploy live
```

Since the site doesn't exist yet on the Locomotive engine, you will be asked for a couple of information about it. 

## 6. Modify the live content of your site!

Go to [locomotive.works](https://station.locomotive.works/_app/sign_in) and sign in with the credentials you entered in the first step.

Then, you will see the following screen:

![2876](pages/quick-start/m7LYIsEvTWax458jOkNJ_first.png)

Click on the **"MyPortfolio"** site and in the next screen, in the left sidebar, click on the **"Projects"** page.

![2876](pages/quick-start/ZhdHoIKGQtK7xybNxZQ8_second.png)

You can edit the text on the right sidebar and see instantaneously the result on the left side.

If you want to add your first project, in right sidebar, click on the "**Manage**" button just beside "**Projects**". In the next screen displaying all the projects (none for now), click on the "New entry" button. Fill the form and save your project.

![2876](pages/quick-start/kroUjFYTkmfifeB9NsnL_third.png)

Finally, go back to your "**Projects**" page. You should see your first project!

![2876](pages/quick-start/Dy71Bnx6SMSrK034wQif_fourth.png)

## What next?

In less than 5 minutes, you were able to create a simple portfolio and generate nice looking back-office to edit the content of your site.

The site needs definitively a custom design. How to do it? Very simple, go back to your Wagon files and tweak your application.css file. 

You want to add a blog? Well, that's also an easy task. Create the right content type (blog posts for instance?) and write the pages to display your posts.

When you're done, just deploy your changes with the **wagon deploy** command!
