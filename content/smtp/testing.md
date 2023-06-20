+++
title = "Testing SMTP"
date = "2017-01-20T11:20:07+02:00"
toc = true
prev = "/smtp/pooled/"
next = "/smtp/oauth2/"
weight = 22

+++

When building complex applications then sooner or later you end up in a situation where you need to send emails from your application in test environment but do not want to accidentally spam anyone.

One solution would be to separate development email addresses and use only some specific testing address to send all mail to but a better approach would be to use a separate email catching service that accepts all messages like a normal transactional SMTP service would but instead of delivering these to destination, it only logs these messages.

There are several options for using such a service, Nodemailer has built-in support for [Ethereal Email](https://ethereal.email). You can create new testing account on the fly by using the `createTestAccount` method or from the Ethereal homepage. You could also test locally using [email-templates](https://github.com/forwardemail/email-templates) which uses [preview-email](https://github.com/forwardemail/preview-email) under the hood (renders an email preview in your browser and iOS simulator).

### Examples

#### Create a testing account on the fly

**NB!** Do not forget to store these credentials somewhere if you want to browse sent messages at [ethereal.email](https://ethereal.email)

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

This example assumes you have already generated as user account at Ethereal. You can do this for example from the [login page](https://ethereal.email/login) or re-use the credentials created in the previous example.

```javascript
var mailConfig;
if (process.env.NODE_ENV === 'production' ){
    // all emails are delivered to destination
    mailConfig = {
        host: 'smtp.sendgrid.net',
        port: 587,
        auth: {
            user: 'real.user',
            pass: 'verysecret'
        }
    };
} else {
    // all emails are catched by ethereal.email
    mailConfig = {
        host: 'smtp.ethereal.email',
        port: 587,
        auth: {
            user: 'ethereal.user@ethereal.email',
            pass: 'verysecret'
        }
    };
}
let transporter = nodemailer.createTransport(mailConfig);
```

Sending a message to Ethereal gives you a link to the stored message. You can either get the link using `getTestMessageUrl` method or log in to Ethereal and open the Messages section.

```javascript
transporter.sendMail(...).then(info=>{
    console.log('Preview URL: ' + nodemailer.getTestMessageUrl(info));
});
```

Output of the the [example script](https://github.com/nodemailer/nodemailer/blob/master/examples/full.js) as shown by the [Ethereal](https://ethereal.email/) mail catching service:

![](https://cldup.com/D5Cj_C1Vw3.png)
