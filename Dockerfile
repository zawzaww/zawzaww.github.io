FROM jekyll/jekyll:stable

WORKDIR /srv/jekyll

COPY . .

RUN jekyll build

CMD [ "jekyll", "serve" ]

