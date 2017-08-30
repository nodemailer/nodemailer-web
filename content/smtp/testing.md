+++
title = "Testing SMTP"
date = "2017-01-20T11:20:07+02:00"
toc = true
prev = "/smtp/pooled/"
next = "/smtp/oauth2/"
weight = 22

+++

When building complex applications then sooner or later you end up in a situation where you need to send emails from your application in test environment but do not want to accidentally spam anyone. One solution would be to separate development email addresses and use only some specific testing account but a better approach would be to use a separate email catching service that accepts all messages like a normal transactional SMTP service but instead of delivering these to destination, it only logs these messages.

There are several options for using such a service, Nodemailer has built-in support for [Ethereal Email](https://ethereal.email). You can create new testing account on the fly by using the `createTestAccount` method or from the Ethereal homepage.

### Examples

#### Create a testing account on the fly

```javascript
nodemailer.createTestAccount((err, account) => {
    // create reusable transporter object using the default SMTP transport
    let transporter = nodemailer.createTransport({
        host: 'smtp.ethereal.email',
        port: 587,
        secure: false, // true for 465, false for other ports
        auth: {
            user: account.user, // generated ethereal user
            pass: account.pass  // generated ethereal password
        }
    });
});
```

#### Use environment specific SMTP settings

```javascript
var mailConfig;
if (process.env.NODE_ENV === 'production' ){
    // all emails are delivered to destination
    mailConfig = {
        host: 'smtp.sendgrid.net',
        port: 587,
        auth: {
            user: 'real.user',
            user: 'verysecret'
        }
    };
} else {
    // all emails are catched by ethereal.email
    mailConfig = {
        host: 'smtp.ethereal.email',
        port: 587,
        auth: {
            user: 'ethereal.user@ethereal.email',
            user: 'verysecret'
        }
    };
}
let transport = nodemailer.createTransport(mailConfig);
```
