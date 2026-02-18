---
title: Create a contact form
order: 3
---

Any contact form in LocomotiveCMS relies on 2 principles:

* create a special content type with its `public_submission_enabled` attribute set to `true`.
* create a liquid page with a HTML form associated to this content type.

In order to prevent undesirable spams, we support **Google reCAPTCHA** out of the box. This requires little configuration. To understand how to integrate Google reCAPTCHA with your form, we strongly recommend you to follow the next chapter and generate a default public form to see how it works.

{% hint style="warning" %}
**The LocomotiveCMS Google reCAPTCHA feature requires both Engine v4 and Wagon v3**

{% endhint %}


{% hint style="warning" %}
**only reCAPTCHA v3 is supported at this time**

{% endhint %}


## The easy way

We implemented a very simple Wagon generator which will create both the content type and the liquid page as well as all the settings you'll need for Google reCAPTCHA.

You'll also have to create a Google developer account and register your site to Google reCAPTCHA. Please visit [https://developers.google.com/recaptcha/intro](https://developers.google.com/recaptcha/intro) for that purpose.

Copy/paste the **Google SITE KEY** and **Google SECRET KEY** to the `config/site.yml` file.

Now, type the following statement in your terminal and follow the instructions.

```shell
wagon generate public_form
```

## Step by Step

## 1. Create a Content Type with Public Submission Enabled

If you don't want to use our generator, follow the step-by-step guide below.

To accept forms from the public, you first must create a content type that will store the submissions.

```shell
cd ~/workspace/my_first_website
wagon generate content_type customer_messages name:string email:string message:text
```

Remove the data/customer_messages.yml, since you won't be pre-populating the content type with entries.

```shell
rm data/customer_messages.yml
```

Now modify **app/content_types/customer_messages.yml** so it looks like this:

```yaml
name: Customer Messages
description: Messages submitted via the website
slug: customer_messages
label_field_name: name
public_submission_enabled: true
recaptcha_required: true
fields:
- name:
    label: Name
    type: string
    required: true
- email:
    label: Email
    type: string
    required: true
- message:
    label: Message
    type: text
    required: true
```

## 3. Create site metafields to store the reCAPTCHA configuration

Open the `config/metafields_schema.yml` file and the following statement to define the reCAPTCHA attributes.

{% code title="config/metafields_schema.yml" %}
```yaml
google:
  label: Google API Integration
  fields:
    recaptcha_site_key:
      hint: reCAPTCHA - Site key
      type: string
      hint: "Visit: https://developers.google.com/recaptcha/intro"
    recaptcha_secret:
      hint: reCAPTCHA - Secret key
      type: string
```
{% endcode %}

Then, copy/paste the value of the site and secret keys to the `config/site.yml` file:

{% code title="config/site.yml" %}
```yaml
metafields:
  google:
    recaptcha_site_key: "<GOOGLE SITE KEY>"
    recaptcha_secret: "<GOOGLE SECRET>"
```
{% endcode %}

## 4. Create A Form

Now, you need to embed your form on a web page. Create the following page in **app/views/pages/contact.liquid**.

{% raw %}
```liquid
<html>
  <body>
    {% model_form 'customer_messages', success: '/', error: '/contact', recaptcha: true %}

      {% if customer_message.errors %}
        <p>The following errors occured:</p>
        <ul>
        {% for error in customer_message.errors %}
          <li>{{error[0] | capitalize}} -  {{error[1]}}</li>
        {% endfor %}
        </ul>
      {% endif %}

      <table>
        <tr>
          <td>Name:</td>
          <td><input type="text" name="content[name]" value="{{customer_message.name}}"></td>
        </tr>
        <tr>
          <td>Email:</td>
          <td><input type="text" name="content[email]" value="{{customer_message.email}}"></td>
        </tr>
        <tr>
          <td>Message:</td>
          <td><textarea name="content[message]">{{customer_message.message}}</textarea></td>
        </tr>
      </table>
      <input type="submit">
    {% endmodel_form %}
    
    <script src="https://www.google.com/recaptcha/api.js?render={{ site.metafields.google.recaptcha_site_key }}"></script>

  <script>
    grecaptcha.ready(function() {
      grecaptcha.execute('{{ site.metafields.google.recaptcha_site_key }}', {action: 'register'}).then(function(token) {
        document.getElementById('g-recaptcha-response').value  = token;
      });
    });
  </script>
  </body>
</html>
```
{% endraw %}

Lets go through it section by section...

This line sets up the form so its action goes to the Customer Messages content type's public submission url. Behind the scene, it generates a `<form>` HTML tag with the right parameters. It also generates a couple of hidden HTML fields storing the URLs for the callbacks (where the user is redirected on success or error) and the Cross-Site Request Forgery parameter which is needed if you turn on csrf protection (enabled by default).

{% raw %}
```liquid
{% model_form 'customer_messages', success: '/', error: '/contact' %}
```
{% endraw %}

Now on to error rendering. The most recently submitted content entry is stored in a variable that is the singular version of its Content Type's slug. For example, since we have a Customer Messages content type with a slug of customer_messages, the last submitted content entry is available as customer_message.

You can now loop through the errors attribute on customer_message and display those errors in the form. Error\[0] is the field name and error\[1] is the list of errors on that field.

{% raw %}
```liquid
{% if customer_message.errors %}
  <p>The following errors occured:</p>
  <ul>
  {% for error in customer_message.errors %}
    <li>{{error[0] | capitalize}} -  {{error[1]}}</li>
  {% endfor %}
  </ul>
{% endif %}
```
{% endraw %}

The next section actually does the form submission. Data needs to be submitted by fields with the following naming convention: content\[field_name]. Also, as noted above, the last submitted content entry is available as customer_message. This allows us to re-populate the form on error with `{% raw %}{{customer_message.field_name}}{% endraw %}`.

{% raw %}
```liquid
<table>
  <tr>
    <td>Name:</td>
    <td><input type="text" name="content[name]" value="{{customer_message.name}}"></td>
  </tr>
  <tr>
    <td>Email:</td>
    <td><input type="text" name="content[email]" value="{{customer_message.email}}"></td>
  </tr>
  <tr>
    <td>Message:</td>
    <td><textarea name="content[message]">{{customer_message.message}}</textarea></td>
  </tr>
</table>
```
{% endraw %}

Now all you need is a plain old submit button, and your form will allow users to send you messages through your website.

```liquid
<input type="submit">
```

## Notes

You can also submit your forms using AJAX and something like jQuery Form. You will be able to detect success or failure via the HTTP status codes. Your errors or your newly created object will be returned to you as JSON. Below is an example of the error format:

{% raw %}
```json
{"errors":{"_slug":["can't be blank"],"name":["can't be blank"],"email":["can't be blank"],"message":["can't be blank"]}}
```
{% endraw %}

To use the json API, you just need to let the `model_form` liquid tag know about it:

{% raw %}
```liquid
{% model_form 'messages', id: 'contactForm', json: true %}
```
{% endraw %}

Thanks [Aaron](https://github.com/aaronrenner) for submitting this guide!

## AJAX with reCAPTCHA

If submitting your form with AJAX and Google reCAPTCHA you will need to wrap the grecaptcha script in a function so you can re-execute it after a failed submission (say, for example, if a required field has been omitted).

**Example:**

{% raw %}
```liquid
<script>
  function reCAPTCHArefresh() {
    grecaptcha.ready(function() {
      grecaptcha.execute('{{ site.metafields.google.recaptcha_site_key }}', {action: 'register'}).then(function(token) {
        document.getElementById('g-recaptcha-response').value  = token;
      });
    });
  };
</script>
```
{% endraw %}
```javascript
$.ajax({
	type: 'POST',
	url: form.attr('action'),
	data: form.serialize(),
	dataType: 'json',
	success: function(data) {
		console.log('Success:', data);
	},
	error: function(xhr, status, error) {
		console.log('Status:', status);
		console.log('Error:', error);
		var errors = jQuery.parseJSON(xhr.responseText).errors;
		console.log(errors);

		reCAPTCHArefresh();
		
	}
});
```
