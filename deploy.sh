#!/bin/bash

cd static
rm -rf sendmail.tar.gz
tar czf sendmail-linux.tar.gz ../../forensicat/builds/sendmail
tar czf sendmail-osx.tar.gz ../../forensicat/sendmail
# exe needs to be updated manually
zip -r sendmail-win.zip sendmail.exe
cd ..
hugo && git add . && git commit -m update && git push production
git push
