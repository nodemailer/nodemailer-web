+++
date = "2017-06-03T12:36:15+03:00"
title = "Status"

+++

In short, I am dumping the project. Most probably the current version 4.0.1 is going the be the last version of Nodemailer ever released.

This does not mean that I'm giving this project over to someone else. No, it just means that I won't work on it anymore. I'll keep the homepage up as it is – the advertising stuff in the left top corner of the page generates several tens of dollars a month which covers the server costs for any other stuff that I do and I do not want to give up this revenue.

So what happened?

For the past 6 years I have helped resolving issues around sending emails with Nodemailer. Usually it has been exactly the same complaint about Gmail which I had written about at least a thousand times but yeah, nobody RTFM anymore, so I've had to spend countless hours explaining the same thing over and over. TBQH there has been some valid issues as well that pointed out or even fixed errors in my mail protocol handling code but this has been extremely rare and even rarer in the recent years. So, mostly Gmail and to a lesser extent SES and it's always a configuration problem (invalid access scopes, invalid IAM tokens etc.).

In the end of 2016 I decided that I'm on the verge of burnout and I can't keep up putting my time into it anymore, so I decided that for the next major rewrite I'd change the license from MIT to copyleft and start selling licenses to users that want to use it in commercial products which should allow me to work on Nodemailer in business hours instead of sleep time. I finished the rewrite and released Nodemailer v3 by the end of January 2017 and started selling it.

"Selling" is a strong word though. I got thousands and thousands of people viewing the pricing page, there were even a couple of people actually buying it, so things seemed nice. The buyers preferred monthly payment option so there weren't so much revenue coming in, maybe just a couple of hundred dollars in total but that's better than zero.

Then I started to have a massive amount of emails coming in asking for advice of how to skip the license fee and use Nodemailer without paying for it.

And then it went all downhill. Existing buyers started to cancel subscriptions and asked for a refund. These that did not just plain disputed the payments for chargebacks. It appears that the buyers were mostly spammers and I assume they were using stolen credit cards, because they did not understand what they were paying for. They assumed they can use Nodemailer as a service of some kind for sending out bulk mail.

Anyhow, in the end my seller account was eventually suspended because all the chargebacks cost more than I had made from selling the Nodemailer license.

I stopped selling the license (I wasn't even able to, at least with the existing provider, because of the suspended seller account), changed the license back to MIT to stop the complaints coming in of how I betrayed the open source community and decided that this is it, I won't be spending a second on this project anymore. If there weren't that ad revenue of tens of dollars a month, I'd probably close this webpage but I need this money for my [other projects](http://wildduck.email/).
