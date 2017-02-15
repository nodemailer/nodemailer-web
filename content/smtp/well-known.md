+++
prev = "/smtp/oauth2/"
next = "/smtp/proxies/"
weight = 23
title = "Well-known services"
date = "2017-01-20T21:15:16+02:00"
toc = true

+++

Nodemailer knows SMTP connection details for several well-known providers. If your provider is listed here you do not need to set the connection details yourself (you can if you want it though) for the transporter object, providing service name is already good enough.

The following example sets up a transporter against [SendPulse](https://sendpulse.com/) SMTP server using only service name instead of actual server configuration:

```javascript
let transporter = nodemailer.createTransport({
     service: 'SendPulse', // no need to set host or port etc.
     auth: {
         user: 'account.email@example.com',
         password: 'smtp-password'
     }
});

transporter.sendMail(...)
```

### Supported services

{{% notice tip %}}
Service names are case insensitive
{{% /notice %}}

- `"126"`
- `"163"`
- `"1und1"`
- `"AOL"`
- `"DebugMail"`
- `"DynectEmail"`
- `"FastMail"`
- `"GandiMail"`
- `"Gmail"`
- `"Godaddy"`
- `"GodaddyAsia"`
- `"GodaddyEurope"`
- `"hot.ee"`
- `"Hotmail"`
- `"iCloud"`
- `"mail.ee"`
- `"Mail.ru"`
- `"Maildev"`
- `"Mailgun"`
- `"Mailjet"`
- `"Mandrill"`
- `"Naver"`
- `"OpenMailBox"`
- `"Outlook365"`
- `"Postmark"`
- `"QQ"`
- `"QQex"`
- `"SendCloud"`
- `"SendGrid"`
- `"SendinBlue"`
- `"SendPulse"`
- `"SES"`
- `"SES-US-EAST-1"`
- `"SES-US-WEST-2"`
- `"SES-EU-WEST-1"`
- `"Sparkpost"`
- `"Yahoo"`
- `"Yandex"`
- `"Zoho"`
- `"qiye.aliyun"`
