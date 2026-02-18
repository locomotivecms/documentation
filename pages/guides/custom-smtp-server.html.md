---
title: Custom SMTP server
order: 13
---

{% hint style="warning" %}
**Only available on Engine 4.0.4 (or for Locomotivecms.com customers)**

{% endhint %}


You can setup one or many public forms on your site (see [Create a contact form](doc:create-a-contact-form)). 

When a visitor submits one of those forms, the Engine sends a notification email to a list of accounts.
To send this email, by default, the Ruby on Rails Engine application uses the **ActionMailer** configuration which will be common to all the Locomotive sites.

In some situations, you'd rather use a custom SMTP server with a custom domain per LocomotiveCMS site.  

Here are the steps to let the Engine know about this custom server

## 1. Add a new site metafields namespace

 You've to add a new [Site metafields](doc:site-metafields) namespace to your site.

{% code title="metafields_schema.yml" %}
```yaml
mailer_settings:
  label: SMTP settings
  fields:
    address:
      label: "Address"
      type: string
      hint: "Ex: smtp.mydomain.org. If blank, Locomotive will use the default mailer settings."
    authentication:
      label: "Authentication"
      type: string
      hint: 'Ex: plain'
    port:
      label: "Port"
      type: integer
      hint: "Ex: 587"
    enable_starttls_auto:
      label: "Start TTLS?"
      type: boolean
    user_name:
      label: "Username"
      type: string
    password:
      label: "Password"
      type: string
    domain:
      label: "Domain"
      type: string
    from:
      label: "From"
      type: string
      hint: "Also used for the reply_to field"
```
{% endcode %}

{% hint style="info" %}
**The allowed namespace names that will enable the feature are:**

**mailer_settings**, **smtp_settings** and **email_settings** .
{% endhint %}


## 2. Deploy your modifications

Inside the folder of your Wagon site, type the following command:

```shell
wagon deploy <env> -r site -v
```

## 3. Fill the information in the Locomotive UI

Open your browser, go to your Locomotive site back-office. Then, click on `properties` in the left sidebar and select the `SMTP settings` tab. You should see something like this:

![2706](pages/custom-smtp-server/ad52afe-Screen_Shot_2020-04-01_at_12.02.02_PM.png)

Finally, save your modifications. 

From now, Locomotive will use the SMTP server you've defined to send notifications emails!
