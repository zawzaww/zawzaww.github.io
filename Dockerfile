FROM ruby:3.2.0-alpine

RUN apk update && \
    apk add --no-cache build-base gcc cmake git

RUN gem install bundler jekyll

WORKDIR /src/jekyll

COPY . .

RUN bundle install

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "jekyll", "serve", "--watch" ]

