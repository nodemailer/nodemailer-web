+++
weight = 5
title = "Configuration"
date = "2017-01-20T12:01:09+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"

+++

Stream Transport is not actually a transport, it returns you the generated RFC822 email message either as a stream or a Buffer. Additionally you can define which kind of newlines to use, either the 'windows' style (`<CR><LF>`) or the 'unix' style (`<LF>`). This transport is mostly useful for testing and also for situations where you want to use Nodemailer plugins to process the message and do the actual delivery using some other means.

To use Stream Transport, set `streamTransport` option to `true` in Nodemailer options. If you want the transport to return buffers instead of streams, set `buffer` option to `true`.

The `info` argument for `sendMail()` method includes the following properties:

- **envelope** – is an envelope object `{from:'address', to:['address']}`
- **messageId** – is the Message-ID header value
- **message** – is either stream (default) of buffer depending on the options

## Examples

### 1\. Stream message with Windows newlines

```javascript
let transporter = nodemailer.createTransport({
    streamTransport: true,
    newline: 'windows'
});
transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets streamed!'
}, (err, info)=>{
    console.log(info.envelope);
    console.log(info.messageId);
    info.message.pipe(process.stdout);
});
```

### 1\. Create buffer with Unix newlines

```javascript
let transporter = nodemailer.createTransport({
    streamTransport: true,
    newline: 'unix',
    buffer: true
});
transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets buffered!'
}, (err, info)=>{
    console.log(info.envelope);
    console.log(info.messageId);
    console.log(info.message.toString());
});
```
