+++
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 5
title = "Custom Headers"
date = "2017-01-20T12:37:05+02:00"

+++

Most messages do not need any kind of tampering with the headers. If you do need to add custom headers either to the message or to an attachment/alternative, you can add these values with the **headers** option. Values are processed automatically, non-ascii strings are encoded as mime-words and long lines are folded.

```javascript
var mail = {
    ...,
    headers: {
        'x-my-key': 'header value',
        'x-another-key': 'another value'
    }
}

// X-My-Key: header value
// X-Another-Key: another value
```

### Multiple rows

The same header key can be used multiple times if the header value is an Array

```javascript
var mail = {
    ...,
    headers: {
        'x-my-key': [
            'value for row 1',
            'value for row 2',
            'value for row 3'
        ]
    }
}

// X-My-Key: value for row 1
// X-My-Key: value for row 2
// X-My-Key: value for row 3
```

### Prepared headers

Normally all headers are encoded and folded to meet the requirement of having plain-ASCII messages with lines no longer than 78 bytes. Sometimes it is preferable to not modify header values and pass these as provided. This can be achieved with the `prepared` option:

```javascript
var mail = {
    ...,
    headers: {
        'x-processed': 'a really long header or value with non-ascii characters ?',
        'x-unprocessed': {
            prepared: true,
            value: 'a really long header or value with non-ascii characters ?'
        }
    }
}

// X-Processed: a really long header or value with non-ascii characters
//  =?UTF-8?Q?=F0=9F=91=AE?=
// X-Unprocessed: a really long header or value with non-ascii characters ?
```
