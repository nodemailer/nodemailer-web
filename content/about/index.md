+++
weight = 0
title = "Nodemailer"
date = "2017-01-20T21:25:35+02:00"
icon = "<b>1. </b>"
chapter = true
next = "/about/pricing"
# prev = "/prev/path"

+++

# Nodemailer

> Nodemailer is an e-mail sending module for Node.js. Send e-mails with Node.js – easy as cake!

Initially it was meant to cover the void in the area of sending e-mails from Node.js – the project got started back in 2010 when there was no sane option to send e-mail messages. Nowadays it is the solution most Node.js users turn to by default.

### Nodemailer supports:

- **Unicode** to use any characters, including full emoji support 💪
- **Windows** – you can install it with _npm_ on Windows just like any other module, there are no compiled dependencies. Use it from Azure or from your Windows box hassle free.
- **HTML content** as well as **plain text** alternative
- **[Attachments](/message/attachments/)** (including attachment **streaming** for sending larger files)
- **[Embedded images](/message/embedded-images/)** in HTML
- Secure e-mail delivery using **SSL/STARTTLS**
- Different **[transport methods](/transports/)** in addition to the built-in **[SMTP support](/smtp/)**
- **[DKIM signing](/dkim/)** messages
- Custom **[Plugin support](/plugins/)** for manipulating messages
- Sane **[OAuth2](/smtp/oauth2/)** authentication
- **[Proxies](/smtp/proxies/)** for SMTP connections

#### TL;DR Usage Example of Nodemailer

This is a complete example to send an e-mail with plaintext and HTML body

```javascript
const nodemailer = require('@nodemailer/pro');

// create reusable transporter object using the default SMTP transport
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'gmail.user@gmail.com',
        pass: 'yourpass'
    }
});

// setup e-mail data with unicode symbols
let mailOptions = {
    from: '"Fred Foo 👻" <foo@blurdybloop.com>', // sender address
    to: 'bar@blurdybloop.com, baz@blurdybloop.com', // list of receivers
    subject: 'Hello ✔', // Subject line
    text: 'Hello world ?', // plaintext body
    html: '<b>Hello world ?</b>' // html body
};

// send mail with defined transport object
transporter.sendMail(mailOptions, (error, info) {
    if (error) {
        return console.log(error);
    }
    console.log('Message %s sent: %s', info.messageId, info.response);
});
```

{{% notice info %}} Using Gmail might not work _out of the box_. See instructions for setting up Gmail SMTP [here](/usage/using-gmail/). {{% /notice %}}

--------------------------------------------------------------------------------

Nodemailer is created by [Andris Reinman](https://github.com/andris9). The Nodemailer logo was designed by [Sven Kristjansen](https://www.behance.net/kristjansen).
