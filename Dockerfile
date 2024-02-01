FROM node:21.6.1-bookworm@sha256:58b34ac1370a11c2c580ffa91f3236a92eaa6021ab186c361ca78d2b36a4cb24 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.6.1-bookworm@sha256:58b34ac1370a11c2c580ffa91f3236a92eaa6021ab186c361ca78d2b36a4cb24

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
