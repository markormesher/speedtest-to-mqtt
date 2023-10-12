FROM node:20.8.0-bookworm@sha256:21505ae2f9f4b29ad9091e6dfc6c56ef9e890a16fc38fe6f6cd9ba3e979ef37c AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.8.0-bookworm@sha256:21505ae2f9f4b29ad9091e6dfc6c56ef9e890a16fc38fe6f6cd9ba3e979ef37c
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
