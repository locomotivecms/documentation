---
title: Relate two content types
order: 2
---

The content-type system in LocomotiveCMS allows you to define and use various types of relations between models.

Let's go through classical Author \<-> Book example to learn each relation type provided by LocomotiveCMS. First we're going to have the very basic models of Authors and Books containing only **name** fields:

```shell
wagon generate content_type authors name:string
wagon generate content_type books name:string
```

## Belongs To: the Book belongs to the Author

With this type of relation we can store a link to an Author along with the Book, which immediately becomes callable as a property of the book instance:

{% raw %}
```liquid
Who wrote the book "{{ book.name }}"? {{ book.author.name }} did that!
```
{% endraw %}

"Belongs To" is the easiest relation to set up. You just need to add the following to **app/content_types/books.yml**:

```yaml
- author:
    label: Author
    type: belongs_to
    class_name: authors
```

The key `author` here is a property that we will call on a book instance. It does not have to match the name of related model. For example, we could name our relation `writer`.

The `class_name` parameter (vice versa) must contain the slug of the model; otherwise, we couldn't know which model exactly we want to bind here.

Also, we may want to add the `required: true` option if the book without an author shouldn't exist in our library.

{% hint style="info" %}
**You could also have used the Wagon relationship generator:**

`bundle exec wagon generate relationship books belongs_to authors`
This also generates the has_many relationship as explained in the next chapter.
{% endhint %}


Ok. Once we're done, we may want to add some records to see how it works. Let's add the following to the **data/authors.yml**:

```yaml
- "Leo Tolstoy"
- "Anton Tchekhov"
```

Internally, and for SEO purposes, Locomotive will convert these keys in computer readable slugs.

Leo Tolstoy will become leo-tolstoy and Anton Tchekhov will become anton-tchekhov

Then add these records to the **data/books.yml**:

```yaml
- "War and Peace":
    author: leo-tolstoy

- "The Cherry Orchard":
    author: anton-tchekhov

- "Anna Karenina":
    author: leo-tolstoy
```

{% hint style="warning" %}
**Defining a relationship between content type entries in YAML data files**

Have you noticed? The relationship between the records in **data/authors.yml** and **data/books.yml** is made through the subkey "author" of the books.
And beware: the value of such subkey needs to be defined by using the slugs automatically created by Locomotive.
If you use natural human readable language, the relationship will not work. So be careful here.
{% endhint %}


Now if we add the following snippet to the index page...

{% raw %}
```liquid
{% for book in contents.books %}
Who wrote the book "{{ book.name }}"? {{ book.author.name }} did that!
{% endfor %}
```
{% endraw %}

...we'll see the list of the books with their authors:

```html
Who wrote the book "War and Peace"? Leo Tolstoy did that!
Who wrote the book "The Cherry Orchard"? Anton Tchekhov did that!
Who wrote the book "Anna Karenina"? Leo Tolstoy did that!
```

As you may notice it's perfectly legal to create an arbitrary amount of Books pointing to one Author. And this brings us to the next type of relation.

## Has Many: the Author has many Books

It is quite unusual for the Author to have only one Book published. That's why we need another type of relation to describe how Books are connected to the Author.

We did most of the work for establishing `has_many` relation in the last section. From the point of view of the root object this type of relation is no more than an inverted belongs_to. This structure is quite obvious: book `belongs` to author and author has many books belonging to the author. That's it! We've come full circle.

Let's add a `books` property to **app/content_type/authors.yml**:

```yaml
- books:
    label: Books
    type: has_many
    class_name: books
    inverse_of: author
    ui_enabled: true
```

Some new parameters are introduced here. The parameter inverse_of specifies which property of the foreign model is used to establish the belongs_to relation with the current model. Its name is self-explanatory: \``what property of the RELATED model would be an inversion of the property that we're going to define on THIS model?`

Or what property of the related model could tell us if we're connected?

It makes perfect sense if you just imagine the Tolstoy record asking Anna Karenina: "Is that me who has created you?"

The last parameter ui_enabled allows you to select whether the related item should be editable right from the editing screen of the current model in the back-office. If you turn on this option you'll be able to conveniently edit or create related items during editing or creation of the root item.

Let's take a look at how it works. To do so, we'll take the first author which happens to be Tolstoy and ask him which books he wrote:

{% raw %}
```liquid
{% for book in contents.authors.first.books %}
Who wrote the book "{{ book.name }}"? {{ book.author.name }} did that!
{% endfor %}
```
{% endraw %}

The output would be the following, as expected:

```html
Who wrote the book "War and Peace"? Leo Tolstoy did that!
Who wrote the book "Anna Karenina"? Leo Tolstoy did that!
```

## Many to Many: the case of the Book written in collaboration

Let's imagine that Tolstoy and Tchekhov wrote a book in co-authorship which in fact never happened even though they lived in the same time. But for learning purpose it would be fun to think that their partnership brought a brilliant book called "Anna Karenina in the Cherry Orchard" to the world.

It breaks our perfect world in no time. Now one Author can have many Books, and one Book can be written by a group of Authors. This type of relation is called Many-to-Many and it is considered the most complex relation.

Let's make some changes in **app/content_type/books.yml**

```yaml
- authors:
    label: Author
    type: many_to_many
    class_name: authors
    inverse_of: books
    ui_enabled: true
```

...and **app/content_type/authors.yml**

```yaml
- books:
    label: Books
    type: many_to_many
    class_name: books
    inverse_of: authors
    ui_enabled: true
```

That's it. Now we can attach as many Books to each Author as we want, and vice versa.

The only thing left is to take a look at the seed data for this kind of relation (**data/books.yml**):

```yaml
- "War and Peace":
    authors: [leo-tolstoy]

- "The Cherry Orchard":
    authors: [anton-tchekhov]

- "Anna Karenina":
    authors: [leo-tolstoy]

- "Anna Karenina in the Cherry Orchard":
    authors: [leo-tolstoy, anton-tchekhov]
```

{% hint style="warning" %}
**Use the slugs!**

Have you noticed? In the array making the references to the authors collection, we use the slugs of the authors.
{% endhint %}


Now if we take the last book and iterate over authors, we will see `Leo Tolstoy and Anton Tchekhov`:

{% raw %}
```liquid
{% for author in contents.books.last.authors %}
{{ author.name }}
{% endfor %}
```
{% endraw %}

will output

```html
Leo Tolstoy
Anton Tchekhov
```

## Tags: special relation

Locomotive has embedded support for tags. To use them, you just have to add a field of type tags to your model. Then you'll be able to scope by tags, like this:

{% raw %}
```liquid
{% with_scope tags: params['tag'] %}
...
{% endwith_scope %}
```
{% endraw %}

A common mistake with relations involves mistreatment of the property. Just remember, that for any relation except the `belongs_to` you have a collection even though it consists of only one element.
