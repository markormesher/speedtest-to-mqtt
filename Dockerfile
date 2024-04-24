FROM node:21.7.3-bookworm@sha256:c38429049e7dec44ffb0f57f39e79e31214d91ce64108a5b2c0d5b67dd3ae6a8 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.3-bookworm@sha256:c38429049e7dec44ffb0f57f39e79e31214d91ce64108a5b2c0d5b67dd3ae6a8

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
