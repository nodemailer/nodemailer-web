+++
title = "Other transports"
date = "2017-01-20T17:20:25+02:00"
icon = "<b>7. </b>"
chapter = true
next = "/next/path"
prev = "/prev/path"
weight = 0

+++

# Other transports

In addition to the default [SMTP transport](/smtp/) you can use other kind of transports as well with Nodemailer. Some transprots are built-in, some need an external plugin. See _Available Transports_ below for known transports.

The following example uses [nodemailer-ses-transport](https://github.com/andris9/nodemailer-ses-transport) (Amazon SES).

```javascript
let ses = require('nodemailer-ses-transport');
let transporter = nodemailer.createTransport(ses({
    accessKeyId: 'AWSACCESSKEY',
    secretAccessKey: 'AWS/Secret/key'
}));
```

## Available Transports

### Built-in transports

- **[sendmail](/transports/sendmail/)** – for piping messages to the _sendmail_ command
- **[stream](/transports/stream/)** – is just for returning messages, most probably for testing

### External transports

- **[nodemailer-mandrill-transport](https://github.com/rebelmail/nodemailer-mandrill-transport)** – for sending messages through Mandrill's Web API
- **[nodemailer-pickup-transport](https://github.com/andris9/nodemailer-pickup-transport)** – for storing messages to pickup folders
- **[nodemailer-sailthru-transport](https://github.com/rebelmail/nodemailer-sailthru-transport)** – for sending messages through Sailthru's Web API
- **[nodemailer-sendgrid-transport](https://github.com/sendgrid/nodemailer-sendgrid-transport)** – for sending messages through SendGrid's Web API
- **[nodemailer-ses-transport](https://github.com/andris9/nodemailer-ses-transport)** – for sending messages to AWS SES
- **[nodemailer-sparkpost-transport](https://github.com/sparkpost/nodemailer-sparkpost-transport)** – for sending messages through SparkPost's Web API
- **your own** (see transport api documentation [here](/plugins/create/#transports))
