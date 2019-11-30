+++
date = "2017-01-20T11:25:35+02:00"
pre = "<b>9. </b>"
chapter = true
prev = "/plugins/create/"
next = "/extras/"
weight = 90
title = "NodemailerApp"
toc = true
+++

# Nodemailer App

**NodemailerApp** is the ultimate cross platform email debugging app.

App includes local SMTP and POP3 servers, a sendmail replacement, and it imports emails from EML files, EMLX files, large MBOX files from Gmail takeout, Maildir folders and Postfix queue files for inspection and preview. Ever wanted to view the actual HTML source of a nicely designed email instead of some garbled rfc822 text? Just open the HTML tab of an email to see it.

![](/screenshots/img01.png)

You can use NodemailerApp to instantly preview emails sent from your dev environment, be it from SMTP or sendmail. You can also upload any email to an external SMTP or IMAP server. All SMTP, POP3 and IMAP transactions include live logs for extra clarity.

<div style="text-align: center"><a href="https://downloads.nodemailer.com/download/osx" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> NodemailerApp (OSX)</a> <a href="https://downloads.nodemailer.com/download/win32" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> NodemailerApp (Windows)</a> <a href="https://snapcraft.io/nodemailerapp" target="_blank" class="btn btn-default"><i class="fas fa-arrow-right"></i> Snapcraft (Linux)</a></div>

### Extras

**1\.** NodemailerApp **Sendmail replacement**. NodemailerApp has sendmail compatibility already built in but in some cases you might need a separate executable. Sendmail app allows to proxy emails to a SMTP server, ie. to the built in development server of NodemailerApp (but is not limited to it). You could use it, for example, if your development environment runs in a Linux container inside Windows or Mac host. This way you could configure php.ini to send emails via sendmail out to the NodemailerApp SMTP server in the host machine.

<div style="text-align: center"><a href="https://nodemailer.com/sendmail-linux.tar.gz" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> Sendmail (Linux)</a> <a href="https://nodemailer.com/sendmail-osx.tar.gz" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> Sendmail (OSX)</a> <a href="https://nodemailer.com/sendmail-win.zip" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> Sendmail (Windows)</a></div>

### Features

**1\.** **Preview emails** as these are being imported. You can start impoting a large 10GB mbox file from Gmail Takout and immediatelly start browsing emails that are already imported.

![](/screenshots/img01.png)

**2\.** **Rich email output.** In addition to normal rich text email views you can see the plain text alternative, HTML source code and email headers. You can download the entire email as an EML file, or export it as PDF. All related attachments can be found under the Files tab.

![](/screenshots/img02.png)

**3\.** **Local development server.** You can configure your development environment to use NodemailerApp as SMTP relay server. Whenever sending out an email from your local Laravel or any other stack you can immediatelly preview the sent email in NodemailerApp. The sent email is catched by NodemailerApp for good so it is not delivered to actual recipients which makes it fantastic for testing environments. If you ever need to access the sent emails from your own app you can do so by using POP3.

![](/screenshots/img03.png)

**4\.** **Message upload.** Stored emails can be uploaded to SMTP (which means the email is being actually delivered to destination) or to an IMAP server (so it would end up in your actual email account).

![](/screenshots/img04.png)

**5\.** **Extensive search.** Search for emails or specific attachments or specific people. You can even search by every header value in every message as NodemailerApp indexes basically everything. Wanted to find that specific PDF file sent by your boss some time last year? NodemailerApp attachment search has you covered.

![](/screenshots/img06.png)
![](/screenshots/img05.png)

### Using with XAMPP

**Windows**

In Windows you can edit php.ini and set it to the value provided in the Local Server view in NodemailerApp as your web app and NodemailerApp run in the same environment. Great thing about such setup is that NodemailerApp does not have to be working while emails are being sent. Emails are stored to disk and can be viewed next time you start the app.

![](/sendmail_win.png)

> Alternatively you can download <a href="https://nodemailer.com/sendmail-win.zip" target="_blank">Windows version of sendmail</a> as a separate application and place it wherever you like. Use the same arguments though as shown in the instructions section.

**OSX**

In OSX XAMPP runs your web app in an isolated container and thus making sendmail requests directly against NodemailerApp application is not possible. Instead you should use the Linux version of sendmail replacement to proxy emails over SMTP. This also means that you can only accept mail when NodemailerApp is actually opened and it has local server running.

**1\.** First make sure that NodemailerApp local server listening IP is either 0.0.0.0 or 192.168.64.1 (default is 127.0.0.1) as XAMPP VM on OSX sets up a virtual private network, where the host machine usually gets assigned the IP 192.168.64.1.

**2\.** Then download and unpack the <a href="https://nodemailer.com/sendmail-linux.tar.gz" target="_blank">Linux version</a> of sendmail replacement and copy it to the XAMPP container.

**3\.** For some reason Apache in XAMPP uses some old c++ libraries, you can force it to use newer one by running the following commands in XAMP terminal:

```
$ mv /opt/lampp/lib/libstdc++.so.6 /opt/lampp/lib/libstdc++.so.6.bak
$ cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/lampp/lib/
```

**4\.** Then edit /opt/lampp/etc/php.ini, find the _[mail function]_ section and add the following configuration line (assuming you copied _sendmail_ binary to _/opt/lampp_) using SMTP username and password provided by NodemailerApp:

```
sendmail_path = "/opt/lampp/sendmail --host=192.168.64.1 --port=1025 --user=project.1 --pass=secret.1 -t -i"
```

For all available configuration options, run `/opt/lampp/sendmail --help`

**5\.** Last, restart Apache service in XAMPP.

### Videos

##### <div style="text-align: center; padding: 20px 0;">Use NodemailerApp as local test server for SMTP</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/ETUmG3B-jOw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="ghost">Use NodemailerApp as local test server for Ghost Blog</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/6uQJcbmZwc0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;">Use NodemailerApp as sendmail replacement</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/cYfdUqd_Vbs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="xampp">Catch and preview emails from XAMPP OSX VM</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/0iO7cxWA_PU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
