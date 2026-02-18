---
title: Protect a site by a password
order: 7
---

This guide will help you to hide your site behind a password to prevent public access.

## Use the default lock-screen

Open the Locomotive back-office for your site and click on the **General Settings** tab in the left sidebar. 

Then, click on **Access Points**, you should see the following screen.

![2510](pages/protect-a-site-by-a-password/q22r6OXuTn4D6Rl8Ow10_Screen-20Shot-202016-01-17-20at-2010.47.51-20PM.png)

Now, toggle the **ENABLE PASSWORD-PROTECTION** switch on **YES** and fill the password input in the field below switch. 

**Don't forget** to save your modifications.

![1690](pages/protect-a-site-by-a-password/rgdZHWf2SRqrb3x4Vc1Y_Screen-20Shot-202016-01-17-20at-2010.53.31-20PM.png)

If you now try to browse your site from the preview url **AND** without being authenticated in the back-office, you should see the following screen.

![2510](pages/protect-a-site-by-a-password/BcJpuhwRQfyFURL6Y3lI_Screen-20Shot-202016-01-17-20at-2010.55.09-20PM.png)

## Build your own lock-screen page

Inside your Wagon site, at the root of the page folder (**app/views/pages**), create a new page called **lock-screen.liquid**. Fill it in with the following code:

{% raw %}
```liquid
---
title: Lock screen
listed: false
handle: lock_screen
---
<html>
  <title>{{ site.name }} - My custom lock screen</title>
  <style>
    @import url(http://fonts.googleapis.com/css?family=Open+Sans:400,700);
    body { background: #f8f8f8; height: 100%; font-family: "Open Sans", sans-serif; font-size: 12px; -webkit-transform-style: preserve-3d; -moz-transform-style: preserve-3d; transform-style: preserve-3d; }
    h1 { text-align: center; }
    form { position: relative; top: 50%; width: 300px; margin: 0px auto; transform: translateY(-50%); -webkit-transform: translateY(-50%); -ms-transform: translateY(-50%); }
    form p { text-align: center; color: #d9684c; }
    form input[type=password] { border: 2px solid #eee; font-size: 14px; padding: 5px 8px; background: #fff; }
    form input[type=submit] { border: 0 none; padding: 6px 20px; background: #171717; color: #fff; font-size: 14px; text-transform: none; transition: all 100ms ease-in-out; cursor: pointer; }
    form input[type=submit]:hover { opacity: .7; }
  }
  </style>
  <body>
    <h1>Work in progress</h1>
    <form action="{{ mounted_on }}" method="POST">
      {% if params.private_access_password.size > 0 %}
        <p>Wrong password</p>
      {% endif %}
      <input type="password" name="private_access_password" placeholder="Password" />
      &nbsp;
      <input type="submit" value="Unlock" />
    </form>
  </body>
</html>
```
{% endraw %}

If you want to test it with Wagon. Open your **config/site.yml** file and add the following lines in the YAML file:

```yaml
private_access: true
password: "asimpletest"
```

{% hint style="info" %}
**The private_access and password properties won't never be deployed.**

{% endhint %}


Now, open your browser at [http://0.0.0.0:3333](http://0.0.0.0:3333), you should see this screen.

![1918](pages/protect-a-site-by-a-password/nR9BYGjzSDqXeChitDRS_Screen-20Shot-202016-01-17-20at-2011.11.13-20PM.png)

Finally, deploy your modifications and you're done!

```shell
bundle exec wagon deploy YOURENV -r pages
```
