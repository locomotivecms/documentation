---
title: Authenticate
order: 2
---

When you host all your sites developed with Wagon to the same remote Locomotive platform, it becomes painful to enter your platform credentials in the **config/deploy.yml** file of your new site again and again.

That's why we developed the **auth** command. Log in once and deploy your new sites without creating them manually on your remote back-office.

{% code title="Shell" %}
```
wagon auth
```
{% endcode %}

You will be asked for 3 information:

* the host of your platform running Locomotive Engine (ex: [http://station.locomotive.works](http://station.locomotive.works))
* your email
* your password

{% hint style="info" %}
**Your credentials are stored in the \~/.netrc file.**

{% endhint %}


You can also run the command with arguments like this:

{% code title="shell" %}
```
wagon auth youremail@address.com yourpassword http://mylocomotiveengine.com
```
{% endcode %}

So, now, when you deploy your new Wagon site for the first time, you just need to run the usual deploy command. 

{% code title="shell" %}
```
bundle exec wagon deploy myenv
```
{% endcode %}

Once you answer the platform host question, it creates a new entry named **myenv** in your config/deploy.yml file. You could have replaced **myenv**  by whatever name fits your context (production, staging, development, ...etc).

{% hint style="info" %}
**Default platform URL when deploying**

You can change the default value by assigning a value to the **LOCOMOTIVE_PLATFORM_URL** environment shell variable. Example:
`export LOCOMOTIVE_PLATFORM_URL=http://mylocomotiveengine.com`
{% endhint %}
