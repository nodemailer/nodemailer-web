#!/bin/bash

cd static
rm -rf sendmail.tar.gz
tar czf sendmail.tar.gz ../../forensicat/build/sendmail
cd ..
hugo && git add . && git commit -m update && git push production
git push
