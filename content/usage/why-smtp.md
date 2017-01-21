+++
date = "2017-01-21T00:44:30+02:00"
toc = true
next = "/next/path"
prev = "/prev/path"
weight = 7
title = "SMTP? Say What?"

+++

You might wonder why you would need to set something up while in comparison PHP's [mail](http://php.net/manual/en/function.mail.php) command works out of the box with no special configuration whatsoever. Just call **mail(...)** and you're already sending mail. So what's going on in Node.js?

The difference is in the software stack required for your application to work. While Node.js stack is thin, all you need for your app to work is the *node* binary, then PHP's stack is fat. The server you're running your PHP code on has several different components installed.

Firstly the PHP interpreter itself. Then there's some kind of web server, most probably Apache or Nginx. Web server needs some way to interact with the PHP interpreter, so you have a (fast-)CGI process manager. There might be MySQL also running in the same host. Depending on the installation type you might even have *imagemagick* executables or other helpers lying around somewhere. And finally, you have the *sendmail* binary.

What PHP's **mail()** call actually does is that it passes your mail data to sendmail's *stdin* and thats it, no magic involved. *sendmail* does all the heavy lifting of queueing your message and trying to send it to the recipients' MX mail server.

In fact you can achieve the exact same behavior in Nodemailer PRO as well by using the [sendmail transport](/transports/sendmail/). The difference being that in case of PHP the sendmail configuration resides in *php.ini* but in case of Node.js the sendmail configuration is part of Nodemailer PRO setup.

Unfortunately this might not always work – as it was already said, the stack for Node.js is thin and this means that *sendmail* might not have been installed to the server your application is running on. This is why it is better to rely on an actual SMTP service that is always accessible.
