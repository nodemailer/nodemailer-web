+++
date = "2017-01-20T12:37:52+02:00"
toc = true
prev = "/message/custom-headers/"
next = "/smtp/"
weight = 18
title = "Custom source"

+++

If you want to use your own custom generated RFC822 formatted message source, instead of letting Nodemailer PRO to generate it from the message options, use option **raw**. This can be used both for the entire message or alternatively per-attachment or per-alternative.

{{% notice note %}}
Don't forget to set the **envelope** option when using **raw** as the message source
{{% /notice %}}

### Examples

#### 1\. Use string as a message body

This example loads the entire message source from a string value. You don't have to worry about proper newlines, these are handled by Nodemailer.

```javascript
let message = {
    envelope: {
        from: 'sender@example.com',
        to: ['recipient@example.com']
    },
    raw: `From: sender@example.com
To: recipient@example.com
Subject: test message

Hello world!`
};
```

#### 2\. Set eml file as message body

This example loads the entire message source from a file

```javascript
let message = {
    envelope: {
        from: 'sender@example.com',
        to: ['recipient@example.com']
    },
    raw: {
        path: '/path/to/message.eml'
    }
};
```

#### 3\. Set string as attachment body

When using **raw** for attachments then you need to provide all content headers youself, Nodemailer PRO does not process it in any way (besides newline processing), it is inserted into the MIME tree as is.

```javascript
let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Custom attachment',
    attachments: [{
        raw: `Content-Type: text/plain
Content-Disposition: attachment

Attached text file`}]
};
```
