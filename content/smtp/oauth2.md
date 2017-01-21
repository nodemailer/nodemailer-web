+++
date = "2017-01-20T10:45:57+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 22
title = "OAuth2"
+++

OAuth2 allows your application to store and use authentication tokens instead of actual login credentials. This is great for security as tokens or valid only for specific actions and can be easily revoked thus, once stolen, can't to as much harm as actual account credentials. OAuth2 authentication in Nodemailer PRO is mostly used with Gmail and G Suite (_née_ Google Apps) even though there are other providers that support it as well.

Access Tokens needed for OAuth2 authentication are short lived so these need to be regenerated from time to time. Nodemailer PRO is able to use both [3LO](https://developers.google.com/identity/protocols/OAuth2) and [2LO](https://developers.google.com/api-client-library/php/auth/service-accounts) to automatically regenerate the tokens but you can also handle all token specific yourself.

1. [Normal OAuth2 authentication](#oauth-3lo)
2. [Authenticating using Service Accounts](#oauth-2lo)
3. [Using custom token handling](#custom-handling)
4. [Token update notifications](#update-notification)
5. [Examples](#examples)
6. [Troubleshooting](#troubleshooting)

{{% notice tip %}}
Nodemailer PRO requires an **Access Token** to perform authentication. 3-legged and 2-legged OAuth2 mechanisms are different ways to produce such tokens but in the end it does not matter how a token was exactly generated, as long as it is valid.
{{% /notice %}}

### 3-legged OAuth2 authentication {#oauth-3lo}

This is the "normal" way of obtaining access tokens. Your application requests permissions from the client and gets a refresh token in return that can be used to generate new access tokens.

- **auth** – is the authentication object

  - **type** – indicates authentication type, set it to _'OAuth2'_
  - **user** – user email address (required)
  - **clientId** – is the registered client id of the application
  - **clientSecret** – is the registered client secret of the application
  - **refreshToken** – is an optional refresh token. If it is provided then Nodemailer PRO tries to generate a new access token if existing one expires or fails
  - **accessToken** – is the access token for the user. Required only if _refreshToken_ is not available and there is no token refresh callback specified
  - **expires** – is an optional expiration time for the current _accessToken_
  - **accessUrl** – is an optional HTTP endpoint for requesting new access tokens. This value defaults to Gmail

Normal SMTP transport (ie. not the pooled version) has a convenience method of using separate authentication for every message. This allows you to set up a transport with just _clientId_ and _clientSecret_ values and provide _accessToken_ and _refreshToken_ with the message options. See [example 5](#example-5).

### 2LO authentication (service accounts) {#oauth-2lo}

Nodemailer PRO also allows you to use [service accounts](https://developers.google.com/identity/protocols/OAuth2ServiceAccount) to generate access tokens. In this case the required `auth` options are a bit different from 3LO auth.

- **auth** – is the authentication object

  - **type** – indicates authentication type, set it to _'OAuth2'_
  - **user** – user email address you want to send mail as (required)
  - **serviceClient** – service client id (required), you can find it from the "client_id" field in the service key file
  - **privateKey** – is the private key contents, you can find it from the "private_key" field in the service key file

### Using custom token handling {#custom-handling}

If you do not want Nodemailer PRO to create new access tokens then you can provide a custom token generation callback that is called every time a new token is needed for an user.

The registered function gets the following arguments:

- **user** – is the user email address
- **renew** – if _true_ then previous access token either expired or it was not accepted by the SMTP server, in this case you should generate a new value
- **callback** with arguments _(err, accessToken)_ – is the callback function to run once you have generated a new access token

```javascript
transporter.set('oauth2_provision_cb', (user, renew, callback)=>{
    let accessToken = userTokens[user];
    if(!accessToken){
        return callback(new Error('Unknown user'));
    }else{
        return callback(null, accessToken);
    }
});
```

### Token update notifications {#update-notification}

If you use _refreshToken_ or service keys to generate new tokens from Nodemailer PRO when _accessToken_ is not present or expired then you can listen for the token updates by registering a 'token' event handler for the transporter object.

```javascript
transporter.on('token', token => {
    console.log('A new access token was generated');
    console.log('User: %s', token.user);
    console.log('Access Token: %s', token.accessToken);
    console.log('Expires: %s', new Date(token.expires));
});
```

### Examples {#examples}

#### 1\. Authenticate using existing token {#example-1}

Use an existing Access Token. If the token is not accepted then message is not sent as there is no way to generate a new token.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2',
        user: 'user@example.com',
        accessToken: 'ya29.Xx_XX0xxxxx-xX0X0XxXXxXxXXXxX0x'
    }
});
```

#### 2\. Custom handler {#example-2}

This example requests a new _accessToken_ value from a custom OAuth2 handler. Nodemailer PRO does not attempt to generate the token by itself.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2',
        user: 'user@example.com'
    }
});

transporter.set('oauth2_provision_cb', (user, renew, callback)=>{
    let accessToken = userTokens[user];
    if(!accessToken){
        return callback(new Error('Unknown user'));
    }else{
        return callback(null, accessToken);
    }
});
```

#### 3\. Set up 3LO authentication {#example-3}

This example uses an existing Access Token. If the token is not accepted or current time is past the _expires_ value, then _refreshToken_ is used to automatically generate a new _accessToken_

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2',
        user: 'user@example.com',
        clientId: '000000000000-xxx0.apps.googleusercontent.com',
        clientSecret: 'XxxxxXXxX0xxxxxxxx0XXxX0',
        refreshToken: '1/XXxXxsss-xxxXXXXXxXxx0XXXxxXXx0x00xxx',
        accessToken: 'ya29.Xx_XX0xxxxx-xX0X0XxXXxXxXXXxX0x',
        expires: 1484314697598
    }
});
```

#### 4\. Set up 2LO authentication {#example-4}

This example uses an existing Access Token. If the token is not accepted or current time is past the _expires_ value, then a new _accessToken_ value is generated using provided service account.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2',
        user: 'user@example.com',
        serviceClient: '113600000000000000000',
        privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBg...',
        accessToken: 'ya29.Xx_XX0xxxxx-xX0X0XxXXxXxXXXxX0x',
        expires: 1484314697598
    }
});
```

#### 5\. Provide authentication details with message options {#example-5}

This example demonstrates how to authenticate every message separately. This is mostly useful if you provide an email application that sends mail for multiple users. Instead of creating a new transporter for every message, create it just once and provide dynamic details with the message options.

{{% notice info %}}
Per-message specific authentication does not work in pooled mode
{{% /notice %}}

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2',
        clientId: '000000000000-xxx.apps.googleusercontent.com',
        clientSecret: 'XxxxxXXxX0xxxxxxxx0XXxX0'
    }
});

transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets through!',
    auth: {
        user: 'user@example.com',
        refreshToken: '1/XXxXxsss-xxxXXXXXxXxx0XXXxxXXx0x00xxx',
        accessToken: 'ya29.Xx_XX0xxxxx-xX0X0XxXXxXxXXXxX0x',
        expires: 1484314697598
    }
});
```

Or alternatively you can do the same with your own OAuth2 handler.

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2'
    }
});

transporter.set('oauth2_provision_cb', (user, renew, callback) => {
    let accessToken = userTokens[user];
    if(!accessToken){
        return callback(new Error('Unknown user'));
    }else{
        return callback(null, accessToken);
    }
});

transporter.sendMail({
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Message',
    text: 'I hope this message gets through!',
    auth: {
        user: 'user@example.com'
    }
});
```

### Troubleshooting {#troubleshooting}

- The correct OAuth2 scope for Gmail SMTP is `https://mail.google.com/`, make sure your client has this scope set when requesting permissions for an user
- Make sure that Gmail API access is enabled for your Client ID. To do this, search for the Gmail API in [Google API Manager](https://console.developers.google.com) and click on "enable"
