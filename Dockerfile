FROM jekyll/jekyll:stable

WORKDIR /srv/jekyll

COPY . .

# RUN bundle install
RUN jekyll build

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "jekyll", "serve", "--livereload" ]

