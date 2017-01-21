+++
weight = 11
title = "Attachments"
date = "2017-01-21T00:09:16+02:00"
toc = true
prev = "/message/"
next = "/message/alternatives/"

+++

**attachments** option in the message object that contains an array of attachment objects.

Attachment object consists of the following properties:

- **filename** - filename to be reported as the name of the attached file. Use of unicode is allowed.
- **content** - String, Buffer or a Stream contents for the attachment
- **path** - path to the file if you want to stream the file instead of including it (better for larger attachments)
- **href** – an URL to the file (data uris are allowed as well)
- **contentType** - optional content type for the attachment, if not set will be derived from the *filename* property
- **contentDisposition** - optional content disposition type for the attachment, defaults to 'attachment'
- **cid** - optional content id for using inline images in HTML message source
- **encoding** - If set and *content* is string, then encodes the content to a Buffer using the specified encoding. Example values: *'base64'*, *'hex'*, *'binary'* etc. Useful if you want to use binary attachments in a JSON formatted email object.
- **headers** - custom headers for the attachment node. Same usage as with message headers
- **raw** - is an optional special value that overrides entire contents of current mime node including mime headers. Useful if you want to prepare node contents yourself

Attachments can be added as many as you want.

**Example**

```javascript
let message = {
    ...
    attachments: [
        {   // utf-8 string as an attachment
            filename: 'text1.txt',
            content: 'hello world!'
        },
        {   // binary buffer as an attachment
            filename: 'text2.txt',
            content: new Buffer('hello world!','utf-8')
        },
        {   // file on disk as an attachment
            filename: 'text3.txt',
            path: '/path/to/file.txt' // stream this file
        },
        {   // filename and content type is derived from path
            path: '/path/to/file.txt'
        },
        {   // stream as an attachment
            filename: 'text4.txt',
            content: fs.createReadStream('file.txt')
        },
        {   // define custom content type for the attachment
            filename: 'text.bin',
            content: 'hello world!',
            contentType: 'text/plain'
        },
        {   // use URL as an attachment
            filename: 'license.txt',
            path: 'https://raw.github.com/nodemailer/nodemailer/master/LICENSE'
        },
        {   // encoded string as an attachment
            filename: 'text1.txt',
            content: 'aGVsbG8gd29ybGQh',
            encoding: 'base64'
        },
        {   // data uri as an attachment
            path: 'data:text/plain;base64,aGVsbG8gd29ybGQ='
        },
        {
            // use pregenerated MIME node
            raw: 'Content-Type: text/plain\r\n' +
                 'Content-Disposition: attachment;\r\n' +
                 '\r\n' +
                 'Hello world!'
        }
    ]
}
```
