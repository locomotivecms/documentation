---
title: Standard filters
order: 4
---

The Liquid language is bundled with standard filters.

## downcase

### Description

convert an input string to DOWNCASE

### Usage

{% raw %}
```text
{{ "Testing" | downcase }}
testing
```
{% endraw %}

## upcase

### Description

convert an input string to UPCASE

### Usage

{% raw %}
```text
{{ "Testing" | upcase }}
TESTING
```
{% endraw %}

## capitalize

### Description

capitalize words in the input sentence

### Usage

{% raw %}
```text
{{ "testing" | capitalize }}
Testing
```
{% endraw %}

## escape

### Description

escape special characters in HTML, namely &"\<>

### Usage

{% raw %}
```text
{{ 'Usage: foo "bar" <baz>' | escape }}
Usage: foo &quot;bar&quot; &lt;baz&gt;
```
{% endraw %}

## truncate

### Description

truncate a string down to x characters

### Usage

{% raw %}
```text
{{ '1234567890' | truncate: 7 }}
1234...
```
{% endraw %}

## truncatewords

### Description

truncate a sentence down to x words

### Usage

{% raw %}
```text
{{ 'one two three' | truncatewords: 2 }}
one two...
```
{% endraw %}

## split

### Description

split input string into an array of substrings separated by given pattern.

### Usage

{% raw %}
```text
{{ '12~34' | split: '~' }}
['12','34']
```
{% endraw %}

## strip_html

### Description

strip HTML tags

### Usage

{% raw %}
```text
{{ '<div>test</div>' | strip_html }}
test
```
{% endraw %}

## strip_newlines

### Description

remove all newlines from the string

### Usage

{% raw %}
```text
{{ "a\nb\nc" | strip_newlines }}
abc
```
{% endraw %}

## lstrip

Strips tabs, spaces, and newlines (all whitespace) from the left side of a string.

{% raw %}
```liquid
{{ '   too many spaces           ' | lstrip }}
```
{% endraw %}
{% code title="Output" %}
```
too many spaces
```
{% endcode %}

## rstrip

Strips tabs, spaces, and newlines (all whitespace) from the right side of a string.

{% raw %}
```liquid
{{ '              too many spaces      ' | rstrip }}
```
{% endraw %}
{% code title="Output" %}
```
too many spaces
```
{% endcode %}

## join

### Description

join elements of the array with certain character between them

### Usage

{% raw %}
```text
{{ [1,2,3,4] | join }}
1 2 3 4
{{ [1,2,3,4] | join: ' - ' }}
1 - 2 - 3 - 4
```
{% endraw %}

## shuffle

### Description

return a new array with elements of this array shuffled.

### Usage

{% raw %}
```liquid
{{ [1,2,3,4] | shuffle }}

# Pick up a random entry of the products content type
{{ contents.products.all | shuffle | first }}
```
{% endraw %}

## slice

### Description

return a subarray starting at the start index and continuing for length elements

### Usage

{% raw %}
```liquid
{{ [1,2,3,4] | slice: 1, 2 | join: ',' }} will return 2,3

# Pick up 3 random products
{{ contents.products.all | shuffle | slice: 0, 3 }}
```
{% endraw %}

## sort

### Description

sort elements of the array. Provide optional property with which to sort an array of hashes or drops

### Usage

{% raw %}
```liquid
{{ [4,3,2,1] | sort }}
[1,2,3,4]
{{ products | sort: price }}
```
{% endraw %}

## reverse

### Description

Reverse the elements of an array

### Usage

{% raw %}
```text
{{ [1,2,3,4] | reverse }}
[4,3,2,1]
```
{% endraw %}

## map

### Description

map/collect on a given property

### Usage

{% raw %}
```text
{{ products | map: name }}
['Product 1', 'Product 2']
```
{% endraw %}

## replace

### Description

replace occurrences of a string with another

### Usage

{% raw %}
```text
{{ '1 1 1 1' | replace: '1', '2' }}
2 2 2 2
```
{% endraw %}

## replace_first

### Description

replace the first occurrences of a string with another

### Usage

{% raw %}
```text
{{ '1 1 1 1' | replace_first: '1', '2' }}
2 1 1 1
```
{% endraw %}

## remove

### Description

remove a substring

### Usage

{% raw %}
```text
{{ "a a a a" | remove: 'a' }}
```
{% endraw %}

## remove_first

### Description

remove the first occurrences of a substring

### Usage

{% raw %}
```text
{{ 'a a a a' | remove_first: 'a ' }}
a a a
```
{% endraw %}

## append

### Description

add one string to another

### Usage

{% raw %}
```text
{{ "bc" | append: 'd' }}
bcd
```
{% endraw %}

## prepend

### Description

prepend a string to another

### Usage

{% raw %}
```text
{{ "bc" | prepend: 'a' }}
abc
```
{% endraw %}

## newline_to_br

### Description

add tags in front of all newlines in input string

### Usage

{% raw %}
```text
{{ "a\nb\nc" | newline_to_br }}
a<br />\nb<br />\nc
```
{% endraw %}

## date

### Description

Reformat a date

```text
%a - The abbreviated weekday name (``Sun'')
%A - The  full  weekday  name (``Sunday'')
%b - The abbreviated month name (``Jan'')
%B - The  full  month  name (``January'')
%c - The preferred local date and time representation
%d - Day of the month (01..31)
%H - Hour of the day, 24-hour clock (00..23)
%I - Hour of the day, 12-hour clock (01..12)
%j - Day of the year (001..366)
%m - Month of the year (01..12)
%M - Minute of the hour (00..59)
%p - Meridian indicator (``AM''  or  ``PM'')
%S - Second of the minute (00..60)
%U - Week  number  of the current year,
        starting with the first Sunday as the first
        day of the first week (00..53)
%W - Week  number  of the current year,
        starting with the first Monday as the first
        day of the first week (00..53)
%w - Day of the week (Sunday is 0, 0..6)
%x - Preferred representation for the date alone, no time
%X - Preferred representation for the time alone, no date
%y - Year without a century (00..99)
%Y - Year with century
%Z - Time zone name
%% - Literal ``%'' character
```

### Usage

{% raw %}
```text
{{ now | date: '%m/%d/%Y' }}
11/23/2014
```
{% endraw %}

## plus

### Description

addition

### Usage

{% raw %}
```text
{{ 1 | plus: 1 }}
2
```
{% endraw %}

## minus

### Description

subtraction

### Usage

{% raw %}
```text
{{ '4.3' | minus: '2' }}
2.3
```
{% endraw %}

## times

### Description

multiplication

### Usage

{% raw %}
```text
{{ 0.0725 | times:100 }}
7.25
```
{% endraw %}

## divided_by

### Description

division

### Usage

{% raw %}
```text
{{ 12 | divided_by:3 }}
4
```
{% endraw %}

## modulo

### Description

modulo

### Usage

{% raw %}
```text
{{ 3 | modulo: 2 }}
1
```
{% endraw %}
