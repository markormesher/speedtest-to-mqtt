FROM node:21.2.0-bookworm@sha256:bc56c8da9f3e892e2697e37db775c42c52abee85c6c035f21587fa509be76d76 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.2.0-bookworm@sha256:bc56c8da9f3e892e2697e37db775c42c52abee85c6c035f21587fa509be76d76

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
