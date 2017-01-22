+++
date = "2017-01-20T21:37:15+02:00"
toc = true
prev = "/about/"
next = "/about/license/"
weight = 2
title = "Why PRO?"

+++

**Nodemailer PRO** is an upgrade of Nodemailer. Unlike Nodemailer which is licensed under MIT. Nodemailer PRO is licensed under restrictive CC license and commercial license. See license details in the [License page](/about/license/).

Even though you can use the [community version](https://community.nodemailer.com/) of Nodemailer as long as you want, Nodemailer PRO has some benefits over it.

  * Nodemailer PRO is **maintained**. Due to the large amount of effort what it takes to handle a myriad of RFC's and also keep the code updated along ever-upgrading Node.js versions, I haven't had too much time to manage the original Nodemailer. The testimonial being that Nodemailer is still fully ES5 code and works on legacy systems like Node.js 0.10.
  * **Support**. For paying customers I am able to provide email based help setting up or resolving issues with Nodemailer PRO. For Nodemailer you mostly have to rely on [Stack Overflow](http://stackoverflow.com/search?q=nodemailer).
  * **Bundled modules**. Nodemailer PRO does not come alone. In addition you get to use [Mailparser2](https://www.npmjs.com/package/@nodemailer/mailparser2) and possibly other modules under the same terms as Nodemailer PRO with no extra cost. More modules coming in the future.
  * **Auditability**. Nodemailer includes a tree of dependencies. Nodemailer PRO has zero dependencies as everything required (and only that) is built in. There's no dead code or dark corners which makes code audits lot easier. In the future I plan to have regular security audits on Nodemailer PRO code to prevent issues like hidden [RCE vulnerabilities](http://thehackernews.com/2017/01/phpmailer-swiftmailer-zendmail.html) that some other email projects have had recently.
  * **Longevity**. By paying you support the project to keep going on. You can use Nodemailer PRO without fearing that it does not support your latest platform upgrade or suddenly stops doing what really matters – delivering your messages to your customers.

### Differences

Nodemailer PRO has dropped some features available in Nodemailer and also introduced some new ones.

  * All **templating is gone**. It was too confusing to use and to be really universal a huge list of different renderers would be required. Nodemailer PRO is about email, not about parsing different template sytaxes
  * No **NTLM authentication**. It was too difficult to re-implement. If you still need it then it would be possible to introduce a pluggable SASL interface where you could load the ntlm module in your own code and pass it to Nodemailer PRO. Currently this is not possible.
  * **OAuth2 authentication** is built in and has a different [configuration](/smtp/oauth2/). You can use both user (3LO) and service (2LO) accounts to generate access tokens from Nodemailer PRO. Additionally there's a new feature to authenticate differently for every message – useful if your application sends on behalf of different users instead of a single sender.
  * **Delivery status notifications** added to Nodemailer PRO
  * Improved **DKIM** signing of messages. Previously you needed an external module for this and it did quite a lousy job with larger messages
  * **Stream transport** to return a RFC822 formatted message as a stream. Useful if you want to use Nodemailer PRO as a preprocessor and not for actual delivery.
  * **Sendmail** transport built-in, no need for external transport plugin
  * **Improved Calendaring**. Provide an ical file to Nodemailer PRO to send out [calendar events](/message/calendar-events/).
  * **Long pipeline of things to do**. Nodemailer PRO is far from being done.

### Why?

Simply because I was not able to afford keeping such a large project like Nodemailer alive. If I would make just a single sale of Nodemailer PRO it would still be more than the money I made in donations in the last 6 years I've been developing Nodemailer. I'm mostly interested in building email related modules, it does not matter if the modules are truly open source or not.
