+++
title = "Alternatives"
date = "2017-01-21T00:12:25+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 12

+++

In addition to text and HTML, any kind of data can be inserted as an alternative content of the main body - for example a word processing document with the same text as in the HTML field. It is the job of the email client to select and show the best fitting alternative to the reader. Usually this field is used for calendar events and such.

{{% notice tip %}}
If you want to use a calendar event as the alternative, the consider using the **icalEvent** option instead. See details [here](/message/calendar-events/).
{{% /notice %}}

Alternative objects use the same options as [attachment objects](/attachments/). The difference between an attachment and an alternative is the fact that attachments are placed into _multipart/mixed_ or _multipart/related_ parts of the message white alternatives are placed into _multipart/alternative_ part.

**Usage example:**

```javascript
let message = {
    ...
    html: '<b>Hello world!</b>',
    alternatives: [
        {
            contentType: 'text/x-web-markdown',
            content: '**Hello world!**'
        }
    ]
}
```

Alternatives can be added as many as you want.
