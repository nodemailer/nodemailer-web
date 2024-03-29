+++
title = "SMTP Server"
date = "2017-01-21T00:12:25+02:00"
toc = true
prev = "/extras/"
next = "/extras/smtp-connection/"
weight = 1

+++

Create SMTP and LMTP server instances on the fly. This is not a full-blown server application like [Haraka](https://haraka.github.io/) but an easy way to add custom SMTP listeners to your app. This module is the successor for the server part of the (now deprecated) SMTP module [simplesmtp](https://www.npmjs.com/package/simplesmtp). For matching SMTP client see [smtp-connection](/extras/smtp-connection/).

{{% notice note %}}
This module does not make any email deliveries by itself. _smtp-server_ allows you to listen on ports 25/24/465/587 etc. using SMTP or LMTP protocol and that's it. Your own application is responsible of accepting and delivering the message to destination.
{{% /notice %}}

## Usage

#### Step 1. Install with npm

```bash
npm install smtp-server --save
```

#### Step 2. Require in your script

```javascript
const SMTPServer = require("smtp-server").SMTPServer;
```

#### Step 3. Create SMTPServer instance

```javascript
const server = new SMTPServer(options);
```

Where

- **options** defines the behavior of the server
  - **options.secure** if _true_, the connection will use TLS. The default is _false_. If the server doesn't start in TLS mode, it is still possible to upgrade clear text socket to TLS socket with the STARTTLS command (unless you disable support for it). If secure is _true_, [additional tls options for tls.createServer](http://nodejs.org/api/tls.html#tls_tls_createserver_options_secureconnectionlistener) can be added directly onto this options object.
  - **options.name** optional hostname of the server, used for identifying to the client (defaults to _os.hostname()_)
  - **options.banner** optional greeting message. This message is appended to the default ESMTP response.
  - **options.size** optional maximum allowed message size in bytes, see details [here](#using-size-extension)
  - **options.hideSize** if set to true then does not expose the max allowed size to the client but keeps size related values like _stream.sizeExceeded_
  - **options.authMethods** optional array of allowed authentication methods, defaults to _['PLAIN', 'LOGIN']_. Only the methods listed in this array are allowed, so if you set it to _['XOAUTH2']_ then PLAIN and LOGIN are not available. Use _['PLAIN', 'LOGIN', 'XOAUTH2']_ to allow all three. Authentication is only allowed in secure mode (either the server is started with _secure:true_ option or STARTTLS command is used)
  - **options.authOptional** allow authentication, but do not require it
  - **options.disabledCommands** optional array of disabled commands (see all supported commands [here](#commands)). For example if you want to disable authentication, use _['AUTH']_ as this value. If you want to allow authentication in clear text, set it to _['STARTTLS']_.
  - **options.hideSTARTTLS** optional boolean, if set to true then allow using STARTTLS but do not advertise or require it. It only makes sense when creating integration test servers for testing the scenario where you want to try STARTTLS even when it is not advertised
  - **options.hidePIPELINING** optional boolean, if set to true then does not show PIPELINING in feature list
  - **options.hide8BITMIME** optional boolean, if set to true then does not show 8BITMIME in features list
  - **options.hideSMTPUTF8** optional boolean, if set to true then does not show SMTPUTF8 in features list
  - **options.allowInsecureAuth** optional boolean, if set to true allows authentication even if connection is not secured first
  - **options.disableReverseLookup** optional boolean, if set to true then does not try to reverse resolve client hostname
  - **options.sniOptions** optional [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) or an object of TLS options for SNI where servername is the key. Overrided by SNICallback.
  - **options.logger** optional [bunyan](https://github.com/trentm/node-bunyan) compatible logger instance. If set to _true_ then logs to console. If value is not set or is _false_ then nothing is logged
  - **options.maxClients** sets the maximum number of concurrently connected clients, defaults to _Infinity_
  - **options.useProxy** boolean, if set to true expects to be behind a proxy that emits a [PROXY header](http://www.haproxy.org/download/1.5/doc/proxy-protocol.txt) (version 1 only)
  - **options.useXClient** boolean, if set to true, enables usage of [XCLIENT](http://www.postfix.org/XCLIENT_README.html) extension to override connection properties. See _session.xClient_ (Map object) for the details provided by the client
  - **options.useXForward** boolean, if set to true, enables usage of [XFORWARD](http://www.postfix.org/XFORWARD_README.html) extension. See _session.xForward_ (Map object) for the details provided by the client
  - **options.lmtp** boolean, if set to true use LMTP protocol instead of SMTP
  - **options.socketTimeout** how many milliseconds of inactivity to allow before disconnecting the client (defaults to 1 minute)
  - **options.closeTimeout** how many millisceonds to wait before disconnecting pending connections once server.close() has been called (defaults to 30 seconds)
  - **options.onAuth** is the callback to handle authentications (see details [here](#handling-authentication))
  - **options.onConnect** is the callback to handle the client connection. (see details [here](#validating-client-connection))
  - **options.onSecure** is the optional callback to validate TLS information. (see details [here](#validating-tls-information))
  - **options.onMailFrom** is the callback to validate MAIL FROM commands (see details [here](#validating-sender-addresses))
  - **options.onRcptTo** is the callback to validate RCPT TO commands (see details [here](#validating-recipient-addresses))
  - **options.onData** is the callback to handle incoming messages (see details [here](#processing-incoming-message))
  - **options.onClose** is the callback that informs about closed client connection

Additionally you can use the options from [net.createServer](http://nodejs.org/api/net.html#net_net_createserver_options_connectionlistener) and [tls.createServer](http://nodejs.org/api/tls.html#tls_tls_createserver_options_secureconnectionlistener) (applies if _secure_ is set to true)

#### Server Methods

The _server_ object returned from _new SMTPServer_ has the following methods:

- **listen(port)** - Begins listening on the given port
- **close(callback)** - Stops the server from accepting new connections. _callback_ is invoked once all client connections are closed

### TLS and STARTLS notice

If you use _secure:true_ option or you do not disable STARTTLS command then you SHOULD also define the _key_, _cert_ and possibly _ca_ properties to use a proper certificate. If you do no specify your own certificate then a pregenerated self-signed certificate for 'localhost' is used. Any respectful client refuses to accept such certificate.

**Example**

```javascript
// This example starts a SMTP server using TLS with your own certificate and key
const server = new SMTPServer({
  secure: true,
  key: fs.readFileSync("private.key"),
  cert: fs.readFileSync("server.crt"),
});
server.listen(465);
```

### Start the server instance

```javascript
server.listen(port[,host][,callback]);
```

Where

- **port** is the port number to bound to
- **host** is the optional host to bound to
- **callback** is called once the server is bound

## Handling errors

Errors can be handled by setting an 'error' event listener to the server instance

```javascript
server.on("error", (err) => {
  console.log("Error %s", err.message);
});
```

## Handling Authentication

Authentication calls can be handled with _onAuth_ handler

```javascript
const server = new SMTPServer({
  onAuth(auth, session, callback) {},
});
```

Where

- **auth** is an authentication object
  - **method** indicates the authentication method used, 'PLAIN', 'LOGIN' or 'XOAUTH2'
  - **username** is the username of the user
  - **password** is the password if LOGIN or PLAIN was used
  - **accessToken** is the OAuth2 bearer access token if 'XOAUTH2' was used as the authentication method
  - **validatePassword** is a function for validating CRAM-MD5 challenge responses. Takes the password of the user as an argument and returns _true_ if the response matches the password
- **session** includes information about the session like _remoteAddress_ for the remote IP, see details [here](#session-object)
- **callback** is the function to run once the user is authenticated. Takes 2 arguments: _(error, response)_
  - **error** is an error to return if authentication failed. If you want to set custom error code, set _responseCode_ to the error object
  - **response** is an object with the authentication results
    - **user** can be any value - if this is set then the user is considered logged in and this value is used later with the session data to identify the user. If this value is empty, then the authentication is considered failed
    - **data** is an object to return if XOAUTH2 authentication failed (do not set the error object in this case). This value is serialized to JSON and base64 encoded automatically, so you can just return the object

This module supports _CRAM-MD5_ but the use of it is discouraged as it requires access to unencrypted user passwords during the authentication process. You shouldn't store passwords unencrypted.

### Examples

#### Password based authentication

```javascript
const server = new SMTPServer({
  onAuth(auth, session, callback) {
    if (auth.username !== "abc" || auth.password !== "def") {
      return callback(new Error("Invalid username or password"));
    }
    callback(null, { user: 123 }); // where 123 is the user id or similar property
  },
});
```

#### OAuth2 authentication

XOAUTH2 support needs to enabled with the _authMethods_ array option as it is disabled by default.
If you support multiple authentication mechanisms, then you can check the used mechanism from the _method_ property.

```javascript
const server = new SMTPServer({
  authMethods: ["XOAUTH2"], // XOAUTH2 is not enabled by default
  onAuth(auth, session, callback) {
    if (auth.method !== "XOAUTH2") {
      // should never occur in this case as only XOAUTH2 is allowed
      return callback(new Error("Expecting XOAUTH2"));
    }
    if (auth.username !== "abc" || auth.accessToken !== "def") {
      return callback(null, {
        data: {
          status: "401",
          schemes: "bearer mac",
          scope: "my_smtp_access_scope_name",
        },
      });
    }
    callback(null, { user: 123 }); // where 123 is the user id or similar property
  },
});
```

#### CRAM-MD5 authentication

CRAM-MD5 support needs to enabled with the _authMethods_ array option as it is disabled by default.
If you support multiple authentication mechanisms, then you can check the used mechanism from the _method_ property.

This authentication method does not return a password with the username but a response to a challenge. To validate the returned challenge response, the authentication object includes a method _validatePassword_ that takes the actual plaintext password as an argument and returns either _true_ if the password matches with the challenge response or _false_ if it does not.

```javascript
const server = new SMTPServer({
  authMethods: ["CRAM-MD5"], // CRAM-MD5 is not enabled by default
  onAuth(auth, session, callback) {
    if (auth.method !== "CRAM-MD5") {
      // should never occur in this case as only CRAM-MD5 is allowed
      return callback(new Error("Expecting CRAM-MD5"));
    }

    // CRAM-MD5 does not provide a password but a challenge response
    // that can be validated against the actual password of the user
    if (auth.username !== "abc" || !auth.validatePassword("def")) {
      return callback(new Error("Invalid username or password"));
    }

    callback(null, { user: 123 }); // where 123 is the user id or similar property
  },
});
```

## Validating client connection

By default any client connection is allowed. If you want to check the remoteAddress or clientHostname before
any other command, you can set a handler for it with _onConnect_

```javascript
const server = new SMTPServer({
  onConnect(session, callback) {},
});
```

Where

- **session** includes the _remoteAddress_ and _clientHostname_ values
- **callback** is the function to run after validation. If you return an error object, the connection is rejected, otherwise it is accepted

```javascript
const server = new SMTPServer({
  onConnect(session, callback) {
    if (session.remoteAddress === "127.0.0.1") {
      return callback(new Error("No connections from localhost allowed"));
    }
    return callback(); // Accept the connection
  },
});
```

If you also need to detect when a connection is closed use _onClose_. This method does not expect you to run a callback function as it is purely informational.

```javascript
const server = new SMTPServer({
  onClose(session) {},
});
```

## Validating TLS information

_onSecure_ allows to validate TLS information for TLS and STARTTLS connections.

```javascript
const server = new SMTPServer({
  onSecure(socket, session, callback) {},
});
```

Where

- **socket** is the TLS socket object
- **session** includes the _servername_ value for SNI
- **callback** is the function to run after validation. If you return an error object, the connection is rejected, otherwise it is accepted

```javascript
const server = new SMTPServer({
  onSecure(socket, session, callback) {
    if (session.servername !== "sni.example.com") {
      return callback(new Error("Only connections for sni.example.com are allowed"));
    }
    return callback(); // Accept the connection
  },
});
```

## Validating sender addresses

By default all sender addresses (as long as these are in valid email format) are allowed. If you want to check
the address before it is accepted you can set a handler for it with _onMailFrom_

```javascript
const server = new SMTPServer({
  onMailFrom(address, session, callback) {},
});
```

Where

- **address** is an [address object](#address-object) with the provided email address from _MAIL FROM:_ command
- **session** includes the _envelope_ object and _user_ data if logged in, see details [here](#session-object)
- **callback** is the function to run after validation. If you return an error object, the address is rejected, otherwise it is accepted

```javascript
const server = new SMTPServer({
  onMailFrom(address, session, callback) {
    if (address.address !== "allowed@example.com") {
      return callback(new Error("Only allowed@example.com is allowed to send mail"));
    }
    return callback(); // Accept the address
  },
});
```

## Validating recipient addresses

By default all recipient addresses (as long as these are in valid email format) are allowed. If you want to check
the address before it is accepted you can set a handler for it with _onRcptTo_

```javascript
const server = new SMTPServer({
  onRcptTo(address, session, callback) {},
});
```

Where

- **address** is an [address object](#address-object) with the provided email address from _RCPT TO:_ command
- **session** includes the _envelope_ object and _user_ data if logged in, see details [here](#session-object)
- **callback** is the function to run after validation. If you return an error object, the address is rejected, otherwise it is accepted

```javascript
const server = new SMTPServer({
  onRcptTo(address, session, callback) {
    if (address.address !== "allowed@example.com") {
      return callback(new Error("Only allowed@example.com is allowed to receive mail"));
    }
    return callback(); // Accept the address
  },
});
```

## Processing incoming message

You can get the stream for the incoming message with _onData_ handler

```javascript
const server = new SMTPServer({
  onData(stream, session, callback) {},
});
```

Where

- **stream** is a readable stream for the incoming message
- **session** includes the _envelope_ object and _user_ data if logged in, see details [here](#session-object)
- **callback** is the on to run once the stream is ended and you have processed the outcome. If you return an error object, the message is rejected, otherwise it is accepted

```javascript
const server = new SMTPServer({
  onData(stream, session, callback) {
    stream.pipe(process.stdout); // print message to console
    stream.on("end", callback);
  },
});
```

This module does not prepend _Received_ or any other header field to the streamed message. The entire message is streamed as-is with no modifications whatsoever. For compliancy you should add the Received data to the message yourself, see [rfc5321 4.4. Trace Information](https://tools.ietf.org/html/rfc5321#section-4.4) for details.

## Using SIZE extension

When creating the server you can define maximum allowed message size with the _size_ option, see [RFC1870](https://tools.ietf.org/html/rfc1870) for details. This is not a strict limitation, the client is informed about the size limit but the client can still send a larger message than allowed, it is up to your application to reject or accept the oversized message. To check if the message was oversized, see _stream.sizeExceeded_ property.

```javascript
const server = new SMTPServer({
  size: 1024, // allow messages up to 1 kb
  onRcptTo(address, session, callback) {
    // do not accept messages larger than 100 bytes to specific recipients
    let expectedSize = Number(session.envelope.mailFrom.args.SIZE) || 0;
    if (address.address === "almost-full@example.com" && expectedSize > 100) {
      err = new Error("Insufficient channel storage: " + address.address);
      err.responseCode = 452;
      return callback(err);
    }
    callback();
  },
  onData(stream, session, callback) {
    stream.pipe(process.stdout); // print message to console
    stream.on("end", () => {
      let err;
      if (stream.sizeExceeded) {
        err = new Error("Message exceeds fixed maximum message size");
        err.responseCode = 552;
        return callback(err);
      }
      callback(null, "Message queued as abcdef");
    });
  },
});
```

## Using LMTP

If _lmtp_ option is set to true when starting the server, then LMTP protocol is used instead of SMTP. The main
difference between these two is how multiple recipients are handled. In case of SMTP the message either fails or succeeds
but in LMTP the message might fail and succeed individually for every recipient.

If your LMTP server application does not distinguish between different recipients then you do not need to care about it.
On the other hand if you want to report results separately for every recipient you can do this by providing an array
of responses instead of a single error or success message. The array must contain responses in the same order as in the
envelope rcptTo array.

```javascript
const server = new SMTPServer({
  lmtp: true,
  onData(stream, session, callback) {
    stream.pipe(process.stdout); // print message to console
    stream.on("end", () => {
      // reject every other recipient
      let response = session.envelope.rcptTo.map((rcpt, i) => {
        if (i % 2) {
          return new Error("<" + rcpt.address + "> Not accepted");
        } else {
          return "<" + rcpt.address + "> Accepted";
        }
      });
      callback(null, response);
    });
  },
});
```

If you provide a single error by invoking _callback(err)_ or single success message _callback(null, 'OK')_ like when dealing with SMTP then every recipient gets the same response.

## Session object

Session object that is passed to the handler functions includes the following properties

- **id** random string identificator generated when the client connected
- **remoteAddress** the IP address for the connected client
- **clientHostname** reverse resolved hostname for _remoteAddress_
- **openingCommand** the opening SMTP command (HELO/EHLO/LHLO)
- **hostNameAppearsAs** hostname the client provided with HELO/EHLO call
- **envelope** includes envelope data
  - **mailFrom** includes an address object or is set to false
  - **rcptTo** includes an array of address objects
- **user** includes the _user_ value returned with the authentication handler
- **transaction** number of the current transaction. 1 is for the first message, 2 is for the 2nd message etc.
- **transmissionType** indicates the current protocol type for the received header (SMTP, ESMTP, ESMTPA etc.)

## Address object

Address object in the _mailFrom_ and _rcptTo_ values include the following properties

- **address** is the address provided with the MAIL FROM or RCPT TO command
- **args** is an object with additional arguments (all key names are uppercase)

For example if the client runs the following commands:

    C: MAIL FROM:<sender@example.com> SIZE=12345 RET=HDRS
    C: RCPT TO:<recipient@example.com> NOTIFY=NEVER

then the envelope object is going go look like this:

```json
{
  "mailFrom": {
    "address": "sender@example.com",
    "args": {
      "SIZE": "12345",
      "RET": "HDRS"
    }
  },
  "rcptTo": [
    {
      "address": "receiver@example.com",
      "args": {
        "NOTIFY": "NEVER"
      }
    }
  ]
}
```

## Supported SMTP commands

### Commands

- **AUTH LOGIN**
- **AUTH PLAIN**
- **AUTH XOAUTH2** not enabled by default, add to _authMethods:['XOAUTH2']_ to enable
- **EHLO**
- **DATA**
- **HELO**
- **HELP** returns URL to RFC5321
- **MAIL**
- **NOOP**
- **QUIT**
- **RCPT**
- **RSET** clears session info but does not renegotiate TLS session
- **STARTTLS**
- **VRFY** always returns positive 252 response

### Extensions

- **PIPELINING**
- **8BITMIME** allows 8bit message content
- **SMTPUTF8** accepts unicode e-mail addresses like _δοκιμή@παράδειγμα.δοκιμή_
- **SIZE** limits maximum message size

Most notably, the **ENHANCEDSTATUSCODES** extension is not supported, all response codes use the standard three digit format and nothing else. I might change this in the future if I have time to revisit all responses and find the appropriate response codes.

**CHUNKING** is also missing. I might add support for it in the future but not at this moment since DATA already accepts a stream and CHUNKING is not supported everywhere.

## License

**MIT**
