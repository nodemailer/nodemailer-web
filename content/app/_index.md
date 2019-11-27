+++
date = "2017-01-20T11:25:35+02:00"
pre = "<b>9. </b>"
chapter = true
prev = "/plugins/create/"
next = "/extras/"
weight = 90
title = "NodemailerApp"
toc = true

+++# Nodemailer App

NodemailerApp is the ultimate email debugging app for OSX and Windows 10.

App imports emails from EML files, EMLX files, large MBOX files from Gmail takeout, Maildir folders and Postfix queue files for inspection. Ever wanted to view the actual HTML source of a nicely designed email instead of some garbled rfc822 format? Just open the HTML tab of an email to see it.

NodemailerApp includes a local SMTP and POP3 server for testing. Use it to instantly preview emails sent from your dev environment. If needed, you can also upload any email to an external SMTP or IMAP server. All SMTP, POP3 and IMAP transactions include live logs.

<div style="text-align: center"><a href="https://downloads.nodemailer.com/download/osx" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> Mac OSX</a> <a href="https://downloads.nodemailer.com/download/win32" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> Windows</a></div>

### Extras

1\. NodemailerApp Sendmail replacement. App allows to proxy emails to a SMTP server like the built in development server of NodemailerApp. You could need it if your development environment runs in a Linux container insidde Windows or Mac host. This way you could configure php.ini to send emails via NodemailerApp sendmail inside the container.

<div style="text-align: center"><a href="https://nodemailer.com/sendmail.tar.gz" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> Linux</a></div>

**Example for XAMPP VM**

```
sendmail_path = '"/opt/lampp/sendmail" --host=192.168.64.1 --port=1025 --user=project.1 --pass=secret.1 -t -i'
```

### Features

1\. Preview emails as these are being imported. You can start impoting a large 10GB mbox file from Gmail Takout and immediatelly start browsing emails that are already imported.

![](/screenshots/img01.png)

2\. Rich email output. In addition to normal rich text email views you can see the plain text alternative, HTML source code and email headers. You can download the entire email as an EML file, or export it as PDF. All related attachments can be found under the Files tab.

![](/screenshots/img02.png)

3\. Local development server. You can configure your development environment to use NodemailerApp as SMTP relay server. Whenever sending out an email from your local Laravel or any other stack you can immediatelly preview the sent email in NodemailerApp. The sent email is catched by NodemailerApp by good so it is not delivered to actual recipients which makes it fantastic for testing environments. If you ever need to access the sent emails from your own app you can do so by using POP3.

![](/screenshots/img03.png)

4\. Message upload. Stored emails can be uploaded to SMTP (which means the email is being actually delivered to destination) or to an IMAP server (so it would end up in your actual email account).

![](/screenshots/img04.png)

5\. Extensive search. Search for emails or specific attachments or specific people. You can even search by every header value in every message as NodemailerApp indexes basically everything. Wanted to find that specific PDF file sent by your boss some time last year? NodemailerApp attachment search gets you covered.

![](/screenshots/img06.png)
![](/screenshots/img05.png)

### Videos

##### <div style="text-align: center; padding: 20px 0;">Use NodemailerApp as local test server for SMTP</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/ETUmG3B-jOw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="ghost">Use NodemailerApp as local test server for Ghost Blog</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/6uQJcbmZwc0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="ghost">Use NodemailerApp as sendmail replacement</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/cYfdUqd_Vbs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
