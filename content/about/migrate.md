+++
date = "2017-01-20T21:37:15+02:00"
toc = true
prev = "/about/"
next = "/about/license/"
weight = 2
title = "Migration"

+++

> This migration document applies to migrating from Nodemailer 2 to Nodemailer 3, and to a lesser extent, to Nodemailer 4.

Nodemailer v3 introduces several changes, removing some features from v2 and adding new functionality to improve the overall experience.

### Major Changes in Nodemailer v3

- **Zero Dependencies**: All external dependencies have been removed, reducing the installation time to less than 2 seconds from NPM.
- **Templating Removed**: Templating support was dropped as it caused confusion and would have required extensive support for multiple rendering engines. Nodemailer is focused solely on email delivery. For templating needs, consider using [email-templates](https://github.com/forwardemail/email-templates).
- **No NTLM Authentication**: NTLM support has been removed due to complexity. While currently unavailable, a future pluggable SASL interface may enable custom NTLM modules. (Note: Nodemailer 5 supports NTLM through the [authentication addon](https://github.com/nodemailer/nodemailer-ntlm-auth)).
- **OAuth2 Authentication Built-in**: OAuth2 support now comes built-in with improved [configuration options](/smtp/oauth2/). It supports both user accounts (3LO) and service accounts (2LO) for token generation, with the added ability to authenticate on a per-message basis. This feature is particularly useful for sending on behalf of multiple users.
- **Delivery Status Notifications (DSN)**: DSN support has been added to provide detailed feedback on message delivery.
- **Improved DKIM Signing**: Built-in DKIM signing has been improved, offering better handling for larger messages, which previously required an external module.
- **Stream Transport**: This feature returns a fully formatted RFC822 message as a stream, allowing Nodemailer to act as a preprocessor when actual message delivery is not needed.
- **Built-in Sendmail Transport**: The sendmail transport is now part of the core, removing the need for external plugins.
- **Enhanced Calendar Support**: Nodemailer now supports sending [calendar events](/message/calendar-events/) by attaching an iCal file directly to your emails.
