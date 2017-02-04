#!/bin/bash

hugo && git add . && git commit -m update && git push && git push production

