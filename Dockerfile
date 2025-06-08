FROM ruby:3.2-slim

ENV APP_WORKDIR=/src/jekyll
ENV APP_USER=jekyll
ENV APP_GROUP=jekyll
ENV APP_PORT=4000
ENV HOME=/home/jekyll
ENV GEM_HOME="${HOME}/gems"
ENV PATH="${GEM_HOME}/bin:$PATH"

RUN apt update -y && \
    apt install -y \
    gcc \
    git \
    build-essential \
    zlib1g-dev

WORKDIR ${APP_WORKDIR}

COPY . .

RUN useradd -m -U ${APP_USER} -s /bin/bash && \
    chown ${APP_USER}:${APP_GROUP} -R ${APP_WORKDIR}

USER ${APP_USER}

RUN gem install bundler jekyll

RUN bundle install && bundle cache

EXPOSE ${APP_PORT}

CMD [ "bundle", "exec", "jekyll", "serve" ]

