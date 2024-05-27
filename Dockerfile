FROM jekyll/jekyll:stable

WORKDIR /srv/jekyll

COPY . .

# RUN jekyll build
RUN bundle install

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "jekyll", "serve", "--livereload" ]

