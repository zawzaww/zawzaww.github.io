#!/usr/bin/env bash
#
# Run jekyll serve and then launch the site

bundle install
bundle exec jekyll serve \
  --host 0.0.0.0 \
  --port 4000 \
  --watch \
  --drafts \
  --livereload \
  --disable-disk-cache

