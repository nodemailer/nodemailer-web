+++
weight = 0
title = "Nodemailer"
date = "2017-01-20T21:25:35+02:00"
icon = "<b>1. </b>"
chapter = true
next = "/about/migrate/"
# prev = "/prev/path"
toc = true

+++

# Nodemailer

**Nodemailer** is a module for Node.js applications to allow easy as cake email sending. The project got started back in 2010 when there was no sane option to send email messages, today it is the solution most Node.js users turn to by default.

The current version of **Nodemailer v3+** is licensed under **EUPL-v1.1 license**. Commercial license availbale. See license details in the [License page](/about/license/).

<!--
{{% notice info %}}
To support the development of Nodemailer and keep it open source you can either donate using [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=DB26KWR2BQX5W) or if you want to support with Bitcoins, then my wallet address is `15Z8ADxhssKUiwP3jbbqJwA21744KMCfTM`
{{% /notice %}}
-->

If you do not want to upgrade from the MIT licensed Nodemailer 2 then you can see the old docs [here](https://community.nodemailer.com/), otherwise see the light migration guide [here](/about/migrate).

```bash
npm install nodemailer --save
```

### Nodemailer features

- A single module with **zero dependencies** – code is easily auditable, as there are no dark corners
- Heavy focus on **security**, no-one likes [RCE vulnerabilities](http://thehackernews.com/2017/01/phpmailer-swiftmailer-zendmail.html)
- **Unicode support** to use any characters, including emoji 💪
- **Windows support** – you can install it with [npm](https://www.npmjs.com/package/nodemailer) on Windows just like any other module, there are no compiled dependencies. Use it hassle free from Azure or from your Windows box
- Use **HTML content**, as well as **plain text** alternative
- Add **[Attachments](/message/attachments/)** to messages
- **[Embedded](/message/embedded-images/)** image attachments for HTML content – your design does not get blocked
- Secure email delivery using **TLS/STARTTLS**
- Different **[transport methods](/transports/)** in addition to the built-in **[SMTP support](/smtp/)**
- Sign messages with **[DKIM](/dkim/)**
- Custom **[Plugin support](/plugins/)** for manipulating messages
- Sane **[OAuth2](/smtp/oauth2/)** authentication
- **[Proxies](/smtp/proxies/)** for SMTP connections
- **ES6 code** – no more unintentional memory leaks, due to hoisted *var*'s

#### Requirements

* **Node.js v6+**. That's it.

If you are able to run Node.js version 6 or newer, then you can use Nodemailer. There are no platform or resource specific requirements.

#### TL;DR

In short, what you need to do to send messages, would be the following:

1. Create a Nodemailer transporter using either [SMTP](/smtp/) or [some other](/transports/) transport mechanism
2. Set up [message options](/message/) (who sends what to whom)
3. Deliver the message object using the **sendMail()** method of your previously created transporter

##### Example

This is a complete example to send an email with plain text and HTML body

```javascript
'use strict';
const nodemailer = require('nodemailer');

// create reusable transporter object using the default SMTP transport
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'gmail.user@gmail.com',
        pass: 'yourpass'
    }
});

// setup email data with unicode symbols
let mailOptions = {
    from: '"Fred Foo 👻" <foo@blurdybloop.com>', // sender address
    to: 'bar@blurdybloop.com, baz@blurdybloop.com', // list of receivers
    subject: 'Hello ✔', // Subject line
    text: 'Hello world ?', // plain text body
    html: '<b>Hello world ?</b>' // html body
};

// send mail with defined transport object
transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
        return console.log(error);
    }
    console.log('Message %s sent: %s', info.messageId, info.response);
});
```

{{% notice info %}}
Using Gmail might or might not work out of the box. See instructions for setting up Gmail SMTP [here](/usage/using-gmail/).
{{% /notice %}}

### Source code

- **Nodemailer** source code is available [on Github](https://github.com/nodemailer/nodemailer)
- **MailParser** source code is available [on Github](https://github.com/andris9/mailparser)
- **smtp-server** source code is available [on Github](https://github.com/andris9/smtp-server)
- **mailsplit** source code is available [on Github](https://github.com/andris9/mailsplit)

### Examples

- ***Nodemailer AMQP example** is an example of using RabbitMQ to manage Nodemailer email messages. [Source](https://github.com/nodemailer/nodemailer-amqp-example).

--------------------------------------------------------------------------------

Nodemailer is created by [Andris Reinman](https://github.com/andris9). The Nodemailer logo was designed by [Sven Kristjansen](https://www.behance.net/kristjansen).
