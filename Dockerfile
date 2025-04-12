FROM ruby:3.2-slim

ENV APP_WORKDIR=/src/jekyll
ENV APP_USER=jekyll
ENV APP_GROUP=jekyll
ENV APP_PORT=4000

RUN apt update -y && \
    apt install -y gcc git build-essential zlib1g-dev

RUN gem install bundler jekyll

WORKDIR ${APP_WORKDIR}

COPY . .

RUN bundle install

RUN useradd -m -U ${APP_USER} && \
    usermod -aG sudo ${APP_USER} && \
    chown ${APP_USER}:${APP_GROUP} -R ${APP_WORKDIR}

USER ${APP_USER}

EXPOSE ${APP_PORT}

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "jekyll", "serve", "--watch" ]

