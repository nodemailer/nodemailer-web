+++
title = "Delivery status notifications"
date = "2017-01-20T11:20:07+02:00"
toc = true
prev = "/smtp/proxies/"
next = "/transports/"
weight = 26

+++

If your delivery service supports it (not all SMTP servers have DSN extension enabled), then you can use Delivery status notifications (DSN) with Nodemailer as defined in [RFC3461](https://tools.ietf.org/html/rfc3461).

To set up a DSN call, add a dsn property to message data

- **dsn** – optional object to define DSN options

  - **id** – is the envelope identifier that would be included in the response (ENVID)
  - **return** – is either _'headers'_ or _'full'_. It specifies if only headers or the entire body of the message should be included in the response (RET)
  - **notify** – is either a string or an array of strings that define the conditions under which a DSN response should be sent. Possible values are _'never'_, _'success'_, _'failure'_ and _'delay'_. The condition _'never'_ can only appear on its own, other values can be grouped together into an array (NOTIFY)
  - **recipient** – is the email address the DSN should be sent (ORCPT)

Non-xtext strings are encoded automatically.

### Examples

#### 1\. Request DSN for delivered messages

```javascript
let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets read!',
    dsn: {
        id: 'some random message specific id',
        return: 'headers',
        notify: 'success',
        recipient: 'sender@example.com'
    }
};
```

#### 2\. Request DSN for undelivered and delayed messages

```javascript
let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets read!',
    dsn: {
        id: 'some random message specific id',
        return: 'headers',
        notify: ['failure', 'delay'],
        recipient: 'sender@example.com'
    }
};
```
