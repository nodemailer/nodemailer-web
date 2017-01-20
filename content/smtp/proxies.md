+++
date = "2017-01-20T11:16:41+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 5
title = "Using Proxies"

+++

Nodemailer is able to use proxies for connecting to SMTP servers. HTTP proxy support is built in, Socks proxy support can be enabled by providing [socks](https://www.npmjs.com/package/socks) module to Nodemailer, other proxies need custom handling.

To enable proxying, define a `proxy` option for the transporter.

- **proxy** – is a proxy URL

## Examples

### 1\. Use HTTP proxy

Set HTTP proxy url for the _proxy_ option. That's it, everything required to handle it is built into Nodemailer.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    proxy: 'http://proxy-host:1234'
});
```

Or if you want to use environment defined variable:

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    proxy: process.env.http_proxy
});
```

Make sure that your HTTP proxy supports CONNECT protocol and allows connecting to the SMTP port you want to use.

### 2\. Use Socks proxy

Set Socks proxy url for the _proxy_ option. Additionally you need to provide the [socks](https://www.npmjs.com/package/socks) module for the transporter as it is not bundled with Nodemailer.

Possible protocol values for the SOCKS proxy:

  * `'socks4:'` or `'socks4a:'` for a SOCKS4 proxy
  * `'socks5:'` or `'socks:'` for a SOCKS5 proxy

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    proxy: 'socks5://socks-host:1234'
});
// enable support for socks URLs
transporter.set('proxy_socks_module', require('socks'));
```

For a testing you can use ssh to create a SOCKS5 proxy. The following command connects to your remote server and sets up a proxy that routes connections through that server.

```
ssh -N -D 0.0.0.0:1080 username@remote.host
```

`proxy` url for that server would be `'socks5://localhost:1080'`

### 3\. Use custom proxy handler

Additionally you can create your own proxy handler. To do this you would need to register a protocol handler callback with the name `proxy_handler_{protocol}` where `{protocol}` would be the protocol from proxy URL. If the URL looks like 'yyy://localhost' then you would need to set callback for `proxy_handler_yyy`.

```javascript
transporter.set('proxy_handler_myproxy', handler)
```

Where

  * **handler** is the function to run to create a proxied socket. It gets the following arguments:
    * **proxy** is the proxy url in a parsed form
    * **options** is transport configuration object
    * **callback** is the function to return the socket

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    proxy: 'myproxy://localhost:1234'
});
// enable support for socks URLs
transporter.set('proxy_handler_myproxy', (proxy, options, callback)=>{
    console.log('Proxy host=% port=%', proxy.hostname, proxy.port);
    let socket = require('net').connect(options.port, options.host, () => {
        callback(null, {
            connection: socket
        });
    });
});
```

If your proxy uses an encrypted connection then you can mark the proxied socket to be already secure. This prevents Nodemailer from upgrading the provided connection using TLS.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    proxy: 'myproxys://localhost:1234'
});
// enable support for socks URLs
transporter.set('proxy_handler_myproxys', (proxy, options, callback)=>{
    console.log('Proxy host=% port=%', proxy.hostname, proxy.port);
    let socket = require('tls').connect(options.port, options.host, () => {
        callback(null, {
            connection: socket,
            secured: true
        });
    });
});
```
