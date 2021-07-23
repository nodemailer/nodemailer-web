+++
weight = 28
title = "SES transport"
date = "2017-01-20T12:01:09+02:00"
toc = true
prev = "/transports/sendmail/"
next = "/transports/stream/"

+++

Nodemailer SES transport is a wrapper around _aws.SES_ from the [aws-sdk](https://www.npmjs.com/package/aws-sdk) package. SES transport is available from Nodemailer v3.1.0.

## Why not use aws-sdk directly?

The SES API exposes two methods to send mail – [SendEmail](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SES.html#sendEmail-property) and [SendRawEmail](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SES.html#sendRawEmail-property). While the first one is really easy to use and Nodemailer is not actually needed, then it is also quite basic in features. For example you can't use attachments with _SendEmail_. On the other hand _SendRawEmail_ requires you build your own MIME formatted email message which is far from being easy. And this is where Nodemailer steps in – it gives you a simple to use API while supporting even really complex scenarios like embedded images or calendar events.

In addition to the simple API, Nodemailer also provides rate limiting for SES out of the box. SES can tolerate short spikes but you can't really flush all your emails at once and expect these to be delivered. To overcome this you can set a rate limiting value and let Nodemailer handle everything – if too many messages are being delivered then Nodemailer buffers these until there is an opportunity to do the actual delivery.

## Usage

To use SES transport, set a _aws.SES_ object as the value for **SES** property in Nodemailer transport options. That's it. You are responsible of initializing that object yourself as Nodemailer does not touch the AWS settings in any way.

- **SES** – is an option that expects an instantiated _aws.SES_ object (see [example #1](#example-1)).

Additional properties to use are the following:

- **sendingRate** optional Number. How many messages per second is allowed to be delivered to SES
- **maxConnections** optional Number. How many parallel connections to allow towards SES.

If you use rate or connection limiting then you can also use helper methods to detect if the sending queue is full or not. This would help to avoid buffering up too many messages.

Listen for the _'idle'_ event to be notified if you can push more messages to the transporter. To explicitly check if there are free spots available use _isIdle()_ method (see [example #2](#example-2)).

#### Message options

When sending mail there's also an additional message option for setting _SendRawEmail_ options

- **ses** is an optional object. All keys are added to the _SendRawEmail_ method options.

#### Response

The **info** argument for **sendMail()** callback includes the following properties:

- **envelope** – is an envelope object _{from:'address', to:['address']}_
- **messageId** – is the Message-ID header value. This value is derived from the response of SES API, so it differs from the Message-ID values used in logging.

### Troubleshooting

**1\. Not allowed to send messages**

1. Check that your IAM role has _ses:SendRawEmail_ action allowed (see [example #3](#example-3))
2. Check that the email address you are sending mail from is verified
3. There are multiple reports that access keys with special symbols might fail sending mail. Try to generate new access keys and see if it helps

**2\. aws-sdk is not found**

You need to install the [aws-sdk](https://www.npmjs.com/package/aws-sdk) module separately, it is not bundled with Nodemailer.

### Examples

#### 1\. Send a message using SES transport {#example-1}

```javascript
let nodemailer = require("nodemailer");
let aws = require("@aws-sdk/client-ses");

// configure AWS SDK
process.env.AWS_ACCESS_KEY_ID = "....";
process.env.AWS_SECRET_ACCESS_KEY = "....";
const ses = new aws.SES({
  apiVersion: "2010-12-01",
  region: "us-east-1",
});

// create Nodemailer SES transporter
let transporter = nodemailer.createTransport({
  SES: { ses, aws },
});

// send some mail
transporter.sendMail(
  {
    from: "sender@example.com",
    to: "recipient@example.com",
    subject: "Message",
    text: "I hope this message gets sent!",
    ses: {
      // optional extra arguments for SendRawEmail
      Tags: [
        {
          Name: "tag_name",
          Value: "tag_value",
        },
      ],
    },
  },
  (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
  }
);
```

#### 2\. Throttle messages {#example-2}

```javascript
let transporter = nodemailer.createTransport({
    SES: { ses, aws },
    sendingRate: 1 // max 1 messages/second
});

// Push next messages to Nodemailer
transporter.once('idle', () => {
    if (transporter.isIdle()) {
        transporter.sendMail(...);
    }
});
```

#### 3\. IAM policy {#example-3}

Nodemailer SES transport requires _ses:SendRawEmail_ role

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
