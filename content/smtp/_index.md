+++
date = "2017-01-20T10:51:36+02:00"
chapter = true
prev = "/message/custom-source/"
next = "/smtp/envelope/"
weight = 40
title = "SMTP transport"
pre = "<b>4. </b>"
toc = true
+++

# SMTP transport

SMTP is the main transport in Nodemailer for delivering messages. SMTP is also the protocol used between different email hosts, so it's truly universal. Almost every email delivery provider supports SMTP-based sending, even if they mainly push their API-based sending. APIs might have more features, but using these also means vendor lock-in. In the case of SMTP, you only need to change the configuration options to replace one provider with another, and you're good to go.

```javascript
let transporter = nodemailer.createTransport(options[, defaults])
```

Where

- **options** – is an object that defines connection data (see below for details)
- **defaults** – is an object that is going to be merged into every message object. This allows you to specify shared options, for example to set the same _from_ address for every message

Alternatively, you could use a connection url instead of an object for the options. Use _'smtp:'_ or _'smtps:'_ as the protocol in the url.

```javascript
let poolConfig = "smtps://username:password@smtp.example.com/?pool=true";
```

##### General options

- **port** – is the port to connect to (defaults to 587 if is _secure_ is _false_ or 465 if _true_)
- **host** – is the hostname or IP address to connect to (defaults to _'localhost'_)
- **auth** – defines authentication data (see [authentication](#authentication) section below)
- **authMethod** – defines preferred authentication method, defaults to 'PLAIN'

Hostnames for the **host** field are resolved using `dns.resolve()`. If you are using a non-resolvable hostname (eg. something listed in _/etc/hosts_ or you are using different resolver for your Node apps), then provide the IP address of the SMTP server as **host** and use the actual hostname in the **tls.servername** parameter. This way, no hostname resolving is attempted, but TLS validation still works.

##### TLS options

- **secure** – if _true_ the connection will use TLS when connecting to server. If _false_ (the default) then TLS is used if server supports the STARTTLS extension. In most cases set this value to _true_ if you are connecting to port 465. For port 587 or 25 keep it _false_
- **tls** – defines additional [node.js TLSSocket options](https://nodejs.org/api/tls.html#tls_class_tls_tlssocket) to be passed to the socket constructor, eg. _{rejectUnauthorized: true}_.
- **tls.servername** - is optional hostname for TLS validation if `host` was set to an IP address
- **ignoreTLS** – if this is _true_ and _secure_ is false then TLS is not used even if the server supports STARTTLS extension
- **requireTLS** – if this is _true_ and _secure_ is false then Nodemailer tries to use STARTTLS even if the server does not advertise support for it. If the connection can not be encrypted then message is not sent

Setting **secure** to **false** does not mean that you would not use an encrypted connection. Most SMTP servers allow connection upgrade via the [STARTTLS](https://tools.ietf.org/html/rfc3207#section-2) command, but to use this, you have to connect using plaintext first.

##### Connection options

- **name** – optional hostname of the client, used for identifying to the server, defaults to hostname of the machine
- **localAddress** – is the local interface to bind to for network connections
- **connectionTimeout** – how many milliseconds to wait for the connection to establish (default is 2 minutes)
- **greetingTimeout** – how many milliseconds to wait for the greeting after connection is established (default is 30 seconds)
- **socketTimeout** – how many milliseconds of inactivity to allow (default is 10 minutes)
- **dnsTimeout** - Time to wait in ms for the DNS requests to be resolved (defaults to 30 seconds)
- **lmtp** - if true, uses LMTP instead of SMTP protocol

##### Debug options

- **logger** – optional [bunyan](https://github.com/trentm/node-bunyan) compatible logger instance. If set to `true` then logs to console. If value is not set or is `false` then nothing is logged
- **debug** – if set to true, then logs SMTP traffic, otherwise logs only transaction events

##### Security options

- **disableFileAccess** – if true, then does not allow to use files as content. Use it when you want to use JSON data from untrusted source as the email. If an attachment or message node tries to fetch something from a file the sending returns an error
- **disableUrlAccess** – if true, then does not allow to use Urls as content

##### Pooling options

- **pool** – see [Pooled SMTP](/smtp/pooled/) for details about connection pooling

##### Proxy options

- **proxy** – all SMTP based transports allow to use proxies for making TCP connections to servers. Read about proxy support in Nodemailer from [here](/smtp/proxies/)

### Examples {#examples}

#### 1\. Single connection

This example would connect to a SMTP server separately for every single message

```javascript
nodemailer.createTransport({
  host: "smtp.example.com",
  port: 587,
  secure: false, // upgrade later with STARTTLS
  auth: {
    user: "username",
    pass: "password",
  },
});
```

#### 2\. Pooled connections

This example would set up pooled connections against an SMTP server on port 465.

```javascript
nodemailer.createTransport({
  pool: true,
  host: "smtp.example.com",
  port: 465,
  secure: true, // use TLS
  auth: {
    user: "username",
    pass: "password",
  },
});
```

#### 3\. Allow self-signed certificates

This config would open a connection to a TLS server with self-signed or invalid TLS certificate.

```javascript
nodemailer.createTransport({
  host: "my.smtp.host",
  port: 465,
  secure: true, // use TLS
  auth: {
    user: "username",
    pass: "pass",
  },
  tls: {
    // do not fail on invalid certs
    rejectUnauthorized: false,
  },
});
```

## Authentication {#authentication}

If authentication data is not present, the connection is considered authenticated from the start. Otherwise you would need to provide the authentication options object.

- **auth** is the authentication object

  - **type** indicates the authetication type, defaults to 'login', other option is 'oauth2'
  - **user** is the username
  - **pass** is the password for the user if normal login is used

For authenticating using OAuth2 instead of normal auth, see OAuth2 options for the **auth** object [here](/smtp/oauth2/).

You can also define [custom authentication handlers](/smtp/customauth/) for protocols that are not natively supported by Nodemailer, see [NTLM handler](https://github.com/nodemailer/nodemailer-ntlm-auth) as an example of such custom handler.

## Verify SMTP connection configuration

You can verify your SMTP configuration with **verify(callback)** call (also works as a Promise). If it returns an error, then something is not correct, otherwise the server is ready to accept messages.

```javascript
// verify connection configuration
transporter.verify(function (error, success) {
  if (error) {
    console.log(error);
  } else {
    console.log("Server is ready to take our messages");
  }
});
```

Be aware though that this call only tests connection and authentication, but it does not check if the service allows you to use a specific envelope "From" address or not.
