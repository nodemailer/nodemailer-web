+++
date = "2017-01-20T11:25:35+02:00"
icon = "<b>6. </b>"
chapter = true
next = "/next/path"
prev = "/prev/path"
weight = 0
title = "DKIM"

+++

# DKIM Signing

Nodemailer is able to sign all messages with DKIM keys. This means calculating a signature for the message and adding it as an additional header (or headers, if you use multiple keys) to the message.

The drawback on DKIM signing is that Nodemailer needs to cache the entire message before it can be sent, unlike normal sending where message output is streamed to SMTP as it is created and nothing needs to be cached. For small messages it does not matter, for larger messages Nodemailer offers an option to cache messages not in memory but on disk. In this case Nodemailer starts buffering the message in memory and if the message size reaches a certain treshold, it gets directed to a file on disk. Once signature is calculated and sent to SMTP, Nodemailer streams the cached message from disk to SMTP.

In general DKIM signing should be fast and effective.

## Setting it up

DKIM signing can be set on the transport level (all messages get signed with the same keys) and also on the message level (provide different keys for every message). If both are set, then message level DKIM configuration is preferred.

In both cases you need to provide a `dkim` object with the following structure

* **dkim** is an object with DKIM options
  * **domainName** – is the domain name to use in the signature
  * **keySelector** – is the DKIM key selector
  * **privateKey** – is the private key for the selector in PEM format
  * **keys** – is an optional array of key objects (*domainName*, *keySelector*, *privateKey*) if you want to add more than one signature to the message. If this value is set then the default key values are ignored
  * **cacheDir** – optional location for cached messages. If not set then caching is not used.
  * **cacheTreshold** – optional size in bytes, if message is larger than this treshold it gets cached to disk (assuming *cacheDir* is set and writable). Defaults to 131072 (128 kB).
  * **hashAlgo** – optional algorithm for the body hash, defaults to 'sha256'
  * **headerFieldNames** – an optional colon separated list of header keys to sign (eg. `message-id:date:from:to...'`)
  * **skipFields** – optional colon separated list of header keys not to sign. This is useful if you want to sign all the relevant keys but your provider changes some values, ie Message-ID and Date. In this case you should use `'message-id:date'` to prevent signing these values.

### Examples

#### 1\. Sign all messages

Assumes that there is a public key available for *2017._domainkey.example.com*. You can test if the key exists or not with the *dig* tool like this

```bash
dig TXT 2017._domainkey.example.com
```

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    dkim: {
        domainName: 'example.com',
        keySelector: '2017',
        privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...'
    }
});
```

#### 2\. Sign all messages with multiple keys

Assumes that there is a public keys available for *2017._domainkey.example.com* and *2016._domainkey.example.com*

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    dkim: {
        keys: [
            {
                domainName: 'example.com',
                keySelector: '2017',
                privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...'
            },
            {
                domainName: 'example.com',
                keySelector: '2016',
                privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...'
            }
        ]
        cacheDir: false
    }
});
```

#### 3\. Sign a specific message

Do not sign by default. Provide DKIM key values separately for every message.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail'
});
let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets read!',
    dkim: {
        domainName: 'example.com',
        keySelector: '2017',
        privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...'
    }
};
```

#### 4\. Cache large messages for signing

Messages larger than 100kB are cached to disk

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    dkim: {
        domainName: 'example.com',
        keySelector: '2017',
        privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...',
        cacheDir: '/tmp',
        cacheTreshold: 100 * 1024
    }
});
```

#### 5\. Do not sign specific header keys

This is needed when sending mail through SES that has its own Message-ID and Date system.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    dkim: {
        domainName: 'example.com',
        keySelector: '2017',
        privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...',
        skipFields: 'message-id:date'
    }
});
```
