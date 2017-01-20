+++
date = "2017-01-20T11:35:26+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 5
title = "Configuration"

+++

Sendmail Transport pipes the generated RFC822 message to the standard input of the `sendmail` command, so it's the same thing what the `mail()` command in PHP does.

To use Sendmail Transport, set `sendmail` option to `true` in Nodemailer options.

The additional options to use with this transport are the following:

- **path** - path to the `sendmail` command (defaults to `'sendmail'`)
- **newline** - either 'windows' or 'unix' (default). Forces all newlines in the output to either use Windows syntax `<CR><LF>` or Unix syntax `<LF>`
- **args** - an optional array of command line options to pass to the `sendmail` command (ie. `["-f", "foo@blurdybloop.com"]`). This overrides all default arguments except for '-i' and recipient list so you need to make sure you have all required arguments set (ie. the '-f' flag).

The command to be spawned by default looks like this:

```
sendmail -i -f from_addr to_addr[]
```

If `args` property was provided then the command looks like this:

```
sendmail -i args[] to_addr[]
```

The `info` argument for `sendMail()` method includes the following properties:

- **envelope** – is an envelope object `{from:'address', to:['address']}`
- **messageId** – is the Message-ID header value

## Examples

### 1\. Send message using specific binary

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
}, (err, info)=>{
    console.log(info.envelope);
    console.log(info.messageId);
});
```
