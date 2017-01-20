+++
next = "/next/path"
prev = "/prev/path"
weight = 5
title = "Calendar Events"
date = "2017-01-20T12:01:43+02:00"
toc = true

+++

Calendar events are tricky because different email clients handle these differently. Nodemailer uses the same style as Gmail for attaching calendar files which should ensure maximum compatibility. If you want to attach a calendar event to your email then you can use the message option **icalEvent**:

- **icalEvent** – an object to define calendar event

  - **method** – optional method, case insensitive, defaults to *'publish'*. Other possible values would be *'request'*, *'reply'*, *'cancel'* or any other valid calendar method listed in [RFC5546](https://tools.ietf.org/html/rfc5546#section-1.4). This should match the **METHOD:** value in calendar event file.
  - **filename** – optional filename, defaults to *'invite.ics'*
  - **content** – is the event file, it can be a string, a buffer, a stream, a file path (*content:{path:'...'}*) or even an URL (*content:{href:'...'}*). You can use modules like [ical-generator](https://www.npmjs.com/package/ical-generator) to generate the actual calendar file content, Nodemailer acts as a transport layer only and does not generate the event file structure.

{{% notice note %}}
In general it is not a good idea to add additional attachments to calendar messages as it might mess up the behavior of some email clients. Try to keep it only to **text**, **html** and **icalEvent** without any additional **alternatives** or **attachments**
{{% /notice %}}

### Examples

#### 1\. Send a REQUEST event as a String

```javascript
let content = 'BEGIN:VCALENDAR\r\nPRODID:-//ACME/DesktopCalendar//EN\r\nMETHOD:REQUEST\r\n...';

let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Appointment',
    text: 'Please see the attached appointment',
    icalEvent: {
        filename: 'invitation.ics',
        method: 'request',
        content: content
    }
};
```

#### 2\. Send a PUBLISH event from a file

Event data is loaded from the provided file and attached to the message.

```javascript
let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Appointment',
    text: 'Please see the attached appointment',
    icalEvent: {
        method: 'PUBLISH',
        content: {
            path: '/path/to/file'
        }
    }
};
```

#### 3\. Send a CANCEL event from an URL

Event data is downloaded from the provided URL and attached to the message as regular calendar file.

```javascript
let message = {
    from: 'sender@example.com',
    to: 'recipient@example.com',
    subject: 'Appointment',
    text: 'Please see the attached appointment',
    icalEvent: {
        method: 'REQUEST',
        content: {
            href: 'http://www.example.com/events?event=123'
        }
    }
};
```
