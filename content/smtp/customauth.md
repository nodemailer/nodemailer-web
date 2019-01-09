+++
date = "2017-01-20T11:16:41+02:00"
toc = true
prev = "/smtp/oauth2/"
next = "/smtp/proxies/"
weight = 24
title = "Custom authentication"
+++

Nodemailer SMTP client can be extended to use custom authentication mechanisms that Nodemailer does not support by default.

To use one you should define a custom authentication handler with `customAuth` in the transporter options. Multiple handlers can be defined. Use authentication identifier as the handler name. For example if the server responds with "AUTH LOGIN PLAIN MY-CUSTOM-METHOD" then it supports "LOGIN", "PLAIN" and "MY-CUSTOM-METHOD". Nodemailer has built in support form "LOGIN" and "PLAIN" but it knows nothing about "MY-CUSTOM-METHOD", to add support use this identifier as the handler name.

If SMTP server supports multiple authentication mechanisms then Nodemailer defaults to some well known mechanism like LOGIN or PLAIN. If you want to make sure that Nodemailer specifically uses your custom mechanism, then set `method` property in the `auth` section, use method identifier as the value.

The following snippet defines MY-CUSTOM-METHOD handler and forces Nodemailer to use it:

```javascript
let transporter = nodemailer.createTransport({
    host: 'smtp.example.com',
    port: 465,
    secure: true,
    auth: {
        type: 'custom',
        method: 'MY-CUSTOM-METHOD', // forces Nodemailer to use your custom handler
        user: 'username',
        pass: 'verysecret'
    },
    customAuth: {
        'MY-CUSTOM-METHOD': ctx => {
            ...
        }
    }
});
```

### Handler context

Handler method gets handler context as the only argument. Handler method can return a Promise (using an `async` function as the handler is also supported). If promises are not used then the method must explicitly run `ctx.reject(err)` to indicate an error or `ctx.resolve()` to indicate successful auth. In case of Promises if the handler does not throw then the user is considered authenticated once Promise resolves.

#### ctx.auth

Authentication options can be found from the `auth` property and credentials from `auth.credentials` (eg. `ctx.auth.credentials.pass` for the password)

#### ctx.sendCommand(cmd, (err, cmd)=>{...})

The most useful method of the context object is `sendCommand` that takes a full SMTP command as an argument. Second argument can be a callback function. If callback is not defined, then a Promise is returned instead.

Resulting `cmd` response object includes the following properties:

* **status** is the numeric status code of the response (eg 250 or 334 etc.)
* **code** is the enchanced status code (eg "5.7.0")
* **text** is the readable part of server response ("Authentication successful")
* **response** is the full response from the server ("235 Authentication successful")

```
async function myCustomMethod(ctx){
    let cmd = await ctx.sendCommand(
        'AUTH PLAIN ' +
            Buffer.from(
                '\u0000' + ctx.auth.credentials.user + '\u0000' + ctx.auth.credentials.pass,
                'utf-8'
            ).toString('base64')
    );

    if(cmd.status < 200 || cmd.status >=300){
        throw new Error('Failed to authenticate user: ' + cmd.text);
    }
}

let transporter = nodemailer.createTransport({
    host: 'smtp.example.com',
    port: 465,
    secure: true,
    auth: {
        type: 'custom',
        method: 'MY-CUSTOM-METHOD', // forces Nodemailer to use your custom handler
        user: 'username',
        pass: 'verysecret'
    },
    customAuth: {
        'MY-CUSTOM-METHOD': myCustomMethod
    }
});
```

### Custom options

If your authentication mechanism requires additional configuration besides the usual username and password, then you can use the `pass` field to provide the details.

```
let transporter = nodemailer.createTransport({
    host: 'smtp.example.com',
    port: 465,
    secure: true,
    auth: {
        type: 'custom',
        method: 'MY-CUSTOM-METHOD', // forces Nodemailer to use your custom handler
        user: 'username',
        pass: {
            clientId: 'verysecret',
            applicationId: 'my-app'
        }
    },
    customAuth: {
        'MY-CUSTOM-METHOD': async ctx => {
            let token = await generateSecretTokenSomehow(
                ctx.auth.credentials.pass.clientId,
                ctx.auth.credentials.pass.applicationId
            );
            ...
        }
    }
});
```
