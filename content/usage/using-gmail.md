+++
prev = "/prev/path"
weight = 8
title = "Using Gmail"
date = "2017-01-21T00:25:10+02:00"
toc = true
next = "/next/path"

+++

Even though Gmail is the fastest way to get started with sending emails, it is by no means a preferable solution unless you are using OAuth2 authentication. Gmail expects the user to be an actual user not a robot so it runs a lot of heuristics for every login attempt and blocks anything that looks suspicious to defend the user from account hijacking attempts. For example you might run into trouble if your server is in another geographical location – everything works in your dev machine but messages are blocked in production.

Additionally Gmail has came up with the concept of ["Less Secure"](https://support.google.com/accounts/answer/6010255?hl=en) apps which is basically anyone who uses plain password to login to Gmail, so you might end up in a situation where one username can send mail (support for "less secure" apps is enabled) but other is blocked (support for "less secure" apps is disabled). You can configure your Gmail account to allow less secure apps [here](https://www.google.com/settings/security/lesssecureapps). When using this method make sure to also enable the required functionality by completing the ["Captcha Enable"](https://accounts.google.com/b/0/displayunlockcaptcha) challenge. Without this, less secure connections probably would not work.

If you are using 2FA you would have to create an ["Application Specific"](https://security.google.com/settings/security/apppasswords) password for Nodemailer PRO to work.

Gmail also always sets authenticated username as the *From:* email address. So if you authenticate as *foo@example.com* and set *bar@example.com* as the *from:* address, then Gmail reverts this and replaces the sender with the authenticated user.

To prevent having login issues you should either use OAuth2 (see details [here](/smtp/oauth2/)) or use another delivery provider and preferably a dedicated one. Usually these providers have free plans available that are comparable to the daily sending limits of Gmail. Gmail has a limit of 500 recipients a day (a message with one _To_ and one _Cc_ address counts as two messages since it has two recipients) for @gmail.com addresses and 2000 for Google Apps customers, larger SMTP providers usually offer about 200-300 recipients a day for free.
