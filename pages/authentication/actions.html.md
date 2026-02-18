---
title: Actions
order: 3
---

Although there is no specific convention about where to put the authentication Liquid pages, we chose to put them within the **app/views/pages/auth** folder in the following examples.

Each authentication action is triggered by posting a form with specific hidden HTML inputs describing the action and its parameters.

## Sign up

This action creates a new user and automatically signs her/him in. The sign up form has to contain 3 fields: the id attribute (usually email), the password and its confirmation.

**Form parameters**

| Name | Description |
| :--- | :--- |
| auth_action | * \*sign_up\*\* (cannot be changed for Locomotive CMS hosting customers) |
| auth_content_type | the slug of your "users" content type with one password type field |
| auth_id_field | name of your field used to identify the user. |
| auth_password_field | name of your password type field |
| auth_callback | path to the page once the user has been authenticated with success. |
| auth_entry\[] | HTML form attributes of the user model. Require the value of [auth_id_field][auth_id_field], [auth_password_field][auth_password_field] and [auth_password_field_confirmation][auth_password_field_confirmation]. Example: auth_entry[email], auth_entry[password] and auth_entry[password_confirmation][password_confirmation] |
| auth_disable_email | don't send the welcome email if it sets to '1' or 'true'. |
| auth_email_handle | the handle of the Locomotive page used as the email template |
| auth_email_subject | the subject of the welcome email |
| auth_email_smtp_namespace | namespace in site metafields used to store your SMTP settings. Default: smtp\ See explanation [here](/guides/custom-smtp-server). |


**Global liquid variables**

| Name                 | Description                                                                                         |
| :------------------- | :-------------------------------------------------------------------------------------------------- |
| auth_entry          | the content entry only if the form is invalid. This liquid drop includes all the validation errors. |
| auth_invalid_entry | not null if the form is invalid.                                                                    |

**Example**

{% code title="sign_up.liquid" %}
{% raw %}
```liquid
---
title: Sign up
handle: sign_up
---
{% if current_account %}
  You're already authenticated!
{% else %}
  <form action="{% path_to 'sign_up' %}" method="POST">
    <input type="hidden" name="auth_action" value="sign_up" />
    <input type="hidden" name="auth_content_type" value="accounts" />
    <input type="hidden" name="auth_id_field" value="email" />
    <input type="hidden" name="auth_password_field" value="password" />
    <input type="hidden" name="auth_email_handle" value="welcome_message" />
    <input type="hidden" name="auth_callback" value="{% path_to me %}" />

    {% if auth_invalid_entry %}
      We're sorry, we couldn't create your account.
    {% endif %}

    <label for="auth-name">Your name</label>
    <input type="text" name="auth_entry[name]" id="auth-name" value="{{ auth_entry.name }}">
    {% if auth_entry.errors.name.size > 0 %}
      {{ auth_entry.errors.name.first }}
    {% endif %}

    <label for="auth-email">Your E-mail</label>
    <input type="email" name="auth_entry[email]"  id="auth-email" value="{{ auth_entry.email }}">
    {% if auth_entry.errors.email.size > 0 %}
      {{ auth_entry.errors.email.first }}
    {% endif %}

    <label for="auth-password">Password</label>
    <input type="password" name="auth_entry[password]" id="auth-password">
    {% if auth_entry.errors.password.size > 0 %}
      {{ auth_entry.errors.password.first }}
    {% endif %}

    <label for="auth-password">Password confirmation</label>
    <input type="password" name="auth_entry[password_confirmation]" id="auth-password">
    {% if auth_entry.errors.password_confirmation.size > 0 %}
      {{ auth_entry.errors.password_confirmation.first }}
    {% endif %}
    
    <button type="submit">Sign up</button>
  </form>
{% endif %}
```
{% endraw %}
{% endcode %}

## Sign in

If a "user" is found based on the auth_id and auth_password values, then the authenticated user will be available as a global liquid variable in all the further requests. The name of the variable is made from the slug of the content type:

`{% raw %}{{ current_<singular version of the content type's slug> }}{% endraw %}`

If the liquid variable is null, it means there is no authenticated user.

If no user has been found, the page specified by the action attribute of the form will be rendered. 

**Form parameters**

| Name                  | Description                                                           |
| :-------------------- | :-------------------------------------------------------------------- |
| auth_action          | **sign_in** (cannot be changed for Locomotive CMS hosting customers) |
| auth_content_type   | the slug of your "users" content type with one password type field    |
| auth_id_field       | name of your field used to identify the user.                         |
| auth_password_field | name of your password type field                                      |
| auth_callback        | path to the page once the user has been authenticated with success.   |
| auth_id              | id typed by the user                                                  |
| auth_password        | password typed by the user                                            |

**Global liquid variables**

| Name                     | Description                                                             |
| :----------------------- | :---------------------------------------------------------------------- |
| auth_wrong_credentials | Wrong id and/or password. Empty if the form has not been submitted yet. |

**Example**

{% code title="auth/sign_in.liquid" %}
{% raw %}
```liquid
---
title: Sign in
handle: sign_in
---
<form action="{% path_to 'sign_in' %}" method="POST">
  <input type="hidden" name="auth_action" value="sign_in" />
  <input type="hidden" name="auth_content_type" value="accounts" />
  <input type="hidden" name="auth_id_field" value="email" />
  <input type="hidden" name="auth_password_field" value="password" />
  <input type="hidden" name="auth_callback" value="{% path_to me %}" />
  
  {% if auth_wrong_credentials %}Wrong credentials!{% endif %}
  
  <label for="auth-email">Your E-mail</label>
  <input type="email" class="form-control" id="auth-email" placeholder="Email" name="auth_id" value="{{ params.auth_id }}">
  
  <label for="auth-password">Password</label>
  <input type="password" class="form-control" id="auth-password" placeholder="Password" name="auth_password" value="">
          
  <button type="submit">Sign in</button>
</form>
```
{% endraw %}
{% endcode %}

## Sign out

Remove the current authenticated user from the current session. Once submitted, the user is redirected to the path defined in the action attribute of the sign out form.

**Form parameters**

| Name                | Description                                                            |
| :------------------ | :--------------------------------------------------------------------- |
| auth_action        | **sign_out** (cannot be changed for Locomotive CMS hosting customers) |
| auth_content_type | the slug of your "users" content type                                  |

**Global liquid variables**

| Name              | Description                            |
| :---------------- | :------------------------------------- |
| auth_signed_out | True once the user has been signed out |

**Example**

{% raw %}
```liquid
<form action="{% path_to 'sign_in' %}" method="POST">
  <input type="hidden" name="auth_action" value="sign_out" />
  <input type="hidden" name="auth_content_type" value="accounts" />
  <input type="submit" value="Sign out" />
</form>
```
{% endraw %}

## Forgot password

Send instructions about how to reset a forgotten password.

**Form parameters**

| Name                                 | Description                                                                              |
| :----------------------------------- | :--------------------------------------------------------------------------------------- |
| auth_action                         | **forgot_password** (cannot be changed for Locomotive CMS hosting customers)            |
| auth_content_type                  | the slug of your "users" content type                                                    |
| auth_id_field                      | name of your field used to identify the user.                                            |
| auth_password_field                | name of your password type field                                                         |
| auth_id                             | id typed by the user                                                                     |
| auth_reset_password_url           | the **absolute** url of the reset password page. This url will be inserted in the email. |
| auth_email_handle                  | the handle of the Locomotive page used as the email template                             |
| auth_email_smtp_namespace         | name of the site metafields namespace used to store your SMTP settings. Default: smtp    |
| auth_email_smtp_address_alias    | name of the address property in the site metafields namespace. Default: address          |
| auth_email_smtp_port_alias       | name of the port property in the site metafields namespace. Default: port                |
| auth_email_smtp_user_name_alias | name of the user_name property in the site metafields namespace. Default: user_name    |
| auth_email_smtp_password_alias   | name of the user_name property in the site metafields namespace. Default: password      |

**Global liquid variables**

| Name                                                      | Description                                  |
| :-------------------------------------------------------- | :------------------------------------------- |
| auth_reset_\<auth_password_field>_instructions_sent | True if the email has been successfully sent |
| auth_wrong_\<auth_id_field>                           | True if no user was found                    |

**Example**

{% code title="/app/views/pages/auth/reset_password.liquid" %}
{% raw %}
```liquid
---
title: Reset password
handle: forgot_password
---
{% if auth_reset_password_instructions_sent %}
  The instructions for changing your password have been emailed to you.
{% else %}
  <form action="{% path_to 'forgot_password' %}" method="POST">
    <input type="hidden" name="auth_action" value="forgot_password" />
    <input type="hidden" name="auth_content_type" value="accounts" />
    <input type="hidden" name="auth_id_field" value="email" />
    <input type="hidden" name="auth_id_password" value="password" />
    <input type="hidden" name="auth_reset_password_url" value="{{ base_url }}{% path_to reset_password %}" />
    <input type="hidden" name="auth_email_handle" value="reset_password_instructions" />

    {% if auth_wrong_email %}Wrong email!{% endif %}

		<label for="auth-email">Your E-mail</label>
		<input type="email" id="auth-email" placeholder="Email" name="auth_id" value="{{ params.auth_id }}">
   
    <button type="submit">Submit</button>
  </form>
{% endif %}
```
{% endraw %}
{% endcode %}

## Reset password

When the user clicks on the link in the email sent by the previous action, she/he is redirected to the reset password page where she/he will enter a new password.

The link is protected by a token only valid for **2 hours**. You can add `{% raw %}{{ reset_password_url }}{% endraw %}` to get the link with token in your email template.

**Form parameters**

| Name                  | Description                                                                  |
| :-------------------- | :--------------------------------------------------------------------------- |
| auth_action          | **reset_password** (cannot be changed for Locomotive CMS hosting customers) |
| auth_content_type   | the slug of your "users" content type                                        |
| auth_password_field | name of your password type field                                             |
| auth_password        | password typed by the user                                                   |
| auth_reset_token    | `{% raw %}{{ params.auth_reset_token }}{% endraw %}`                                              |
| auth_callback        | path to the page once the password has been updated with success             |

**Global liquid variables**

| Name                                       | Description                                           |
| :----------------------------------------- | :---------------------------------------------------- |
| auth_invalid_token                       | True if the token is invalid or has expired           |
| auth_\<auth_password_field>_too_short | True if the password length is less than 6 characters |

**Example**

{% code title="/app/views/pages/auth/reset_password.liquid" %}
{% raw %}
```liquid
---
title: Reset password
handle: reset_password
---
<form action="{% path_to 'reset_password' %}" method="POST">
  <input type="hidden" name="auth_action" value="reset_password" />
  <input type="hidden" name="auth_content_type" value="accounts" />
  <input type="hidden" name="auth_password_field" value="password" />
  <input type="hidden" name="auth_reset_token" value="{{ params.auth_reset_token }}" />
  <input type="hidden" name="auth_callback" value="{% path_to me %}" />

  {% if auth_invalid_token %}
    Your token is invalid or has expired.
  {% endif %}

  {% if auth_password_too_short %}
    Password too short!
  {% endif %}

  <label for="auth-password">Your new password</label>
  <input type="password" id="auth-password" placeholder="Password" name="auth_password">
  
  <button type="submit">Submit</button>
</form>
```
{% endraw %}
{% endcode %}
