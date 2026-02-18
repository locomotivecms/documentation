---
title: Setup
order: 2
---

Inside your Wagon site, you need to create a content type describing your users with:

* **ONE** password type field. 
* **ONE** email/string type field (unique: true)

There is no restriction about the name of these 2 fields.

```shell
$ wagon generate content_type accounts name:string email:email password:password
```

The previous command will both generate the YAML file for the content type definition and another file for the test users.

**Note: Make sure the password has a minimum of 6 characters.** 

{% code title="data/accounts.yml" %}
```yaml
"John":
  email: "john@doe.net"
  password: "uncryptedpassword"
```
{% endcode %}

{% hint style="warning" %}
**Passwords are stored in plain text in Wagon.**

{% endhint %}
