+++
title = "Other transports"
date = "2017-01-20T17:20:25+02:00"
icon = "<b>5. </b>"
chapter = true
prev = "/smtp/dsn/"
next = "/transports/sendmail/"
weight = 0
toc = true
+++

# Other transports

In addition to the default [SMTP transport](/smtp/) you can use other kind of transports as well with Nodemailer. Some transports are built-in, some need an external plugin. See _Available Transports_ below for known transports.

The following example uses [SES transport](/transports/ses/) (Amazon SES).

```javascript
let nodemailer = require('nodemailer');
let aws = require('aws-sdk');
let transporter = nodemailer.createTransport({
    SES: new aws.SES({apiVersion: '2010-12-01'})
});
```

## Available transports

### Built-in transports

- **[sendmail](/transports/sendmail/)** – for piping messages to the _sendmail_ command
- **[SES](/transports/ses/)** – is a Nodemailer wrapper around *aws-sdk* to send mail using AWS SES
- **[stream](/transports/stream/)** – is just for returning messages, most probably for testing

### External transports

- **your own** (see transport api documentation [here](/plugins/create/#transports))

### General options for transports

Even though every transport has its own set of configuration options there are a few that can be used for every transport type

- **attachDataUrls** – if true, then converts *data:* images in the HTML content in every message to embedded attachments
- **disableFileAccess** – if true, then does not allow to use files as content. Use it when you want to use JSON data from untrusted source as the email. If an attachment or message node tries to fetch something from a file the sending returns an error
- **disableUrlAccess** – if true, then does not allow to use Urls as content
