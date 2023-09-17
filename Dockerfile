FROM node:20.6.1-bookworm@sha256:14bd39208dbc0eb171cbfb26ccb9ac09fa1b2eba04ccd528ab5d12983fd9ee24 AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.6.1-bookworm@sha256:14bd39208dbc0eb171cbfb26ccb9ac09fa1b2eba04ccd528ab5d12983fd9ee24
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
