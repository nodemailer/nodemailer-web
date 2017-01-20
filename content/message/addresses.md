+++
prev = "/prev/path"
weight = 5
title = "Address object"
date = "2017-01-20T20:58:57+02:00"
toc = true
next = "/next/path"

+++

All e-mail addresses can be **plain** e-mail addresses

```javascript
'foobar@blurdybloop.com'
```

- or with **formatted name** (includes unicode support)

```javascript
'Ноде Майлер <foobar@blurdybloop.com>'
```

{{% notice tip %}}
Notice that all address fields (even *from:*) are comma separated lists, so if you want to use a comma (or any other special symbol) in the name part, make sure you enclose the name in double quotes like this: `'"Майлер, Ноде" <foobar@blurdybloop.com>'`
{{% /notice %}}

- or as an **address object** (in this case you do not need to worry about the formatting, no need to use quotes etc.)

```javascript
{
    name: 'Майлер, Ноде',
    address: 'foobar@blurdybloop.com'
}
```

All address fields accept values as a comma separated list of e-mails or an array of e-mails or an array of comma separated list of e-mails or address objects - use it as you like. Formatting can be mixed.

```javascript
...,
to: 'foobar@blurdybloop.com, "Ноде Майлер" <bar@blurdybloop.com>, "Name, User" <baz@blurdybloop.com>',
cc: [
    'foobar@blurdybloop.com',
    '"Ноде Майлер" <bar@blurdybloop.com>,
    "Name, User" <baz@blurdybloop.com>'
],
bcc: [
    'foobar@blurdybloop.com',
    {
        name: 'Майлер, Ноде',
        address: 'foobar@blurdybloop.com'
    }
]
...
```

You can even use unicode domains, these are automatically converted to punycode

```javascript
'"Unicode Domain" <info@müriaad-polüteism.info>'
```
