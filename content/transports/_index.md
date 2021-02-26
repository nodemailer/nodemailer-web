+++
title = "Other transports"
date = "2017-01-20T17:20:25+02:00"
pre = "<b>5. </b>"
chapter = true
prev = "/smtp/dsn/"
next = "/transports/sendmail/"
weight = 50
toc = true
+++

# Other transports

In addition to the default [SMTP transport](/smtp/) you can use other kind of transports as well with Nodemailer. Some transports are built-in, some need an external plugin. See _Available Transports_ below for known transports.

The following example uses [SES transport](/transports/ses/) (Amazon SES).

```javascript
let nodemailer = require("nodemailer");
let aws = require("@aws-sdk/client-ses");
process.env.AWS_ACCESS_KEY_ID = "....";
process.env.AWS_SECRET_ACCESS_KEY = "....";
const ses = new aws.SES({
  apiVersion: "2010-12-01",
  region: "us-east-1",
});
let transporter = nodemailer.createTransport({
  SES: { ses, aws },
});
```

## Available transports

### Built-in transports

- **[sendmail](/transports/sendmail/)** – for piping messages to the _sendmail_ command
- **[SES](/transports/ses/)** – is a Nodemailer wrapper around _aws-sdk_ to send mail using AWS SES
- **[stream](/transports/stream/)** – is just for returning messages, most probably for testing

### External transports

- **your own** (see transport api documentation [here](/plugins/create/#transports))

### General options for transports

Even though every transport has its own set of configuration options there are a few that can be used for every transport type

- **attachDataUrls** – if true, then converts _data:_ images in the HTML content in every message to embedded attachments
- **disableFileAccess** – if true, then does not allow to use files as content. Use it when you want to use JSON data from untrusted source as the email. If an attachment or message node tries to fetch something from a file the sending returns an error
- **disableUrlAccess** – if true, then does not allow to use Urls as content
- **normalizeHeaderKey(key)** – a method that is applied to every header key before inserting to generated rfc822 message. [Example](https://github.com/nodemailer/nodemailer/blob/3e3ba4f30ad5a73f037f45d3e36a9361ca43a318/examples/custom-headers.js#L13-L14)
