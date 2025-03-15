FROM ruby:3.2-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache build-base gcc cmake git

RUN gem install bundler jekyll

WORKDIR /src/jekyll

COPY . .

RUN git config --global --add safe.directory /src/jekyll

RUN bundle install && \
    bundle exec jekyll build

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "jekyll", "serve", "--watch" ]

