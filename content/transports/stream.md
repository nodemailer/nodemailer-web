+++
weight = 28
title = "Stream transport"
date = "2017-01-20T12:01:09+02:00"
toc = true
prev = "/transports/ses/"
next = "/plugins/"

+++

Stream Transport is not actually a transport, it's more like a testing add-on as instead of delivering the message it processes input data and returns you the generated RFC822 email message either as a stream or a Buffer. Additionally you can define which kind of newlines to use, either the 'windows' style (&lt;CR&gt;&lt;LF&gt;) or the 'unix' style (&lt;LF&gt;). This transport is mostly useful for testing and also for scenarios where you want to use Nodemailer plugins to process the message and do the actual delivery by some other means.

To use Stream Transport, set **streamTransport** in Nodemailer transport options to *true* in Nodemailer options. If you want the transport to return buffers instead of streams, set **buffer** option to *true*. For newline selection use **newline** property (defaults to 'unix')

The **info** argument for **sendMail()** callback includes the following properties:

- **envelope** – is an envelope object *{from:'address', to:['address']}*
- **messageId** – is the Message-ID header value
- **message** – is either stream (default) of buffer depending on the options

### JSON transport

Another alternative instead of streaming is JSON transport (available since Nodemailer v3.1.0). In this case the message object would include a JSON string that in turn could be used as input for Nodemailer. All attachments, web content etc. are converted into base64 encoded strings. Address strings are parsed into address objects. The only downside is that *raw* property is not supported.

### Examples

#### 1\. Stream a message with windows-style newlines

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
}, (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
    info.message.pipe(process.stdout);
});
```

#### 2\. Create a buffer with unix-style newlines

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
}, (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
    console.log(info.message.toString());
});
```

#### 3\. Create a JSON encoded message object

```javascript
let transporter = nodemailer.createTransport({
    jsonTransport: true
});
transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets buffered!'
}, (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
    console.log(info.message); // JSON string
});
```

The contents of *info.message* (string value) would look like this:

```json
{
   "from":{
      "address":"sender@example.com",
      "name":""
   },
   "to":[
      {
         "address":"recipient@example.com",
         "name":""
      }
   ],
   "subject":"Message",
   "text":"I hope this message gets buffered!",
   "headers":{

   },
   "messageId":"<77a3458f-8070-339d-095f-85bb73f3db8e@example.com>"
}
```
