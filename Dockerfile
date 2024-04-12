FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/outilslibre/composeverter.git && \
    cd composeverter && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node AS build

WORKDIR /composeverter
COPY --from=base /git/composeverter .
RUN cd packages/composeverter-website && \
    yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /composeverter/packages/composeverter-website/build .
