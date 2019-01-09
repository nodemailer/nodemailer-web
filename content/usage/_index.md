+++
prev = "/about/license/"
next = "/usage/why-smtp/"
weight = 20
title = "Usage"
date = "2017-01-21T00:20:55+02:00"
pre = "<b>2. </b>"
chapter = true
toc = true
+++

# Usage

## Setting it up

Install Nodemailer from [npm](https://www.npmjs.com/package/nodemailer)

```bash
npm install nodemailer
```

To send emails you need a transporter object

```javascript
let transporter = nodemailer.createTransport(transport[, defaults])
```

Where

- **transporter** is going to be an object that is able to send mail
- **transport** is the transport configuration object, connection url or a transport plugin instance
- **defaults** is an object that defines default values for mail options

{{% notice tip %}}
You have to create the transporter object only once. If you already have a transporter object you can use it to send mail as much as you like.
{{% /notice %}}

### Send using SMTP

See the details about setting up a SMTP based transporter [here](/smtp/).

### Send using a transport plugin

See the details about setting up a plugin based transporter [here](/transports/).

## Sending mail

Once you have a transporter object you can send mail with it:

```javascript
transporter.sendMail(data[, callback])
```

Where

- **data** defines the mail content (see [Message Configuration](/message/) for possible options)
- **callback** is an optional callback function to run once the message is delivered or it failed
  - **err** is the error object if message failed
  - **info** includes the result, the exact format depends on the transport mechanism used
    - **info.messageId** most transports _should_ return the final Message-Id value used with this property
    - **info.envelope** includes the envelope object for the message
    - **info.accepted** is an array returned by SMTP transports (includes recipient addresses that were accepted by the server)
    - **info.rejected** is an array returned by SMTP transports (includes recipient addresses that were rejected by the server)
    - **info.pending** is an array returned by Direct SMTP transport. Includes recipient addresses that were temporarily rejected together with the server response
    - **response** is a string returned by SMTP transports and includes the last SMTP response from the server

{{% notice info %}}
If the message includes several recipients then the message is considered sent if at least one recipient is accepted
{{% /notice %}}

If `callback` argument is not set then the method returns a Promise object. Nodemailer itself does not use Promises internally but it wraps the return into a Promise for convenience.
