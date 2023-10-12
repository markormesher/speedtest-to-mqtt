FROM node:20.8.0-bookworm@sha256:e6c64b695205fab13cc22a50b085710980383a6d13f5985b150f6ee1c949681e AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.8.0-bookworm@sha256:e6c64b695205fab13cc22a50b085710980383a6d13f5985b150f6ee1c949681e
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
