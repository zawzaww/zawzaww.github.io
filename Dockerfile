FROM jekyll/jekyll:stable

WORKDIR /srv/jekyll

COPY . .

RUN bundle install

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "jekyll", "serve", "--livereload" ]

