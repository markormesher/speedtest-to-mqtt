FROM node:20.9.0-bookworm@sha256:62efd17e997bc843aefa4c003ed84f43dfac83fa6228c57c898482e50a02e45c AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.9.0-bookworm@sha256:62efd17e997bc843aefa4c003ed84f43dfac83fa6228c57c898482e50a02e45c
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
