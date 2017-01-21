+++
date = "2017-01-20T23:19:31+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 30
title = "Create plugins"

+++

There are 3 stages a plugin can hook to:

1. **'compile'** is the step where email data is set but nothing has been done with it yet. At this step you can modify mail options, for example modify **html** content, add new headers etc.
2. **'stream'** is the step where message tree has been compiled and is ready to be streamed. At this step you can modify the generated MIME tree or add a transform stream that the generated raw email will be piped through before passed to the transport object
3. **Transport** step where the raw email is streamed to destination

## Including plugins

'compile' and 'stream' plugins can be attached with `use(plugin)` method

```javascript
transporter.use(step, pluginFunc)
```

Where

- **transporter** is a transport object created with **createTransport()**
- **step** is a string, either _'compile'_ or _'stream'_ that defines when the plugin should be hooked
- **pluginFunc** is a function that takes two arguments: the mail object and a callback function

## Plugin API

All plugins (including transports) get two arguments, the mail object and a callback function.

Mail object that is passed to the plugin function as the first argument is an object with the following properties:

- **data** is the mail data object that is passed to the **sendMail()** method
- **message** is the MimeNode object of the message. This is available for the 'stream' step and for the transport but not for 'compile'.
- **resolveContent** is a helper function for converting Nodemailer PRO compatible stream objects into Strings or Buffers

### resolveContent()

If your plugin needs to get the full value of a param, for example the String value for the **html** content, you can use **resolveContent()** to convert Nodemailer PRO compatible content objects to Strings or Buffers.

```javascript
mail.resolveContent(obj, key, callback)
```

Where

- **obj** is an object that has a property you want to convert to a String or a Buffer
- **key** is the name of the property you want to convert
- **callback** is the callback function with _(err, value)_ where **value** is either a String or Buffer, depending on the input

#### Example

```javascript
function plugin(mail, callback) {
    // if mail.data.html is a file or an url, it is returned as a Buffer
    mail.resolveContent(mail.data, 'html', (err, html) => {
        if(err){
            return callback(err);
        }
        console.log('HTML contents: %s', html.toString());
        callback();
    });
};
```

### 'compile'

Compile step plugins get only the **mail.data** object but not **mail.message**. If you need to access the latter as well, use _'stream'_ step instead.

This is really straightforward, your plugin can modify the **mail.data** object at will and once everything is finished run the callback function. If the callback gets an error object as an argument, then the process is terminated and the error is returned to the **sendMail()** callback.

#### Example

The following plugin checks if **text** value is set and if not converts **html** value by removing all html tags.

```javascript
transporter.use('compile', (mail, callback) => {
    if(!mail.data.text && mail.data.html){
        mail.data.text = mail.data.html.replace(/<[^>]*>/g, ' ');
    }
    callback();
});
```

### 'stream'

Streaming step is invoked once the message structure is built and ready to be streamed to the transport. Plugin function does get **mail.data** as an argument but it is included just for the reference, modifying it should not change anything (unless the transport requires something from the **mail.data**, for example **mail.data.envelope**).

You can modify the **mail.message** object as you like, the message is not yet streaming anything (message starts streaming when the transport calls **mail.message.createReadStream()**).

In most cases you might be interested in the **message.transform()** method for applying transform streams to the raw message.

#### Example

The following plugin replaces all tabs with spaces in the raw message.

```javascript
let transformer = new (require('stream').Transform)();
transformer._transform = (chunk, encoding, done) => {
    // replace all tabs with spaces in the stream chunk
    for(let i = 0; i < chunk.length; i++){
        if(chunk[i] === 0x09){
            chunk[i] = 0x20;
        }
    }
    this.push(chunk);
    done();
};

transporter.use('stream', (mail, callback) => {
    // apply output transformer to the raw message stream
    mail.message.transform(transformer);
    callback();
});
```

Additionally you might be interested in the **message.getAddresses()** method that returns the contents for all address fields as structured objects.

#### Example

The following plugin prints address information to console.

```javascript
transporter.use('stream', function(mail, callback) => {
    let addresses = mail.message.getAddresses();
    console.log('From: %s', JSON.stringify(addresses.from));
    console.log('To: %s', JSON.stringify(addresses.to));
    console.log('Cc: %s', JSON.stringify(addresses.cc));
    console.log('Bcc: %s', JSON.stringify(addresses.bcc));
    callback();
});
```

### message.transform()

If you want to modify the created stream, you can add transform streams that the output will be piped through.

```javascript
mail.message.transform(transformStream)
```

Where

- **transformStream** - _Stream_ or _Function_ Transform stream that the output will go through. If the value is a function the function should return a transform stream object when called.

### message.getAddresses()

Returns an address container object. Includes all parsed addresses from _From_, _Sender_, _To_, _Cc_, _Bcc_ and _Reply-To_ fields. All returned values are arrays, including `from`.

Possible return values (all arrays in the form of `[{name:'', address:''}]`):

- **from**
- **sender**
- **'reply-to'**
- **to**
- **cc**
- **bcc**

If no addresses were found for a particular field, the field is not set in the response object.

## Transports

Transports are objects that have a method **send()** and properies **name** and **version**. A transport object is passed to the `nodemailer.createTransport(transport)` method to create the transporter object.

### transport.name

This is the name of the transport object. For example 'SMTP' or 'SES' etc.

```javascript
transport.name = require('package.json').name;
```

### transport.version

This should be the transport module version. For example '0.1.0'.

```javascript
transport.version = require('package.json').version;
```

### transport.send(mail, callback)

This is the method that actually sends out emails. The method is basically the same as 'stream' plugin functions. It gets two arguments: **mail** and a callback. To start streaming the message, create the stream with **mail.message.createReadStream()**

Callback function should return an **info** object as the second argument. This info object should contain and **envelope** object with envelope data and a **messageId** value with the Message-Id header (including the surrounding < & > brackets),

The following example pipes the raw stream from Nodemailer PRO to the console.

```javascript
transport.send = (mail, callback) => {
    let input = mail.message.createReadStream();
    let envelope = mail.message.getEnvelope();
    let messageId = mail.message.messageId();
    input.pipe(process.stdout);
    input.on('end', function() {
        callback(null, {
            envelope,
            messageId
        });
    });
};
```

### transport.close()

If your transport needs to be closed explicitly, you can implement a **close()** method.

This is purely optional feature and only makes sense in special contexts (eg. closing a SMTP pool).

```javascript
transport.close = () => {
    transport.pool = null;
};
```

### transport.isIdle()

If your transport is able to notify about idling state by issuing _'idle'_ events then this method should return if the transport is still idling or not.

```javascript
transport.idling = true;
transport.isIdle = () => transport.idling;
transport.send = (mail, callback) => {
    transport.idling = false;
    sendMail(mail, ()=>{
        transport.idling = true;
        transport.emit('idle');
    });
};
```

### Transport Example

This example creates and uses a transport object that pipes the raw message to console

```javascript
let transport = {
    name: 'minimal',
    version: '0.1.0',
    send: (mail, callback) => {
        let input = mail.message.createReadStream();
        input.pipe(process.stdout);
        input.on('end', function () {
            callback(null, true);
        });
    }
};

let transporter = nodemailer.createTransport(transport);
transporter.sendMail({
    from: 'sender',
    to: 'receiver',
    subject: 'hello',
    text: 'hello world!'
});
```

## Wrapping up

Once you have a transport object, you can create a mail transporter out of it.

```javascript
let transport = require('some-transport-method');
let transporter = nodemailer.createTransport(transport);
transporter.sendMail({
    from: '...',
    to: '...',
    message
});
```
