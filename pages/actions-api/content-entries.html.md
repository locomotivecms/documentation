---
title: Content entries
order: 4
---

## allEntries

### Description

Fetch all the content entries of a content type.

### Usage

```javascript
allEntries("<SLUG_OF_CONTENT_TYPE>", <CONDITIONS>)
```

### Example

{% raw %}
```liquid
{% action "query the bands content type" %}
  var entries = allEntries('bands', { published: true });
  var names = [];

  for (var i = 0; i < entries.length; i++) {
    names.push(entries[i].name)
  }

  setProp("names", names.join(', '))
{% endaction %}

<p>{{names}}</p>
```
{% endraw %}

## findEntry

### Description

Find a content entry from its id.

### Usage

```javascript
findEntry("<SLUG_OF_CONTENT_TYPE>", "<ID_OR_SLUG>");
```

### Example

{% raw %}
```liquid
{% action "find the name of a band" %}
  var name = findEntry('bands', '42').name;
  setProp("name", name);
{% endaction %}

<p>{{name}}</p>
```
{% endraw %}

## createEntry

### Description

Create a content entry. If the new entry is not valid, it won't be persisted. The returned value is a **hash** which includes either the **id** or the **errors** attributes if the entry is valid or not.

### Usage

```javascript
createEntry("<SLUG_OF_CONTENT_TYPE>", <ATTRIBUTES>);
```

### Example

{% raw %}
```liquid
{% action "create a band" %}
  var band = createEntry('bands', { name: 'Pearl Jam'});
	setProp("band, band);
{% endaction %}

<p>{{band.id}}</p>
```
{% endraw %}

## updateEntry

### Description

Update a content entry. If the entry is not valid, it won't be persisted. The returned value is a **hash**.
The returned value includes the **errors** attributes which will be filled with the entry is not valid.

### Usage

```javascript
updateEntry("<SLUG_OF_CONTENT_TYPE>", <ID_OR_SLUG>, <ATTRIBUTES>);
```

### Example

{% raw %}
```liquid
{% action "update a band" %}
  var band = updateEntry('bands', 'pearl-jam', { leader: 'Eddie Vedder'});
	setProp("band, band);
{% endaction %}

<p>{{band.name}}</p>
```
{% endraw %}
