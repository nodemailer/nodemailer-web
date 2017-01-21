+++
date = "2017-01-21T00:09:24+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 5
title = "Embedded images"

+++

Attachments can be used as embedded images in the HTML body. To use this feature, you need to set additional property of the attachment - **cid** (unique identifier of the file) which is a reference to the attachment file. The same **cid** value must be used as the image URL in HTML (using **cid:** as the URL protocol, see example below).

{{% notice note %}}
**NB!** the cid value should be as unique as possible!
{{% /notice %}}

#### Example

```javascript
let message = {
    ...
    html: 'Embedded image: <img src="cid:unique@kreata.ee"/>',
    attachments: [{
        filename: 'image.png',
        path: '/path/to/file',
        cid: 'unique@kreata.ee' //same cid value as in the html img src
    }]
}
```
