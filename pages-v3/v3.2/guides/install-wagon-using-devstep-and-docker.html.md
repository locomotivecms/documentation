---
title: Install Wagon using Devstep and Docker
order: 7
---

{% hint style="warning" %}
**Important: This document is no longer valid**

Devstep is incompatible with Docker as of Docker 1.12. This is because as of July 2017, Devstep hasn't been updated in over 2 years. Spend (waste) time going down this path at your own peril.
{% endhint %}


If you don't want to install the ruby package on your machine and you are familiar with Heroku you can use Devstep.
Devstep reuse the same buildpack as Heroku, in short Devstep will start a container and install wagon inside. If you want to drop wagon just drop the container, nothing have been install on your host. (Devstep demo video : [https://vimeo.com/99482658](https://vimeo.com/99482658))

First install Docker : [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/)
Then install Devstep : [http://fgrehm.viewdocs.io/devstep/cli/installation/](http://fgrehm.viewdocs.io/devstep/cli/installation/)

Now create a new project

```shell
mkdir MyPortfolio
cd MyPortfolio
devstep bootstrap -r devstep/MyPortfolio
```

Devstep will start and open a new container, now set the environnement type

```shell
build-project -b ruby
reload-env
```

Now install wagon and bootstrap your new project 

```shell
gem install locomotivecms_wagon
wagon init . -t bootstrap
bundle install
```

Your image and your project are ready, just exit the container to save the image (no more build until the next dev)

```shell
exit
```

Image is ready, it's time to hack !

```shell
devstep hack -p 3333:3333
```

Now you are inside a container, with all dependencies installed, let's run wagon

```shell
bundle exec wagon serve
```

You can access to your website at http://localhost:3333
Note : Devstep can hack a lot of environments (python, js, go....)

If you already have a website project, you can simply start to hack with the following command

```shell
git clone https://github.com/myaccount/myproject
cd myproject
devstep build
devstep hack -p 3333:3333
```

Enjoy it !
