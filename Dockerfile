FROM node:20.8.1-bookworm@sha256:bd20621deff56cb66c6cd10772d26db1a0d480f2b08609eb96b799ba6260f3ed AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.8.1-bookworm@sha256:bd20621deff56cb66c6cd10772d26db1a0d480f2b08609eb96b799ba6260f3ed
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
