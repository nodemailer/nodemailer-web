+++
title = "Node.js daemons"
date = "2017-01-21T00:12:25+02:00"
toc = true
prev = "/extras/mailcomposer/"
next = "/about/"
weight = 47

+++

This tutorial shows how to set up Node.js applications as daemon services under Linux. Specifically the following would apply:

* The daemon application is a Node.js web app
* Daemon is set up as a SystemD services
* Node.js app is accessed as a Nginx virtual domain
* Updates are deployed using git

> Even though this tutorial uses a web app as the service daemon, then the same approach can be used for deploying any kind of services.


### 1\. Application

The application code is simple, it consists only from two files, the application script and package.json. It's a Node.js app that serves web requests at port 3000. For demo purposes the app uses [npmlog](https://www.npmjs.com/package/npmlog) as a dependency that is only needed to demonstrate deploying dependencies.

```javascript
// index.js
const http = require('http');
const log = require('npmlog')

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\n');
  log.http('App', req.url);
});

server.listen(port, hostname, () => {
  log.info('App', `Server running at http://${hostname}:${port}/`);
});
```

```json
{
  "name": "demo-app",
  "private": true,
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "npmlog": "^4.1.2"
  },
  "license": "ISC"
}
```

### 2\. Setting up git

Assuming we have these two files in a directory, let's set up git repository

```bash
$ git init
  Initialized empty Git repository in ~/demo-app/.git/
$ git add .
$ git commit -m Initial
  [master (root-commit) 057e7f3] initial
   2 files changed, 27 insertions(+)
   create mode 100644 index.js
   create mode 100644 package.json
```

For now we do not set up remote repository, let's leave this for later.

### 3\. Setting up server
