+++
date = "2017-01-20T11:25:35+02:00"
pre = "<b>7. </b>"
chapter = true
prev = "/plugins/create/"
next = "/extras/"
weight = 70
title = "DKIM"
toc = true
+++

# DKIM Signing

Nodemailer supports DKIM signing, which adds a digital signature to all outgoing messages. This signature is calculated and added as an additional header (or multiple headers, if using multiple keys).

One drawback of DKIM signing is that Nodemailer needs to cache the entire message before it can be sent. Normally, message output is streamed directly to SMTP without caching. For small messages, this difference is negligible, but for larger messages, Nodemailer offers the option to cache messages on disk instead of in memory. In this scenario, Nodemailer buffers the message in memory up to a certain size and then switches to disk caching. After the signature is calculated and sent to SMTP, the cached message is streamed from disk to SMTP.

In general, DKIM signing is fast and effective for most use cases.

### Setting It Up

DKIM signing can be configured at the transport level (where all messages are signed with the same keys) or at the message level (where different keys can be used for each message). If both are configured, the message-level DKIM settings will take precedence.

To set up DKIM signing, you need to provide a `dkim` object with the following structure:

- **dkim**: An object with DKIM options
  - **domainName**: The domain name to use in the signature
  - **keySelector**: The DKIM key selector
  - **privateKey**: The private key for the selector in PEM format
  - **keys**: (Optional) An array of key objects (_domainName_, _keySelector_, _privateKey_) for signing with multiple keys. If this is provided, the default key values are ignored.
  - **cacheDir**: (Optional) The location for cached messages. If not set, caching is not used.
  - **cacheTreshold**: (Optional) The size in bytes after which messages are cached to disk (assuming _cacheDir_ is set and writable). Defaults to 131072 (128 kB).
  - **hashAlgo**: (Optional) The hashing algorithm for the body hash, defaults to 'sha256'.
  - **headerFieldNames**: (Optional) A colon-separated list of header fields to sign (e.g., `message-id:date:from:to`).
  - **skipFields**: (Optional) A colon-separated list of header fields not to sign, useful when certain fields (like Message-ID or Date) are modified by the provider.

### Examples

#### 1. Sign All Messages

Assumes a public key is available for _2017.\_domainkey.example.com_. You can check if the key exists using the _dig_ tool:

```bash
dig TXT 2017._domainkey.example.com
```

```javascript
let transporter = nodemailer.createTransport({
  host: "smtp.example.com",
  port: 465,
  secure: true,
  dkim: {
    domainName: "example.com",
    keySelector: "2017",
    privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...",
  },
});
```

#### 2. Sign Messages with Multiple Keys

Assumes public keys are available for _2017.\_domainkey.example.com_ and _2016.\_domainkey.example.com_.

```javascript
let transporter = nodemailer.createTransport({
  host: "smtp.example.com",
  port: 465,
  secure: true,
  dkim: {
    keys: [
      {
        domainName: "example.com",
        keySelector: "2017",
        privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...",
      },
      {
        domainName: "example.com",
        keySelector: "2016",
        privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...",
      },
    ],
    cacheDir: false,
  },
});
```

#### 3. Sign a Specific Message

This example shows how to sign a specific message without signing all messages by default.

```javascript
let transporter = nodemailer.createTransport({
  host: "smtp.example.com",
  port: 465,
  secure: true,
});

let message = {
  from: "sender@example.com",
  to: "recipient@example.com",
  subject: "Message",
  text: "I hope this message gets read!",
  dkim: {
    domainName: "example.com",
    keySelector: "2017",
    privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...",
  },
};
```

#### 4. Cache Large Messages for Signing

Messages larger than 100kB are cached to disk before signing.

```javascript
let transporter = nodemailer.createTransport({
  host: "smtp.example.com",
  port: 465,
  secure: true,
  dkim: {
    domainName: "example.com",
    keySelector: "2017",
    privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...",
    cacheDir: "/tmp",
    cacheTreshold: 100 * 1024, // 100kB
  },
});
```

#### 5. Do Not Sign Specific Header Keys

Useful when sending mail through SES, which generates its own Message-ID and Date.

```javascript
let transporter = nodemailer.createTransport({
  host: "smtp.example.com",
  port: 465,
  secure: true,
  dkim: {
    domainName: "example.com",
    keySelector: "2017",
    privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...",
    skipFields: "message-id:date",
  },
});
```
