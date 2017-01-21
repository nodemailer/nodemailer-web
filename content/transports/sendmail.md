+++
date = "2017-01-20T11:35:26+02:00"
toc = true
prev = "/transports/"
next = "/transports/stream/"
weight = 27
title = "Sendmail Transport"

+++

Sendmail Transport pipes the generated RFC822 message to the standard input of the **sendmail** command, so it's the same thing what the **mail()** function in PHP does.

To use Sendmail Transport, set **sendmail** in Nodemailer PRO transport options to *true*.

The additional options to use with this transport are the following:

- **path** - path to the **sendmail** command (defaults to *'sendmail'*)
- **newline** - either *'windows'* or *'unix'* (default). Forces all newlines in the output to either use Windows syntax &lt;CR&gt;&lt;LF&gt; or Unix syntax &lt;LF&gt;
- **args** - an optional array of command line options to pass to the **sendmail** command (ie. `["-f", "foo@blurdybloop.com"]`). This overrides all default arguments except for *'-i'* and recipient list so you need to make sure you have all required arguments set (ie. the '-f' flag).

The command to be spawned by default looks like this:

```sh
sendmail -i -f from_addr to_addr[]
```

If **args** property was provided then the command looks like this:

```sh
sendmail -i args[] to_addr[]
```

The **info** argument for **sendMail()** callback includes the following properties:

- **envelope** – is an envelope object *{from:'address', to:['address']}*
- **messageId** – is the Message-ID header value

### Examples

#### 1\. Send a message using specific binary

This example pipes message to a custom command using unix-style newlines. Sendmail does not produce any output besides the exit code, so there's nothing else to return with the callback.

```javascript
let transporter = nodemailer.createTransport({
    sendmail: true,
    newline: 'unix',
    path: '/usr/sbin/sendmail'
});
transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets delivered!'
}, (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
});
```
