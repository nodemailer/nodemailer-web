+++
title = "Pooled SMTP"
date = "2017-01-20T11:20:07+02:00"
toc = true
prev = "/smtp/envelope/"
next = "/smtp/oauth2/"
weight = 21

+++

If pooling is used then Nodemailer PRO keeps a fixed amount of connections open and sends the next message once a connection becomes available. It is mostly useful when you have a large number of messages that you want to send in batches or your provider allows you to only use a small amount of parallel connections.

To use pooled connections use the following options in transport configuration

- **pool** – set to *true* to use pooled connections (defaults to *false*) instead of creating a new connection for every email
- **maxConnections** – is the count of maximum simultaneous connections to make against the SMTP server (defaults to 5)
- **maxMessages** – limits the message count to be sent using a single connection (defaults to 100). After *maxMessages* is reached the connection is dropped and a new one is created for the following messages
- **rateDelta** – defines the time measuring period in milliseconds (defaults to 1000, ie. to 1 second) for rate limiting
- **rateLimit** – limits the message count to be sent in **rateDelta** time. Once *rateLimit* is reached, sending is paused until the end of the measuring period. This limit is shared between connections, so if one connection uses up the limit, then other connections are paused as well. If *rateLimit* is not set then sending rate is not limited

### Methods

#### transporter.isIdle()

Returns *true* if there are available connection slots

#### transporter.close()

If transporter uses pooling then connections are kept open even if there is nothing to be sent. To close all pending connections you can use the *close()* method

```javascript
let transporter = nodemailer.createTransport({pool: true,...});
// ...
transporter.close();
```

### Events

#### Event:'idle'

Emitted by the transporter object if connection pool has free connection slots. Check if a connection is still available with `isIdle()` method (returns `true` if a connection is still available). This allows to create push-like senders where messages are not queued into memory in a Node.js process but pushed and loaded through an external queue.

```javascript
let messages = [...'list of messages'];
transporter.on('idle', function(){
    // send next message from the pending queue
    while (transporter.isIdle() && messages.length) {
        transporter.sendMail (messages.shift());
    }
});
```
