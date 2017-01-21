+++
weight = 0
title = "Nodemailer PRO"
date = "2017-01-20T21:25:35+02:00"
icon = "<b>1. </b>"
chapter = true
next = "/about/why/"
# prev = "/prev/path"
toc = true

+++

# Nodemailer PRO

The [community version](https://community.nodemailer.com/) of **Nodemailer** is a module for Node.js applications to allow easy as cake email sending. The project got started back in 2010 when there was no sane option to send email messages, today it is the solution most Node.js users turn to by default.

**Nodemailer PRO** ([why PRO?](/about/why/)) is an upgrade of Nodemailer. Unlike Nodemailer which is licensed under MIT, Nodemailer PRO is licensed under restrictive CC license. See license details in the [License page](/about/license/).

### Nodemailer PRO features

- A single module with **zero dependencies**. Code is easily auditable as there are no dark corners
- Heavy focus on **security**, no-one likes [RCE vulnerabilities](http://thehackernews.com/2017/01/phpmailer-swiftmailer-zendmail.html)
- **Unicode support** to use any characters, including emoji 💪
- **Windows support** – you can install it with [npm](https://www.npmjs.com/package/@nodemailer/pro) on Windows just like any other module, there are no compiled dependencies. Use it from Azure or from your Windows box hassle free.
- Use **HTML content** as well as **plain text** alternative
- Add **[Attachments](/message/attachments/)** to messages
- **[Embedded](/message/embedded-images/)** image attachments for HTML content, so your design does not get blocked
- Secure email delivery using **SSL/STARTTLS**
- Different **[transport methods](/transports/)** in addition to the built-in **[SMTP support](/smtp/)**
- Sign messages with **[DKIM sign](/dkim/)**
- Custom **[Plugin support](/plugins/)** for manipulating messages
- Sane **[OAuth2](/smtp/oauth2/)** authentication
- **[Proxies](/smtp/proxies/)** for SMTP connections
- **ES6 code** so no more unintentional memory leaks due to hoisted *var*'s

#### Requirements

* Node.js v6+. That's it.

If you are able to run Node.js version 6 or newer then you can use Nodemailer. There are no platform or resource specific requirements.

#### TL;DR

In short what you need to do to send messages would be the following:

1. Create a Nodemailer PRO transporter using either [SMTP](/smtp/) or [some other](/transports/) transport mechanism
2. Set up [message options](/message/) (who sends what to whom)
3. Deliver the message object using the **sendMail()** method of your previously created transporter

##### Example

This is a complete example to send an email with plaintext and HTML body

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

// setup email data with unicode symbols
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

{{% notice info %}}
Using Gmail might or might not work out of the box. See instructions for setting up Gmail SMTP [here](/usage/using-gmail/).
{{% /notice %}}


--------------------------------------------------------------------------------

Nodemailer and Nodemailer PRO are created by [Andris Reinman](https://github.com/andris9). The Nodemailer logo was designed by [Sven Kristjansen](https://www.behance.net/kristjansen).
