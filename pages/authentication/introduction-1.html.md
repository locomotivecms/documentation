---
title: Introduction
order: 1
---

**Authentication** is a built-in feature which allows to build private access areas within your Locomotive CMS site.

Consider the following scenario: you have built a beautiful site for a law firm and now they're asking for a password-protected area where partners can download fancy Excel/PDF files. You could achieve this with [session variables](/actions-api/access-session-variables) and a members content type. However, this solution presents some issues:

* member passwords would be stored in plain text in the Back Office which is a security problem
* you couldn't help your members to reset their forgotten password by sending instructions by email

Locomotive CMS' **Authentication** built-in functionality provides the following features:

* sign up / sign in / sign out actions
* email instructions action to reset password (including customisable email template page)
* reset password action
* encrypted password
* authentication views in Liquid

{% hint style="info" %}
**Wagon authentication demo site**

We built a simple Wagon site which includes all the features listed above. [Click here](https://github.com/locomotivecms/site-templates/tree/master/auth) to see the code source.
{% endhint %}
