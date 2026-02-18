---
title: Using ReCaptcha in a contact form
order: 11
---

Google reCAPTCHA is a free and easy captcha service that prevents bots from spamming your contact forms. Below you can find out how to implement this for your LocomotiveCMS sites.

In this example we also make sure it is using the locale of the site.

![](pages/using-recaptcha-in-a-contact-form/3JsHF1YKScyD5qYjLXj8_google-recaptcha.jpg)

## 1. Generate site_key on reCAPTCHA website

Make sure, before you start implementing this, to generate a site key on the [reCAPTCHA website](https://www.google.com/recaptcha/intro/index.html) for each of your websites.

![612](pages/using-recaptcha-in-a-contact-form/5Hxn9eszTuCV9FP7mAuX_Screen-20Shot-202016-05-25-20at-2012.12.59.png)

![943](pages/using-recaptcha-in-a-contact-form/lwZWE16QP6fsyODC3Hp6_Screen-20Shot-202016-05-25-20at-2012.13.10.png)

## 2. Add required fields in your contact form

In your contact form add a reCAPTCHA id and the required JavaScript imports:

{% code title="contact.liquid" %}
{% raw %}
```liquid
<form id="contact-form" method="POST" action= {{contents.contact.public_submission_url}}.json">
	{% csrf_param %}

  <div class="alert alert-success" style="display: none">
 		{% editable_text 'contact-form-success' %}
    	<p><strong>Success!</strong> Your request has been sent! We will get back to you as soon as possible.</p>
		{% endeditable_text %}
	</div>

	<div class="alert alert-danger" style="display: none">
		{% editable_text 'contact-form-error' %}
			<p><strong>Failed!</strong> Your form has not been sent, please make sure all required fields are filled in.</p>
		{% endeditable_text %}
	</div>

  <div class="form-item">
		<label for="name">{{ 'name' | translate }}</label>
		<input type="text" name="content[name]" id="name" required>
	</div>

	<div class="form-item">
		<label for="email">{{ 'email' | translate }}</label>
		<input type="email" name="content[email]" id="email" required>
	</div>

	<div class="form-item">
		<label for="comment">{{ 'comment' | translate }}</label>
		<textarea id="comment" name="content[message]"></textarea>
	</div>

	<div class="form-item">
		<div id="recaptcha"></div>
	</div>

	<button type="submit" class="button button-primary">
		{{ 'send' | translate }}
	</button>
</form>
                                                     
{% block "page-scripts" %}
  <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit&hl={{locale}}" async defer></script>
  {{ "contact.js" | javascript_tag }}
{% endblock %}
```
{% endraw %}
{% endcode %}

## 3. Add required JavaScript

After that add the following JavaScript to your form. Replace the generated_site_key with the key you generated on the reCAPTCHA website.

{% code title="contact.js" %}
```javascript
var onloadCallback = function() {
  grecaptcha.render('recaptcha', {
		'sitekey' : 'generated_site_key'
  });
};

$(function() {
  $('#contact-form').on('submit', function(e) {
    e.preventDefault();
    var form = $(this);

    form.find('.alert-danger').hide();

    var payload = form.serialize();

    function showError() {
      form.find('.alert-danger').fadeIn();
    }

    if (grecaptcha.getResponse() == "") {
      showError();
      return false;
    }

    var xhr = $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: payload,
      dataType: 'json'
    });

    xhr.done(function(d) {
      form.find('.alert-success').fadeIn();
    });

    xhr.fail(function(d) {
      showError();
    });
  });
});
```
{% endcode %}

That's it, your contact form is now using reCAPTCHA!
