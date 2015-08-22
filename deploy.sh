#! /bin/bash
aws s3 sync jekyll/_site s3://s3.pencilinthehand.com
# TODO add cache invalidation
