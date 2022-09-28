+++
title = "SMTP Connection"
date = "2017-01-21T00:12:25+02:00"
toc = true
prev = "/extras/smtp-server/"
next = "/extras/mailparser/"
weight = 2

+++

SMTP client module to connect to SMTP servers and send mail with it.

This module is the successor for the client part of the (now deprecated) SMTP module [simplesmtp](https://www.npmjs.com/package/simplesmtp). For matching SMTP server see [smtp-server](/extras/smtp-server/).

## Usage

#### Step 1. Install Nodemailer with npm

_smtp-connection_ is exposed as a submodule of Nodemailer

```bash
npm install nodemailer --save
```

#### Step 2. Require _smtp-connection_ in your script

```javascript
const SMTPConnection = require("nodemailer/lib/smtp-connection");
```

#### Step 3. Create SMTPConnection instance

```javascript
let connection = new SMTPConnection(options);
```

Where

- **options** defines connection data

  - **options.port** is the port to connect to (defaults to 25 or 465)
  - **options.host** is the hostname or IP address to connect to (defaults to 'localhost')
  - **options.secure** defines if the connection should use SSL (if _true_) or not (if _false_)
  - **options.ignoreTLS** turns off STARTTLS support if true
  - **options.requireTLS** forces the client to use STARTTLS. Returns an error if upgrading the connection is not possible or fails.
  - **options.opportunisticTLS** tries to use STARTTLS and continues normally if it fails
  - **options.name** optional hostname of the client, used for identifying to the server
  - **options.localAddress** is the local interface to bind to for network connections
  - **options.connectionTimeout** how many milliseconds to wait for the connection to establish
  - **options.greetingTimeout** how many milliseconds to wait for the greeting after connection is established
  - **options.socketTimeout** how many milliseconds of inactivity to allow
  - **options.dnsTimeout** - Time to wait in ms for the DNS requests to be resolved (defaults to 30 seconds)
  - **options.logger** optional [bunyan](https://github.com/trentm/node-bunyan) compatible logger instance. If set to _true_ then logs to console. If value is not set or is _false_ then nothing is logged
  - **options.transactionLog** if set to true, then logs SMTP traffic without message content
  - **options.debug** if set to true, then logs SMTP traffic and message content, otherwise logs only transaction events
  - **options.authMethod** defines preferred authentication method, e.g. 'PLAIN'
  - **options.tls** defines additional options to be passed to the socket constructor, e.g. _{rejectUnauthorized: true}_
  - **options.socket** - initialized socket to use instead of creating a new one
  - **options.connection** - connected socket to use instead of creating and connecting a new one. If _secure_ option is true, then socket is upgraded from plaintext to ciphertext

### Events

SMTPConnection instances are event emitters with the following events

- **'error'** _(err)_ emitted when an error occurs. Connection is closed automatically in this case.
- **'connect'** emitted when the connection is established
- **'end'** when the instance is destroyed

### connect

Establish the connection

```javascript
connection.connect(callback);
```

Where

- **callback** is the function to run once the connection is established. The function is added as a listener to the 'connect' event.

After the connect event the _connection_ has the following properties:

- **connection.secure** - if _true_ then the connection uses a TLS socket, otherwise it is using a cleartext socket. Connection can start out as cleartext but if available (or _requireTLS_ is set to true) connection upgrade is tried

### login

If the server requires authentication you can login with

```javascript
connection.login(auth, callback);
```

Where

- **auth** is the authentication object

  - **credentials** is a normal authentication object
  - **credentials.user** is the username
  - **credentials.pass** is the password
  - **oauth2** if set then forces smtp-connection to use XOAuth2 for authentication
  - **oauth2.user** is the username
  - **oauth2.clientId** is the OAuth2 Client ID
  - **oauth2.clientSecret** is the OAuth2 Client Secret
  - **oauth2.refreshToken** is the refresh token to generate new access token if needed
  - **oauth2.accessToken** is the access token

- **callback** is the callback to run once the authentication is finished. Callback has the following arguments

  - **err** and error object if authentication failed

### send

Once the connection is authenticated (or just after connection is established if authentication is not required), you can send mail with

```javascript
connection.send(envelope, message, callback);
```

Where

- **envelope** is the envelope object to use

  - **envelope.from** is the sender address
  - **envelope.to** is the recipient address or an array of addresses
  - **envelope.size** is an optional value of the predicted size of the message in bytes. This value is used if the server supports the SIZE extension (RFC1870)
  - **envelope.use8BitMime** if _true_ then inform the server that this message might contain bytes outside 7bit ascii range
  - **envelope.dsn** is the dsn options
  - **envelope.dsn.ret** return either the full message 'FULL' or only headers 'HDRS'
  - **envelope.dsn.envid** sender's 'envelope identifier' for tracking
  - **envelope.dsn.notify** when to send a DSN. Multiple options are OK - array or comma delimited. NEVER must appear by itself. Available options: 'NEVER', 'SUCCESS', 'FAILURE', 'DELAY'
  - **envelope.dsn.orcpt** original recipient

- **message** is either a String, Buffer or a Stream. All newlines are converted to \r\n and all dots are escaped automatically, no need to convert anything before.

- **callback** is the callback to run once the sending is finished or failed. Callback has the following arguments
  - **err** and error object if sending failed
  - **err.code** string code identifying the error, for example 'EAUTH' is returned when authentication fails
  - **err.response** is the last response received from the server (if the error is caused by an error response from the server)
  - **err.responseCode** is the numeric response code of the _response_ string (if available)
  - **info** information object about accepted and rejected recipients
  - **info.accepted** an array of accepted recipient addresses. Normally this array should contain at least one address except when in LMTP mode. In this case the message itself might have succeeded but all recipients were rejected after sending the message.
  - **info.rejected** an array of rejected recipient addresses. This array includes both the addresses that were rejected before sending the message and addresses rejected after sending it if using LMTP
  - **info.rejectedErrors** if some recipients were rejected then this property holds an array of error objects for the rejected recipients
  - **info.response** is the last response received from the server

### quit

Use it for graceful disconnect

```javascript
connection.quit();
```

### close

Use it for less graceful disconnect

```javascript
connection.close();
```

### reset

Use it to reset current session (invokes RSET command)

```javascript
connection.reset(callback);
```

## License

**MIT**
