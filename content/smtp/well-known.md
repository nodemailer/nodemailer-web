+++
prev = "/smtp/oauth2/"
next = "/smtp/proxies/"
weight = 23
title = "Well Known Services"
date = "2017-01-20T21:15:16+02:00"
toc = true

+++

Nodemailer PRO knows SMTP connection details for several well-known providers. If your provider is listed here you do not need to set the connection details yourself (you can if you want it though) for the transporter object, providing service name is already good enough.

```javascript
let transporter = nodemailer.createTransport({
     service: 'gmail', // no need to set host or port etc.
     auth: {...}
});
```

### Supported services

> Service names are case insensitive

* `"1und1"`
* `"AOL"`
* `"DebugMail.io"`
* `"DynectEmail"`
* `"FastMail"`
* `"GandiMail"`
* `"Gmail"`
* `"Godaddy"`
* `"GodaddyAsia"`
* `"GodaddyEurope"`
* `"hot.ee"`
* `"Hotmail"`
* `"iCloud"`
* `"mail.ee"`
* `"Mail.ru"`
* `"Mailgun"`
* `"Mailjet"`
* `"Mandrill"`
* `"Naver"`
* `"Postmark"`
* `"QQ"`
* `"QQex"`
* `"SendCloud"`
* `"SendGrid"`
* `"SES"`
* `"Sparkpost"`
* `"Yahoo"`
* `"Yandex"`
* `"Zoho"`
