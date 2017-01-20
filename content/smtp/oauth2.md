+++
date = "2017-01-20T10:45:57+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 5
title = "OAuth2"

+++

Nodemailer is able to authenticate to Gmail using OAuth2 (both [3LO](https://developers.google.com/identity/protocols/OAuth2) and [2LO](https://developers.google.com/api-client-library/php/auth/service-accounts)) for SMTP transports. This allows your application to only store access tokens for an user, not the actual login credentials.

OAuth2 processing is built into Nodemailer, you do not need any external modules to handle it. In the simplest form all you need to do is to provide `auth` property with OAuth tokens.

## 3LO authentication (normal users)

- **auth** – is the authentication object

  - **type** – indicates authentication type, set it to _'OAuth2'_
  - **user** – user email address (required)
  - **clientId** – is the registered client id of the application
  - **clientSecret** – is the registered client secret of the application
  - **refreshToken** – is an optional refresh token. If it is provided then Nodemailer tries to generate a new access token if existing one expires or fails
  - **accessToken** – is the access token for the user. Required only if _refreshToken_ is not available and there is no token refresh callback specified
  - **expires** – is an optional expiration time for the current _accessToken_

Normal SMTP transport (ie. not the pooled version) has a convenience method of using separate authentication for every message. This allows you to set up a transport with just clientId and clientSecret values and provide _accessToken_ and _refreshToken_ with the message options. See example 5.

## 2LO authentication (service accounts)

You can also use [service accounts](https://developers.google.com/identity/protocols/OAuth2ServiceAccount) to generate access tokens, in this case the required `auth` options are a bit different

- **auth** – is the authentication object

  - **type** – indicates authentication type, set it to _'OAuth2'_
  - **user** – user email address you want to send mail as (required)
  - **serviceClient** – service client id (required), you can find it from the "client_id" field in the service key file
  - **privateKey** – is the private key contents, you can find it from the "private_key" field in the service key file

## Using custom token handling

If you do not want Nodemailer to create new access tokens then you can provide a custom token generation callback that is called every time a new token is needed for a user.

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

## Updated access token notifications

If you use _refreshToken_ or service keys to generate new tokens from Nodemailer when _accessToken_ is not present or expired then you can listen for the token updates by registering a 'token' event handler for the transporter object.

```javascript
transporter.on('token', token => {
    console.log('A new access token was generated');
    console.log('User: %s', token.user);
    console.log('Access Token: %s', token.accessToken);
    console.log('Expires: %s', new Date(token.expires));
});
```

## Examples

### 1\. Set up 3LO authentication

If _accessToken_ is not accepted then message is not sent

```javascript
let transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        type: 'OAuth2',
        user: 'user@example.com',
        clientId: '000000000000-xxx.apps.googleusercontent.com',
        clientSecret: 'XxxxxXXxX0xxxxxxxx0XXxX0',
        accessToken: 'ya29.Xx_XX0xxxxx-xX0X0XxXXxXxXXXxX0x'
    }
});
```

### 2\. Set up 3LO authentication

Request _accessToken_ value from a callback handler

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

### 3\. Set up 3LO authentication

If _accessToken_ is not accepted or current time is past the _expires_ value, then _refreshToken_ is used to automatically generate a new _accessToken_

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

### 4\. Set up 2LO authentication

If _accessToken_ is not accepted or current time is past the _expires_ value, then generate a new _accessToken_ value using a service account

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

### 5\. Provide authentication details with message options

Authenticate every message separately. This is mostly useful if you provide an email application that sends mail for multiple users. Instead of creating a new transporter for every message, create it just once and provide dynamic details with the message options.

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

Or alternatively if you want to generate the tokens yourself, then move auth.user from transporter options to message options.

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

## Troubleshooting

- The correct OAuth2 scope for Gmail SMTP is `"https://mail.google.com/"`, make sure your client has this scope set when requesting permissions for an user
- Make sure that Gmail API access is enabled for your Client ID. To do this, search for the Gmail API in [Google API Manager](https://console.developers.google.com) and click on "enable"
