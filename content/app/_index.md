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

# NodemailerApp

**NodemailerApp** is the ultimate cross-platform email debugging tool.

The app includes local SMTP and POP3 servers, a sendmail replacement, a catchall email domain service, an AMP4Email renderer, and it imports emails from EML, EMLX, large MBOX files from Gmail Takeout, Maildir folders, and Postfix queue files for inspection and preview. Want to see the actual HTML source of a beautifully designed email instead of garbled rfc822 text? Just open the HTML tab of an email to view it.

![](/screenshots/img01.png)

You can use NodemailerApp to instantly preview emails sent from your dev environment, whether via SMTP, sendmail, or the open web using the built-in catchall service. You can also upload emails to an external SMTP or IMAP server. All SMTP, POP3, and IMAP transactions include live logs for extra clarity.

### Download

> **Note**: Downloads may be slow due to limited network throughput, and file sizes are large (>100MB) since NodemailerApp is built on [Electron](https://www.electronjs.org/apps/nodemailer-app).

<div style="text-align: center"><a href="https://github.com/nodemailer/nodemailer-app/releases/download/v1.0.16/NodemailerApp-1.0.16.dmg" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> NodemailerApp (OSX)</a> <a href="https://github.com/nodemailer/nodemailer-app/releases/download/v1.0.16/NodemailerApp-1.0.16.Setup.exe" target="_blank" class="btn btn-default"><i class="fas fa-download"></i> NodemailerApp (Windows)</a> <a href="https://snapcraft.io/nodemailerapp" target="_blank" class="btn btn-default"><i class="fas fa-arrow-right"></i> Snapcraft (Linux)</a></div>

### Features

**1\. Preview emails** as they are imported. You can start importing a large 10GB mbox file from Gmail Takeout and immediately start browsing the emails that are already imported.

![](/screenshots/img01.png)

**2\. Rich email output.** View the plain text alternative, HTML source code, and email headers alongside the standard rich text view. You can download the entire email as an EML file or export it as a PDF. Attachments are located under the Files tab.

![](/screenshots/img02.png)

**3\. Local development server.** NodemailerApp can be configured as an SMTP relay server in your development environment. Emails sent from local environments (like Laravel) can be immediately previewed in NodemailerApp, which catches emails for testing purposes without delivering them to actual recipients. You can also retrieve these emails via POP3 if needed.

![](/screenshots/img03.png)

**4\. Message upload.** Emails stored in NodemailerApp can be uploaded to an SMTP server for delivery or to an IMAP server to store them in your email account.

![](/screenshots/img04.png)

**5\. Extensive search.** Search for emails, attachments, or people. NodemailerApp indexes all header values in every message, making it easy to find specific emails, such as a PDF sent by your boss last year.

![](/screenshots/img06.png)
![](/screenshots/img05.png)

**6\. Catchall service.** Built-in support for a catchall email domain service is included. Enable it with a single click to assign a custom domain name, and all emails sent to this domain will be routed to a project in your app.

**7\. AMP4Email.** Preview dynamic AMP4Email messages. If something is wrong with the message, NodemailerApp will display the exact cause of the error, unlike email services that ignore dynamic content when errors occur. See [this blog post](https://blog.nodemailer.com/2019/12/30/testing-amp4email-with-nodemailer/) for an example.

![](/screenshots/img07.png)
![](/screenshots/img08.png)

### Using with XAMPP

**Windows**

On Windows, you can edit `php.ini` and set it to the value provided in NodemailerApp's Local Server view. NodemailerApp does not need to be running while emails are sent since they are stored to disk and can be viewed the next time the app starts.

![](/sendmail_win.png)

> Alternatively, you can download the [Windows version of sendmail](https://nodemailer.com/sendmail-win.zip) as a separate application. Use the same arguments shown in the instructions section.

**OSX**

In OSX, XAMPP runs your web app in an isolated container, making direct sendmail requests to NodemailerApp impossible. Instead, use the Linux version of sendmail replacement to proxy emails over SMTP, which requires that NodemailerApp is running.

**Steps:**

1. Ensure NodemailerApp's local server listening IP is either `0.0.0.0` or `192.168.64.1` (default is `127.0.0.1`). XAMPP VM assigns `192.168.64.1` to the host machine.
2. Download and unpack the [Linux version of sendmail replacement](https://nodemailer.com/sendmail-linux.tar.gz) and copy it to the XAMPP container.
3. Replace the old c++ libraries by running these commands in the XAMPP terminal:
   ```
   $ mv /opt/lampp/lib/libstdc++.so.6 /opt/lampp/lib/libstdc++.so.6.bak
   $ cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/lampp/lib/
   ```
4. Edit `/opt/lampp/etc/php.ini`, and in the `[mail function]` section, add the following configuration line using the SMTP username and password provided by NodemailerApp:
   ```
   sendmail_path = "/opt/lampp/sendmail --host=192.168.64.1 --port=1025 --user=project.1 --pass=secret.1 -t -i"
   ```
   For all available configuration options, run `/opt/lampp/sendmail --help`.
5. Restart the Apache service in XAMPP.

### Videos

##### <div style="text-align: center; padding: 20px 0;">Use NodemailerApp as local test server for SMTP</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/ETUmG3B-jOw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="ghost">Use NodemailerApp as local test server for Ghost Blog</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/6uQJcbmZwc0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;">Use NodemailerApp as sendmail replacement</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/cYfdUqd_Vbs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="xampp">Catch and preview emails from XAMPP OSX VM</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/0iO7cxWA_PU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="xampp">Use built-in catchall service to receive emails from the web</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/1lHDxv65lLc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

##### <div style="text-align: center; padding: 20px 0;" id="xampp">Preview AMP4Emails</div>

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/LFbXztDb03A" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
