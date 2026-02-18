---
title: Emails
order: 5
---

## sendEmail

## Description

Send an email. The body can be either a string or the handle of a liquid page. A SMTP server is required.
It's also possible to attach files to the email.

## Usage

```javascript
sendEmail(<OPTIONS>);
```

## Options

| Name | Type | Description |
| :--- | :--- | :--- |
| to | String | recipient's email |
| from | String | sender's email |
| subject | String | subject of the email |
| body | String | [Optional] body of the email |
| page_handle | String | [Optional] handle of a liquid page |
| attachments | Hash | [Optional] key is the file name, value is the absolute url to the file |
| smtp | Hash | settings for the SMTP server. Attributes: address, port,\ user_name, password, authentication ('plain'),\ enable_starttls_auto (boolean) |


## Example

{% raw %}
```liquid
{% action "Send an email" %}
  sendEmail({
      to:                   'john@doe.net',
      from:                 'jane@doe.net',
      subject:              'Hello world',
      body:          				'Lorem ipsum',
      smtp: {
        address:         'somewhere.net',
        port:             '42',
        user_name:        'root',
        password:         'easyone',
        authentication:   'plain',
        enable_starttls_auto: true
      }
    });
{% endaction %}
```
{% endraw %}

{% hint style="warning" %}
**Do not store SMTP settings in the liquid tag**

Instead use the site metafields to store them.
{% endhint %}


{% raw %}
```liquid
{% action "send an email like a boss" %}
	var emailSettings = getProp('site').metafields.email_settings;

	sendEmail({
    to:                   'john@doe.net',
    from:                 emailSettings.from,
    subject:              emailSettings.subject,
    page_handle:          'email-template',
    attachments:          { 'invitation.pdf': 'http://randomkittenpicture.png' },
    smtp: {
      address:          emailSettings.smtp_address,
      port:             emailSettings.smtp_port,
      user_name:        emailSettings.smtp_user_name,
      password:         emailSettings.smtp_password,
      authentication:   'plain',
      enable_starttls_auto: true
    }
  });
{% endaction %}
```
{% endraw %}
