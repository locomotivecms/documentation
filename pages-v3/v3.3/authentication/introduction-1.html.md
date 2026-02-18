---
title: Introduction
order: 1
---

{% hint style="warning" %}
**This functionality is only available in Locomotive 3.3 and Wagon 2.3.**

{% endhint %}


**Authentication** is a built-in functionality which allows to build private access sections within your Locomotive site.

Here is a quick example. You built a beautiful site for a lawyer company and now they're asking for a protected section where partners could download fancy Excel/PDF files.
You could achieve this with the session liquid tag and a members content type. However, this solution presents some flaws. First the password would be stored in clear in Locomotive which is a security issue. Then you couldn't help your clients to reset their forgotten password by sending instructions by email the way [Devise](https://github.com/plataformatec/devise) does.

The authentication built-in functionality provides the following features:

* sign up / sign in / sign out actions
* email instructions action to reset password (the email is a locomotive page)
* reset password action
* encrypted password
* authentication views in Liquid

{% hint style="info" %}
**Wagon authentication demo site**

We built a simple Wagon site which includes all the features listed above. [Click here](https://github.com/locomotivecms/site-templates/tree/master/auth) to see the code source.
{% endhint %}
