---
title: External API
order: 6
---

## callAPI

### Description

Call any URL directly in javascript.

### Usage

```javascript
callAPI(<HTTP METHOD>, <URL>, <OPTIONS>)
```

### Options

| Name | Type | Description |
| :--- | :--- | :--- |
| data | Hash | Body of the request |
| username | String | Basic auth username |
| password | String | Basic auth password |
| headers | Hash | HTTP headers |


`data` is automatically converted to JSON, `username` and `password` are automatically base64 encoded.

### Example

{% raw %}
```liquid
{% action "Create Stripe subscription" %}
  var email   = params.stripeEmail, token = params.stripeToken;
  var payment = false;

  if (token) {
    payment = callAPI('POST', 'https://api.stripe.com', {      
      username: site.metafields.stripe.api_key,
      data: {
        'email':  email,
        'source': token,
        'plan':   'weekly_box'
      }
    });
  }

  setProp('payment', !!payment);

{% endaction %}

{% if payment %}
  <h1>SUCCESS!</h1>
{% else %}
  <h1>FAILURE!</h1>
{% endif %}
```
{% endraw %}
