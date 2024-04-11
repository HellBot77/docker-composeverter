FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/outilslibre/composeverter.git && \
    cd composeverter && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node AS build

WORKDIR /composeverter
COPY --from=base /git/composeverter/packages/composeverter-website .
RUN yarn && \
    export NODE_ENV=production && \
    yarn build

FROM pierrezemb/gostatic

COPY --from=build /composeverter/build /srv/http
EXPOSE 8043
