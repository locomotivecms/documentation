---
title: Create a contact form
order: 2
---

## 1. Create a Content Type with Public Submission Enabled

To accept forms from the public, you first must create a content type that will store the submissions.

```shell
cd ~/workspace/my_first_website
bundle exec wagon generate content_type customer_messages name:string email:string message:text
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

## 2. Create A Form

Now, you need to embed your form on a web page. Create the following page in **app/views/pages/contact.liquid**.

{% raw %}
```liquid
<html>
  <body>
    {% model_form 'customer_messages', success: '/', error: '/contact' %}

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
