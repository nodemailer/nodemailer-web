+++
title = "SMTP Envelope"
date = "2017-01-20T11:20:07+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 5

+++

SMTP envelope is usually auto generated from **from**, **to**, **cc** and **bcc** fields in the message object but if for some reason you want to specify it yourself (custom envelopes are usually used for VERP addresses), you can do it with the `envelope` property in the message object.

- **envelope** – is an object with the following address params that behave just like with regular mail options. You can also use the regular address format, unicode domains etc.
  - **from** – the first address gets used as MAIL FROM address in SMTP
  - **to** – addresses from this value get added to RCPT TO list
  - **cc** – addresses from this value get added to RCPT TO list
  - **bcc** – addresses from this value get added to RCPT TO list

```javascript
let message = {
    ...,
    from: 'mailer@kreata.ee', // listed in rfc822 message header
    to: 'daemon@kreata.ee', // listed in rfc822 message header
    envelope: {
        from: 'Daemon <deamon@kreata.ee>', // used as MAIL FROM: address for SMTP
        to: 'mailer@kreata.ee, Mailer <mailer2@kreata.ee>' // used as RCPT TO: address for SMTP
    }
}
```

The envelope object returned by **sendMail()** includes just **from** (address string) and **to** (an array of address strings) fields as all addresses from **to**, **cc** and **bcc** get merged into **to** when sending.
