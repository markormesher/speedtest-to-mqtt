FROM node:20.7.0-bookworm@sha256:191b360003a7458df0f14bbc0aa1d298a706e32786e1830191036971eb1547a2 AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.7.0-bookworm@sha256:191b360003a7458df0f14bbc0aa1d298a706e32786e1830191036971eb1547a2
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
