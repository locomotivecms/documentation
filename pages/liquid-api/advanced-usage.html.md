---
title: Advanced usage
order: 7
---

## Using with_scope to filter multilple many_to_many entries

Say you have a model that has a many_to_many relationship with a **categories** model and you want to list  entries that relate to categories **A** and **B**:

{% raw %}
```liquid
{% with_scope categories.all: "$and: ['A', 'B']" %}
```
{% endraw %}
