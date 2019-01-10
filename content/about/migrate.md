+++
date = "2017-01-20T21:37:15+02:00"
toc = true
prev = "/about/"
next = "/about/license/"
weight = 2
title = "Migration"

+++

> This migration document applies Migrating from Nodemailer 2 to Nodemailer 3 and to a lesser extent to 4

Nodemailer v3 has dropped some features that were available in Nodemailer v2 and also introduced some new ones.

- All **dependencies were dropped**. There is exactly 0 dependencies needed to use Nodemailer. This brings the installation time of Nodemailer from NPM to less than 2 seconds
- All **templating is gone**. It was too confusing to use and to be really universal a huge list of different renderers would be required. Nodemailer is about email, not about parsing different template syntaxes
- No **NTLM authentication**. It was too difficult to re-implement. If you still need it then it would be possible to introduce a pluggable SASL interface where you could load the ntlm module in your own code and pass it to Nodemailer. Currently this is not possible. (Nodemailer 5 supports NTLM through an authentication [addon](https://github.com/nodemailer/nodemailer-ntlm-auth))
- **OAuth2 authentication** is built in and has a different [configuration](/smtp/oauth2/). You can use both user (3LO) and service (2LO) accounts to generate access tokens from Nodemailer. Additionally there's a new feature to authenticate differently for every message – useful if your application sends on behalf of different users instead of a single sender.
- **Delivery status notifications** added to Nodemailer
- Improved **DKIM** signing of messages. Previously you needed an external module for this and it did quite a lousy job with larger messages
- **Stream transport** to return a RFC822 formatted message as a stream. Useful if you want to use Nodemailer as a preprocessor and not for actual delivery.
- **Sendmail** transport built-in, no need for external transport plugin
- **Improved Calendaring**. Provide an ical file to Nodemailer to send out [calendar events](/message/calendar-events/).
