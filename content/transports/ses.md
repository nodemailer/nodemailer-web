+++
weight = 28
title = "SES transport"
date = "2017-01-20T12:01:09+02:00"
toc = true
prev = "/transports/sendmail/"
next = "/transports/stream/"

+++

Nodemailer SES transport is a wrapper around *aws.SES* from the [aws-sdk](https://www.npmjs.com/package/aws-sdk) package. SES transport is available from Nodemailer v3.1.0.

#### Why not use aws-sdk directly?

The SES API exposes two methods to send mail – [SendEmail](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SES.html#sendEmail-property) and [SendRawEmail](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SES.html#sendRawEmail-property). While the first one is really easy to use and Nodemailer is not actualy needed, then it is also quite basic in features. For example you can't use attachments with *SendEmail*. On the other hand *SendRawEmail* requires you build your own MIME formatted email message which is far from being easy. And this is where Nodemailer steps in – it gives you a simple to use API while supporting even really complex scenarios like embedded images or calendar events.

In addition to the simple API, Nodemailer also provides rate limiting for SES out of the box. SES can tolerate short spikes but you can't really flush all your emails at once and expect these to be delivered. To overcome this you can set a rate limiting value and let Nodemailer handle everything – if too many messages are being delivered then Nodemailer buffers these until there is an opportunity to do the actual delivery.

#### Usage

To use SES transport, set a *aws.SES* object as the value for **SES** property in Nodemailer transport options. That's it. You are responsible of initializing that object yourself as Nodemailer does not touch the AWS settings in any way.

Additional properties to use are the following:

  * **sendingRate** optional Number. How many messages per second is allowed to be delivered to SES
  * **maxConnections** optional Number. How many parallel connections to allow towards SES.

When sending mail there's also an additional message option for setting *SendRawEmail* options

  * **ses** is an optional object. All keys are added to the *SendRawEmail* method options.

##### Response

The **info** argument for **sendMail()** callback includes the following properties:

- **envelope** – is an envelope object *{from:'address', to:['address']}*
- **messageId** – is the Message-ID header value. This value is derived from the response of SES API, so it differs from the Message-ID values used in logging.

### Troubleshooting

**1\. Not allowed to send messages**

1. Check that your IAM role has *ses:SendRawEmail* action allowed
2. Check that the email address you are sending mail from is verified
3. There are multiple reports that access keys with special symbols might fail sending mail. Try to generate new access keys and see if it helps

**2\. aws-sdk is not found**

You need to install the [aws-sdk](https://www.npmjs.com/package/aws-sdk) module separately, it is not bundled with Nodemailer.

### Examples

#### 1\. Send a message using SES transport

```javascript
let nodemailer = require('nodemailer');
let aws = require('aws-sdk');

// configure AWS SDK
aws.config.loadFromPath('config.json');

// create Nodemailer SES transporter
let transporter = nodemailer.createTransport({
    SES: new aws.SES({
        apiVersion: '2010-12-01'
    }),
    sendingRate: 1 // max 1 messages/second
});

// send some mail
transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets sent!',
    ses: { // optional extra arguments for SendRawEmail
        Tags: [{
            Name: 'tag name',
            Value: 'tag value'
        }]
    }
}, (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
});
```

#### 2\. IAM policy
```json
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendRawEmail",
            "Resource": "*"
        }
    ]
}
```
