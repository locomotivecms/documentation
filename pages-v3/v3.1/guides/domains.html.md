---
title: Domains
order: 1
---

Each site created in Locomotive has a generic address based on its `handle` property.

For instance, sites hosted by **[locomotive.works](http://www.locomotive.works)**, our platform for professionals, will have the following address:

```
https://station.locomotive.works/_app/my-site/preview
```

If you've deployed your own Locomotive application with **mylocomotiveapp.com** as your main domain, you will end up with addresses like this one:

```
http://mylocomotiveapp.com/locomotive/my-site/preview
```

Locomotive gives you the ability to map any domain names you want to your site so that you don't have to give `https://station.locomotive.works/_app/my-site/preview` anymore as the address of your site.

{% hint style="info" %}
**Installing Locomotive Engine on your local machine and binding to your own custom domain name**

If you are looking for information on how to bind a locally installed Locomotive Engine to your machine, please scroll down to 4. below
{% endhint %}


Let's say you want `www.example.com` and `example.com` to point your Locomotive site hosted by **locomotive.works**.

## 1. Create a CNAME record

{% hint style="warning" %}
**In order to manage to map a domain, you need to have access to the DNS manager of the domain name you previously purchased.**

{% endhint %}


You need to create a record for the `www` sub domain. This can be done by logging into the administration panel of your DNS manager for your **example.com** domain name. Here are the information you'll need.

| Property | Value |
| :--- | :--- |
| **Type** | CNAME |
| **Name** | www |
| **Alias for** | domains.locomotive.works |


{% hint style="info" %}
**If you host your own Locomotive application, use the address of your platform as the "Alias for".**

{% endhint %}


## 2. Create an A record

For a root domain name (ex.: example.com), you can't use a CNAME record. You need to create A record instead. Again, in your DNS manager for your domain name, add a new A record with the following information:

| Property | Value |
| :--- | :--- |
| **Type** | A |
| **Name** | *(leave it blank)* |
| **Address** | 104.131.45.223 |


**Note**: `104.131.45.223` is the IP address of the **locomotive.works** platform.

{% hint style="info" %}
**If you host your own Locomotive application, use the IP of your platform as the "Address".**

{% endhint %}


{% hint style="warning" %}
**DNS modifications can take time to be fully effective.**

{% endhint %}


## 3. Add your domains in the back-office

Now, go to the back-office of your Locomotive site and click to the `General Settings` section in the left sidebar.

Add your 2 domains ([www.example.com](http://www.example.com) and example.com). You should end up with the following screen. Do not forget to save your modifications.

![1194](pages/domains/N8nkaX6PTMuBG2YTd1RJ_Screen-20Shot-202015-10-04-20at-2012.57.17-20AM.png)

So, now, if you type `www.example.com` in your browser, you will see the index page of your Locomotive site.

## 4. Specific instructions to bind your local install of Locomotive to a local domain

The following instruction will describe how to use the feature described under 3. Add your domains to the back-office above on a Locomotive Engine installed on a local machine.

We assume that:

1. you have a Locomotive Engine up and running, installed as described [here](/get-started/getting-started-with-locomotive);
2. you are logged in on the command line as an adminsitrator;
3. you are using a Mac;
4. you known - or at least, you think you know what you are doing.

On the command line:, do

```text
$ sudo
```

Enter your username and password as requested. 

First, make a backup copy of your /etc/hosts file. Something like:

```text
$ cp /etc/hosts /etc/hosts.20151201
```

Then do:

```text
$ vi /etc/hosts
```

You are now in the /etc/hosts file. With the scrolling arrows, go to the line following the line:

```text
127.0.0.1       localhost
```

Type i (to enter into vi's edit mode). You can now add some text to your file.

Press return to add a new line.

Add the following lines:

```text
127.0.0.1       locomotive.dev
127.0.0.1       alpha.locomotive.dev
```

Press the ESC button, then type ZZ. This should save your file and close vi automatically.

Now, if the rails server where your Locomotive Engine is running, close it and restart with the following command. 

Do not forget to log out of your `sudo` account before starting the rails server!

```text
$ bundle exec rails s -b 0.0.0.0
```

This will bind rails to listen on all your localhosts.

If you follow the instructions in 3. Add your domains in the back-office and add

alpha.locomotive.dev

to your list of domain names, you should be able to visit your local site with your browser at:

[http://alpha.locomotive.dev](http://alpha.locomotive.dev)

Happy debugging!!!
