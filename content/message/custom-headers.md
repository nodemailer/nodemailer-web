+++
toc = true
prev = "/message/list-headers/"
next = "/message/custom-source/"
weight = 17
title = "Custom Headers"
date = "2017-01-20T12:37:05+02:00"

+++

Most messages do not need any kind of tampering with the headers. If you do need to add custom headers either to the message or to an attachment/alternative, you can add these values with the **headers** option. Values are processed automatically, non-ascii strings are encoded as mime-words and long lines are folded.

* **headers** – is an object of key-value pairs, where key names are converted into message header keys

### Examples

#### 1\. Set custom headers

```javascript
let message = {
    ...,
    headers: {
        'x-my-key': 'header value',
        'x-another-key': 'another value'
    }
}

// Becomes:
//   X-My-Key: header value
//   X-Another-Key: another value
```

#### 2\. Multiple rows with the same key

The same header key can be used multiple times if the header value is an Array

```javascript
let message = {
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

#### 3\. Prepared headers

Normally all headers are encoded and folded to meet the requirement of having plain-ASCII messages with lines no longer than 78 bytes. Sometimes it is preferable to not modify header values and pass these as provided. This can be achieved with the **prepared** option:

```javascript
let message = {
    ...,
    headers: {
        'x-processed': 'a really long header or value with non-ascii characters 👮',
        'x-unprocessed': {
            prepared: true,
            value: 'a really long header or value with non-ascii characters 👮'
        }
    }
}

// X-Processed: a really long header or value with non-ascii characters
//  =?UTF-8?Q?=F0=9F=91=AE?=
// X-Unprocessed: a really long header or value with non-ascii characters ?
```
