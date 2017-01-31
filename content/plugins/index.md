+++
weight = 0
title = "Plugins"
date = "2017-01-20T22:51:00+02:00"
icon = "<b>6. </b>"
chapter = true
prev = "/transports/stream/"
next = "/plugins/create/"

+++

# Plugins

Nodemailer can be extended with plugins. In most cases there are 3 different kind of plugins.

  1. Plugins that operate on the mail object (for example extend it or change existing values). This is the pre-processing step
  2. Plugins that operate on mail stream (for example to calculate message signatures). This is the processing step
  3. Plugins that operate as transports (for example to send the message using an API of some delivery provider). This is the sending step

### Available plugins

These are some existing public plugins for Nodemailer

  * [express-handlebars](https://github.com/yads/nodemailer-express-handlebars) – this plugin uses the express-handlebars view engine to generate html emails
  * [inline-base64](https://github.com/mixmaxhq/nodemailer-plugin-inline-base64) – This plugin will convert base64-encoded images in your nodemailer email to be inline ("CID-referenced") attachments within the email
  * [html-to-text](https://github.com/andris9/nodemailer-html-to-text) – The plugin checks if there is no text option specified and populates it based on the html value

For a more extensive list [search for nodemailer](https://www.npmjs.com/search?q=nodemailer) in npm.
