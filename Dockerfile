#-------------------
# base
#-------------------
FROM node:16.15.0-alpine3.15 as base

ENV LANG=ja_JP.UTF-8
ENV HOME=/home/node
ENV APP_HOME="$HOME/app"

WORKDIR $APP_HOME

RUN apk upgrade --no-cache && \
    apk add --update --no-cache \
    curl git

# https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#global-npm-dependencies
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

# 全ファイルをnodeユーザーのものにする
RUN chown -R node:node .

USER node

RUN echo "WORKDIR : $WORKDIR. HOME : $HOME. LANG : $LANG." && npm config list

#-------------------
# dev
#-------------------
FROM base as dev
ENV NODE_ENV=development
