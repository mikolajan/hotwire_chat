FROM ruby:3.2.2-alpine

WORKDIR /hotwire_chat

RUN apk --no-cache add \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    chromium chromium-chromedriver python3 python3-dev py3-pip

COPY . .

RUN gem update --system \
    && gem install bundler -v 2.4.13 \
    && bundle install

RUN yarn config set strict-ssl false   # hack if strict-ssl error
RUN yarn install
