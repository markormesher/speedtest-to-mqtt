FROM node:20.8.0-bookworm@sha256:3bf611a98fc25697b3907ef8f3b9800e0814dc3feca0495acbbfd86f9b8329b9 AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.8.0-bookworm@sha256:3bf611a98fc25697b3907ef8f3b9800e0814dc3feca0495acbbfd86f9b8329b9
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
